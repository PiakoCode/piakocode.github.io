# SpringBoot

在Spring Boot中，`@RestController` 和 `@Controller` 注解的区别在于它们处理 HTTP 请求的方式不同。

`@RestController` 会将处理方法的返回值直接转换成 JSON 或 XML 格式，并将其响应给客户端。这意味着当你使用 `@RestController` 注解时，你不需要每个方法上都加上 `@ResponseBody` 注解。

例如，当你使用 `@RestController` 注解时，一个处理 GET 请求的方法可以这样写：

```java
@RestController
public class MyRestController {

    @GetMapping("/hello")
    public String sayHello() {
        return "Hello World!";
    }
}
```

然而，如果你使用 `@Controller` 注解，你需要使用 `@ResponseBody` 注解来告诉 Spring MVC 将处理方法的返回值转换成 JSON 或 XML 格式。

例如，当你使用 `@Controller` 注解时，一个处理 GET 请求的方法可以这样写：

```java
@Controller
public class MyController {

    @GetMapping("/hello")
    @ResponseBody
    public String sayHello() {
        return "Hello World!";
    }
}
```

其他写法

```java
@Controller
@RequestMapping("/user")
public class UserController {

    @GetMapping("/list")
    public String listUsers() {
    }

    @GetMapping("/details")
    public String userDetails() {
    }
}

这样listUsers()方法就只会拦截到/user/list路径下的GET请求，userDetails()方法就只会拦截到/user/details路径下的GET请求。
```

## Mabatis Plus

### 基本使用


添加依赖

```xml
<dependency>
     <groupId>com.baomidou</groupId>
     <artifactId>mybatis-plus-boot-starter</artifactId>
     <version>3.5.3.1</version>
</dependency>
<dependency>
     <groupId>com.mysql</groupId>
     <artifactId>mysql-connector-j</artifactId>
     <version>8.0.33</version>
</dependency>
```


配置数据源

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/test
    username: root
    password: 123456
    driver-class-name: com.mysql.cj.jdbc.Driver
```


entity/User.java

```java
@Data  
@TableName("user")  
public class User {  
    @TableId(type = IdType.AUTO)  
    int id;  
    @TableField("name")  
    String name;  
    @TableField("email")  
    String email;  
    @TableField("password")  
    String password;  
}
```


mapper/UserMapper.java

```java
@Mapper
public interface UserMapper extends BaseMapper<User> {

}
```

MySpringBootApplicationTests.java

```java
@SpringBootTest  
class MySpringBootApplicationTests {  
    @Resource  
    UserMapper mapper;  
  
  
    @Test  
    void contextLoad() {  
        User user = new User();  
        user.setEmail("123123");  
        user.setName("asdfasdf");  
        mapper.insert(user);  
    }  
  
  
}
```

### 条件构造器

[条件构造器 | MyBatis-Plus](https://baomidou.com/pages/10c804/#abstractwrapper)

[条件构造器](SpringBoot笔记（二）数据交互.md#条件构造器)

```java
@Test
void contextLoads() {
    QueryWrapper<User> wrapper = new QueryWrapper<>();    //复杂查询可以使用QueryWrapper来完成
  	wrapper
            .select("id", "name", "email", "password")    //可以自定义选择哪些字段
            .ge("id", 2)     			//选择判断id大于等于1的所有数据
            .orderByDesc("id");   //根据id字段进行降序排序
    System.out.println(mapper.selectList(wrapper));   //Mapper同样支持使用QueryWrapper进行查询
}
```

通过使用上面的QueryWrapper对象进行查询，也就等价于下面的SQL语句：

```sql
select id,name,email,password from user where id >= 2 order by id desc
```


有些时候我们遇到需要批处理的情况，也可以直接使用批处理操作：

```java
@Test
void contextLoads() {
    //支持批处理操作，我们可以一次性删除多个指定ID的用户
    int count = mapper.deleteBatchIds(List.of(1, 3));
    System.out.println(count);
}
```

我们也可以快速进行分页查询操作，不过在执行前我们需要先配置一下：

```java
@Configuration
public class MybatisConfiguration {
    @Bean
    public MybatisPlusInterceptor paginationInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
      	//添加分页拦截器到MybatisPlusInterceptor中
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        return interceptor;
    }
}
```

这样我们就可以愉快地使用分页功能了：

```java
@Test
void contextLoads() {
    //这里我们将用户表分2页，并获取第一页的数据
    Page<User> page = mapper.selectPage(Page.of(1, 2), Wrappers.emptyWrapper());
    System.out.println(page.getRecords());   //获取分页之后的数据
}
```

### 代码生成


```xml

<!--- Mybatis plus 的依赖， 以及以下的依赖-->
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-generator</artifactId>
    <version>3.5.3.1</version>
</dependency>
<dependency>  
    <groupId>org.apache.velocity</groupId>  
    <artifactId>velocity-engine-core</artifactId>  
    <version>2.3</version>  
</dependency>

```



```java
import javax.sql.DataSource;  
  
@SpringBootTest  
class TestApplicationTests {  
    @Autowired  
    DataSource dataSource;  
  
    @Test  
    void contextLoads() {  
        FastAutoGenerator  
                //首先使用create来配置数据库链接信息  
                .create(new DataSourceConfig.Builder(dataSource))  
                .globalConfig(builder -> {  
                    builder.author("Piako");  
                    builder.commentDate("2023-09-24");  
                    builder.outputDir("src/main/java");  
                })  
                .packageConfig(builder ->  
                    builder.parent("com.example.test")  
                )                .strategyConfig(builder -> {  
                    builder.mapperBuilder()  
                            .mapperAnnotation(Mapper.class)  // 需要导入ibatis的包
                            .build();  
                })  
                .execute();  
    }  
}
```


## 前后端分离

### 返回响应数据

创建一个实体类来装载响应数据:

```java
public class RestBean<T> {  
    int code;  
    T data;  
    String message;  
  
    private RestBean(int code, T data,String message) {  
        this.code = code;  
        this.data = data;  
        this.message = message;  
    }  
  
    public static <T> RestBean<T> success(T data) {  
        return new RestBean<>(200,data,"获取成功");  
    }  
  
  
    public static <T> RestBean<T> failure(int code, String message) {  
        return new RestBean<>(code,null,message);  
    }  
  
    public String asJsonString() {  
        return JSONObject  
                .from(this, JSONWriter.Feature.WriteNulls)  
                .toString();  
    }  
}
```