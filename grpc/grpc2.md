## grpc相关

**gRPC的本身实现介绍**

## balancer_conn_wrappers.go
```shell
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

```shell
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

```shell
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