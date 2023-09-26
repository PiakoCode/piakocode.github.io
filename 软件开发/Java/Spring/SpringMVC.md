# SpringMVC

MVC架构

![MVC架构](https://s2.loli.net/2023/02/18/2IiK8YrfhF4zyU1.jpg))

MVC详细解释如下：

- M是指业务模型（Model）：通俗的讲就是我们之前用于封装数据传递的实体类。
- V是指用户界面（View）：一般指的是前端页面。
- C则是控制器（Controller）：控制器就相当于Servlet的基本功能，处理请求，返回响应。

![img](https://s2.loli.net/2023/02/18/voy7HYrIbJuw9R3.jpg)

## 环境配置

### xml文件配置

pom.xml

```xml
<dependency>  
    <groupId>org.springframework</groupId>  
    <artifactId>spring-webmvc</artifactId>  
    <version>6.0.11</version>  
</dependency>
```

初始结构:
```
src
.
├── main
│   ├── java
│   │   └── com
│   │       └── example
│   │           └── springmvc
│   │               └── HelloServlet.java
│   ├── resources
│   └── webapp
│       ├── index.jsp
│       └── WEB-INF
│           └── web.xml
└── test
    ├── java
    └── resources

```


修改web.xml, 将DispatcherServlet替换掉Tomcat自带的Servlet，这里url-pattern需要写为`/`，即可完成替换

src/main/webapp/WEB-INF/web.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee https://jakarta.ee/xml/ns/jakartaee/web-app_5_0.xsd"
         version="5.0">
    <servlet>
        <servlet-name>mvc</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>mvc</servlet-name> <!-- 名字要相同 -->
        <url-pattern>/</url-pattern>
    </servlet-mapping>
</web-app>
```

接着需要为整个Web应用程序配置一个Spring上下文环境（也就是容器），因为SpringMVC是基于Spring开发的，它直接利用Spring提供的容器来实现各种功能，那么第一步依然跟之前一样，需要编写一个配置文件：

main/resources/配置文件.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">
</beans>
```

接着我们需要为DispatcherServlet配置一些初始化参数来指定刚刚创建的配置文件：

```xml
<servlet>
    <servlet-name>mvc</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <init-param>
      	<!--     指定我们刚刚创建在类路径下的XML配置文件       -->
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:配置文件.xml</param-value>
    </init-param>
</servlet>
```

这样我们就完成了基本的配置。


### 创建一个Controller类


src/main/java/org/example/controller/MainController.java

```java
@Controller
public class MainController {
    @ResponseBody
    @RequestMapping("/")
    public String hello(){
        return "HelloWorld!";
    }
}
```


将这个类注册为Bean

src/main/resources/spring.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd">
  	<!-- 需要先引入context命名空间，然后直接配置base-package属性就可以了 -->
    <context:component-scan base-package="com.example"/>
</beans>
```

### 全注解配置

pom.xml

```xml
<dependency>  
    <groupId>org.springframework</groupId>  
    <artifactId>spring-webmvc</artifactId>  
    <version>6.0.11</version>  
</dependency>
```


结构：
```
.
├── main
│   ├── java
│   │   └── com
│   │       └── example
│   │           ├── config
│   │           │   ├── MainInitializer.java
│   │           │   └── WebConfiguration.java
│   │           └── controller
│   │               └── HelloController.java
│   ├── resources
│   └── webapp
└── test
    ├── java
    └── resources

```

src/main/java/com/example/config/MainInitializer.java

```java
public class MainInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    @Override
    protected Class<?>[] getRootConfigClasses() {
        return new Class[]{WebConfiguration.class};   //基本的Spring配置类，一般用于业务层配置
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        return new Class[0];  //配置DispatcherServlet的配置类、主要用于Controller等配置，这里为了教学简单，就不分这么详细了，只使用上面的基本配置类
    }

    @Override
    protected String[] getServletMappings() {
        return new String[]{"/"};    //匹配路径，与上面一致
    }
}
```

src/main/java/com/example/config/WebConfiguration.java

```java
@Configuration
@EnableWebMvc   //快速配置SpringMvc注解，如果不添加此注解会导致后续无法通过实现WebMvcConfigurer接口进行自定义配置
@ComponentScan("com.example.controller")
public class WebConfiguration implements WebMvcConfigurer{


}
```

src/main/java/com/example/controller/HelloController.java

```java
@Controller
public class HelloController {
    @ResponseBody
    @RequestMapping("/")
    public String hello() {
        return "Hello, World!";
    }
}
```


有了SpringMVC之后，我们不必再像之前那样一个请求地址创建一个Servlet了，它使用`DispatcherServlet`替代Tomcat为我们提供的默认的静态资源Servlet，也就是说，现在所有的请求（除了jsp，因为Tomcat还提供了一个jsp的Servlet）都会经过`DispatcherServlet`进行处理。

那么`DispatcherServlet`会帮助我们做什么呢？

![img](https://s2.loli.net/2023/02/18/SQNnl3yFjhHbp1G.jpg)

根据图片我们可以了解，我们的请求到达Tomcat服务器之后，会交给当前的Web应用程序进行处理，而SpringMVC使用`DispatcherServlet`来处理所有的请求，也就是说它被作为一个统一的访问点，所有的请求全部由它来进行调度。

当一个请求经过`DispatcherServlet`之后，会先走`HandlerMapping`，它会将请求映射为`HandlerExecutionChain`，依次经过`HandlerInterceptor`有点类似于之前我们所学的过滤器，不过在SpringMVC中我们使用的是拦截器，然后再交给`HandlerAdapter`，根据请求的路径选择合适的控制器进行处理，控制器处理完成之后，会返回一个`ModelAndView`对象，包括数据模型和视图，通俗的讲就是页面中数据和页面本身（只包含视图名称即可）。

返回`ModelAndView`之后，会交给`ViewResolver`（视图解析器）进行处理，视图解析器会对整个视图页面进行解析，SpringMVC自带了一些视图解析器，但是只适用于JSP页面，我们也可以像之前一样使用Thymeleaf作为视图解析器，这样我们就可以根据给定的视图名称，直接读取HTML编写的页面，解析为一个真正的View。

解析完成后，就需要将页面中的数据全部渲染到View中，最后返回给`DispatcherServlet`一个包含所有数据的成形页面，再响应给浏览器，完成整个过程。

因此，实际上整个过程我们只需要编写对应请求路径的的Controller以及配置好我们需要的ViewResolver即可，之后还可以继续补充添加拦截器，而其他的流程已经由SpringMVC帮助我们完成了。


### 视图解析器配置


依赖

首先我们需要实现最基本的页面解析并返回，第一步就是配置视图解析器，这里我们使用Thymeleaf为我们提供的视图解析器，导入需要的依赖：

```xml
<dependency>
    <groupId>org.thymeleaf</groupId>
    <artifactId>thymeleaf-spring6</artifactId>
    <version>3.1.1.RELEASE</version>
</dependency>
```


修改：src/main/java/com/example/config/WebConfiguration.java

```java
@Configuration
@EnableWebMvc
@ComponentScan("com.example.controller")
public class WebConfiguration implements WebMvcConfigurer{
    //我们需要使用ThymeleafViewResolver作为视图解析器，并解析我们的HTML页面
    @Bean
    public ThymeleafViewResolver thymeleafViewResolver(SpringTemplateEngine springTemplateEngine){
        ThymeleafViewResolver resolver = new ThymeleafViewResolver();
        resolver.setOrder(1);   //可以存在多个视图解析器，并且可以为他们设定解析顺序
        resolver.setCharacterEncoding("UTF-8");   //编码格式是重中之重
        resolver.setTemplateEngine(springTemplateEngine);   //和之前JavaWeb阶段一样，需要使用模板引擎进行解析，所以这里也需要设定一下模板引擎
        return resolver;
    }

    //配置模板解析器
    @Bean
    public SpringResourceTemplateResolver templateResolver(){
        SpringResourceTemplateResolver resolver = new SpringResourceTemplateResolver();
        resolver.setSuffix(".html");   //需要解析的后缀名称
        resolver.setPrefix("classpath:");   //需要解析的HTML页面文件存放的位置，默认是webapp目录下，如果是类路径下需要添加classpath:前缀
        return resolver;
    }

    //配置模板引擎Bean
    @Bean
    public SpringTemplateEngine springTemplateEngine(ITemplateResolver resolver){
        SpringTemplateEngine engine = new SpringTemplateEngine();
        engine.setTemplateResolver(resolver);   //模板解析器，默认即可
        return engine;
    }
    
    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        converters.add(new FastJsonHttpMessageConverter());
    }
}
```

创建Controller

src/main/java/com/example/controller/HelloController.java

```java
@Controller //直接添加注解即可
public class HelloController {
    @ResponseBody
    @RequestMapping("/") //直接填写访问路径
    public ModelAndView hello() {
        return new ModelAndView("index"); //返回ModelAndView对象，这里填入了视图的名称
        //返回后会经过视图解析器进行处理
    }
}
```

index.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
<p>This is a test page</p>
</body>
</html>
```


我们在之前，使用Thymeleaf解析后端的一些数据时，需要通过Context进行传递，而使用SpringMvc后，数据我们可以直接向Model模型层进行提供：

```java
@RequestMapping(value = "/index")
public ModelAndView index(){
    ModelAndView modelAndView = new ModelAndView("index");
    modelAndView.getModel().put("name", "啊这");   //将name传递给Model
    return modelAndView;
}
```

这样Thymeleaf就能收到我们传递的数据进行解析：

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="static/test.js"></script>
</head>
<body>
    HelloWorld！
    <div th:text="${name}"></div>
</body>
</html>
```

当然，为了简便，我们可以直接返回View名称，SpringMVC会将其自动包装为ModelAndView对象：

```java
@RequestMapping(value = "/index")
public String index(){
    return "index";
}
```

我们还可以单独添加一个Model作为形参进行设置，SpringMVC通过依赖注入会自动帮助我们传递实例对象：

```java
@RequestMapping(value = "/index")
public String index(Model model){  //这里不仅仅可以是Model，还可以是Map、ModelMap
    model.addAttribute("name", "yyds");
    return "index";
}
```

[配置视图解析器和控制器](SSM笔记（二）SpringMvc基础#配置视图解析器和控制器)


## 核心内容

### @RequestMapping

```java
@Controller 
public class HelloController {
    @ResponseBody
    @RequestMapping("/","/hello","test") //路径必须全局唯一，不能重复
    public ModelAndView hello() {
        return new ModelAndView("index"); 
    }

}
```


**路径还支持使用通配符进行匹配**

/text/a? ==>  /test/a /test/aa /test/ab
/test/x\*  
/test/\*  


#### 限定请求方式

```java
@RequestMapping(value = "/index", method = RequestMethod.POST)
public ModelAndView index(){
    return new ModelAndView("index");
}
```


我们也可以使用衍生注解直接设定为指定类型的请求映射：

@PostMapping
@GetMapping

```java
@PostMapping(value = "/index")
public ModelAndView index(){
    return new ModelAndView("index");
}
```

我们可以使用`params`属性来指定请求必须携带哪些请求参数，比如：

```java
@RequestMapping(value = "/index", params = {"username", "password"})
public ModelAndView index(){
    return new ModelAndView("index");
}
```

比如这里我们要求请求中必须携带`username`和`password`属性，否则无法访问。它还支持表达式，比如我们可以这样编写：

```java
@RequestMapping(value = "/index", params = {"!username", "password"})
public ModelAndView index(){
    return new ModelAndView("index");
}
```

在username之前添加一个感叹号表示请求的不允许携带此参数，否则无法访问，我们甚至可以直接设定一个固定值：

```java
@RequestMapping(value = "/index", params = {"username!=test", "password=123"})
public ModelAndView index(){
    return new ModelAndView("index");
}
```

这样，请求参数username不允许为test，并且password必须为123，否则无法访问。

`header`属性用法与`params`一致，但是它要求的是请求头中需要携带什么内容，比如：

```java
@RequestMapping(value = "/index", headers = "!Connection")
public ModelAndView index(){
    return new ModelAndView("index");
}
```

那么，如果请求头中携带了`Connection`属性，将无法访问。其他两个属性：

- consumes： 指定处理请求的提交内容类型（Content-Type），例如application/json, text/html;
- produces:  指定返回的内容类型，仅当request请求头中的(Accept)类型中包含该指定类型才返回；

### 请求参数获取

#### @RequestParam、@RequestHeader

我们只需要为方法添加一个形式参数，并在形式参数前面添加`@RequestParam`注解即可：

```java
@RequestMapping(value = "/index")
public ModelAndView index(@RequestParam("username") String username){
    System.out.println("接受到请求参数："+username);
    return new ModelAndView("index");
}
```

我们需要在`@RequestParam`中填写参数名称，参数的值会自动传递给形式参数，我们可以直接在方法中使用，注意，如果参数名称与形式参数名称相同，即使不添加`@RequestParam`也能获取到参数值。

一旦添加`@RequestParam`，那么此请求必须携带指定参数，我们也可以将require属性设定为false来将属性设定为非必须：

```java
@RequestMapping(value = "/index")
public ModelAndView index(@RequestParam(value = "username", required = false) String username){
    System.out.println("接受到请求参数："+username);
    return new ModelAndView("index");
}
```

我们还可以直接设定一个默认值，当请求参数缺失时，可以直接使用默认值：

```java
@RequestMapping(value = "/index")
public ModelAndView index(@RequestParam(value = "username", required = false, defaultValue = "伞兵一号") String username){
    System.out.println("接受到请求参数："+username);
    return new ModelAndView("index");
}
```

如果需要使用Servlet原本的一些类，比如：

```java
@RequestMapping(value = "/index")
public ModelAndView index(HttpServletRequest request){
    System.out.println("接受到请求参数："+request.getParameterMap().keySet());
    return new ModelAndView("index");
}
```

直接添加`HttpServletRequest`为形式参数即可，SpringMVC会**自动传递**该请求原本的`HttpServletRequest`对象，同理，我们也可以添加`HttpServletResponse`作为形式参数，甚至可以直接将HttpSession也作为参数传递：

```java
@RequestMapping(value = "/index")
public ModelAndView index(HttpSession session){
    System.out.println(session.getAttribute("test"));
    session.setAttribute("test", "鸡你太美");
    return new ModelAndView("index");
}
```

我们还可以直接将请求参数传递给一个实体类：

```java
@Data
public class User {
    String username;
    String password;
}
```

注意必须携带set方法或是构造方法中包含所有参数，请求参数会自动根据类中的字段名称进行匹配：

```java
@RequestMapping(value = "/index")
public ModelAndView index(User user){
    System.out.println("获取到cookie值为："+user);
    return new ModelAndView("index");
}
```

`@RequestHeader`与`@RequestParam`用法一致，不过它是用于获取请求头参数的，这里就不再演示了。


#### @CookieValue、@SessionAttrbutie


通过使用`@CookieValue`注解，我们也可以快速获取请求携带的Cookie信息：

```java
@RequestMapping(value = "/index")
public ModelAndView index(HttpServletResponse response,
                          @CookieValue(value = "test", required = false) String test){
    System.out.println("获取到cookie值为："+test);
    response.addCookie(new Cookie("test", "lbwnb"));
    return new ModelAndView("index");
}
```

同样的，Session也能使用注解快速获取：

```java
@RequestMapping(value = "/index")
public ModelAndView index(@SessionAttribute(value = "test", required = false) String test,
                          HttpSession session){
    session.setAttribute("test", "xxxx");
    System.out.println(test);
    return new ModelAndView("index");
}
```


### 重定向和请求转发

重定向和请求转发也非常简单，我们只需要在视图名称前面添加一个前缀即可，比如重定向：

```java
@RequestMapping("/index")
public String index(){
    return "redirect:home";
}

@RequestMapping("/home")
public String home(){
    return "home";
}
```

通过添加`redirect:`前缀，就可以很方便地实现重定向，那么请求转发呢，其实也是一样的，使用`forward:`前缀表示转发给其他请求映射：

```java
@RequestMapping("/index")
public String index(){
    return "forward:home";
}

@RequestMapping("/home")
public String home(){
    return "home";
}
```



### Bean的Web作用域

在学习Spring时我们讲解了Bean的作用域，包括`singleton`和`prototype`，Bean分别会以单例和多例模式进行创建，而在SpringMVC中，它的作用域被继续细分：

- request：对于每次HTTP请求，使用request作用域定义的Bean都将产生一个新实例，请求结束后Bean也消失。
- session：对于每一个会话，使用session作用域定义的Bean都将产生一个新实例，会话过期后Bean也消失。
- global session：不常用，不做讲解。

这里我们创建一个测试类来试试看：

```java
public class TestBean {

}
```

接着将其注册为Bean，注意这里需要添加`@RequestScope`或是`@SessionScope`表示此Bean的Web作用域：

```java
@Bean
@RequestScope // or `@SessionScope`
public TestBean testBean(){
    return new TestBean();
}
```

接着我们将其自动注入到Controller中：

```java
@Controller
public class MainController {

    @Resource
    TestBean bean;

    @RequestMapping(value = "/index")
    public ModelAndView index(){
        System.out.println(bean);
        return new ModelAndView("index");
    }
}
```

我们发现，每次发起得到的Bean实例都不同，接着我们将其作用域修改为`@SessionScope`，这样作用域就上升到Session，只要清理浏览器的Cookie，那么都会被认为是同一个会话，只要是同一个会话，那么Bean实例始终不变。

实际上，它也是通过代理实现的，我们调用Bean中的方法会被转发到真正的Bean对象去执行。


### Restful 风格

这种风格的连接，我们就可以直接从请求路径中读取参数，比如：

```
http://localhost:8080/mvc/index/123456
```

我们可以直接将index的下一级路径作为请求参数进行处理，也就是说现在的请求参数包含在了请求路径中：

```java
@RequestMapping("/index/{str}")
public String index(@PathVariable String str) {
    System.out.println(str);
    return "index";
}
```

注意请求路径我们可以手动添加类似占位符一样的信息，这样占位符位置的所有内容都会被作为请求参数，而方法的形参列表中必须包括一个与占位符同名的并且添加了`@PathVariable`注解的参数，或是由`@PathVariable`注解指定为占位符名称：

```java
@RequestMapping("/index/{str}")
public String index(@PathVariable("str") String text){
    System.out.println(text);
    return "index";
}
```

如果没有配置正确，方法名称上会出现黄线。

我们可以按照不同功能进行划分：

- POST http://localhost:8080/mvc/index -  添加用户信息，携带表单数据
- GET http://localhost:8080/mvc/index/{id} -  获取用户信息，id直接放在请求路径中
- PUT http://localhost:8080/mvc/index -  修改用户信息，携带表单数据
- DELETE http://localhost:8080/mvc/index/{id} -  删除用户信息，id直接放在请求路径中

我们分别编写四个请求映射：

```java
@Controller
public class MainController {

    @RequestMapping(value = "/index/{id}", method = RequestMethod.GET)
    public String get(@PathVariable("id") String text){
        System.out.println("获取用户："+text);
        return "index";
    }

    @RequestMapping(value = "/index", method = RequestMethod.POST)
    public String post(String username){
        System.out.println("添加用户："+username);
        return "index";
    }

    @RequestMapping(value = "/index/{id}", method = RequestMethod.DELETE)
    public String delete(@PathVariable("id") String text){
        System.out.println("删除用户："+text);
        return "index";
    }

    @RequestMapping(value = "/index", method = RequestMethod.PUT)
    public String put(String username){
        System.out.println("修改用户："+username);
        return "index";
    }
}
```


### Interceptor拦截器

#### 创建拦截器

创建一个拦截器我们需要实现一个`HandlerInterceptor`接口：

```java
public class MainInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("我是处理之前！");
        return true;   //只有返回true才会继续，否则直接结束
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        System.out.println("我是处理之后！");
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
      	//在DispatcherServlet完全处理完请求后被调用
        System.out.println("我是完成之后！");
    }
}
```

接着我们需要在配置类（之前的WebConfiguration）中进行注册：

```java
@Override
public void addInterceptors(InterceptorRegistry registry) {
    registry.addInterceptor(new MainInterceptor())
      .addPathPatterns("/**")    //添加拦截器的匹配路径，只要匹配一律拦截
      .excludePathPatterns("/home");   //拦截器不进行拦截的路径
}
```

现在我们在浏览器中访问index页面，拦截器已经生效。

得到整理拦截器的执行顺序：

```
我是处理之前！
我是处理！
我是处理之后！
我是完成之后！
```

也就是说，处理前和处理后，包含了真正的请求映射的处理，在整个流程结束后还执行了一次`afterCompletion`方法，其实整个过程与我们之前所认识的Filter类似，不过在处理前，我们只需要返回true或是false表示是否被拦截即可，而不是再去使用FilterChain进行向下传递。

那么我们就来看看，如果处理前返回false，会怎么样：

```
我是处理之前！
```

通过结果发现一旦返回false，之后的所有流程全部取消，那么如果是在处理中发生异常了呢？

```java
@RequestMapping("/index")
public String index(){
    System.out.println("我是处理！");
    if(true) throw new RuntimeException("");
    return "index";
}
```

结果为：

```
我是处理之前！
我是处理！
我是完成之后！
```

我们发现如果处理过程中抛出异常，那么久不会执行处理后`postHandle`方法，但是会执行`afterCompletion`方法，我们可以在此方法中获取到抛出的异常。

#### 多级拦截器

前面介绍了仅仅只有一个拦截器的情况，我们接着来看如果存在多个拦截器会如何执行，我们以同样的方式创建二号拦截器：

```java
public class SubInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        System.out.println("二号拦截器：我是处理之前！");
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        System.out.println("二号拦截器：我是处理之后！");
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        System.out.println("二号拦截器：我是完成之后！");
    }
}
```

注册二号拦截器：

```java
@Override
public void addInterceptors(InterceptorRegistry registry) {
  	//一号拦截器
    registry.addInterceptor(new MainInterceptor()).addPathPatterns("/**").excludePathPatterns("/home");
  	//二号拦截器
    registry.addInterceptor(new SubInterceptor()).addPathPatterns("/**");
}
```

注意拦截顺序就是注册的顺序，因此拦截器会根据注册顺序依次执行，我们可以打开浏览器运行一次：

```
一号拦截器：我是处理之前！
二号拦截器：我是处理之前！
我是处理！
二号拦截器：我是处理之后！
一号拦截器：我是处理之后！
二号拦截器：我是完成之后！
一号拦截器：我是完成之后！
```

和多级Filter相同，在处理之前，是按照顺序从前向后进行拦截的，但是处理完成之后，就按照倒序执行处理后方法，而完成后是在所有的`postHandle`执行之后再同样的以倒序方式执行。

那么如果这时一号拦截器在处理前就返回了false呢？

```java
@Override
public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    System.out.println("一号拦截器：我是处理之前！");
    return false;
}
```

得到结果如下：

```
一号拦截器：我是处理之前！
```

我们发现，与单个拦截器的情况一样，一旦拦截器返回false，那么之后无论有无拦截器，都不再继续。


### 异常处理

当我们的请求映射方法中出现异常时，会直接展示在前端页面，这是因为SpringMVC为我们提供了默认的异常处理页面，当出现异常时，我们的请求会被直接转交给专门用于异常处理的控制器进行处理。

我们可以自定义一个异常处理控制器，一旦出现指定异常，就会转接到此控制器执行：

```java
@ControllerAdvice
public class ErrorController {

    @ExceptionHandler(Exception.class)
    public String error(Exception e, Model model){  //可以直接添加形参来获取异常
        e.printStackTrace();
        model.addAttribute("e", e);
        return "500";
    }
}
```

接着我们编写一个专门显示异常的页面：

```java
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
  500 - 服务器出现了一个内部错误QAQ
  <div th:text="${e}"></div>
</body>
</html>
```

接着修改：

```java
@RequestMapping("/index")
public String index(){
    System.out.println("我是处理！");
    if(true) throw new RuntimeException("错误，无法访问！");
    return "error";
}
```

访问后，我们发现控制台会输出异常信息，同时页面也是我们自定义的一个页面。


### JSON数据格式与Axios请求


JSON (JavaScript Object Notation, JS 对象简谱) 是一种轻量级的数据交换格式。

我们现在推崇的是前后端分离的开发模式，而不是所有的内容全部交给后端渲染再发送给浏览器，也就是说，整个Web页面的内容在一开始就编写完成了，而其中的数据由前端执行JS代码来向服务器动态获取，再到前端进行渲染（填充），这样可以大幅度减少后端的压力，并且后端只需要传输关键数据即可（在即将到来的SpringBoot阶段，我们将完全采用前后端分离的开发模式）

#### JSON数据格式

既然要实现前后端分离，那么我们就必须约定一种更加高效的数据传输模式，来向前端页面传输后端提供的数据。因此JSON横空出世，它非常容易理解，并且与前端的兼容性极好，因此现在比较主流的数据传输方式则是通过JSON格式承载的。

一个JSON格式的数据长这样，以学生对象为例：

```json
{"name": "杰哥", "age": 18}
```

多个学生可以以数组的形式表示：

```json
[{"name": "杰哥", "age": 18}, {"name": "阿伟", "age": 18}]
```

嵌套关系可以表示为：

```json
{"studentList": [{"name": "杰哥", "age": 18}, {"name": "阿伟", "age": 18}], "count": 2}
```

它直接包括了属性的名称和属性的值，与JavaScript的对象极为相似，它到达前端后，可以直接转换为对象，以对象的形式进行操作和内容的读取，相当于以字符串形式表示了一个JS对象，我们可以直接在控制台窗口中测试：

```javascript
let obj = JSON.parse('{"studentList": [{"name": "杰哥", "age": 18}, {"name": "阿伟", "age": 18}], "count": 2}')
//将JSON格式字符串转换为JS对象
obj.studentList[0].name   //直接访问第一个学生的名称
```

我们也可以将JS对象转换为JSON字符串：

```javascript
JSON.stringify(obj)
```

我们后端就可以以JSON字符串的形式向前端返回数据，这样前端在拿到数据之后，就可以快速获取，非常方便。

那么后端如何快速创建一个JSON格式的数据呢？我们首先需要导入以下依赖：

```xml
<dependency>
      <groupId>com.alibaba.fastjson2</groupId>
      <artifactId>fastjson2</artifactId>
      <version>2.0.34</version>
</dependency>
```

JSON解析框架有很多种，比较常用的是Jackson和FastJSON，这里我们使用阿里巴巴的FastJSON进行解析，这是目前号称最快的JSON解析框架，并且现在已经强势推出FastJSON 2版本。

首先要介绍的是JSONObject，它和Map的使用方法一样，并且是有序的（实现了LinkedHashMap接口），比如我们向其中存放几个数据：

```java
@RequestMapping(value = "/index")
public String index(){
    JSONObject object = new JSONObject();
    object.put("name", "杰哥");
    object.put("age", 18);
    System.out.println(object.toJSONString());   //以JSON格式输出JSONObject字符串
    return "index";
}
```

最后我们得到的结果为：

```json
{"name": "杰哥", "age": 18}
```

实际上JSONObject就是对JSON数据的一种对象表示。同样的还有JSONArray，它表示一个数组，用法和List一样，数组中可以嵌套其他的JSONObject或是JSONArray：

```java
@RequestMapping(value = "/index")
public String index(){
    JSONObject object = new JSONObject();
    object.put("name", "杰哥");
    object.put("age", 18);
    JSONArray array = new JSONArray();
    array.add(object);
    System.out.println(array.toJSONString());
    return "index";
}
```

得到的结果为：

```json
[{"name": "杰哥", "age": 18}]
```

当出现循环引用时，会按照以下语法来解析：

![img](https://s2.loli.net/2023/08/14/MjO4awH3X1YnlmR.png)

我们可以也直接创建一个实体类，将实体类转换为JSON格式的数据：

```java
@RequestMapping(value = "/index", produces = "application/json")
@ResponseBody
public String data(){
    Student student = new Student();
    student.setName("杰哥");
    student.setAge(18);
    return JSON.toJSONString(student);
}
```

这里我们修改了`produces`的值，将返回的内容类型设定为`application/json`，表示服务器端返回了一个JSON格式的数据（当然不设置也行，也能展示，这样是为了规范）然后我们在方法上添加一个`@ResponseBody`表示方法返回（也可以在类上添加`@RestController`表示此Controller默认返回的是字符串数据）的结果不是视图名称而是直接需要返回一个字符串作为页面数据，这样，返回给浏览器的就是我们直接返回的字符串内容。

接着我们使用JSON工具类将其转换为JSON格式的字符串，打开浏览器，得到JSON格式数据。

SpringMVC非常智能，我们可以直接返回一个对象类型，它会被自动转换为JSON字符串格式：

```java
@RequestMapping(value = "/data", produces = "application/json")
@ResponseBody
public Student data(){
    Student student = new Student();
    student.setName("杰哥");
    student.setAge(18);
    return student;
}
```

注意需要在配置类中添加一下FastJSON转换器，这里需要先添加一个依赖：

```xml
<dependency>
    <groupId>com.alibaba.fastjson2</groupId>
    <artifactId>fastjson2-extension-spring6</artifactId>
    <version>2.0.34</version>
</dependency>
```

然后编写配置：

```java
@Override
public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
    converters.add(new FastJsonHttpMessageConverter());
}
```

再次尝试，内容就会自动转换为JSON格式响应给客户端了。

#### Axios异步请求

前面我们讲解了如何向浏览器发送一个JSON格式的数据，那么我们现在来看看如何向服务器请求数据。

![img](https://s2.loli.net/2023/08/14/faYcVC6dpIOuJyA.png)

这一部分，我们又要回到前端相关内容的介绍中，当然，我们依然是仅做了解，并不需要详细学习前端项目开发知识。

前端为什么需要用到异步请求，这是因为我们的网页是动态的（这里的动态不是指有动画效果，而是能够实时更新内容）比如我们点击一个按钮会弹出新的内容、或是跳转到新的页面、更新页面中的数据等等，这些都需要通过JS完成异步请求来实现。

> 前端异步请求指的是在前端中发送请求至服务器或其他资源，并且不阻塞用户界面或其他操作。在传统的同步请求中，当发送请求时，浏览器会等待服务器响应，期间用户无法进行其他操作。而异步请求通过将请求发送到后台，在等待响应的同时，允许用户继续进行其他操作。这种机制能够提升用户体验，并且允许页面进行实时更新。常见的前端异步请求方式包括使用XMLHttpRequest对象、Fetch API、以及使用jQuery库中的AJAX方法，以及目前最常用的Axios框架等。

假设我们后端有一个需要实时刷新的数据（随时间而变化）现在需要再前端实时更新展示，这里我们以axios框架的简单使用为例子，带各位小伙伴体验如何发起异步请求并更新我们页面中的数据。

首先是前端页面，直接抄作业就行：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>测试</title>
    <script src="https://unpkg.com/axios@1.1.2/dist/axios.min.js"></script>
</head>
<body>
  <p>欢迎来到GayHub全球最大同性交友网站</p>
  <p>用户名: <span id="username"></span></p>
  <p>密码: <span id="password"></span></p>
</body>
</html>
```

接着我们使用axios框架直接对后端请求JSON数据：

```html
<script>
    function getInfo() {
        axios.get('/mvc/test').then(({data}) => {
            document.getElementById('username').innerText = data.username
            document.getElementById('password').innerText = data.password
        })
    }
</script>
```

这样，我们就实现了从服务端获取数据并更新到页面中，前端开发者利用JS发起异步请求，可以实现各种各样的效果，而我们后端开发者只需要关心接口返回正确的数据即可，这就已经有前后端分离开发的雏形了（实际上之前，我们在JavaWeb阶段使用XHR请求也演示过，不过当时是纯粹的数据）

那么我们接着来看，如何向服务端发送一个JS对象数据并进行解析，这里以简单的登录为例：

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>测试</title>
    <script src="https://unpkg.com/axios@1.1.2/dist/axios.min.js"></script>
</head>
<body>
  <p>欢迎来到GayHub全球最大同性交友网站</p>
  <button onclick="login()">立即登录</button>
</body>
</html>
```

这里依然使用axios发送POST请求：

```html
<script>
    function login() {
        axios.post('/mvc/test', {
            username: 'test',
            password: '123456'
        }, {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).then(({data}) => {
            if(data.success) {
                alert('登录成功')
            } else {
                alert('登录失败')
            }
        })
    }
</script>
```

服务器端只需要在请求参数位置添加一个对象接收即可（和前面是一样的，因为这里也是提交的表单数据）：

```java
@ResponseBody
@PostMapping(value = "/test", produces = "application/json")
public String hello(String username, String password){
    boolean success = "test".equals(user.getUsername()) && "123456".equals(user.getPassword());
    JSONObject object = new JSONObject();
    object.put("success", success);
    return object.toString();
}
```

我们也可以将js对象转换为JSON字符串的形式进行传输，这里需要使用ajax方法来处理：

```html
<script>
    function login() {
        axios.post('/mvc/test', {
            username: 'test',
            password: '123456'
        }).then(({data}) => {
            if(data.success) {
                alert('登录成功')
            } else {
                alert('登录失败')
            }
        })
    }
</script>
```

如果我们需要读取前端发送给我们的JSON格式数据，那么这个时候就需要添加`@RequestBody`注解：

```java
@ResponseBody
@PostMapping(value = "/test", produces = "application/json")
public String hello(@RequestBody User user){
    boolean success = "test".equals(user.getUsername()) && "123456".equals(user.getPassword());
    JSONObject object = new JSONObject();
    object.put("success", success);
    return object.toString();
}
```

这样，我们就实现了前后端使用JSON字符串进行通信。


### 实现文件上传和下载


利用SpringMVC，我们可以很轻松地实现文件上传和下载，我们需要在MainInitializer中添加一个新的方法：

```java
public class MainInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    ...

    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {
      	// 直接通过registration配置Multipart相关配置，必须配置临时上传路径，建议选择方便打开的
        // 同样可以设置其他属性：maxFileSize, maxRequestSize, fileSizeThreshold
        registration.setMultipartConfig(new MultipartConfigElement("/Users/nagocoler/Download"));
    }
}
```

接着我们直接编写Controller即可：

```java
@RequestMapping(value = "/upload", method = RequestMethod.POST)
@ResponseBody
public String upload(@RequestParam MultipartFile file) throws IOException {
    File fileObj = new File("test.png");
    file.transferTo(fileObj);
    System.out.println("用户上传的文件已保存到："+fileObj.getAbsolutePath());
    return "文件上传成功！";
}
```

最后在前端添加一个文件的上传点：

```html
<div>
    <form action="upload" method="post" enctype="multipart/form-data">
        <input type="file" name="file">
        <input type="submit">
    </form>
</div>
```

这样，点击提交之后，文件就会上传到服务器了。

下载其实和我们之前的写法大致一样，直接使用HttpServletResponse，并向输出流中传输数据即可。

```java
@RequestMapping(value = "/download", method = RequestMethod.GET)
@ResponseBody
public void download(HttpServletResponse response){
    response.setContentType("multipart/form-data");
    try(OutputStream stream = response.getOutputStream();
        InputStream inputStream = new FileInputStream("test.png")){
        IOUtils.copy(inputStream, stream);
    }catch (IOException e){
        e.printStackTrace();
    }
}
```

在前端页面中添加一个下载点：

```html
<a href="download" download="test.png">下载最新资源</a>
```
