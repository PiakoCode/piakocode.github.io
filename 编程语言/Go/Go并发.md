
# 并发

#go #基础 

## go关键词

在调用的函数前加`go`关键词，当程序调用这个函数的时候，会创建一个*goroutine*。

"sync"包中的Mutex可以实现锁:[sync.Mutex](https://tour.go-zh.org/concurrency/9)


```go
func main() {
	// 此时创建了一个goroutine
	go count(5, "🐏");
}

func count(n int, animal string) {
    for i := 0; i < n; i++ {
        fmt.Println(i+1, animal)
        time.Sleep(time.Millisecond * 500)
    }
}
```

注意：当main函数结束时，go程序就会结束。
	 无论你创建了多少goroutine，无论goroutine有没有结束。


我们可以使用"sync"包中的waitGroup来解决这个问题。可以用它来追踪还有多少任务没有完成。

```go
func main() {
    var wg sync.WaitGroup
    wg.Add(2)
    go func ()  {
        count(5, "🐏")
        wg.Done()
    }()
    go func ()  {
        count(3,"🐂")
        wg.Done()
    }()
    wg.Wait()
}
```

## channel

当线程/协程处理相同的一块内存时，可能会发生冲突。

一般的解决方案是给这块内存上一个锁，使得同一时间只有一个线程/协程可以操作它。操作结束后再解除锁。

但是go采用了另外一种方法解决这个问题。通信顺序进程(Communicating sequential processes)，通过交流来共享内存，而不是通过共享内存来交流。

可以使用`channel`来实现goroutine之间的交流。

记得要关闭channel，否则接收方会一直等待channel发送过来的消息

![](../../Algorithm/Picture/Pasted%20image%2020221222110734.png)
```go
func main() {
	c := make(chan string)

	go count(5, "🐏", c)

	for message := range c {
		fmt.Println(message)
	}

	// for {
	// 	message, open := <-c
	// 	if !open {
	// 		break
	// 	}
	// 	fmt.Println(message)
	// }
}

func count(n int, animal string, c chan string) {
	for i := 0; i < n; i++ {
		c <- animal
		time.Sleep(time.Millisecond * 500)
	}
	// 关闭channel
	close(c)
}
```


```go
func main() {
	c1 := make(chan string)
	c2 := make(chan string)
	go func() {
		for {
			c1 <- "🐏"
			time.Sleep(time.Millisecond * 500)
		}
	}()

	go func() {
		for {
			c2 <- "🐂"
			time.Sleep(time.Millisecond * 2000)
		}
	}()
	for {
		select {
		case msg := <-c1:
			fmt.Println(msg)
		case msg := <-c2:
			fmt.Println(msg)
		}
	}
}
```

## 实战

使用go实现遍历树形结构

不使用协程

```go
package main
import (
	"fmt"
	"os"
	"time"
)
var matches int

func main() {
	start := time.Now()
	search("E:/Blog/")
	fmt.Println(matches, "marches")
	fmt.Println(time.Since(start))
}
func search(path string) {
	files, err := os.ReadDir(path)
	if err == nil {
		for _, file := range files {
			name := file.Name()
			if file.IsDir() {
				search(path + name + "/")
			} else {
				if len(name) < 5 {
					matches++
				}
			}
		}
	}
}
```

使用协程

```go
package main

import (
	"fmt"
	"os"
	"time"
)

var matches int
var workerCount = 0
var maxWorkerCount = 16
var searchRequest = make(chan string)
var workerDone = make(chan bool)
var findMatch = make(chan bool)

func main() {
	start := time.Now()
	workerCount = 1
	go search("E:/Blog/", true)
	waitForWorkers()
	fmt.Println(matches, "matches")
	fmt.Println(time.Since(start))
}

func waitForWorkers() {
	for {
		select {
		case path := <-searchRequest:
			workerCount++
			go search(path, true)
		case <-workerDone:
			workerCount--
			if workerCount == 0 {
				return
			}
		case <-findMatch:
			matches++
		}
	}
}

func search(path string, master bool) {
	files, err := os.ReadDir(path)
	if err == nil {
		for _, file := range files {
			name := file.Name()
			if file.IsDir() {
				if workerCount < maxWorkerCount {
					searchRequest <- path + name + "/"
				} else {
					search(path+name+"/", false)
				}
			} else {
				if len(name)<5 {
				findMatch <- true
				}
			}
		}
		if master {
			workerDone <- true
		}
	}
}

```

