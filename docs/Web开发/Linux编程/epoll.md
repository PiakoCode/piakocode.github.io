# epoll

`epoll` 是 Linux 提供的一种高效的 I/O 事件通知机制，用于监控多个文件描述符（file descriptors）的状态变化（如可读、可写、错误等）。它是 `select` 和 `poll` 的改进版本，特别适合处理大量并发连接的场景（如高性能网络服务器）。

`epoll` 的核心思想是：**通过内核与用户空间的协作，高效地通知应用程序哪些文件描述符已经就绪**。

---

### 1. `epoll` 的核心机制

`epoll` 的机制可以分为以下几个部分：

#### 1.1 **事件驱动**
- `epoll` 是事件驱动的，应用程序只需要关注感兴趣的事件（如可读、可写），而不需要主动轮询文件描述符的状态。
- 当文件描述符的状态发生变化时，内核会通知应用程序。

#### 1.2 **高效的数据结构**
- `epoll` 使用红黑树（Red-Black Tree）和双向链表（Doubly Linked List）来管理文件描述符和事件。
  - **红黑树**：用于存储所有被监控的文件描述符，支持高效的插入、删除和查找操作。
  - **双向链表**：用于存储就绪的事件，内核会将就绪的事件添加到链表中，供应用程序读取。

#### 1.3 **边缘触发（ET）和水平触发（LT）**
- `epoll` 支持两种事件触发模式：
  - **水平触发（Level Triggered, LT）**：
    - 默认模式。
    - 只要文件描述符处于就绪状态（如缓冲区有数据），`epoll_wait` 就会不断通知。
  - **边缘触发（Edge Triggered, ET）**：
    - 需要显式设置 `EPOLLET` 标志。
    - 只有当文件描述符状态发生变化时（如从无数据到有数据），`epoll_wait` 才会通知。

#### 1.4 **内核与用户空间的协作**
- `epoll` 通过以下系统调用实现内核与用户空间的协作：
  - `epoll_create`：创建一个 `epoll` 实例。
  - `epoll_ctl`：向 `epoll` 实例中添加、修改或删除文件描述符。
  - `epoll_wait`：等待文件描述符上的事件发生。

---

### 2. `epoll` 的工作流程

#### 2.1 创建 `epoll` 实例
- 使用 `epoll_create` 或 `epoll_create1` 创建一个 `epoll` 实例。
- 返回一个文件描述符，用于后续操作。

```c
int epoll_fd = epoll_create1(0);
if (epoll_fd == -1) {
    perror("epoll_create1");
    exit(EXIT_FAILURE);
}
```

#### 2.2 注册文件描述符
- 使用 `epoll_ctl` 向 `epoll` 实例中添加、修改或删除文件描述符。
- 需要指定感兴趣的事件类型（如 `EPOLLIN`、`EPOLLOUT`）和用户数据（如文件描述符）。

```c
struct epoll_event ev;
ev.events = EPOLLIN;  // 监听可读事件
ev.data.fd = sockfd;  // 存储文件描述符
if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, sockfd, &ev) == -1) {
    perror("epoll_ctl");
    exit(EXIT_FAILURE);
}
```

#### 2.3 等待事件
- 使用 `epoll_wait` 等待文件描述符上的事件发生。
- 内核会将就绪的事件填充到 `epoll_event` 结构体数组中。

```c
struct epoll_event events[MAX_EVENTS];
int n = epoll_wait(epoll_fd, events, MAX_EVENTS, -1);
if (n == -1) {
    perror("epoll_wait");
    exit(EXIT_FAILURE);
}

for (int i = 0; i < n; i++) {
    if (events[i].events & EPOLLIN) {
        printf("File descriptor %d is ready for reading.\n", events[i].data.fd);
    }
}
```

#### 2.4 处理事件
- 根据 `epoll_wait` 返回的事件类型，执行相应的操作（如读取数据、写入数据、关闭连接等）。

---

### 3. `epoll` 的优势

#### 3.1 高效的文件描述符管理
- `epoll` 使用红黑树管理文件描述符，插入、删除和查找的时间复杂度为 O(log N)。
- 相比于 `select` 和 `poll` 的线性扫描，`epoll` 的性能更高。

#### 3.2 高效的事件通知
- `epoll` 使用双向链表存储就绪的事件，应用程序只需要遍历就绪的事件，而不需要遍历所有文件描述符。

#### 3.3 支持边缘触发（ET）
- 边缘触发模式可以减少事件通知的次数，适合高性能场景。

#### 3.4 支持大量文件描述符
- `epoll` 没有文件描述符数量的限制（仅受系统资源限制），而 `select` 和 `poll` 通常有文件描述符数量的限制（如 1024）。

---

### 4. `epoll` 的局限性

#### 4.1 仅适用于 Linux
- `epoll` 是 Linux 特有的机制，其他操作系统（如 Windows、macOS）不支持。

#### 4.2 编程复杂度较高
- 相比于 `select` 和 `poll`，`epoll` 的编程模型更复杂，尤其是边缘触发模式需要确保一次性处理完所有数据。

---

### 5. 完整示例

以下是一个使用 `epoll` 的完整示例，展示了如何实现一个简单的 TCP 服务器：

```c
#include <sys/epoll.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_EVENTS 10

int main() {
    int listen_fd, conn_fd, epoll_fd;
    struct sockaddr_in server_addr;
    struct epoll_event ev, events[MAX_EVENTS];

    // 创建监听套接字
    listen_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (listen_fd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 绑定地址
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    server_addr.sin_port = htons(8080);
    if (bind(listen_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        close(listen_fd);
        exit(EXIT_FAILURE);
    }

    // 监听
    if (listen(listen_fd, 10) == -1) {
        perror("listen");
        close(listen_fd);
        exit(EXIT_FAILURE);
    }

    // 创建 epoll 实例
    epoll_fd = epoll_create1(0);
    if (epoll_fd == -1) {
        perror("epoll_create1");
        close(listen_fd);
        exit(EXIT_FAILURE);
    }

    // 注册监听套接字
    ev.events = EPOLLIN;
    ev.data.fd = listen_fd;
    if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, listen_fd, &ev) == -1) {
        perror("epoll_ctl");
        close(listen_fd);
        close(epoll_fd);
        exit(EXIT_FAILURE);
    }

    // 事件循环
    while (1) {
        int n = epoll_wait(epoll_fd, events, MAX_EVENTS, -1);
        if (n == -1) {
            perror("epoll_wait");
            break;
        }

        for (int i = 0; i < n; i++) {
            if (events[i].data.fd == listen_fd) {
                // 接受新连接
                conn_fd = accept(listen_fd, NULL, NULL);
                if (conn_fd == -1) {
                    perror("accept");
                    continue;
                }

                // 注册新连接
                ev.events = EPOLLIN | EPOLLET;
                ev.data.fd = conn_fd;
                if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, conn_fd, &ev) == -1) {
                    perror("epoll_ctl");
                    close(conn_fd);
                }
            } else {
                // 处理可读事件
                char buffer[1024];
                ssize_t count = read(events[i].data.fd, buffer, sizeof(buffer));
                if (count == -1) {
                    perror("read");
                } else if (count == 0) {
                    // 对端关闭连接
                    close(events[i].data.fd);
                } else {
                    // 处理数据
                    printf("Received: %s\n", buffer);
                }
            }
        }
    }

    close(listen_fd);
    close(epoll_fd);
    return 0;
}
```

---

### 6. 总结
- `epoll` 是 Linux 提供的高效 I/O 事件通知机制，适合处理大量并发连接。
- 它通过红黑树和双向链表实现高效的文件描述符管理和事件通知。
- `epoll` 支持水平触发（LT）和边缘触发（ET）两种模式，适合不同的应用场景。
- 相比于 `select` 和 `poll`，`epoll` 的性能更高，但编程复杂度也更高。


## 工作流程


`epoll` 的工作流程可以概括为以下几个步骤：

---

### 1. **创建 `epoll` 实例**
   - 首先，通过 `epoll_create` 或 `epoll_create1` 创建一个 `epoll` 实例。
   - 这个实例本质上是一个内核中的数据结构，用于存储和管理需要监控的文件描述符（如套接字）。
   - 创建成功后，会返回一个文件描述符（`epoll_fd`），用于后续操作。

---

### 2. **注册需要监控的文件描述符**
   - 使用 `epoll_ctl` 向 `epoll` 实例注册需要监控的文件描述符。
   - 注册时需要指定：
     - 要监控的文件描述符（如套接字）。
     - 感兴趣的事件类型（如可读事件 `EPOLLIN`、可写事件 `EPOLLOUT` 等）。
     - 可选的用户数据（通常用于标识文件描述符）。
   - 注册后，`epoll` 实例会开始监控这些文件描述符的状态变化。

---

### 3. **等待事件发生**
   - 使用 `epoll_wait` 等待注册的文件描述符上发生事件。
   - `epoll_wait` 会阻塞（除非设置了超时），直到有文件描述符就绪（如数据到达、连接请求等）。
   - 当事件发生时，`epoll_wait` 会返回一个就绪事件列表，列表中包含所有触发事件的文件描述符及其事件类型。

---

### 4. **处理就绪事件**
   - 遍历 `epoll_wait` 返回的就绪事件列表，处理每个文件描述符上的事件。
   - 例如：
     - 如果是可读事件（`EPOLLIN`），可以读取数据或接受新连接。
     - 如果是可写事件（`EPOLLOUT`），可以发送数据。
   - 处理完事件后，根据需要决定是否继续监控该文件描述符，或者将其从 `epoll` 实例中移除。

---

### 5. **循环监控**
   - 通常，`epoll` 会与一个事件循环结合使用。
   - 在循环中，不断调用 `epoll_wait` 等待新事件，并处理就绪的文件描述符。
   - 这种机制非常适合高并发场景，因为它可以高效地处理大量文件描述符，而不会因为遍历所有描述符而导致性能下降。

---

### 6. **边缘触发（ET）与水平触发（LT）模式**
   - `epoll` 支持两种事件触发模式：
     - **水平触发（LT）**：只要文件描述符处于就绪状态，`epoll_wait` 就会不断通知。
     - **边缘触发（ET）**：只在文件描述符状态发生变化时通知一次，需要一次性处理所有数据。
   - 开发者可以根据需求选择合适的模式。

---

### 7. **关闭和清理**
   - 当不再需要监控某些文件描述符时，可以使用 `epoll_ctl` 将其从 `epoll` 实例中移除。
   - 最后，关闭 `epoll` 实例的文件描述符（`epoll_fd`），释放资源。

---

### 工作流程总结
1. 创建 `epoll` 实例。
2. 注册需要监控的文件描述符及其事件。
3. 等待事件发生（`epoll_wait`）。
4. 处理就绪事件。
5. 循环监控，直到程序结束。
6. 关闭和清理资源。

`epoll` 的核心优势在于其高效的事件通知机制，能够处理大量并发连接，特别适合高并发的网络服务器场景。