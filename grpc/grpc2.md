## grpc相关

**gRPC的本身实现介绍**

## balancer_conn_wrappers.go
```go
// scStateUpdate contains the subConn and the new state it changed to.
type scStateUpdate struct {
	sc    balancer.SubConn
	state connectivity.State
}

// scStateUpdateBuffer is an unbounded channel for scStateChangeTuple.
// TODO make a general purpose buffer that uses interface{}.
type scStateUpdateBuffer struct {
	c       chan *scStateUpdate
	mu      sync.Mutex
	backlog []*scStateUpdate
}
```
而根据`SubConn`的定义，`SubConn`代表了一个`gRPC sub connection`,并且包含了一个要去连接的目标地址的列表，通过接口方式对外定义了一个更新这个列表的方法，以及一个连接`Connect`的方法。

`scStateUpdate`就是更新的对应连接的连接状态；
`scStateUpdateBuffer`定义了一个用来管理`scStateUpdate`的缓冲池

```go
// ccBalancerWrapper is a wrapper on top of cc for balancers.
// It implements balancer.ClientConn interface.
type ccBalancerWrapper struct {
	cc               *ClientConn
	balancer         balancer.Balancer
	stateChangeQueue *scStateUpdateBuffer
	resolverUpdateCh chan *resolverUpdate
	done             chan struct{}

	mu       sync.Mutex
	subConns map[*acBalancerWrapper]struct{}
}
.
.
.
.
.
.
// acBalancerWrapper is a wrapper on top of ac for balancers.
// It implements balancer.SubConn interface.
type acBalancerWrapper struct {
	mu sync.Mutex
	ac *addrConn

```
`ccBalancerWrapper`:
这个结构体里包含有`cc *ClientConn`，代表从前端来的连接；`subConns`则是代表要连接去后端的连接，以及一个连接去后端的负载均衡器，域名解析器,添加或者移除`SubConn`。
就类似于一个中间的粘合器，将前后融合进一个结构体里进行管理。
`acBalancerWrapper`:
这个结构体通过支持`balancer`接口，来对后端的连接进行负载均衡

---

## balancer.go
这个文件是原来的`balancer`抽象接口，现在已经废弃，建议使用`balancer`这个包的定义:Deprecated: please use package balancer. 


----

## balancer_v1_wrapper.go

一个　balancer的实现:

![balancer.png](balancer.png)

```go
type balancerWrapper struct {
	balancer  Balancer // The v1 balancer.
	pickfirst bool

	cc         balancer.ClientConn
	targetAddr string // Target without the scheme.

	mu     sync.Mutex
	conns  map[resolver.Address]balancer.SubConn
	connSt map[balancer.SubConn]*scState
	// This channel is closed when handling the first resolver result.
	// lbWatcher blocks until this is closed, to avoid race between
	// - NewSubConn is created, cc wants to notify balancer of state changes;
	// - Build hasn't return, cc doesn't have access to balancer.
	startCh chan struct{}

	// To aggregate the connectivity state.
	csEvltr *balancer.ConnectivityStateEvaluator
	state   connectivity.State
}
```

---

## call.go

Invoke sends the RPC request on the wire and returns after response is
received.  This is typically called by generated code.
All errors returned by Invoke are compatible with the status package.

![invoke.png](invoke.png)

```go
func (cc *ClientConn) Invoke
```

提供给使用protobuf文件生成的代码使用的一个函数，附属在`ClientConn`这个结构定义上

---

## clientconn.go

在这个文件中定义了代表客户端连接的结构体
`ClientConn`的定义：
```go
// ClientConn represents a client connection to an RPC server.
type ClientConn struct {
	ctx    context.Context
	cancel context.CancelFunc

	target       string
	parsedTarget resolver.Target
	authority    string
	dopts        dialOptions
	csMgr        *connectivityStateManager

	balancerBuildOpts balancer.BuildOptions
	blockingpicker    *pickerWrapper

	mu              sync.RWMutex
	resolverWrapper *ccResolverWrapper
	sc              ServiceConfig
	scRaw           string
	conns           map[*addrConn]struct{}
	// Keepalive parameter can be updated if a GoAway is received.
	mkp             keepalive.ClientParameters
	curBalancerName string
	preBalancerName string // previous balancer name.
	curAddresses    []resolver.Address
	balancerWrapper *ccBalancerWrapper
	retryThrottler  atomic.Value

	firstResolveEvent *grpcsync.Event

	channelzID int64 // channelz unique identification number
	czData     *channelzData
}
```

一些默认值:

```go
const (
	// minimum time to give a connection to complete
	minConnectTimeout = 20 * time.Second
	// must match grpclbName in grpclb/grpclb.go
	grpclbName = "grpclb"
)
.
.
.
.
.
.
const (
	defaultClientMaxReceiveMessageSize = 1024 * 1024 * 4
	defaultClientMaxSendMessageSize    = math.MaxInt32
	// http2IOBufSize specifies the buffer size for sending frames.
	defaultWriteBufSize = 32 * 1024
	defaultReadBufSize  = 32 * 1024
)
```

以及一些error的定义:
```go
var (
	// ErrClientConnClosing indicates that the operation is illegal because
	// the ClientConn is closing.
	//
	// Deprecated: this error should not be relied upon by users; use the status
	// code of Canceled instead.
	ErrClientConnClosing = status.Error(codes.Canceled, "grpc: the client connection is closing")
	// errConnDrain indicates that the connection starts to be drained and does not accept any new RPCs.
	errConnDrain = errors.New("grpc: the connection is drained")
	// errConnClosing indicates that the connection is closing.
	errConnClosing = errors.New("grpc: the connection is closing")
	// errBalancerClosed indicates that the balancer is closed.
	errBalancerClosed = errors.New("grpc: balancer is closed")
	// We use an accessor so that minConnectTimeout can be
	// atomically read and updated while testing.
	getMinConnectTimeout = func() time.Duration {
		return minConnectTimeout
	}
)

// The following errors are returned from Dial and DialContext
var (
	// errNoTransportSecurity indicates that there is no transport security
	// being set for ClientConn. Users should either set one or explicitly
	// call WithInsecure DialOption to disable security.
	errNoTransportSecurity = errors.New("grpc: no transport security set (use grpc.WithInsecure() explicitly or set credentials)")
	// errTransportCredsAndBundle indicates that creds bundle is used together
	// with other individual Transport Credentials.
	errTransportCredsAndBundle = errors.New("grpc: credentials.Bundle may not be used with individual TransportCredentials")
	// errTransportCredentialsMissing indicates that users want to transmit security
	// information (e.g., oauth2 token) which requires secure connection on an insecure
	// connection.
	errTransportCredentialsMissing = errors.New("grpc: the credentials require transport level security (use grpc.WithTransportCredentials() to set)")
	// errCredentialsConflict indicates that grpc.WithTransportCredentials()
	// and grpc.WithInsecure() are both called for a connection.
	errCredentialsConflict = errors.New("grpc: transport credentials are set for an insecure connection (grpc.WithTransportCredentials() and grpc.WithInsecure() are both called)")
)
```
在这个文件中，定义了一个这样的函数：
```go
// newAddrConn creates an addrConn for addrs and adds it to cc.conns.
//
// Caller needs to make sure len(addrs) > 0.
func (cc *ClientConn) newAddrConn(addrs []resolver.Address, opts balancer.NewSubConnOptions) (*addrConn, error)
```
根据一个地址`addrs`列表创建一个对后端的连接`addrConn`,然后把这个连接添加到`ClientConn`的成员变量`conns  map[*addrConn]struct{}`中


addrConn的定义：
```go
// addrConn is a network connection to a given address.
type addrConn struct {
	ctx    context.Context
	cancel context.CancelFunc

	cc     *ClientConn
	dopts  dialOptions
	acbw   balancer.SubConn
	scopts balancer.NewSubConnOptions

	// transport is set when there's a viable transport (note: ac state may not be READY as LB channel
	// health checking may require server to report healthy to set ac to READY), and is reset
	// to nil when the current transport should no longer be used to create a stream (e.g. after GoAway
	// is received, transport is closed, ac has been torn down).
	transport transport.ClientTransport // The current transport.

	mu      sync.Mutex
	curAddr resolver.Address   // The current address.
	addrs   []resolver.Address // All addresses that the resolver resolved to.

	// Use updateConnectivityState for updating addrConn's connectivity state.
	state connectivity.State

	tearDownErr error // The reason this addrConn is torn down.

	backoffIdx   int // Needs to be stateful for resetConnectBackoff.
	resetBackoff chan struct{}

	channelzID         int64 // channelz unique identification number.
	czData             *channelzData
	healthCheckEnabled bool
}
```
`addrConn`中定义的这个方法：
connect starts creating a transport.It does nothing if the ac is not IDLE.
```go
func (ac *addrConn) connect() error{
    ...
    // Start a goroutine connecting to the server asynchronously.
	go ac.resetTransport()
    ...
}
```
`addrConn`的这个函数实现的xxx的接口定义，用来触发实际的连接操作的
```go
// createTransport creates a connection to one of the backends in addrs. It
// sets ac.transport in the success case, or it returns an error if it was
// unable to successfully create a transport.
//
// If waitForHandshake is enabled, it blocks until server preface arrives.
func (ac *addrConn) createTransport(addr resolver.Address, copts transport.ConnectOptions, connectDeadline time.Time, reconnect *grpcsync.Event, prefaceReceived chan struct{}) (transport.ClientTransport, error) {
    ...
    newTr, err := transport.NewClientTransport(connectCtx, ac.cc.ctx, target, copts, onPrefaceReceipt, onGoAway, onClose)
}
```

---
## codec.go
这个文件定义了序列化相关的接口：
```go
// baseCodec contains the functionality of both Codec and encoding.Codec, but
// omits the name/string, which vary between the two and are not needed for
// anything besides the registry in the encoding package.
type baseCodec interface {
	Marshal(v interface{}) ([]byte, error)
	Unmarshal(data []byte, v interface{}) error
}

var _ baseCodec = Codec(nil)
var _ baseCodec = encoding.Codec(nil)

// Codec defines the interface gRPC uses to encode and decode messages.
// Note that implementations of this interface must be thread safe;
// a Codec's methods can be called from concurrent goroutines.
//
// Deprecated: use encoding.Codec instead.
type Codec interface {
	// Marshal returns the wire format of v.
	Marshal(v interface{}) ([]byte, error)
	// Unmarshal parses the wire format into v.
	Unmarshal(data []byte, v interface{}) error
	// String returns the name of the Codec implementation.  This is unused by
	// gRPC.
	String() string
}
```
---

## dialoptions.go
这个文件定义了用来进行建立连接的一些可以进行设置的参数：
```go
// dialOptions configure a Dial call. dialOptions are set by the DialOption
// values passed to Dial.
type dialOptions struct {
	unaryInt    UnaryClientInterceptor
	streamInt   StreamClientInterceptor
	cp          Compressor
	dc          Decompressor
	bs          backoff.Strategy
	block       bool
	insecure    bool
	timeout     time.Duration
	scChan      <-chan ServiceConfig
	authority   string
	copts       transport.ConnectOptions
	callOptions []CallOption
	// This is used by v1 balancer dial option WithBalancer to support v1
	// balancer, and also by WithBalancerName dial option.
	balancerBuilder balancer.Builder
	// This is to support grpclb.
	resolverBuilder      resolver.Builder
	reqHandshake         envconfig.RequireHandshakeSetting
	channelzParentID     int64
	disableServiceConfig bool
	disableRetry         bool
	disableHealthCheck   bool
	healthCheckFunc      internal.HealthChecker
}

// DialOption configures how we set up the connection.
type DialOption interface {
	apply(*dialOptions)
}
...
type funcDialOption struct {
	f func(*dialOptions)
}

func (fdo *funcDialOption) apply(do *dialOptions) {
	fdo.f(do)
}

func newFuncDialOption(f func(*dialOptions)) *funcDialOption {
	return &funcDialOption{
		f: f,
	}
}

```
`DialOption`这个通用的接口定义,然后通过`funcDialOption`包装一层，这样其它函数构建一个`DialOption`时只需要使用`newFuncDialOption`这个函数生成就好

![newFuncDialOption.png](newFuncDialOption.png)
