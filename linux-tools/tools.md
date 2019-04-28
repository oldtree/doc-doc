## tools tips

```shell
ab -k -c 8 -n 100000 "http://127.0.0.1:8080/v1/leftpad/?str=test&len=50&chr=*"
# -k   Enables HTTP keep-alive
# -c   Number of concurrent requests
# -n   Number of total requests to make
```

获取linux环境下的二进制(ELF)文件的信息

```shell
$ readelf -h devutil 
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00 
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x459ca0
  Start of program headers:          64 (bytes into file)
  Start of section headers:          624 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         10
  Size of section headers:           64 (bytes)
  Number of section headers:         36
  Section header string table index: 9

```

---
  需要精准的时间同步，就是使用`ntp`同步，`ntp`也是一种时钟同步协议。它有自己的一套算法，当前相差多少，
  下次什么时候同步等等，它的这一套算法，可以保证时钟时时刻刻的同步。
  `ntp`是`linux`的一个服务，配置文件是`/etc/ntp.conf`

---