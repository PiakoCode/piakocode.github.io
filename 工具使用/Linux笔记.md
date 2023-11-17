# Linux笔记


**正常解压gbk编码格式的文件**

```shell
unzip -O gbk path/to/archive1.zip path/to/archive2.zip
```

**定时执行脚本**

`cronie` 使用 `cronie.service`

```
systemctl enable cronie.service
```

开始编辑cron表

```bash
crontab -e
```

具体内容

```bash
0 9 * * * /path/to/your/script.sh
```

这个例子中，`0`代表分钟，`9`代表小时，`* * *`代表日期、月份和星期几，表示每天都匹配。`/path/to/your/script.sh`是要执行的脚本的路径。

- 分钟（0-59）
- 小时（0-23）
- 日期（1-31）
- 月份（1-12）
- 星期几（0-7，其中0和7都表示星期日）

输出所有定时任务

```bash
crontab -l
```

shell中1&将STDERR和STDOUT的输出重定向到同一个管道

`chattr` 修改文件属性
`lsattr` 查看文件属性

**任务管理**

`jobs` 查看终端中的任务列表（在后台运行的任务）

`bg`和`fg`：将后台作业切换到前台或将前台作业切换到后台。

- `bg %job_number`: 将编号为`job_number`的作业切换到后台运行。
- `fg %job_number`: 将编号为`job_number`的作业切换到前台运行。

按下 `Ctrl + Z` 键组合可以将正在运行的任务（前台任务）暂停，并将其切换到后台。这个操作通常称为挂起（suspend）。

[Linux中的管道与连接符号 - 知乎](https://zhuanlan.zhihu.com/p/223681357)

**获得两个文件之间的相对路径**

```sh
realpath FILE(traget)  --relative-to=FILE(current)
```

[Linux获取两个路径之间的相对路径](https://www.cnblogs.com/jmliao/p/12400597.html)

ln：
  - 创建指向文件或目录的符号链接：
    ln -s /路径/到/文件或目录 路径/到/符号链接

  - 覆盖现有的符号链接以指向其他文件：
    ln -sf /路径/到/新文件 路径/到/符号链接

  - 创建文件的硬链接：
    ln /路径/到/文件 路径/到/硬链接


软链接类似于Windows的快捷方式

而对于硬链接类似于一种clone，原文件被修改也会同步到硬链接上，但删除不会。
硬链接不能链接目录，只能链接文件。


**scp 传输文件**

```shell
scp 本地文件路径 remote_username@remote_ip:remote_文件名 # 本地文件复制到远程

scp remote_username@remote_ip:remote_文件名 本地文件路径 # 远程文件复制到本地
```

使用方式类似于`cp`

`-r` 递归复制目录


**PATH环境变量**

```shell
vim ~/.bashrc
```

```shell
export PATH=$PATH:/usr/local/src/python3/bin
# 或
export PATH=/usr/local/src/python3/bin:$PATH
```


## 网络


### lsof


**查看端口占用情况**

```shell
lsof -i:[port]
```
### netstat

netstat命令用于显示网络连接和路由表信息。

-n：直接使用IP地址，而不通过域名服务器。
-l：显示监控中的服务器的Socket。
-t：显示TCP传输协议的连线状况。
-u：显示UDP传输协议的连线状况。
-p：显示正在使用Socket的程序识别码和程序名称。


显示所有活动的网络连接：
   ```
   netstat -a
   ```


## 好用的工具

`cloc` 统计代码行数

`ncdu` 查看文件(夹)占用空间

`hyperfine` benchmark工具

`valgrind` C++应用内存泄露检查

`webbench` 网络压力测试

```shell
webbench -c [并发量] -t [时间-秒] [target]

# sample
webbench -c 500 -t 60 localhost:8080
```


`locust` 性能测试

[Locust - A modern load testing framework](https://locust.io/)