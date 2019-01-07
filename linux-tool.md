## linux tool

![language-war](language-war.jpeg)

使用 find 命令在 Linux 中搜索文件和文件夹

它允许用户根据大小、名称、所有者、组、类型、权限、日期和其他条件执行所有类型的文件搜索。
运行以下命令以在系统中查找给定文件。
```shell
find / -iname "sshd_config"
```
运行以下命令以查找系统中的给定文件夹。要在 Linux 中搜索文件夹，我们需要使用 -type 参数。
```shell
find / -type d -iname "ssh"
```

使用通配符搜索系统上的所有文件。我们将搜索系统中所有以 `.config` 为扩展名的文件
```shell
find / -name "*.config"
```

使用以下命令格式在系统中查找空文件和文件夹
```shell
find / -empty
```

使用以下命令组合查找 Linux 上包含特定文本的所有文件。
```shell
find / -type f -exec grep "Port 22" '{}' \; -print
find / -type f -print | xargs grep "Port 22"
find / -type f | xargs grep 'Port 22'
find / -type f -exec grep -H 'Port 22' {} \;
```

---

使用 `locate` 命令在 `Linux` 中搜索文件和文件夹

`locate` 命令比 `find` 命令运行得更快，因为它使用 `updatedb` 数据库，而 `find` 命令在真实系统中搜索。

它使用数据库而不是搜索单个目录路径来获取给定文件。数据库通过 `cron` 任务定期更新，但我们可以通过运行以下命令手动更新它。
```shell
sudo updatedb
```
在系统中搜索 `ssh` 文件夹
```shell
locate --basename '\ssh'
```
在系统中搜索 `ssh_config` 文件
```shell
locate --basename '\sshd_config'
```

---

在 Linux 中搜索文件使用 `which` 命令
`which` 返回在终端输入命令时执行的可执行文件的完整路径
`which` 命令搜索当前用户而不是所有用户的 `$PATH` 环境变量中列出的目录
运行以下命令以打印 `vim` 可执行文件的完整路径
```shell
which vi
which -a vi sudo
```

---

使用 `whereis` 命令在 Linux 中搜索文件
`whereis` 命令用于搜索给定命令的二进制、源码和手册页文件
```shell
whereis vi
vi: /usr/bin/vi /usr/share/man/man1/vi.1p.gz /usr/share/man/man1/vi.1.gz
```

---

## linux中查看内存的工具命令


* `free` 显示系统中空闲和已用的物理内存和交换内存的总量，以及内核使用的缓冲区和缓存。它通过解析 /proc/meminfo 来收集信息。
```shell
~$ free -m
             total       used       free     shared    buffers     cached
Mem:          7948       7693        254         88         41        503
-/+ buffers/cache:       7148        800
Swap:         8141       6591       1550
~$ free -g
             total       used       free     shared    buffers     cached
Mem:             7          7          0          0          0          0
-/+ buffers/cache:          6          0
Swap:            7          6          1
~$
```

* `/proc/meminfo` 是一个虚拟文本文件，它包含有关系统 RAM 使用情况的大量有价值的信息。它报告系统上的空闲和已用内存（物理和交换）的数量。
```shell
~$ grep MemTotal /proc/meminfo
MemTotal:        8138800 kB
~$ grep MemTotal /proc/meminfo | awk '{print $2 / 1024}'
7948.05
~$ grep MemTotal /proc/meminfo | awk '{print $2 / 1024 / 1024}'
7.76176

```

* `top` 命令是 `Linux` 中监视实时系统进程的基本命令之一。它显示系统信息和运行的进程信息，如正常运行时间、平均负载、正在运行的任务、登录的用户数、`CPU` 数量和 `CPU` 利用率，以及内存和交换信息。运行 `top` 命令，然后按下 `E` 来使内存利用率以 `MB` 为单位显示。
```shell
top - 17:03:24 up 11 days, 5 min, 18 users,  load average: 0.64, 0.64, 0.50
Tasks: 400 total,   1 running, 399 sleeping,   0 stopped,   0 zombie
%Cpu(s):  1.4 us,  0.9 sy,  0.0 ni, 97.6 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem:   8138800 total,  7907932 used,   230868 free,    52892 buffers
KiB Swap:  8337404 total,  6736120 used,  1601284 free.   478344 cached Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                                  
    1 root      20   0   49748   3308   1684 S   0.0  0.0   0:02.76 init                                                     
    2 root      20   0       0      0      0 S   0.0  0.0   0:00.10 kthreadd                                                 
    3 root      20   0       0      0      0 S   0.0  0.0   0:04.40 ksoftirqd/0                                              
    5 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/0:0H                                             
    7 root      20   0       0      0      0 S   0.0  0.0  15:15.03 rcu_sched                                                
    8 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcu_bh                                                   
    9 root      rt   0       0      0      0 S   0.0  0.0   0:06.16 migration/0                                              
   10 root      rt   0       0      0      0 S   0.0  0.0   0:03.48 watchdog/0                                               
   11 root      rt   0       0      0      0 S   0.0  0.0   0:03.48 watchdog/1                                               
   12 root      rt   0       0      0      0 S   0.0  0.0   0:06.22 migration/1                                              
   13 root      20   0       0      0      0 S   0.0  0.0   0:04.31 ksoftirqd/1                                              
   15 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/1:0H                                             
   16 root      rt   0       0      0      0 S   0.0  0.0   0:03.20 watchdog/2                                               
   17 root      rt   0       0      0      0 S   0.0  0.0   0:06.16 migration/2                                              
   18 root      20   0       0      0      0 S   0.0  0.0   0:05.18 ksoftirqd/2                                              
   20 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/2:0H                                             
   21 root      rt   0       0      0      0 S   0.0  0.0   0:03.22 watchdog/3                                               
   22 root      rt   0       0      0      0 S   0.0  0.0   0:06.22 migration/3                                              
   23 root      20   0       0      0      0 S   0.0  0.0   0:03.57 ksoftirqd/3                                              
   25 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/3:0H                                             
   26 root      rt   0       0      0      0 S   0.0  0.0   0:03.27 watchdog/4                                               
   27 root      rt   0       0      0      0 S   0.0  0.0   0:09.45 migration/4                                              
   28 root      20   0       0      0      0 S   0.0  0.0   0:03.73 ksoftirqd/4                                              
   30 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/4:0H                                             
   31 root      rt   0       0      0      0 S   0.0  0.0   0:03.25 watchdog/5                                               
   32 root      rt   0       0      0      0 S   0.0  0.0   0:09.59 migration/5                                              
   33 root      20   0       0      0      0 S   0.0  0.0   0:01.85 ksoftirqd/5                                              
   35 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/5:0H                                             
   36 root      rt   0       0      0      0 S   0.0  0.0   0:03.23 watchdog/6 
```
  
* `vmstat` 是一个漂亮的标准工具，它报告 `Linux` 系统的虚拟内存统计信息。`vmstat` 报告有关`进程、内存、分页、块 IO、陷阱和 CPU` 活动的信息。它有助于 Linux 管理员在故障检修时识别系统瓶颈。
```shell
~$ vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0 6744328 242832  48856 455084    2    3    14     9    5    3  1  1 98  0  0
~$ vmstat -s | grep "total memory"
8138800 K total memory
~$ vmstat -s -S M | egrep -ie 'total memory'
7948 M total memory
~$ vmstat -s | awk '{print $1 / 1024 / 1024}' | head -1
7.76176
```  
* `dmidecode` 是一个读取计算机 DMI 表内容的工具，它以人类可读的格式显示系统硬件信息。（DMI 意即桌面管理接口，也有人说是读取的是 SMBIOS —— 系统管理 BIOS）,此表包含系统硬件组件的描述，以及其它有用信息，如序列号、制造商信息、发布日期和 BIOS 修改等。
```shell
~$ sudo dmidecode -t memory | grep  Size:
	Size: 8192 MB
	Size: No Module Installed
	Size: No Module Installed
	Size: No Module Installed
~$ sudo dmidecode -t memory | grep  Size: | grep -v "No Module Installed"
	Size: 8192 MB
```
* `lshw`（代表 Hardware Lister）是一个小巧的工具，可以生成机器上各种硬件组件的详细报告，如`内存配置、固件版本、主板配置、CPU 版本和速度、缓存配置、USB、网卡、显卡、多媒体、打印机、总线速度`等。它通过读取 `/proc 目录和 DMI 表`中的各种文件来生成硬件信息。
```shell
~$ lshw -short -class memory
WARNING: you should run this program as super-user.
H/W path       Device       Class          Description
======================================================
/0/0                        memory         7948MiB System memory
/0/100/1f.2                 memory         Memory controller
```
* `dmesg`（代表显示消息或驱动消息）是大多数类 Unix 操作系统上的命令，用于打印内核的消息缓冲区。
```shell
~$ dmesg | grep "Memory"
[    0.000000] Memory: 8113248K/8352408K available (8319K kernel code, 1322K rwdata, 4016K rodata, 1512K init, 1316K bss, 239160K reserved, 0K cma-reserved)
```