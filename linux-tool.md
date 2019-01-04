## linux tool

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