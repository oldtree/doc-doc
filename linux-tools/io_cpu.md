## IO CPU
REF(https://www.jianshu.com/p/e62f0ef9629d)
##### IO 输入输出
##### CPU　计算

**现代的服务器的关注的两个主要的地方，实际上存储只是这两个的混合物，记好比火影忍者中的土遁和水遁合并为木遁的技能一样**

    一次请求中的整个的数据流动，包含client-server.
    数据在三个主要层次流动，即硬件，内核，应用。在流动的过程中，
    从一个层流向另一个层即为IO操作。
    
![cs.jpg](cs.jpg)

**DMA**

     Direct Memory Access，直接内存访问方式，即现在的计算机硬件设备，
     可以独立地直接读写系统内存，而不需CPU完全介入处理。
     也就是数据从DISK或者NIC从把数据copy到内核buf，不需要计算机cpu的
     参与，而是通过设备上的芯片（cpu）参与。对于内核来说，这样的数据读
     取过程中，cpu可以做别的事情。

**IO**

![io.jpg](io.jpg)

    通常现代的程序软件都运行在内存里，内存又分为用户态和内核态，后者隶
    属于操作系统。所谓的IO，就是将硬件（磁盘、网卡）的数据读取到程序的
    内存中。
    因为应用程序很少可以直接和硬件交互，因此操作系统作为两者的桥梁。通
    常操作系统在对接两端（应用程序与硬件）时，自身有一个内核buf，用于
    数据的copy中转。
    应用的读IO操作，即将网卡的数据，copy到应用的进程buf，中途会经过内核的buf。


5中基本的网络I/O模型，主要分为同步和异步I/O:

* 阻塞I/O（blocking）:IO过程分为两个阶段，等待数据准备和数据拷贝过程。这里涉及两个对象，其一是发起IO操作的进程（线程），其二是内核对象。所谓阻塞是指进程在两个阶段都阻塞，即线程挂起，不能做别的事情。
* 
![blocking.jpg](blocking.jpg)

* 非阻塞I/O（nonblocking）:在nonblockingIO中，如果没有io数据，那么发起的系统调用也会马上返回，会返回一个EWOULDBLOCK错误。函数返回之后，线程没有被挂起，当然是可以继续做别的。
  
![nonblocking.jpg](nonblocking.jpg)

* 多路复用I/O（multiplexing）:由内核负责监控应用指定的socket文件描述符，当socket准备好数据（可读，可写，异常）的时候，通知应用进程。准备好数据是一个事件，当事件发生的时候，通知应用进程，而应用进程可以根据事件事先注册回调函数。多路复用I/O的本质就是 多路监听 + 阻塞/非阻塞IO。多路监听即select，poll，epoll这些系统调用。后面的才是真正的IO，红色的线表示，即前文介绍的阻塞或者非阻塞IO。
  
![multiplexing.jpg](multiplexing.jpg)

select poll epoll更多时候是配合非阻塞的方式使用。如下图：

![multiplexing-unblocking.jpg](multiplexing-unblocking.jpg)

* 信号驱动I/O（SIGIO）:让内核在描述符就绪时发送SIGIO信号通知进程。这种模型为信号驱动式I/O（signal-driven I/O），和事件驱动类似，也是一种回调方式。与非阻塞方式不一样的地方是，发起了信号驱动的系统调用，进程没有挂起，可以做的事情，可是实际中，代码逻辑通常还是主循环，主循环里可能还是会阻塞。因此使用这样的IO的软件很少
  
![signal.jpg](signal.jpg)

* 异步I/O（asynchronous）

![async.jpg](async.jpg)
