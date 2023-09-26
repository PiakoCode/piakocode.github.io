# Unix网络编程


SOCK_STREAM
TCP套接字

SOCK_DGRAM
UDP套接字

![](Picture/Pasted%20image%2020230508202302.png)


1. 调用socket函数创建套接字
2. 调用bind函数分配IP地址和端口号
3. 调用listen函数转为可接收请求状态
4. 调用accept函数受理连接请求。