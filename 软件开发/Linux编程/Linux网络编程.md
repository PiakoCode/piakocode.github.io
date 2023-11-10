# Linux 网络编程


应用程序使用socket进行通信的方式如下：
- 各个各个应用程序创建一个 socket。socket 是一个允许通信的“设备”,两个应用程序都需要用到它。
- 服务器将自己的 socket 绑定到一个众所周知的地址(名称)上使得客户端能够定位到它的位置。


使用 socket() 系统调用能够创建一个 socket,它返回一个用来在后续系统调用中引用该 socket 的文件描述符。

`fd = socket(domain, type, protocol)`

每个 socket 实现都至少提供了两种 socket：*流和数据报*

| 属性           | 流  | 数据报 |
| -------------- |: --- :|: ------: |
| 可靠地递送？   | 是  | 否     |
| 消息边界保留？ | 否  | 是     |
| 面向连接？     | 是  | 否     |

一个数据报 socket 在使用时无需与另一个 socket 连接。


**关键的 socket 系统调用**
- `socket()`: 创建一个新的`socket`
- `bind()`: 将一个`socket`绑定到一个地址上
- `lieten()`: 允许一个流`socket`接受来自其他`socket`的接入连接
- `accept()`: 在一个监听流 `socket` 上接受来自一个对等应用程序的连接，并可选地返回对等 `socket` 的地址
- `connect()`: 建立与另一个`socket`之间的连接

***


**socket()**

创建一个新的socket

```c
#include <sys/socket.h>

int socket(int domain, int type, int protocol) // Returns filedescriptor on success, or -1 on error

```

- `domain` 参数指定了 `socket` 的通信 domain。对于TCP/IP协议族而言，该参数应该设置为PF_INET(Protocal Family of Internet，用于IPv4)或PF_INET6(用于IPv6)，对于UNIX本地协议族而言，该参数应设置为PF_UNIX。

- `type` 参数指定了 `socket` 类型。这个参数通常在创建流 `socket` 时会被指定为 `SOCK_STREAM`，而在创建数据报 `socket` 时会被指定为 `SOCK_DGRAM`。
- `protocol` 几乎都指定为 0


**bind()**

将一个`socket`绑定到一个*地址*上

```c
#include <sys/socket.h>

int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen); // Returns 0 on success, or -1 on error

```

- `socket`是在上一个socket()调用中获得的文件描述符
- `addr` 是一个指针，指向一个指定该socket绑定到的地址的结构
- `addlen` 是地址结构的大小


**struct sockaddr**

```c
struct sockaddr {
    sa_family_t sa_family;    // Address family
    char        sa_data[14];  // Socket address (size varies according to socket domain)
}
```



**监听接入连接：listen()**

TCP

`listen()`系统调用将文件描述符 sockfd 引用的流 socket 标记为被动。这个 socket 后面会被用来接受来自其他(主动的)socket 的连接。

```c
#include <sys/socket.h>

int listen(int sockfd, int backlog); // Returns 0 on success, or -1 on error
```

**接受连接：accept()**

TCP

`accept()`系统调用在文件描述符 sockfd 引用的监听流 socket 上接受一个接入连接。如果在调用`accept()`时不存在未决的连接,那么调用就会阻塞直到有连接请求到达为止。

```c
#include <sys/socket.h>

int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);// Returns file descriptor on success, or -1 on error
```

**连接到对等 socket：connect()**

TCP

connect()系统调用将文件描述符 sockfd 引用的主动 socket 连接到地址通过 addr 和 addrlen指定的监听 socket 上。

```c
#include <sys/socket.h>

int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);// Returns 0 on success, or -1 on error
```

**连接终止：close()**

终止一个流 socket 连接的常见方式是调用 close()。如果多个文件描述符引用了同一个socket,那么当所有描述符被关闭之后连接就会终止。


**sendto()**

UDP

sendto是一个网络编程中用于发送数据的函数，它可以向指定的目的地址发送数据，并且支持在UDP和Raw Socket中使用。在Linux中，sendto函数通常用于发送数据报文到指定的目的地址，可以是IPv4或IPv6地址。

sendto函数的原型如下：
```c
ssize_t sendto(int sockfd, const void *buf, size_t len, int flags, const struct sockaddr *dest_addr, socklen_t addrlen);
```
参数说明：
- sockfd：指定发送数据的套接字描述符。
- buf：指向要发送数据的缓冲区的指针。
- len：要发送的数据的长度。
- flags：指定发送数据的方式，通常可以设置为0。
- dest_addr：指定目的地址的sockaddr结构体指针，包括目的IP地址和端口号。
- addrlen：dest_addr结构体的长度。

成功调用sendto函数后，数据将被发送到指定的目的地址。如果函数调用成功，它将返回已发送的字节数，如果发生错误，则返回-1，并设置errno变量以指示错误类型。


**recvfrom()**

UDP

recvfrom函数用于从一个已连接的套接字上接收数据，并同时获取发送数据的主机地址和端口号。它的原型如下：

```c
ssize_t recvfrom(int sockfd, void *buf, size_t len, int flags, struct sockaddr *src_addr, socklen_t *addrlen);
```

参数说明：

- sockfd：要接收数据的已连接套接字的文件描述符。
- buf：用于存放接收数据的缓冲区。
- len：buf的大小。
- flags：接收操作的标志。通常设置为0。
- src_addr：用于存放发送数据的主机地址信息的结构体指针。
- addrlen：src_addr的大小。

recvfrom函数返回接收到的字节数，如果返回0表示连接已经关闭，-1表示出错。

- 由于UDP是不面向连接的，因此我们除了获取到数据以外还需要获取到对端网络相关的属性信息，包括IP地址和端口号等。
- 在调用recvfrom读取数据时，必须将addrlen设置为你要读取的结构体对应的大小。
- 由于recvfrom函数提供的参数也是struct sockaddr_类型的，因此我们在传入结构体地址时需要将struct sockaddr_in_类型进行强转。





>[!tip] 
>sendto函数用于向指定的目标地址发送数据，常用于UDP通信，可以指定数据的目标地址和端口。
>
>accept函数用于在服务器端接受客户端的连接请求，当有新的客户端连接到服务器时，服务器调用accept函数来建立一个与客户端的连接，并返回一个新的套接字用于与客户端通信。




htons()、htonl()、ntohs()以及 ntohl()函数被定义(通常为宏)用来在主机和网络字节序之间转换整数。

```c
#include <arpa/inet.h>
#include <netinet/in.h>

// host to network
uint16_t htons(uint16_t host_uint16);

uint32_t htonl(uint32_t host_uint32);

// network to host
uint16_t ntohs(uint16_t net_uint16);

uint32_t ntohl(uint32_t net_uint32);


```


**Internet socket 地址**

`struct sockadd_in`

```c
#include <arpa/inet.h>

struct in_addr {        // IPv4 4-byte address
    in_addr_t s_addr;   // Unsigned 32-bit integer
}

struct sockaddr_in {
    sa_family_t    sin_family;
    in_port_t      sin_port;
    struct in_addr sin_addr;
    unsigned char  __pad[X];
}
```

example

server端
```c
    struct sockaddr_in server_addr;

    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons(atoi(argv[1])); // port 端口
```


***

服务器端代码：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    int server_fd, client_fd;
    struct sockaddr_in server_addr, client_addr;
    socklen_t client_addr_len = sizeof(client_addr);
    char buffer[BUFFER_SIZE];

    // 创建套接字
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // 绑定套接字到服务器地址和端口
    if (bind(server_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("bind");
        exit(EXIT_FAILURE);
    }

    // 监听连接请求
    if (listen(server_fd, 5) == -1) {
        perror("listen");
        exit(EXIT_FAILURE);
    }

    printf("Server listening on port %d...\n", PORT);

    // 接受客户端连接
    client_fd = accept(server_fd, (struct sockaddr *)&client_addr, &client_addr_len);
    if (client_fd == -1) {
        perror("accept");
        exit(EXIT_FAILURE);
    }

    printf("Client connected: %s:%d\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));

    // 接收并打印客户端发送的消息
    while (1) {
        memset(buffer, 0, BUFFER_SIZE);
        if (recv(client_fd, buffer, BUFFER_SIZE, 0) == -1) {
            perror("recv");
            exit(EXIT_FAILURE);
        }

        if (strcmp(buffer, "exit\n") == 0) {
            break;
        }

        printf("Received message: %s", buffer);
    }

    // 关闭连接
    close(client_fd);
    close(server_fd);

    printf("Server disconnected.\n");

    return 0;
}
```

客户端代码：

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define SERVER_IP "127.0.0.1"
#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    int client_fd;
    struct sockaddr_in server_addr;
    char buffer[BUFFER_SIZE];

    // 创建套接字
    client_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (client_fd == -1) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // 设置服务器地址和端口
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr(SERVER_IP);
    server_addr.sin_port = htons(PORT);

    // 连接服务器
    if (connect(client_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1) {
        perror("connect");
        exit(EXIT_FAILURE);
    }

    printf("Connected to server: %s:%d\n", SERVER_IP, PORT);

    // 发送消息给服务器
    while (1) {
        printf("Enter a message (or 'exit' to quit): ");
        fgets(buffer, BUFFER_SIZE, stdin);

        if (send(client_fd, buffer, strlen(buffer), 0) == -1) {
            perror("send");
            exit(EXIT_FAILURE);
        }

        if (strcmp(buffer, "exit\n") == 0) {
            break;
        }
    }

    // 关闭连接
    close(client_fd);

    printf("Disconnected from server.\n");

    return 0;
}
```



***

helloserver.c
```c
#include <netinet/in.h>
#include <stdio.h>
#include <arpa/inet.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

void error_handing(char *message);


// ./build/server 9091 

int main(int argc, char *argv[]) 
{
    int serv_sock;
    int clnt_sock;

    struct sockaddr_in serv_addr;
    struct sockaddr_in clnt_addr;

    socklen_t clnt_addr_size;

    char message[] = "Hello, World!";

    if (argc != 2) 
    {
        printf("Usage : %s <port>\n", argv[0]);
        exit(1);
    }

    serv_sock = socket(PF_INET, SOCK_STREAM, 0);

    if (serv_sock == -1) {
        error_handing("socket() error");
    }

    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    serv_addr.sin_port = htons(atoi(argv[1]));

    if (bind(serv_sock, (struct sockaddr*) &serv_addr, sizeof(serv_addr)) == -1)
    {
        error_handing("bind() error");
    }

    if (listen(serv_sock, 5) == -1)
    {
        error_handing("listen() error");
    }

    clnt_addr_size = sizeof(clnt_addr);
    clnt_sock = accept(serv_sock, (struct sockaddr*)&clnt_addr, &clnt_addr_size);

    if (clnt_sock == -1) {
        error_handing("accept() error");
    }

    write(clnt_sock, message, sizeof(message));
    close(clnt_sock);
    close(serv_sock);

    return 0;

}



void error_handing(char *message) {
    fputs(message, stderr);
    fputc('\n', stderr);
    exit(1);

}
```





helloclient.c
```c
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

void error_handing(char *message);

//  ./build/client 127.0.0.1 9091

int main(int argc, char* argv[]) {
    int sock;
    struct sockaddr_in serv_addr;
    char message[30];
    int str_len;

    if (argc != 3) {
        printf("Usage : %s <IP> <port>\n", argv[0]);
        exit(1);
    }

    sock = socket(PF_INET, SOCK_STREAM, 0);

    if (sock == -1) 
        error_handing("socket() error");

    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = inet_addr(argv[1]);
    serv_addr.sin_port = htons(atoi(argv[2]));

    if (connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) == -1)
        error_handing("connect() error!");

    str_len = read(sock, message, sizeof(message) - 1);
    if (str_len == -1)
        error_handing("read() error");

    printf("Message from server : %s \n", message);
    close(sock);
    return 0;
}


void error_handing(char *message) {
    fputs(message, stderr);
    fputc('\n', stderr);
    exit(1);

}
```
















