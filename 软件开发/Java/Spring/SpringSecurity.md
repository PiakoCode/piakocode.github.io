# SpringSecurity

pom.xml

```xml
<dependency>  
    <groupId>org.springframework</groupId>  
    <artifactId>spring-webmvc</artifactId>  
    <version>6.0.11</version>  
</dependency>  
  
<dependency>  
    <groupId>org.thymeleaf</groupId>  
    <artifactId>thymeleaf-spring6</artifactId>  
    <version>3.1.1.RELEASE</version>  
</dependency>  
  
<dependency>  
    <groupId>com.alibaba.fastjson2</groupId>  
    <artifactId>fastjson2</artifactId>  
    <version>2.0.37</version>  
</dependency>  
  
<dependency>  
    <groupId>com.alibaba.fastjson2</groupId>  
    <artifactId>fastjson2-extension-spring6</artifactId>  
    <version>2.0.37</version>  
</dependency>  
  
  
<dependency>  
    <groupId>org.slf4j</groupId>  
    <artifactId>slf4j-api</artifactId>  
    <version>2.0.5</version>  
</dependency>  
  
<dependency>  
    <groupId>org.slf4j</groupId>  
    <artifactId>slf4j-jdk14</artifactId>  
    <version>2.0.5</version>  
</dependency>  
  
<dependency>  
    <groupId>org.projectlombok</groupId>  
    <artifactId>lombok</artifactId>  
    <version>1.18.28</version>  
</dependency>  
  
<dependency>  
    <groupId>jakarta.annotation</groupId>  
    <artifactId>jakarta.annotation-api</artifactId>  
    <version>2.1.1</version>  
</dependency>
```



## SpringSecurity配置


pom.xml
```xml
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-web</artifactId>
    <version>6.1.2</version>
</dependency>
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-config</artifactId>
    <version>6.1.2</version>
</dependency>
```


src/main/java/com/example/init/SecurityInitializer.java

```java
public class SecurityInitializer extends AbstractSecurityWebApplicationInitializer {
    //不用重写任何内容
  	//这里实际上会自动注册一个Filter，SpringSecurity底层就是依靠N个过滤器实现的
}
```


src/main/java/com/example/config/SpringSecurityConfiguration.java
```java
@Configuration  
@EnableWebSecurity   //开启WebSecurity相关功能  
public class SpringSecurityConfiguration {  
  
}
```

在MainInitializer中添加`SecurityConfiguration.class`

```java
    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[]{WebConfiguration.class, SecurityConfiguration.class};   
    }
```


再次运行项目，会发现无法进入的我们的页面中，无论我们访问哪个页面，都会进入到SpringSecurity为我们提供的一个默认登录页面，之后我们会讲解如何进行配置。

![image-20230702135644834](https://s2.loli.net/2023/07/02/dWkGc5YhNAIbP8j.png)

至此，项目环境搭建完成。


## 认证


```java
@Configuration  
@EnableWebSecurity   //开启WebSecurity相关功能  
public class SecurityConfiguration {  
    
    @Bean  
    public UserDetailsService userDetailsService() {   //添加用户信息
        UserDetails user = User  
                .withDefaultPasswordEncoder()  
                .username("user")  
                .password("654321")  
                .build();  
  
  
        UserDetails admin = User  
                .withDefaultPasswordEncoder()  
                .username("admin")  
                .password("123456")  
                .build();  
        return new InMemoryUserDetailsManager(user,admin);  
    }  
}
```



密码加密
```java
    //这里将BCryptPasswordEncoder直接注册为Bean，Security会自动进行选择
    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }
```


### 基于数据库验证

前面我们已经实现了直接认证的方式，但是实际项目中往往都是将用户信息存储在数据库中，那么如何将其连接到数据库，通过查询数据库中的用户信息来进行用户登录呢？

官方默认提供了可以直接使用的用户和权限表设计，根本不需要我们来建表，直接在Navicat中执行以下查询：

```sql
create table users(username varchar(50) not null primary key,password varchar(500) not null,enabled boolean not null);
create table authorities (username varchar(50) not null,authority varchar(50) not null,constraint fk_authorities_users foreign key(username) references users(username));
create unique index ix_auth_username on authorities (username,authority);
```

接着我们添加Mybatis和MySQL相关的依赖：

```xml
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.5.13</version>
</dependency>
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-spring</artifactId>
    <version>3.0.2</version>
</dependency>
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.0.31</version>
</dependency>
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>6.0.10</version>
</dependency>
```

接着我们编写配置类：

```java
@Configuration
@EnableWebSecurity
public class SecurityConfiguration {

    @Bean PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

    @Bean
    public DataSource dataSource(){
      	//数据源配置
        return new PooledDataSource("com.mysql.cj.jdbc.Driver",
                "jdbc:mysql://localhost:3306/test", "root", "123456");
    }

    @Bean
    public UserDetailsService userDetailsService(DataSource dataSource,
                                                 PasswordEncoder encoder) {
        JdbcUserDetailsManager manager = new JdbcUserDetailsManager(dataSource);
      	//仅首次启动时创建一个新的用户用于测试，后续无需创建
   			manager.createUser(User.withUsername("user")
                      .password(encoder.encode("password")).roles("USER").build());
        return manager;
    }
}
```

启动后，可以看到两张表中已经自动添加好对应的数据了：

![image-20230702181131252](https://s2.loli.net/2023/07/02/VG19mSConefsilH.png)

![image-20230702181119809](https://s2.loli.net/2023/07/02/6uqerwFo13p9jxJ.png)

我们可以直接尝试进行登录，使用方式和之前是完全一样的：

![image-20230702181211157](https://s2.loli.net/2023/07/02/dVM5ltzF1ua8Y3E.png)

这样，当我们下次需要快速创建一个用户登录的应用程序时，直接使用这种方式就能快速完成了，是不是感觉特别方便。

无论是我们上节课认识的InMemoryUserDetailsManager还是现在认识的JdbcUserDetailsManager，他们都是实现自UserDetailsManager接口，这个接口中有着一套完整的增删改查操作，方便我们直接对用户进行处理：

```java
public interface UserDetailsManager extends UserDetailsService {
	
  //创建一个新的用户
	void createUser(UserDetails user);

  //更新用户信息
	void updateUser(UserDetails user);

  //删除用户
	void deleteUser(String username);

  //修改用户密码
	void changePassword(String oldPassword, String newPassword);

  //判断是否存在指定用户
	boolean userExists(String username);
}
```

通过使用UserDetailsManager对象，我们就能快速执行用户相关的管理操作，比如我们可以直接在网站上添加一个快速重置密码的接口，首先需要配置一下JdbcUserDetailsManager，为其添加一个AuthenticationManager用于原密码的校验：

```java
@Configuration
@EnableWebSecurity
public class SecurityConfiguration {

    ...

    //手动创建一个AuthenticationManager用于处理密码校验
    private AuthenticationManager authenticationManager(UserDetailsManager manager,
                                                        PasswordEncoder encoder){
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(manager);
        provider.setPasswordEncoder(encoder);
        return new ProviderManager(provider);
    }

    @Bean
    public UserDetailsManager userDetailsService(DataSource dataSource,
                                                 PasswordEncoder encoder) throws Exception {
        JdbcUserDetailsManager manager = new JdbcUserDetailsManager(dataSource);
      	//为UserDetailsManager设置AuthenticationManager即可开启重置密码的时的校验
        manager.setAuthenticationManager(authenticationManager(manager, encoder));
        return manager;
    }
}

```

接着我们编写一个快速重置密码的接口：

```java
@ResponseBody
@PostMapping("/change-password")
public JSONObject changePassword(@RequestParam String oldPassword,
                                 @RequestParam String newPassword) {
    manager.changePassword(oldPassword, encoder.encode(newPassword));
    JSONObject object = new JSONObject();
    object.put("success", true);
    return object;
}
```

接着我们在主界面中添加一个重置密码的操作：

```html
<div>
    <label>
        修改密码：
        <input type="text" id="oldPassword" placeholder="旧密码"/>
        <input type="text" id="newPassword" placeholder="新密码"/>
    </label>
    <button onclick="change()">修改密码</button>
</div>
```

```javascript
function change() {
    const oldPassword = document.getElementById("oldPassword").value
    const newPassword = document.getElementById("newPassword").value
    const csrf = document.getElementById("_csrf").value
    axios.post('/mvc/change-password', {
        oldPassword: oldPassword,
        newPassword: newPassword,
        _csrf: csrf
    }, {
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    }).then(({data}) => {
        alert(data.success ? "密码修改成功" : "密码修改失败，请检查原密码是否正确")
    })
}
```

这样我们就可以在首页进行修改密码操作了

当然，这种方式的权限校验虽然能够直接使用数据库，但是存在一定的局限性，只适合快速搭建Demo使用，不适合实际生产环境下编写，下一节我们将介绍如何实现自定义验证，以应对各种情况。