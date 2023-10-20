# 常用git指令

```shell
git init					    # 初始化仓库
```

```bash
git add 文件名   				  # 将文件添加到缓存区
```

```bash
git commit -m "添加信息标注" 		# 将缓存区的文件添加到本地仓库
```

```bash
git status					    # 查看仓库当前的状态
```

```bash
git diff						# 缓存区和工作区文件的差异
```

```bash
git rm    						# 删除本地仓库的文件
```

```bash
git log     					# 查看历史提交记录
```

```bash
ssh-keygen -t rsa -C "github上注册的电子邮箱"              # 生成SSH
```

```bash
git pull      					  # 下载远程代码并合并
```

```bash
git push      				      # 上传文件至远程库
git push origin master
```

```bash
git remote add origin <server>	  # 添加远程服务器
```

```shell
git checkout 分支名     # 切换分支
```

设定初始分支名

```shell
git config --global init.defaultBranch <名称>
```


**.gitignore**





## 相关资料

[高质量的 Git 中文教程，源于国外社区的优秀文章和个人实践](https://github.com/geeeeeeeeek/git-recipes)

[《Pro Git》Git官方书籍(中文)](https://git-scm.com/book/zh/v2)





##  错误

OpenSSL SSL_read: Connection was aborted, errno 10054

解决方法参考:  [作者：云梦&&玄龙](https://www.cnblogs.com/fairylyl/p/15059437.html)   或   [作者：Herio](https://blog.51cto.com/u_15326986/3328947)



[解决 ssh: connect to host github.com port 22: Connection timed out](https://segmentfault.com/a/1190000040896781)

