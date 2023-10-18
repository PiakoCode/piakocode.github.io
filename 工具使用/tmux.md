# Tmux

新建会话
```shell
tmux new -s <name>
```

退出会话
```shell
tmux detach
```

列出所有会话
 ```shell
 tmux ls
```

左右分屏
```shell
ctrl + b -> %
```

上下分屏
```shell
ctrl + b -> "
```

关闭当前分屏
```shell
ctrl + b -> x
```

设定鼠标滚动支持：
```shell
tmux set mouse on
```


切换会话
```shell
ctrl + b -> 方向键
```


## 配置文件

`~/.tmux.conf`

开启鼠标
```text
set-option -g mouse on
```

让tmux在当前目录分屏
```text
bind-key c new-window -c "#{pane_current_path}"
bind-key % split-window -h -c "#{pane_current_path}"
bind-key '"' split-window -c "#{pane_current_path}"
```

https://zhuanlan.zhihu.com/p/345577995

```shell
echo "set-option -g mouse on
bind-key c new-window -c \"#{pane_current_path}\"
bind-key % split-window -h -c \"#{pane_current_path}\"
bind-key '\"' split-window -c \"#{pane_current_path}\"
" > .tmux.conf
```