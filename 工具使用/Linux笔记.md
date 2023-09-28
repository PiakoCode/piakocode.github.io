# Linux笔记

#linux

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

[Linux获取两个路径之间的相对路径(https://www.cnblogs.com/jmliao/p/12400597.html)

## 好用的工具

`cloc` 统计代码行数

`ncdu` 查看文件(夹)占用空间



