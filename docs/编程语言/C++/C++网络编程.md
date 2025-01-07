# Reactor

主从Reactor架构是一种常见的高性能网络服务器设计模式，广泛应用于C++网络编程中。它通过分离I/O事件的处理和业务逻辑的处理，提升了服务器的并发能力和响应速度。以下是主从Reactor架构的详细设计思路：

## 1. 架构概述
主从Reactor架构的核心思想是将事件处理分为两个层次：
- **主Reactor**：负责监听和接受新的连接，并将新连接分发给从Reactor。
- **从Reactor**：负责处理已建立连接的I/O事件（如读、写等）。

这种设计通过多线程或事件循环的方式，充分利用多核CPU的性能，同时避免了单线程事件循环的瓶颈。

---

## 2. 核心组件
### (1) Reactor
Reactor是事件驱动的核心，通常基于`epoll`（Linux）或`kqueue`（BSD）等I/O多路复用技术实现。它的主要职责是：
- 监听文件描述符（fd）上的事件（如读、写、异常等）。
- 将事件分发给对应的处理器（Handler）。

### (2) Acceptor
Acceptor是主Reactor的一部分，负责监听新的连接请求。当有新连接到达时，Acceptor会接受连接，并将新连接的fd分配给从Reactor。

### (3) Handler
Handler是事件处理器，负责处理具体的I/O事件。每个连接对应一个Handler，它通常包含以下功能：
- 读取数据并解析协议。
- 执行业务逻辑。
- 发送响应数据。

### (4) EventLoop
EventLoop是事件循环的核心，负责不断监听和分发事件。每个Reactor（主Reactor和从Reactor）都有自己的EventLoop。


在C++网络编程中，**EventLoop** 是一个核心概念，尤其是在基于事件驱动的编程模型中。EventLoop 负责不断监听和分发事件，确保程序能够及时响应各种I/O事件、定时器事件等。

#### EventLoop 的作用

1. **事件监听**：EventLoop 会不断地检查是否有新的事件发生，比如新的连接请求、数据到达、定时器超时等。
2. **事件分发**：当检测到有事件发生时，EventLoop 会将事件分发给相应的处理函数或回调函数进行处理。
3. **循环执行**：EventLoop 通常在一个无限循环中运行，不断地监听和分发事件，直到程序退出。

#### EventLoop 的实现

在实现上，EventLoop 通常会依赖于底层的I/O多路复用机制（如 `select`、`poll`、`epoll` 或 `kqueue`）来高效地监听多个文件描述符上的事件。以下是一个简单的 EventLoop 实现框架：

```cpp
#include <iostream>
#include <vector>
#include <sys/epoll.h>
#include <unistd.h>
#include <fcntl.h>

class EventLoop {
public:
    EventLoop() {
        epoll_fd_ = epoll_create1(0);
        if (epoll_fd_ == -1) {
            perror("epoll_create1");
            exit(EXIT_FAILURE);
        }
    }

    ~EventLoop() {
        close(epoll_fd_);
    }

    void addFd(int fd, uint32_t events) {
        struct epoll_event ev;
        ev.events = events;
        ev.data.fd = fd;
        if (epoll_ctl(epoll_fd_, EPOLL_CTL_ADD, fd, &ev) == -1) {
            perror("epoll_ctl: add");
            exit(EXIT_FAILURE);
        }
    }

    void run() {
        const int MAX_EVENTS = 10;
        struct epoll_event events[MAX_EVENTS];

        while (true) {
            int nfds = epoll_wait(epoll_fd_, events, MAX_EVENTS, -1);
            if (nfds == -1) {
                perror("epoll_wait");
                exit(EXIT_FAILURE);
            }

            for (int i = 0; i < nfds; ++i) {
                if (events[i].events & EPOLLIN) {
                    // Handle read event
                    std::cout << "Read event on fd: " << events[i].data.fd << std::endl;
                }
                if (events[i].events & EPOLLOUT) {
                    // Handle write event
                    std::cout << "Write event on fd: " << events[i].data.fd << std::endl;
                }
                // Handle other events...
            }
        }
    }

private:
    int epoll_fd_;
};

int main() {
    EventLoop loop;

    // Example: Add a file descriptor to the event loop
    int fd = open("example.txt", O_RDONLY);
    if (fd == -1) {
        perror("open");
        return EXIT_FAILURE;
    }

    loop.addFd(fd, EPOLLIN);
    loop.run();

    return 0;
}
```

#### Reactor 模式中的 EventLoop

在 **Reactor模式** 中，通常会有多个 EventLoop。主 Reactor（Main Reactor）负责监听新的连接请求，而从 Reactor（Sub Reactor）则负责处理已建立连接的I/O操作。每个 Reactor 都有自己的 EventLoop，这样可以有效地将任务分配到不同的线程或进程中，提高并发处理能力。

- **主 Reactor**：通常只有一个主 Reactor，它负责监听新的连接请求。当有新连接到来时，主 Reactor 会将连接分配给一个从 Reactor。
- **从 Reactor**：可以有多个从 Reactor，每个从 Reactor 都有自己的 EventLoop。它们负责处理已建立连接的I/O操作。

#### 总结

EventLoop 是C++网络编程中非常关键的一个组件，它通过不断监听和分发事件来驱动整个程序的运行。在复杂的网络应用中，合理地使用多个 EventLoop（如主从Reactor模式）可以显著提高程序的并发处理能力和性能。

#### (5) ThreadPool
从Reactor通常运行在多个线程中，每个线程独立运行一个EventLoop。ThreadPool用于管理这些线程，确保负载均衡。

---

## 3. 工作流程
1. **主Reactor监听新连接**：
   - 主Reactor运行在一个独立的线程中，监听服务器套接字（listen fd）。
   - 当有新连接到达时，主Reactor调用Acceptor接受连接。

2. **分配连接给从Reactor**：
   - Acceptor接受连接后，将新连接的fd分配给一个从Reactor。
   - 分配策略可以是轮询、哈希或其他负载均衡算法。

3. **从Reactor处理I/O事件**：
   - 从Reactor在自己的EventLoop中监听已分配连接的fd。
   - 当fd上有可读或可写事件时，从Reactor调用对应的Handler处理。

4. **Handler处理业务逻辑**：
   - Handler读取数据并解析协议（如HTTP、WebSocket等）。
   - 执行业务逻辑（如数据库查询、计算等）。
   - 将响应数据写入fd，触发可写事件。

5. **事件循环持续运行**：
   - 主Reactor和从Reactor的EventLoop持续运行，不断监听和处理事件。

---

## 4. 代码结构示例
以下是一个简化的C++代码结构示例：

```cpp
#include <iostream>
#include <thread>
#include <vector>
#include <memory>
#include <sys/epoll.h>
#include <unistd.h>
#include <fcntl.h>
#include <arpa/inet.h>

// Reactor类
class Reactor {
public:
    Reactor() : epoll_fd(epoll_create1(0)) {}
    ~Reactor() { close(epoll_fd); }

    void add_fd(int fd, uint32_t events) {
        epoll_event ev;
        ev.events = events;
        ev.data.fd = fd;
        epoll_ctl(epoll_fd, EPOLL_CTL_ADD, fd, &ev);
    }

    void run() {
        while (true) {
            epoll_event events[10];
            int n = epoll_wait(epoll_fd, events, 10, -1);
            for (int i = 0; i < n; ++i) {
                handle_event(events[i]);
            }
        }
    }

    virtual void handle_event(const epoll_event& ev) = 0;

protected:
    int epoll_fd;
};

// Acceptor类
class Acceptor : public Reactor {
public:
    Acceptor(int port) {
        listen_fd = socket(AF_INET, SOCK_STREAM, 0);
        sockaddr_in addr{};
        addr.sin_family = AF_INET;
        addr.sin_port = htons(port);
        addr.sin_addr.s_addr = INADDR_ANY;
        bind(listen_fd, (sockaddr*)&addr, sizeof(addr));
        listen(listen_fd, 5);
        add_fd(listen_fd, EPOLLIN);
    }

    void handle_event(const epoll_event& ev) override {
        if (ev.data.fd == listen_fd) {
            int conn_fd = accept(listen_fd, nullptr, nullptr);
            // 将conn_fd分配给从Reactor
            // 这里省略了具体的分配逻辑
            std::cout << "New connection: " << conn_fd << std::endl;
        }
    }

private:
    int listen_fd;
};

// Handler类
class Handler : public Reactor {
public:
    Handler(int fd) : conn_fd(fd) {
        add_fd(conn_fd, EPOLLIN | EPOLLET);
    }

    void handle_event(const epoll_event& ev) override {
        if (ev.events & EPOLLIN) {
            char buf[1024];
            int n = read(conn_fd, buf, sizeof(buf));
            if (n > 0) {
                // 处理业务逻辑
                std::cout << "Received data: " << std::string(buf, n) << std::endl;
            } else {
                close(conn_fd);
            }
        }
    }

private:
    int conn_fd;
};

// 主函数
int main() {
    Acceptor acceptor(8080);
    std::thread main_thread([&acceptor]() { acceptor.run(); });

    // 假设有多个从Reactor线程
    std::vector<std::thread> workers;
    for (int i = 0; i < 4; ++i) {
        workers.emplace_back([]() {
            // 从Reactor的逻辑
        });
    }

    main_thread.join();
    for (auto& t : workers) {
        t.join();
    }

    return 0;
}
```

---

## 5. 优化与扩展
- **线程池动态调整**：根据负载动态调整从Reactor的线程数量。
- **零拷贝技术**：使用`sendfile`或`mmap`减少数据拷贝。
- **协议优化**：支持HTTP/2、WebSocket等高性能协议。
- **异步日志**：使用异步日志库记录日志，避免阻塞主线程。

---

通过以上设计，主从Reactor架构能够高效处理高并发请求，是C++网络服务器开发的经典模式。