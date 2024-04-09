# JavaOI流

### FileInputStream

### BufferedOutputStream

```java
import java.io.*;
import java.util.Scanner;

public class Bu {
    public static void main(String[] args) throws IOException {
        BufferedOutputStream bufferedOutputStream=new BufferedOutputStream(new FileOutputStream("1.txt"));
        Scanner in=new Scanner(System.in);
        String s=in.nextLine();
        bufferedOutputStream.write(s.getBytes());//将String转化为byte输出到文件中
        bufferedOutputStream.close();
    }
}
```



### BufferedInputStream

```java
import java.io.*;

public class Bu {
    public static void main(String[] args) throws IOException {
        BufferedInputStream inputStream=new BufferedInputStream(new FileInputStream("1.txt"));
        byte[] bytes=new byte[1024];
        int tmp;
        while((tmp=inputStream.read(bytes))!=-1){
            System.out.println(new String(bytes,0,tmp));//将文件中的byte转化为String输入到程序中
        }
        intputStream.close();
    }
}
```

### Buffered流复制视频

```java
import java.io.*;

public class Bu{
    public static void main(String[] args) throws IOException {
        BufferedOutputStream outputStream=new BufferedOutputStream(new FileOutputStream("2.mp4"));
        BufferedInputStream inputStream=new BufferedInputStream(new FileInputStream("1.mp4"));
        byte[] bytes=new byte[1024];
        int tmp;
        while((tmp=inputStream.read(bytes))!=-1){
            outputStream.write(bytes,0,tmp);
        }
        outputStream.close();
        inputStream.close();
    }
}
```

## JavaWeb

### 使用Socket传输文件

**客户端**

```java
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.Socket;

public class Main {
    public static void main(String[] args){
        try(Socket socket =new Socket("localhost",8080)) {
            FileInputStream fileInputStream=new FileInputStream("1.mp4");
            OutputStream stream=socket.getOutputStream();
            byte[] bytes=new byte[1024];

            int tmp;
            while((tmp=fileInputStream.read(bytes))!=-1) {
                stream.write(bytes,0,tmp);
            }
            stream.flush();
        }catch (Exception e){
            System.out.println("连接失败!!!");
            e.printStackTrace();
        }
    }
}
```



**服务端**

```java
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
    public static void main(String[] args){
        try(ServerSocket server=new ServerSocket(8080)){
            Socket socket=server.accept();
            FileOutputStream fileOutputStream=new FileOutputStream("net/2.mp4");
            InputStream stream=socket.getInputStream();
            int tmp;
            byte[] bytes=new byte[1024];
            while((tmp=stream.read(bytes))!=-1) {
                fileOutputStream.write(bytes,0,tmp);
            }
            fileOutputStream.flush();;
            fileOutputStream.close();
        }catch (IOException e){
            e.printStackTrace();
        }
    }
}

```

### 浏览器访问Socket服务器

```java
public static void main(String[] args) {
    try(ServerSocket server = new ServerSocket(8080)){    //将服务端创建在端口8080上
        System.out.println("正在等待客户端连接...");
        Socket socket = server.accept();
        System.out.println("客户端已连接，IP地址为："+socket.getInetAddress().getHostAddress());
        BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));  //通过
        System.out.println("接收到客户端数据：");
        while (reader.ready()) System.out.println(reader.readLine());   //ready是判断当前流中是否还有可读内容
        OutputStreamWriter writer = new OutputStreamWriter(socket.getOutputStream());
        writer.write("HTTP/1.1 200 Accepted\r\n");   //200是响应码，Http协议规定200为接受请求，400为错误的请求，404为找不到此资源（不止这些，还有很多）
        writer.write("\r\n");   //在请求头写完之后还要进行一次换行，然后写入我们的响应实体（会在浏览器上展示的内容）
        writer.write("lbwnb!");
        writer.flush();
    }catch (Exception e){
        e.printStackTrace();
    }
}
```

