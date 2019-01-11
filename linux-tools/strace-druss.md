## strace like tool
### strace
```shell
:~$ strace  date
execve("/bin/date", ["date"], [/* 84 vars */]) = 0
brk(0)                                  = 0x12c6000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2af8593000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/usr/local/cuda/lib/tls/x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda/lib/tls/x86_64", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda/lib/tls/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda/lib/tls", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda/lib/x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda/lib/x86_64", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda/lib", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda/lib64/tls/x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda/lib64/tls/x86_64", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda/lib64/tls/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda/lib64/tls", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda/lib64/x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda/lib64/x86_64", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda/lib64", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("/usr/local/cuda-8.0/lib/tls/x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda-8.0/lib/tls/x86_64", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda-8.0/lib/tls/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda-8.0/lib/tls", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda-8.0/lib/x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda-8.0/lib/x86_64", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda-8.0/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda-8.0/lib", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda-7.5/lib64/tls/x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda-7.5/lib64/tls/x86_64", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda-7.5/lib64/tls/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda-7.5/lib64/tls", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda-7.5/lib64/x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda-7.5/lib64/x86_64", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/usr/local/cuda-7.5/lib64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/usr/local/cuda-7.5/lib64", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("tls/x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("tls/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
open("libc.so.6", O_RDONLY|O_CLOEXEC)   = -1 ENOENT (No such file or directory)
open("/home/xxxxxx/devxxxxxx/libs/tls/x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/home/xxxxxx/devxxxxxx/libs/tls/x86_64", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/home/xxxxxx/devxxxxxx/libs/tls/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/home/xxxxxx/devxxxxxx/libs/tls", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/home/xxxxxx/devxxxxxx/libs/x86_64/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/home/xxxxxx/devxxxxxx/libs/x86_64", 0x7ffd3afa4910) = -1 ENOENT (No such file or directory)
open("/home/xxxxxx/devxxxxxx/libs/libc.so.6", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory)
stat("/home/xxxxxx/devxxxxxx/libs", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=260802, ...}) = 0
mmap(NULL, 260802, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f2af8553000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P \2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1857312, ...}) = 0
mmap(NULL, 3965632, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f2af7fa9000
mprotect(0x7f2af8167000, 2097152, PROT_NONE) = 0
mmap(0x7f2af8367000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1be000) = 0x7f2af8367000
mmap(0x7f2af836d000, 17088, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f2af836d000
close(3)                                = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2af8551000
arch_prctl(ARCH_SET_FS, 0x7f2af8551740) = 0
mprotect(0x7f2af8367000, 16384, PROT_READ) = 0
mprotect(0x60d000, 4096, PROT_READ)     = 0
mprotect(0x7f2af8594000, 4096, PROT_READ) = 0
munmap(0x7f2af8553000, 260802)          = 0
brk(0)                                  = 0x12c6000
brk(0x12e7000)                          = 0x12e7000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=7216688, ...}) = 0
mmap(NULL, 7216688, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f2af78c7000
close(3)                                = 0
open("/etc/localtime", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=388, ...}) = 0
fstat(3, {st_mode=S_IFREG|0644, st_size=388, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2af8592000
read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\2\0\0\0\2\0\0\0\0"..., 4096) = 388
lseek(3, -240, SEEK_CUR)                = 148
read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\3\0\0\0\3\0\0\0\0"..., 4096) = 240
close(3)                                = 0
munmap(0x7f2af8592000, 4096)            = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 10), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f2af8592000
write(1, "2019\345\271\264 01\346\234\210 11\346\227\245 \346\230\237\346\234\237\344\272\224 15"..., 432019年 01月 11日 星期五 15:58:38 CST
) = 43
close(1)                                = 0
munmap(0x7f2af8592000, 4096)            = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++

```

`strace` 可以开始一个新进程，也可以附加到一个已经运行的进程上