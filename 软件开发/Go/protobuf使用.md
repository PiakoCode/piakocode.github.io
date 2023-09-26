# protobuf使用

[Protocol Buffer Basics: Go | Protocol Buffers Documentation (protobuf.dev)](https://protobuf.dev/getting-started/gotutorial/)

[Go Protobuf 简明教程 | 快速入门 | 极客兔兔 (geektutu.com)](https://geektutu.com/post/quick-go-protobuf.html#1-Protocol-Buffers-%E7%AE%80%E4%BB%8B)

proto文件内容
```proto
syntax = "proto3"; // 注明使用proto3
package pratice;
option go_package="."; //文件输出的目录

// 数字为标识号
message Student {
    string name = 1;
    bool male = 2;
    repeated int32 scores = 3;
}
```

生成代码
```shell
protoc --go_out=. *.proto
```

结果
![](Picture/Pasted%20image%2020230301183948.png)

- protobuf 有2个版本，默认版本是 proto2，如果需要 proto3，则需要在非空非注释第一行使用 `syntax = "proto3"` 标明版本。
- `package`，即包名声明符是可选的，用来防止不同的消息类型有命名冲突。
- `option` 文件输出的目录
- 消息类型 使用 `message` 关键字定义，Student 是类型名，name, male, scores 是该类型的 3 个字段，类型分别为 string, bool 和 []int32。字段可以是标量类型，也可以是合成类型。
- 每个字段的修饰符默认是 singular，一般省略不写，`repeated` 表示字段可重复，即用来表示 Go 语言中的数组类型。
- 每个字符 ` = ` 后面的数字称为标识符，每个字段都需要提供一个唯一的标识符。标识符用来在消息的二进制格式中识别各个字段，一旦使用就不能够再改变，标识符的取值范围为 [1, 2^29 - 1] 。
- .proto 文件可以写注释，单行注释 `//`，多行注释 `/* ... */`
- 一个 .proto 文件中可以写多个消息类型，即对应多个结构体(struct)。

main.go 样例
证明序列化和反序列化后的示例，包含相同的数据
```go
package pratice

import (
	"log"

	"google.golang.org/protobuf/proto"
)

func main() {
	test := &Student{
		Name:   "geektutu",
		Male:   true,
		Scores: []int32{98, 85, 88},
	}
	data, err := proto.Marshal(test)
	if err != nil {
		log.Fatal("marshaling error: ", err)
	}
	newTest := &Student{}
	err = proto.Unmarshal(data, newTest)
	if err != nil {
		log.Fatal("unmarshaling error: ", err)
	}
	// Now test and newTest contain the same data.
	if test.GetName() != newTest.GetName() {
		log.Fatalf("data mismatch %q != %q", test.GetName(), newTest.GetName())
	}
}
```


## proto文件格式

TODO:



## grpc使用步骤

**编写proto文件**
```proto
syntax = "proto3";  
package  service;  
option go_package="..;service";  
  
message HelloRequest {  
  string name = 1;  
}  
  
message HelloReply {  
  string message = 1;  
}  
  
  
service Greeter {  
  rpc SayHello(HelloRequest) returns (HelloReply) {}  
}
```

使用指令`protoc --go_out=. *.proto` 和 `protoc --go-grpc_out=. *.proto` 生成两个文件


- `xxx.pb.go` - 包含xxx.pb包，其中包含我们定义的HelloRequest、HelloReply和Greeter服务的代码。
-   `xxx_grpc.pb.go` - 包含xxx.pb.go中定义的服务的gRPC代码。

***

**编写服务端代码**

```go
package main  
  
import (  
   "context"  
   "google.golang.org/grpc"   
   "log"   
   "net"   
   pb "server/service"  
)  
  
const (  
   port = ":50051"  
)  

// 实现server
type server struct {  
   pb.UnimplementedGreeterServer  
}  
  
func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {  
   log.Printf("Received: %v", in.Name)  
   return &pb.HelloReply{Message: "Hello " + in.Name}, nil  
}  
  
func main() {  
    // 开启端口
   lis, _ := net.Listen("tcp", port)  

   // 创建grpc服务
   s := grpc.NewServer()  
   // 在grpc服务端中注册自己编写的服务
   pb.RegisterGreeterServer(s, &server{})

    // 启动服务
   if err := s.Serve(lis); err != nil {  
      log.Fatalf("failed to serve: %v", err)  
   }
}
```

1.  导入所需的包和.proto文件中生成的相关包。
2.  定义常量port，指定要监听的TCP端口。
3.  实现server结构体，其中实现了SayHello服务的具体实现。
4.  注册此实现的服务。
5.  创建gRPC服务器，并调用Serve方法监听端口。

- 编写客户端代码
```go
package main  
  
import (  
   "context"  
   "google.golang.org/grpc/credentials/insecure"   
   "log"   
   "os"   
   "time"  
   "google.golang.org/grpc"   
   pb "server/service"  
)  
  
const (  
   address     = "localhost:50051"  
   defaultName = "world"  
)  
  
func main() {  
   // Set up a connection to the server.
   conn, err := grpc.Dial(address, grpc.WithTransportCredentials(insecure.NewCredentials()))  
   
   if err != nil {  
      log.Fatal(err)  
   }   
   defer conn.Close()  
   
   c := pb.NewGreeterClient(conn)  
  
   // Contact the server and print out its response.  
   name := defaultName  
   if len(os.Args) > 1 {  
      name = os.Args[1]  
   }   
   ctx, cancel := context.WithTimeout(context.Background(), time.Second)  
   
   defer cancel()  
   
   r, err := c.SayHello(ctx, &pb.HelloRequest{Name: name})  
   
   if err != nil {  
      log.Fatalf("could not greet: %v", err)  
   }   
   log.Printf("Greeting: %s", r.Message)  
}
```

1. 创建与给定目标（服务器） 的连接交互
2. 创建server的客户端对象
3. 发送RPC请求，等待同步响应，得到回调后返回响应结果、
4. 输出响应结果