# Mybatis


Mybatis with spring

## Mybatis初步

pom.xml

```xml
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.13</version>
        </dependency>

        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>8.0.33</version>
        </dependency>

        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis-spring</artifactId>
            <version>3.0.2</version>
        </dependency>

        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>6.0.11</version>
        </dependency>
```


目录结构：

```
.
└── main
    ├── java
    │   └── org
    │       └── example
    │           ├── config
    │           │   └── MainConfiguration.java
    │           ├── entity
    │           │   └── Teacher.java
    │           ├── Main.java
    │           └── mapper
    │               └── TestMapper.java
    └── resources
        └── mybatis-config.xml
```

config/MainConfiguration.java

1.xml写法
```java
@Configuration
@ComponentScans({ //扫描bean
        @ComponentScan("org.example.entity") 
})
@MapperScan("org.example.mapper") //扫描mapper
public class MainConfiguration {
    @Bean
    public SqlSessionTemplate sqlSessionTemplate() throws IOException {
        SqlSessionFactory factory = new SqlSessionFactoryBuilder().build(
                Resources.getResourceAsReader("mybatis-config.xml")); // 读取mybatis配置文件
                
        return new SqlSessionTemplate(factory);
    }
}
```

2.注解写法
```java
@Configuration
@ComponentScans({
        @ComponentScan("org.example.entity")
})
@MapperScan("org.example.mapper") //扫描mapper
public class MainConfiguration {

    @Bean //单独创建一个Bean，方便之后更换
    public DataSource dataSource() {
        return new PooledDataSource("com.mysql.cj.jdbc.Driver",
                "jdbc:mysql://localhost:3306/study",
                "root",
                "123456");
    }

    @Bean
    public SqlSessionFactoryBean sqlSessionFactoryBean(DataSource dataSource){  //直接参数得到Bean对象
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(dataSource);
        return bean;
    }
}
```


entity/Teacher.java

```java
@Data
public class Teacher {
    private int tid;
    private String name;
    private String sex;
}
```


mybatis-config.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/study"/>
                <property name="username" value="root"/>
                <property name="password" value="123456"/>
            </dataSource>
        </environment>
    </environments>
    <mappers>
        <mapper class="org.example.mapper.TestMapper"/>
    </mappers>
</configuration>
```

mapper/TestMapper.java

```java
public interface TestMapper {
    @Select("select * from Teacher where tid = 1")
    Teacher getTeacher();
}
```


Main.java

```java
public class Main {  
    public static void main(String[] args) {  
        // 读取配置
        ApplicationContext context = new AnnotationConfigApplicationContext(MainConfiguration.class);
        
        TestMapper testMapper = context.getBean(TestMapper.class);  
  
        System.out.println(testMapper.getTeacher());  
    }  
}
```

output

```
Teacher(tid=1, name=2, sex=1)
```


## HikariCP 连接池

优点，速度更快

pom.xml

```xml
        <dependency>
            <groupId>com.zaxxer</groupId>
            <artifactId>HikariCP</artifactId>
            <version>5.0.1</version>
        </dependency>
        <dependency> // 日志管理    需要和 slf4j-api版本一致
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-jdk14</artifactId>
            <version>2.0.0-alpha1</version>
        </dependency>
```


MainConfiguration.java

```java
@Configuration
@ComponentScans({
        @ComponentScan("org.example.entity")
})
@MapperScan("org.example.mapper") //扫描mapper
public class MainConfiguration {

    @Bean //单独创建一个Bean，方便之后更换
    public DataSource dataSource() { // 
        HikariDataSource dataSource = new HikariDataSource();
        dataSource.setJdbcUrl("jdbc:mysql://localhost:3306/study");
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        dataSource.setUsername("root");
        dataSource.setPassword("a=)zgatsf8hL");
        return dataSource;
    }

    @Bean
    public SqlSessionFactoryBean sqlSessionFactoryBean(DataSource dataSource){  //直接参数得到Bean对象
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(dataSource);
        return bean;
    }
}
```

更改为 HikariCP

output
```java
9月 15, 2023 3:28:25 下午 com.zaxxer.hikari.HikariDataSource getConnection
信息: HikariPool-1 - Starting...
9月 15, 2023 3:28:26 下午 com.zaxxer.hikari.pool.HikariPool checkFailFast
信息: HikariPool-1 - Added connection com.mysql.cj.jdbc.ConnectionImpl@a68df9
9月 15, 2023 3:28:26 下午 com.zaxxer.hikari.HikariDataSource getConnection
信息: HikariPool-1 - Start completed.

Teacher(tid=1, name=2, sex=1)
```


## Mybatis事务管理

MyBatis的事务管理分为两种形式：

1. 使用**JDBC**的事务管理机制：即利用对应数据库的驱动生成的`Connection`对象完成对事务的提交（commit()）、回滚（rollback()）、关闭（close()）等，对应的实现类为`JdbcTransaction`
2. 使用**MANAGED**的事务管理机制：这种机制MyBatis自身不会去实现事务管理，而是让程序的容器（比如Spring）来实现对事务的管理，对应的实现类为`ManagedTransaction`
3. 如果需要自定义，那么得实现`org.apache.ibatis.transaction.Transaction`接口，然后在`type`属性中指定其类名。使用自定义的事务管理器可以根据具体需求来实现一些特定的事务管理行为。

[Mybatis事务管理](SSM笔记（一）Spring基础#Mybatis事务管理)


## Spring事务

MainConfiguration.java

添加事务管理器

```java
@Configuration
@ComponentScans({
        @ComponentScan("org.example")
})
@MapperScan("org.example.mapper") //扫描mapper
@EnableTransactionManagement      // 启用事务管理器
public class MainConfiguration {

    @Bean
    public TransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }
// --------------------- snip ------------------
}
```


mapper/TestMapper.java

```java
@Mapper
public interface TestMapper {
    @Select("select * from Teacher where tid = 1")
    Teacher getTeacher();


    @Insert("insert into Teacher(name, sex) values ('测试', '男')")
    void insertTeacher();
}
```


service/TestService.java

```java
public interface TestService {
    void test();
}
```


service/impl/TestServiceImpl.java

```java
@Component
public class TestServiceImpl implements TestService {

    @Autowired
    TestMapper mapper;

    @Transactional // 启用错误回滚
    public void test() { 
        mapper.insertTeacher();
        if (true) throw new RuntimeException("我是测试异常! "); // 异常自动回滚, 最后没有插入
        mapper.insertTeacher();
    }
}
```

@Transactional() 的比较关键的参数

- transactionManager：指定事务管理器
- propagation：事务传播规则，一个事务可以包括N个子事务
- isolation：事务隔离级别，不多说了
- timeout：事务超时时间
- readOnly：是否为只读事务，不同的数据库会根据只读属性进行优化，比如MySQL一旦声明事务为只读，那么久不允许增删改操作了。
- rollbackFor和noRollbackFor：发生指定异常时回滚或是不回滚，默认发生任何异常都回滚。



事务的传播规则：
Spring默认的传播级别是`PROPAGATION_REQUIRED`

[使用Spring事务管理](SSM笔记（一）Spring基础.md#使用Spring事务管理)

![image-20221217161156859](https://s2.loli.net/2022/12/17/C1RA4mBEoxNDFGl.png)