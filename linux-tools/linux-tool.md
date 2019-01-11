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
### 进程内存分配
可以通过读取 /proc/pid_of_process/maps 文件来检查 Linux 进程中的内存区域;
**经典内存布局:**
![class-mem](class-mem.png)
可以使用 nm 和 objdump 命令去检查二进制镜像，去显示它们的符号、地址、段等等

* nm
```shell
$ nm -help
Usage: nm [option(s)] [file(s)]
 List symbols in [file(s)] (a.out by default).
 The options are:
  -a, --debug-syms       Display debugger-only symbols
  -A, --print-file-name  Print name of the input file before every symbol
  -B                     Same as --format=bsd
  -C, --demangle[=STYLE] Decode low-level symbol names into user-level names
                          The STYLE, if specified, can be `auto` (the default),
                          `gnu`, `lucid`, `arm`, `hp`, `edg`, `gnu-v3`, `java`
                          or `gnat`
      --no-demangle      Do not demangle low-level symbol names
  -D, --dynamic          Display dynamic symbols instead of normal symbols
      --defined-only     Display only defined symbols
  -e                     (ignored)
  -f, --format=FORMAT    Use the output format FORMAT.  FORMAT can be `bsd`,
                           `sysv` or `posix`.  The default is `bsd`
  -g, --extern-only      Display only external symbols
  -l, --line-numbers     Use debugging information to find a filename and
                           line number for each symbol
  -n, --numeric-sort     Sort symbols numerically by address
  -o                     Same as -A
  -p, --no-sort          Do not sort the symbols
  -P, --portability      Same as --format=posix
  -r, --reverse-sort     Reverse the sense of the sort
      --plugin NAME      Load the specified plugin
  -S, --print-size       Print size of defined symbols
  -s, --print-armap      Include index for symbols from archive members
      --size-sort        Sort symbols by size
      --special-syms     Include special symbols in the output
      --synthetic        Display synthetic symbols as well
  -t, --radix=RADIX      Use RADIX for printing symbol values
      --target=BFDNAME   Specify the target object format as BFDNAME
  -u, --undefined-only   Display only undefined symbols
  -X 32_64               (ignored)
  @FILE                  Read options from FILE
  -h, --help             Display this information
  -V, --version          Display this program's version number

```

* objdump
```shell
~$ objdump help
Usage: objdump <option(s)> <file(s)>
 Display information from object <file(s)>.
 At least one of the following switches must be given:
  -a, --archive-headers    Display archive header information
  -f, --file-headers       Display the contents of the overall file header
  -p, --private-headers    Display object format specific file header contents
  -P, --private=OPT,OPT... Display object format specific contents
  -h, --[section-]headers  Display the contents of the section headers
  -x, --all-headers        Display the contents of all headers
  -d, --disassemble        Display assembler contents of executable sections
  -D, --disassemble-all    Display assembler contents of all sections
  -S, --source             Intermix source code with disassembly
  -s, --full-contents      Display the full contents of all sections requested
  -g, --debugging          Display debug information in object file
  -e, --debugging-tags     Display debug information using ctags style
  -G, --stabs              Display (in raw form) any STABS info in the file
  -W[lLiaprmfFsoRt] or
  --dwarf[=rawline,=decodedline,=info,=abbrev,=pubnames,=aranges,=macro,=frames,
          =frames-interp,=str,=loc,=Ranges,=pubtypes,
          =gdb_index,=trace_info,=trace_abbrev,=trace_aranges,
          =addr,=cu_index]
                           Display DWARF info in the file
  -t, --syms               Display the contents of the symbol table(s)
  -T, --dynamic-syms       Display the contents of the dynamic symbol table
  -r, --reloc              Display the relocation entries in the file
  -R, --dynamic-reloc      Display the dynamic relocation entries in the file
  @<file>                  Read options from <file>
  -v, --version            Display this program's version number
  -i, --info               List object formats and architectures supported
  -H, --help               Display this information
```
---

### Linux 网络监视器
用 iftop、Nethogs 和 vnstat 了解更多关于你的网络连接.
你可以通过这三个 Linux 网络命令，了解有关你网络连接的大量信息。iftop 通过进程号跟踪网络连接，Nethogs 可以快速显示哪个在占用你的带宽，而 vnstat 作为一个很好的轻量级守护进程运行，可以随时随地记录你的使用情况。

## iftop
```shell
~$ sudo iftop
interface: eth0
IP address is: 10.9.97.0
MAC address is: 30:9c:23:29:06:f8
~$ sudo iftop help
iftop: found arguments following options
*** some options have changed names since v0.9 ***
iftop: display bandwidth usage on an interface by host

Synopsis: iftop -h | [-npblNBP] [-i interface] [-f filter code]
                               [-F net/mask] [-G net6/mask6]

   -h                  display this message
   -n                  don't do hostname lookups
   -N                  don't convert port numbers to services
   -p                  run in promiscuous mode (show traffic between other
                       hosts on the same network segment)
   -b                  don't display a bar graph of traffic
   -B                  Display bandwidth in bytes
   -i interface        listen on named interface
   -f filter code      use filter code to select packets to count
                       (default: none, but only IP packets are counted)
   -F net/mask         show traffic flows in/out of IPv4 network
   -G net6/mask6       show traffic flows in/out of IPv6 network
   -l                  display and count link-local IPv6 traffic (default: off)
   -P                  show ports as well as hosts
   -m limit            sets the upper limit for the bandwidth scale
   -c config file      specifies an alternative configuration file

iftop, version 1.0pre2


```

```shell
~$ dig A pandora.com

; <<>> DiG 9.9.5-3ubuntu0.17-Ubuntu <<>> A pandora.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 32657
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;pandora.com.			IN	A

;; ANSWER SECTION:
pandora.com.		3599	IN	A	208.85.40.20

;; Query time: 169 msec
;; SERVER: 172.30.1.104#53(172.30.1.104)
;; WHEN: Fri Jan 11 10:17:56 CST 2019
;; MSG SIZE  rcvd: 56
```

## Nethogs

当想要快速了解谁占用了你的带宽时，Nethogs 是快速和容易的。以 root 身份运行，并指定要监听的接口。

```shell
~$ nethogs -h
usage: nethogs [-V] [-b] [-d seconds] [-t] [-p] [device [device [device ...]]]
		-V : prints version.
		-d : delay for update refresh rate in seconds. default is 1.
		-t : tracemode.
		-b : bughunt mode - implies tracemode.
		-p : sniff in promiscious mode (not recommended).
		device : device(s) to monitor. default is eth0

When nethogs is running, press:
 q: quit
 m: switch between total and kb/s mode

$ sudo nethogs wlan0

NetHogs version 0.8.1

PID USER   PROGRAM              DEV    SENT   RECEIVED       
7690 carla /usr/lib/firefox     wlan0 12.494 556.580 KB/sec
5648 carla .../chromium-browser wlan0  0.052 0.038 KB/sec
TOTAL                                 12.546 556.618 KB/sec
```

## vnstat
vnstat 是最容易使用的网络数据收集器
```shell
~$ vnstat --help
 vnStat 1.11 by Teemu Toivola <tst at iki dot fi>

         -q,  --query          query database
         -h,  --hours          show hours
         -d,  --days           show days
         -m,  --months         show months
         -w,  --weeks          show weeks
         -t,  --top10          show top10
         -s,  --short          use short output
         -u,  --update         update database
         -i,  --iface          select interface (default: eth0)
         -?,  --help           short help
         -v,  --version        show version
         -tr, --traffic        calculate traffic
         -ru, --rateunit       swap configured rate unit
         -l,  --live           show transfer rate in real time

See also "--longhelp" for complete options list and "man vnstat".
```
## history
如何轻松记住 `Linux` 命令
首先要介绍的是命令行工具 `history`，它能帮你记住那些你曾经用过的命令。包括应用最广泛的 `Bash` 在内的大多数 `Linux shell`，都会创建一个历史文件来包含那些你输入过的命令。
如果你用的是 Bash，这个历史文件就是 `/home/XXXXX/.bash_history`
```shell
~$ history
 1995  tmux
 1996  lsb_release -a
 1997  lsb_release 
 1998  cat /etc/lsb-release
 1999  cat /etc/issue
 2000  sudo iftop
 2001  iftop
 2002  sudo apt-get install iftop
 2003  sudo iftop
 2004  sudo iftop help
 2005  sudo iftop -i wlan0
 2006  sudo iftop -i eth0
 2007  history
 2008  apropos
 2009  apropos go
 2010  apropos golang
 2011  apropos make
 2012  apropos minikube
 2013  apropos clang
 2014  apropos man
 2015  history
 2016  history -h
 2017  history help
 2018  history ssh
 2019  history go
 2020  history
```

## ftrace：跟踪你的内核函数，ftrace-cmd

##  Linux 上的网络信息嗅探工具

在计算机网络中，数据是暴露的，因为数据包传输是无法隐藏的，所以让我们来使用 `whois`、`dig`、`nmcli` 和 `nmap` 这四个工具来嗅探网络吧

#### dig
```shell
~$ dig help

; <<>> DiG 9.9.5-3ubuntu0.17-Ubuntu <<>> help
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL, id: 28393
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;help.				IN	A

;; Query time: 1 msec
;; SERVER: 172.30.1.104#53(172.30.1.104)
;; WHEN: Fri Jan 11 11:45:58 CST 2019
;; MSG SIZE  rcvd: 33
```

```shell
~$ dig

; <<>> DiG 9.9.5-3ubuntu0.17-Ubuntu <<>>
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 9703
;; flags: qr rd ra; QUERY: 1, ANSWER: 13, AUTHORITY: 0, ADDITIONAL: 27

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;.				IN	NS

;; ANSWER SECTION:
.			449960	IN	NS	j.root-servers.net.
.			449960	IN	NS	m.root-servers.net.
.			449960	IN	NS	c.root-servers.net.
.			449960	IN	NS	b.root-servers.net.
.			449960	IN	NS	d.root-servers.net.
.			449960	IN	NS	k.root-servers.net.
.			449960	IN	NS	h.root-servers.net.
.			449960	IN	NS	f.root-servers.net.
.			449960	IN	NS	g.root-servers.net.
.			449960	IN	NS	l.root-servers.net.
.			449960	IN	NS	e.root-servers.net.
.			449960	IN	NS	i.root-servers.net.
.			449960	IN	NS	a.root-servers.net.

;; ADDITIONAL SECTION:
j.root-servers.net.	85610	IN	A	192.58.128.30
j.root-servers.net.	85610	IN	AAAA	2001:503:c27::2:30
m.root-servers.net.	85610	IN	A	202.12.27.33
m.root-servers.net.	85610	IN	AAAA	2001:dc3::35
c.root-servers.net.	85610	IN	A	192.33.4.12
c.root-servers.net.	85610	IN	AAAA	2001:500:2::c
b.root-servers.net.	85610	IN	A	199.9.14.201
b.root-servers.net.	85610	IN	AAAA	2001:500:200::b
d.root-servers.net.	85610	IN	A	199.7.91.13
d.root-servers.net.	85610	IN	AAAA	2001:500:2d::d
k.root-servers.net.	85610	IN	A	193.0.14.129
k.root-servers.net.	85610	IN	AAAA	2001:7fd::1
h.root-servers.net.	85610	IN	A	198.97.190.53
h.root-servers.net.	85610	IN	AAAA	2001:500:1::53
f.root-servers.net.	85610	IN	A	192.5.5.241
f.root-servers.net.	85610	IN	AAAA	2001:500:2f::f
g.root-servers.net.	85610	IN	A	192.112.36.4
g.root-servers.net.	85610	IN	AAAA	2001:500:12::d0d
l.root-servers.net.	85610	IN	A	199.7.83.42
l.root-servers.net.	85610	IN	AAAA	2001:500:9f::42
e.root-servers.net.	85610	IN	A	192.203.230.10
e.root-servers.net.	85610	IN	AAAA	2001:500:a8::e
i.root-servers.net.	85610	IN	A	192.36.148.17
i.root-servers.net.	85610	IN	AAAA	2001:7fe::53
a.root-servers.net.	85610	IN	A	198.41.0.4
a.root-servers.net.	85610	IN	AAAA	2001:503:ba3e::2:30

```
使用 `dig` 命令比较从不同的域名服务器返回的查询结果，去除陈旧的信息。域名服务器记录缓存各地的解析信息，并且不同的域名服务器有不同的刷新间隔。

```shell
dig baidu.com

; <<>> DiG 9.9.5-3ubuntu0.17-Ubuntu <<>> baidu.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 18743
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;baidu.com.			IN	A

;; ANSWER SECTION:
baidu.com.		57	IN	A	123.125.115.110
baidu.com.		57	IN	A	220.181.57.216

;; Query time: 1 msec
;; SERVER: 172.30.1.104#53(172.30.1.104)
;; WHEN: Fri Jan 11 11:47:24 CST 2019
;; MSG SIZE  rcvd: 70

```
#### nmcli
```shell
$ nmcli dev show | grep DNS
```
