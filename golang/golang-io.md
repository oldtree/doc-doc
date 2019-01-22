## go的IO文件封装

### Go 中 open 系统调用的封装

一般的，我们使用 os 标准库的 `Open/Create` 方法来间接调用 open 系统调用，跟踪代码，找到 Go 中 open 系统调用的封装：

```go
func Open(path string, mode int, perm uint32) (fd int, err error) {
    return openat(_AT_FDCWD, path, mode|O_LARGEFILE, perm)
}
```

从 2.6.16 （Go 支持的 Linux 版本是 2.6.23）开始，Linux 内核提供了一系列新的系统调用（以at结尾），它们在执行与传统系统调用相似任务的同时，还提供了一些附加功能，对某些程序非常有用，这些系统调用使用目录文件描述符来解释相对路径。

```c
#define _XOPEN_SOURCE 700 /* Or define _POSIX_C_SOURCE >= 200809 */
#include <fcntl.h>

int openat(int dirfd, const char* pathname, int flags, … /* mode_t mode */);
                   Returns file descriptor on success, or -1 on error

```

可见，openat 系统调用和 open 类似，只是添加了一个 dirfd 参数，其作用如下：

    1）如果 `pathname` 中为一相对路径名，那么对其解释则以打开文件描述符 `dirfd` 所指向的目录为参照点，而非进程的当前工作目录；
    2）如果 `pathname` 中为一相对路径，且 `dirfd` 中所含为特殊值 `AT_FDCWD`（其值为-100），那么对 `pathname` 的解释则相对于进程当前工作目录，这时 `openat` 和 `open` 行为一致；
    3）如果 `pathname` 中为绝对路径，那么将忽略 `dirfd` 参数；

在 Go 中，只要存在相应的 at 系统调用，都会使用它。Go 中的 `Open` 并非执行 `open` 系统调用，而是 `openat` 系统调用，行为和 `open` 一致。

```go
func openat(dirfd int, path string, flags int, mode uint32) (fd int, err error) {
    var _p0 *byte
    // 根据要求，path 必须是 C 语言中的字符串，即以 NULL 结尾
    // BytePtrFromString 的作用就是返回一个指向 NULL 结尾的字节数组指针
    _p0, err = BytePtrFromString(path)
    if err != nil {
        return
    }
    // SYS_OPENAT openat 系统调用编号
    r0, _, e1 := Syscall6(SYS_OPENAT, uintptr(dirfd), uintptr(unsafe.Pointer(_p0)), uintptr(flags), uintptr(mode), 0, 0)
    // 空操作，用于保证 _p0 存活
    use(unsafe.Pointer(_p0))
    fd = int(r0)
    if e1 != 0 {
        err = errnoErr(e1)
    }
    return
}
```

`OpenFile` 函数有一个点需要注意，创建或打开文件时，自动加上了 `O_CLOEXEC` 标志，也就是执行 `Exec` 系统调用时该文件描述符不会被继承；

`os.OpenFile` 返回 `os.File` 类型的指针，通过 `File.Fd()` 可以获取到文件描述符；

### read、write 和 close 系统调用

`通过 open 系统调用的分析可以很容易的自己分析 read、write和close 系统调用。
说明一点：close 系统调用，企图关闭一个未打开的文件描述符或两次关闭同一个文件描述符，会返回错误。一般都不需要关心错误。
Go 中的 os 包的 File.Seek 对应的系统调用是 lseek
os 包中，File 类型中 ReadAt/WriteAt 对应的系统调用是 pread/pwrite
Truncate 对应 truncate 等；
几乎所有 Linux 文件相关系统调用，Go 都有封装；另外，通过上面 Open 的介绍，即使没有封装，自己封装也不是难事`