## http２相关

---
##### 在HTTP/2 中：

- Stream： 一个双向流，一条连接可以有多个 streams。
- Message： 也就是逻辑上面的 request，response。
- Frame:：数据传输的最小单位。每个 Frame 都属于一个特定的 stream 或者整个连接。一个 message 可能有多个 frame 组成。

--- 

##### Frame Format
Frame 是 HTTP/2 里面最小的数据传输单位，一个 Frame 定义如下:

    +-----------------------------------------------+
    |                 Length (24)                   |
    +---------------+---------------+---------------+
    |   Type (8)    |   Flags (8)   |
    +-+-------------+---------------+-------------------------------+
    |R|                 Stream Identifier (31)                      |
    +=+=============================================================+
    |                   Frame Payload (0...)                      ...
    +---------------------------------------------------------------+

- Length：也就是 Frame 的长度，默认最大长度是 16KB，如果要发送更大的 Frame，需要显示的设置 max frame size。 Type：Frame 的类型，譬如有 DATA，HEADERS，PRIORITY 等。 Flag 和 R：保留位，可以先不管。 Stream Identifier：标识所属的 stream，如果为 0，则表示这个 frame 属于整条连接。Frame Payload：根据不同 Type 有不同的格式。

---

##### Multiplexing
HTTP/2 通过 stream 支持了连接的多路复用，提高了连接的利用率。Stream 有很多重要特性


- 一条连接可以包含多个 streams，多个 streams 发送的数据互相不影响。
- Stream 可以被 client 和 server 单方面或者共享使用。
- Stream 可以被任意一段关闭。
- Stream 会确定好发送 frame 的顺序，另一端会按照接受到的顺序来处理。
- Stream 用一个唯一 ID 来标识(服务端和客户端的ＩＤ采用奇偶数来分配)。

###### **Stream ID : 如果是 client 创建的 stream，ID 就是奇数，如果是 server 创建的，ID 就是偶数。ID 0x00 和 0x01 都有特定的使用场景，不会用到**
###### **Stream ID 不可能被重复使用，如果一条连接上面 ID 分配完了，client 会新建一条连接。而 server 则会给 client 发送一个 GOAWAY frame 强制让 client 新建一条连接**
###### **为了更大的提高一条连接上面的 Stream 并发，可以考虑调大 SETTINGS_MAX_CONCURRENT_STREAMS**

--- 

##### Priority

因为一条连接允许多个 streams 在上面发送 frame，那么在一些场景下面，我们还是希望 stream 有优先级，方便对端为不同的请求分配不同的资源。譬如对于一个 Web 站点来说，优先加载重要的资源，而对于一些不那么重要的图片啥的，则使用低的优先级.
还可以设置 Stream Dependencies，形成一棵 streams priority tree。假设 Stream A 是 parent，Stream B 和 C 都是它的孩子，B 的 weight 是 4，C 的 weight 是 12，假设现在 A 能分配到所有的资源，那么后面 B 能分配到的资源只有 C 的 1/3

---

##### Flow Control

HTTP/2 也支持流控，如果 sender 端发送数据太快，receiver 端可能因为太忙，或者压力太大，或者只想给特定的 stream 分配资源，receiver 端就可能不想处理这些数据。譬如，如果 client 给 server 请求了一个视屏，但这时候用户暂停观看了，client 就可能告诉 server 别在发送数据了.
虽然 TCP 也有 flow control，但它仅仅只对一个连接有效果。HTTP/2 在一条连接上面会有多个 streams，有时候，我们仅仅只想对一些 stream 进行控制，所以 HTTP/2 单独提供了流控机制。Flow control 有如下特性：

- Flow control 是单向的。Receiver 可以选择给 stream 或者整个连接设置 window size。
- Flow control 是基于信任的。Receiver 只是会给 sender 建议它的初始连接和 stream 的 flow control window size。
- Flow control 不可能被禁止掉。当 HTTP/2 连接建立起来之后，client 和 server 会交换 SETTINGS frames，用来设置 flow control window size。
- Flow control 是 hop-by-hop，并不是 end-to-end 的，也就是我们可以用一个中间人来进行 flow control。

这里需要注意，HTTP/2 默认的 window size 是 64 KB

---

##### HPACK

在一个 HTTP 请求里面，我们通常在 header 上面携带很多改请求的元信息，用来描述要传输的资源以及它的相关属性。在 HTTP/1.x 时代，我们采用纯文本协议，并且使用 \r\n 来分隔，如果我们要传输的元数据很多，就会导致 header 非常的庞大。另外，多数时候，在一条连接上面的多数请求，其实 header 差不了多少，譬如我们第一个请求可能 GET /a.txt，后面紧接着是 GET /b.txt，两个请求唯一的区别就是 URL path 不一样，但我们仍然要将其他所有的 fields 完全发一遍。
HTTP/2 为了结果这个问题，使用了 HPACK。虽然 HPACK 的 RFC 文档 看起来比较恐怖，但其实原理非常的简单易懂。
HPACK 提供了一个静态和动态的 table，静态 table 定义了通用的 HTTP header fields，譬如 method，path 等。发送请求的时候，只要指定 field 在静态 table 里面的索引，双方就知道要发送的 field 是什么了。
对于动态 table，初始化为空，如果两边交互之后，发现有新的 field，就添加到动态 table 上面，这样后面的请求就可以跟静态 table 一样，只需要带上相关的 index 就可以了。
同时，为了减少数据传输的大小，使用 Huffman 进行编码。这里就不再详细说明 HPACK 和 Huffman 如何编码了。
