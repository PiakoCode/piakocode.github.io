# Spring


## Bean的注册和配置


java代码
```java
public class Main {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("application.xml"); // 配置文件位置
         // Bean的注册与配置
         Student student  = context.getBean(Student.class); // 通过class获得类 会自动选择
         Student student = (Student) context.getBean("stu"); // 通过bean的name获得类
         student.hello();
    }
}
```

xml配置文件
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">
        
    <bean name="stu" class="org.example.entity.Student"/> // 填写类的位置
    <!--
    <bean name="stu" class="org.example.entity.Student" scope="prototype"/> // 原型模式
    <bean name="stu" class="org.example.entity.Student" lazy-init="true"/>  // 懒加载
    <bean name="stu" class="org.example.entity.Student" depends-on="a"/>    // 依赖a
    -->
    <bean name="a" class="org.example.service.AService"/> <!-- 注册AService -->
    <alias name="a" alias="aaa"/>                         <!-- 别名 -->
</beans>
```


## 依赖注入

以下是一个简单的示例，演示如何在Spring XML配置文件中进行依赖注入：

1. 创建一个Java类，作为需要注入的依赖对象，例如：

```java
public class MyDependency {
    public void doSomething() {
        System.out.println("MyDependency is doing something");
    }
}
```

```java
@ToString
public class Student {
    String name;
    Teacher1 teacher;
    private  List<String> list;
    public void setList(List<String> list) {
        this.list = list;
    }
//    public Student(Teacher1 teacher, String name) {
//        this.teacher = teacher;
//        this.name = name;
//    }
//
//    public Student(Teacher1 teacher) {
//        this.teacher=teacher;
//    }
//
//    public Student(String name) {
//        this.name = name;
//    }
//    public void setName(String name) {
//        this.name = name;
//    }
//
//    public void setTeacher(Teacher1 teacher) {
//        this.teacher = teacher;
//    }
}
```




2. 创建一个Spring XML配置文件，例如，名为"applicationContext.xml"，并在其中定义bean和依赖注入，例如：

**通过使用依赖注入，可以将对象的创建和依赖关系的配置从代码中抽离出来，转移到配置文件中进行管理**
**即在配置文件中设置对象的初始值**

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
                           http://www.springframework.org/schema/beans/spring-beans.xsd">
    
    <bean id="myDependency" class="com.example.MyDependency"/>
    
    <bean id="myBean" class="com.example.MyBean">
        <property name="dependency" ref="myDependency"/> <!-- 依赖myDependency -->
    </bean>



    <bean name="artTeacher" class="org.example.entity.ArtTeacher"/>
    <bean name="stu" class="org.example.entity.Student">
    <!--<property name="name" value="小明"/>-->
    <!--<property name="teacher" ref="artTeacher"/>  //当stu使用teacher时，会通过set函数注入artTeacher-->
    <!--<constructor-arg name="teacher" ref="artTeacher"/>-->
    <!--<constructor-arg name="name" value="小明" type="java.lang.String"/>   // 通过构造函数注入， 当有两个不同的构造函数时，能够自动选择 -->
        <property name="list">
            <list>
                <value>aaa</value> <!-- 注入列表到构造函数中 -->
                <value>bbb</value>
                <value>ccc</value>
            </list>
        </property>
    </bean>

</beans>
```

在上面的示例中，我们定义了一个名为"myDependency"的bean，它的类是"com.example.MyDependency"。然后，我们定义了一个名为"myBean"的bean，它的类是"com.example.MyBean"。在"myBean"的定义中，我们使用"property"元素来注入"myDependency"作为依赖。

3. 创建一个Java类，表示需要依赖注入的对象，例如：

```java
public class MyBean {
    private MyDependency dependency;
    
    public void setDependency(MyDependency dependency) {
        this.dependency = dependency;
    }
    
    public void doSomethingWithDependency() {
        dependency.doSomething();
    }
}
```

在上面的示例中，我们定义了一个"dependency"属性，并提供了一个"setDependency"方法，用于注入依赖对象。我们还定义了一个"doSomethingWithDependency"方法，用于在需要时使用依赖对象。

4. 创建一个应用程序入口类，并使用Spring框架加载配置文件并获取bean，例如：

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class MyApp {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        
        MyBean myBean = (MyBean) context.getBean("myBean");
        myBean.doSomethingWithDependency();
    }
}
```

在上面的示例中，我们使用"ClassPathXmlApplicationContext"类加载"applicationContext.xml"配置文件，并使用"getBean"方法获取名为"myBean"的bean。然后，我们可以使用该bean调用相关方法。




## 自动装配


手动装配

```xml
    <bean name="teacher" class="org.example.entity.ArtTeacher"/>
    <bean name="student" class="org.example.entity.Student">
        <property name="teacher" ref="teacher"/>
    </bean>
```


自动装配

```xml
    <bean name="teacher" class="org.example.entity.ArtTeacher"/>
    <bean name="student" class="org.example.entity.Student" autowire="byType"/>
                                                            <!-- byNanme -->
```

byName的情况

```xml
    <bean name="program" class="org.example.entity.ProgramTeacher"/>
    <bean name="art" class="org.example.entity.ArtTeacher"/>
    <bean name="student" class="org.example.entity.Student" autowire="byName" />
```


```java
@ToString
public class Student {
    String name;
    Teacher1 teacher;

    public void setArt(Teacher1 teacher) { // 根据setxxx决定自动装配xxx
        this.teacher = teacher;
    }
    
    public void setProgram(Teacher1 teacher) { // 如果存在该函数则装配这个，无法通过添加autowire-candidate="false"或者primary避免，总是选择最后出现的set函数
        this.teacher =teacher;
    }
}
```

`autowire = 'constructor' `自动装配构造函数



避免自动装配

```xml
    <bean name="art" class="org.example.entity.ArtTeacher"/>
    <bean name="program" class="org.example.entity.ProgramTeacher" autowire-candidate="false"/>
    <bean name="student" class="org.example.entity.Student" autowire="byType" />
```

```java
@ToString
public class Student {
    String name;
    Teacher1 teacher;
    
    public void setArt(Teacher1 teacher) {
        this.teacher = teacher;
    }
    
    public void setProgram(Teacher1 teacher) {
        this.teacher =teacher;
    }
}
```

输出
```
Student(name=null, teacher=org.example.entity.ArtTeacher@6ff29830)
```

优先选择
```xml
    <bean name="art" class="org.example.entity.ArtTeacher" primary="true"/>
    <bean name="program" class="org.example.entity.ProgramTeacher"/>
    <bean name="student" class="org.example.entity.Student" autowire="byName" />
```


## 生命周期和继承 


### 生命周期

除了修改构造方法，我们也可以为Bean指定初始化方法和销毁方法，以便在对象创建和被销毁时执行一些其他的任务：

```java
public void init(){
    System.out.println("我是对象初始化时要做的事情！");    
}

public void destroy(){
    System.out.println("我是对象销毁时要做的事情！");
}
```

我们可以通过`init-method`和`destroy-method`来指定：

```xml
<bean name="student" class="com.test.bean.Student" init-method="init" destroy-method="destroy"/>
```

那么什么时候是初始化，什么时候又是销毁呢？

```java
//当容器创建时，默认情况下Bean都是单例的，那么都会在一开始就加载好，对象构造完成后，会执行init-method
ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("test.xml");
//我们可以调用close方法关闭容器，此时容器内存放的Bean也会被一起销毁，会执行destroy-method
context.close();
```

```java
public class Main {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("application.xml"); // 配置文件位置

        Student student = context.getBean(Student.class);
        System.out.println(student);

        context.close();

    }
}
```

加载时init，
单例模式下，销毁时destroy

所以，最后的结果为：
```
我是对象初始化时要做的事情！
Student()
我是对象销毁时要做的事情！
```


### 继承

Bean之间也是具备继承关系的，只不过这里的继承并不是类的继承，而是属性的继承，比如：

```java
public class SportStudent {
    private String name;

    public void setName(String name) {
        this.name = name;
    }
}
```

```java
public class ArtStudent {
    private String name;
   
    public void setName(String name) {
        this.name = name;
    }
}
```

如果新的Bean和之前的Bean属性一样，但属性太多的话，我们就可以配置Bean之间的继承关系，我们可以让SportStudent这个Bean直接继承ArtStudent这个Bean配置的属性：

```xml
<bean class="com.test.bean.SportStudent" parent="artStudent"/>
```

这样，在ArtStudent Bean中配置的属性，会直接继承给SportStudent Bean（注意，所有配置的属性，在子Bean中必须也要存在，并且可以进行注入，否则会出现错误）当然，如果子类中某些属性比较特殊，也可以在继承的基础上单独配置：

```xml
<bean name="artStudent" class="com.test.bean.ArtStudent" abstract="true">
    <property name="name" value="小明"/>
    <property name="id" value="1"/>
</bean>
<bean class="com.test.bean.SportStudent" parent="artStudent">
    <property name="id" value="2"/>
</bean>
```

如果我们只是希望某一个Bean仅作为一个配置模版供其他Bean继承使用，那么我们可以将其配置为abstract，这样，容器就不会创建这个Bean的对象了：

```xml
<bean name="artStudent" class="com.test.bean.ArtStudent" abstract="true">
    <property name="name" value="小明"/>
</bean>
<bean class="com.test.bean.SportStudent" parent="artStudent"/>
```

注意，一旦声明为抽象Bean，那么就无法通过容器获取到其实例化对象了。

![image-20221123140409416](https://s2.loli.net/2022/11/23/SyDkvOldB7ETW4z.png)

不过Bean的继承使用频率不是很高，了解就行。

这里最后再提一下，我们前面已经学习了各种各样的Bean配置属性，如果我们希望整个上下文中所有的Bean都采用某种配置，我们可以在最外层的beans标签中进行默认配置：

![image-20221123141221259](https://s2.loli.net/2022/11/23/KzSUJXa4jBfO9rd.png)

这样，即使Bean没有配置某项属性，但是只要在最外层编写了默认配置，那么同样会生效，除非Bean自己进行配置覆盖掉默认配置。


## 工厂模式和工厂Bean


```java
public class Student {
    Student() {
        System.out.println("我被构造了");
    }
}
```

```java
public class StudentFactory {
    public static Student getStudent(){
      	System.out.println("欢迎光临电子厂");
        return new Student();
    }
}
```


此时Student有一个工厂，我们正常情况下需要使用工厂才可以得到Student对象，现在我们希望Spring也这样做，不要直接去反射搞构造方法创建，我们可以通过factory-method进行指定：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean class="org.example.entity.StudentFactory" factory-method="getStudent" />

</beans>
```

```java
public class Main {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("application.xml"); // 配置文件位置

        System.out.println(context.getBean(Student.class));

    }
}
```

output
```
欢迎光临电子厂
我被构造了
org.example.entity.Student@4e08711f
```

当我们采用工厂模式后，我们就无法再通过配置文件对Bean进行依赖注入等操作了，而是只能在工厂方法中完成，这似乎与Spring的设计理念背道而驰？

当然，可能某些工厂类需要构造出对象之后才能使用，我们也可以将某个工厂类直接注册为工厂Bean：

```java
public class StudentFactory {
    public Student getStudent(){
        System.out.println("欢迎光临电子厂");
        return new Student();
    }
}
```

现在需要StudentFactory对象才可以获取到Student，此时我们就只能先将其注册为Bean了：

```xml
<bean name="studentFactory" class="com.test.bean.StudentFactory"/>
```

像这样将工厂类注册为Bean，我们称其为工厂Bean，然后再使用`factory-bean`来指定Bean的工厂Bean：

```xml
<bean factory-bean="studentFactory" factory-method="getStudent"/>
```

注意，使用factory-bean之后，不再要求指定class，我们可以直接使用了





如果我们想获取工厂Bean为我们提供的Bean，可以直接输入工厂Bean的名称，这样不会得到工厂Bean的实例，而是工厂Bean生产的Bean的实例：

```java
Student bean = (Student) context.getBean("studentFactory");
```

当然，如果我们需要获取工厂类的实例，可以在名称前面添加`&`符号：

```java
StudentFactory bean = (StudentFactory) context.getBean("&studentFactory");
```

## 使用注解开发

不再需要xml配置文件

新建一个配置类

```java
@Configuration  
public class MainConfiguration {  
}
```

修改Main类为：
```java
public class Main {  
    public static void main(String[] args) {  
        ApplicationContext context = new AnnotationConfigApplicationContext(MainConfiguration.class); // 加载配置类  
        System.out.println(context.getBean(Student.class));  
    }  
}
```


新增Bean：
在配置类中添加

```java
@Configuration
public class MainConfiguration {
    @Bean
    public Student student(){ // 添加Student Bean
        return new Student();
    }
//    @Bean("test")
//    @Lazy(true)
//    @Scope("prototype")
//    public Student student(){
//        return new Student();
//    }
}
```


，初始化方法和摧毁方法、自动装配可以直接在@Bean注解中进行配置：

```java
@Bean(name = "", initMethod = "", destroyMethod = "", autowireCandidate = false)
public Student student(){
    return new Student();
}
```

其次，我们可以使用一些其他的注解来配置其他属性，比如：

```java
@Bean
@Lazy(true)     //对应lazy-init属性
@Scope("prototype")    //对应scope属性
@DependsOn("teacher")    //对应depends-on属性
public Student student(){
    return new Student();
}
```

对于那些我们需要通过构造方法或是Setter完成依赖注入的Bean，比如：

```xml
<bean name="teacher" class="com.test.bean.ProgramTeacher"/>
<bean name="student" class="com.test.bean.Student">
    <property name="teacher" ref="teacher"/>
</bean>
```

像这种需要引入其他Bean进行的注入，我们可以直接将其作为形式参数放到方法中：

```java
@Configuration
public class MainConfiguration {
    @Bean
    public Teacher teacher(){
        return new Teacher();
    }

    @Bean
    public Student student(Teacher teacher){
        return new Student(teacher);
    }
}
```

此时我们可以看到，旁边已经出现图标了：

![image-20221123213527325](https://s2.loli.net/2022/11/23/wy5JtiVp8zK1bmG.png)

运行程序之后，我们发现，这样确实可以直接得到对应的Bean并使用。

只不过，除了这种基于构造器或是Setter的依赖注入之外，我们也可以直接到Bean对应的类中使用自动装配：

```java
public class Student {
    @Autowired   //使用此注解来进行自动装配，由IoC容器自动为其赋值
    private Teacher teacher;
}
```

现在，我们甚至连构造方法和Setter都不需要去编写了，就能直接完成自动装配，是不是感觉比那堆配置方便多了？

当然，@Autowired并不是只能用于字段，对于构造方法或是Setter，它同样可以：

```java
public class Student {
    private Teacher teacher;

    @Autowired
    public void setTeacher(Teacher teacher) {
        this.teacher = teacher;
    }
}
```

@Autowired默认采用byType的方式进行自动装配，也就是说会使用类型进行配，那么要是出现了多个相同类型的Bean，如果我们想要指定使用其中的某一个该怎么办呢？

```java
@Bean("a")
public Teacher teacherA(){
    return new Teacher();
}

@Bean("b")
public Teacher teacherB(){
    return new Teacher();
}
```

此时，我们可以配合@Qualifier进行名称匹配：

```java
public class Student {
    @Autowired
    @Qualifier("a")   //匹配名称为a的Teacher类型的Bean
    private Teacher teacher;
}
```


还有@PostConstruct和@PreDestroy，它们效果和init-method和destroy-method是一样的：

```java
@PostConstruct
public void init(){
    System.out.println("我是初始化方法");
}

@PreDestroy
public void destroy(){
    System.out.println("我是销毁方法");
}
```


前面我们介绍了使用@Bean来注册Bean，但是实际上我们发现，如果只是简单将一个类作为Bean的话，这样写还是不太方便，因为都是固定模式，就是单纯的new一个对象出来，能不能像之前一样，让容器自己反射获取构造方法去生成这个对象呢？

肯定是可以的，我们可以在需要注册为Bean的类上添加`@Component`注解来将一个类进行注册**（现在最常用的方式）**，不过要实现这样的方式，我们需要添加一个自动扫描来告诉Spring，它需要在哪些包中查找我们提供的`@Component`声明的Bean。

```java
@Component("lbwnb")   //同样可以自己起名字
public class Student {

}
```

要注册这个类的Bean，只需要添加@Component即可，然后配置一下包扫描：

```java
@Configuration
@ComponentScan("com.test.bean")   //包扫描，这样Spring就会去扫描对应包下所有的类
public class MainConfiguration {

}
```

```java
@Configuration
@ComponentScans({
    @ComponentScan("path.to.A")
    @ComponentScan("path.to.B")
})   //包扫描，这样Spring就会去扫描对应包下所有的类
public class MainConfiguration {

}
```

Spring在扫描对应包下所有的类时，会自动将那些添加了@Component的类注册为Bean，是不是感觉很方便？只不过这种方式只适用于我们自己编写类的情况，如果是第三方包提供的类，只能使用前者完成注册，并且这种方式并不是那么的灵活。

不过，无论是通过@Bean还是@Component形式注册的Bean，Spring都会为其添加一个默认的name属性，比如：

```java
@Component
public class Student {
}
```

它的默认名称生产规则依然是类名并按照首字母小写的驼峰命名法来的，所以说对应的就是student：

```java
Student student = (Student) context.getBean("student");   //这样同样可以获取到
System.out.println(student);
```

同样的，如果是通过@Bean注册的，默认名称是对应的方法名称：

```java
@Bean
public Student artStudent(){
    return new Student();
}
```

```java
Student student = (Student) context.getBean("artStudent");
System.out.println(student);
```

相比传统的XML配置方式，注解形式的配置确实能够减少我们很多工作量。并且，对于这种使用`@Component`注册的Bean，如果其构造方法不是默认无参构造，那么默认会对其每一个参数都进行自动注入：

```java
@Component
public class Student {
    Teacher teacher;
    public Student(Teacher teacher){   //如果有Teacher类型的Bean，那么这里的参数会被自动注入
        this.teacher = teacher;
    }
}
```

最后，对于我们之前使用的工厂模式，Spring也提供了接口，我们可以直接实现接口表示这个Bean是一个工厂Bean：

```java
@Component
public class StudentFactory implements FactoryBean<Student> {
    @Override
    public Student getObject() {   //生产的Bean对象
        return new Student();
    }

    @Override
    public Class<?> getObjectType() {   //生产的Bean类型
        return Student.class;
    }

    @Override
    public boolean isSingleton() {   //生产的Bean是否采用单例模式
        return false;
    }
}
```

实际上跟我们之前在配置文件中编写是一样的，这里就不多说了。

## 高级用法 TODO


## SpEL表达式

[[SSM笔记（一）Spring基础#SpringEL表达式]]


Spring Expression Language (SpEL) 是一种强大的表达式语言，用于在 Spring 框架中处理和评估表达式。SpEL 可以在运行时计算表达式，并将其应用于 Spring 应用程序的不同方面，例如属性注入、XML 配置、注解、AOP 等。

SpEL的作用包括：

1. 属性值的引用：SpEL可以使用类似于JavaScript或Python的点号语法来引用对象的属性。这允许在配置文件中动态引用属性值。

2. 方法调用：SpEL可以调用对象的方法，包括静态方法和实例方法。

3. 算术和逻辑运算：SpEL支持各种算术和逻辑运算符，例如加法、减法、乘法、除法、取模、逻辑与、逻辑或等。

4. 条件判断和三元运算符：SpEL可以使用条件判断语句，例如if-else语句和三元运算符。

5. 集合和数组的操作：SpEL可以对集合和数组进行操作，例如获取集合的长度、获取数组的元素等。

6. 类型转换：SpEL可以在表达式中执行类型转换，例如将字符串转换为数字、将对象转换为字符串等。

7. 正则表达式匹配：SpEL可以使用正则表达式进行模式匹配。

8. Bean引用和属性赋值：SpEL可以在运行时引用和操作Spring容器中的Bean，包括获取Bean的属性值和给Bean的属性赋值。


SpEL 支持一系列表达式操作符和函数，可以用于访问对象属性、调用方法、进行数学计算、逻辑判断等。以下是一些常见的 SpEL 表达式示例：

1. 访问对象属性：

    ```
    #{person.name}  // 获取 person 对象的 name 属性
    #{person.address.city}  // 获取 person 对象的 address 属性的 city 属性
    ```

2. 调用对象方法：

    ```
    #{person.getName()}  // 调用 person 对象的 getName() 方法
    #{person.getAddress().getCity()}  // 调用 person 对象的 getAddress() 方法的 getCity() 方法
    ```

3. 数学计算：

    ```
    #{2 + 3}  // 加法
    #{10 - 5}  // 减法
    #{2 * 4}  // 乘法
    #{10 / 2}  // 除法
    ```

4. 逻辑判断：

    ```
    #{age > 18}  // 判断 age 是否大于 18
    #{person.age >= 20 && person.age <= 30}  // 判断 person.age 是否在 20 到 30 之间
    ```

5. 条件表达式：

    ```
    #{person.age > 18 ? '成年' : '未成年'}  // 判断 person.age 是否大于 18，返回不同的文本
    ```

以上只是一些 SpEL 表达式的示例，SpEL 还提供了更多功能和语法，用于处理更复杂的表达式和逻辑。在 Spring 应用程序中，可以在 XML 配置文件、注解中或通过编程方式使用 SpEL 表达式。


使用Spring的SpEL的一些常见用法：

1. 评估简单表达式：
SpEL可以用来评估简单的表达式，例如算术表达式、字符串拼接等。你可以使用SpEL的解析器来评估这些表达式。

```java
ExpressionParser parser = new SpelExpressionParser();
Expression expression = parser.parseExpression("2 + 3");
int sum = (Integer) expression.getValue();
System.out.println(sum); // 输出：5

expression = parser.parseExpression("'Hello' + ' World'");
String message = (String) expression.getValue();
System.out.println(message); // 输出：Hello World
```

2. 访问对象属性：
SpEL可以访问Java对象的属性。你可以使用"."操作符来访问对象的属性。

```java
public class Person {
    private String name;
    // getters and setters...
}

Person person = new Person();
person.setName("John");

ExpressionParser parser = new SpelExpressionParser();
Expression expression = parser.parseExpression("name");
String name = (String) expression.getValue(person);
System.out.println(name); // 输出：John
```

3. 调用对象方法：
SpEL可以调用Java对象的方法。你可以使用"."操作符来调用对象的方法。

```java
public class Calculator {
    public int add(int a, int b) {
        return a + b;
    }
}

Calculator calculator = new Calculator();

ExpressionParser parser = new SpelExpressionParser();
Expression expression = parser.parseExpression("add(2, 3)");
int sum = (Integer) expression.getValue(calculator);
System.out.println(sum); // 输出：5
```

4. 使用条件和逻辑运算符：
SpEL支持条件和逻辑运算符，可以用于条件判断和逻辑操作。

```java
ExpressionParser parser = new SpelExpressionParser();
Expression expression = parser.parseExpression("age > 18 && gender == 'male'");
boolean result = (Boolean) expression.getValue(person);
System.out.println(result); // 输出：true
```

5. 使用集合操作符：
SpEL支持集合操作符，可以用于对集合或数组进行过滤、映射和投影等操作。

```java
// 假设有一个包含Person对象的List
List<Person> people = new ArrayList<>();
people.add(new Person("John", 25));
people.add(new Person("Alice", 30));
people.add(new Person("Bob", 35));

ExpressionParser parser = new SpelExpressionParser();
Expression expression = parser.parseExpression("name.toUpperCase()");
List<String> names = (List<String>) expression.getValue(people);
System.out.println(names); // 输出：[JOHN, ALICE, BOB]
```



## 集成JUnit测试

pom.xml

```xml
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.9.3</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-test</artifactId>
            <version>6.0.11</version>
        </dependency>
```


test/java/MainTest.java

```java
@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = MainConfiguration.class)
public class MainTest {

    @Autowired
    TestService service;

    @Test
    public void test() {
        service.test();
        System.out.println("我是测试");
    }

}
```