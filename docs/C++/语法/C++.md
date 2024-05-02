# C++

#基础

## 条件宏

条件宏的工作原理是先检查宏是否已经定义，如果已经定义则编译`#ifdef`和`#else`之间的代码，否则编译`#else`和`#endif`之间的代码。

条件宏的常用场景包括：

1. 平台相关代码：根据不同的操作系统平台来编写不同的代码。比如：

```cpp
#ifdef _WIN32
    // Windows平台下的代码
#elif __linux__
    // Linux平台下的代码
#elif __APPLE__
    // macOS平台下的代码
#else
    // 其他平台下的代码
#endif
```

2. 特定功能的开关：根据宏的定义与否来选择性地编译某些功能代码。比如：

```cpp
#ifdef DEBUG
    // 调试模式下的代码
#endif

#ifndef NDEBUG
    // 非调试模式下的代码
#endif
```

在代码中，`DEBUG`和`NDEBUG`都是预定义的宏，在编译时可以使用命令行参数或者IDE工具的设置来决定是否定义这些宏，从而选择性地编译调试相关的代码。

需要注意的是，条件宏只能在预编译阶段起作用，即在源代码被编译之前进行处理。一旦宏被定义或未定义，它在整个编译过程中都保持不变。因此，在不同的编译单元中定义或取消定义同一个宏可能会导致不一致的行为。

此外，条件宏也可以使用`#ifndef`（即“如果未定义”）来判断宏是否未定义。例如：

```cpp
#ifndef 宏名
    // 如果宏未被定义，则编译这部分代码
#endif
```

## 构造函数

```cpp
struct S {
    // 我不想自己写默认构造函数，就按照预置的来就行
    S() = default;
    // 默认初始化所有成员（调用默认构造或不初始化）


    // 我也不想自己写复制构造函数，就按照预置的来就行
    S(const S&) = default;
    // 复制初始化所有成员（调用复制构造或直接复制）

    S(/* 其它构造函数 */) { /* [...] */ }
};
```


```cpp
struct S {
    // 不许生成默认构造函数
    S() = delete;
};
```

## static 静态变量

当声明一个静态方法或者静态变量，这个静态方法或静态变量只能在该cpp文件中使用，而不能够被其他cpp文件所使用。除非两个文件声明了两个名字相同的变量，并都为静态变量

静态成员变量在编译时存储在静态存储区，即定义过程应该在编译时完成，因此一定要在类外进行定义，但可以不初始化。
静态成员变量是**所有实例共享**的，但是其只是在类中进行了声明，并未定义或初始化（分配内存），类或者类实例就无法访问静态成员变量，这显然是不对的，所以必须先在类外部定义，也就是分配内存


```cpp
class Entity {
public:
    static int x;
    static int y;
    void Print() {
        std::cout << x << " " << y << std::endl;
    }
};
int Entity::x;
int Entity::y;

Entity e;
e.x = 1;

Entity::x = 2;
```

静态方法不能访问非静态变量，因为静态方法没有类实例

### 局部 static

只能被函数改变

```cpp
void Function() {
    static int i = 0;
    i++;
    std::cout<<i<<std::endl;
}

int main() {
    Function(); // 1
    Function(); // 2
    Function(); // 3
    Function(); // 4
    Function(); // 5
    return 0;
}
```

通过使用static，实际上可以延长变量的生存期

## enum 枚举

只能为整数

```cpp
enum xxx {
    A, B, C
}; // 0, 1, 2

xxx a = 2; // 0 ~ 2
```

设置整数的类型

```cpp
enum xxx : unsigned char {
    A, B, C
};
```

## 继承


下述代码中的Player类是Entity类的超集，可以被当作Entity类使用
```cpp

class Entity {
public:
    float x, y;

    void Move(float xa, float ya) {
        x += xa;
        y += ya;
    }

    void print() {
        std::cout << x << ", " << y << std::endl;
    }
};

class Player : public Entity { //没有 public 时，默认为private
public:
    const char* Name;

    void PrintName() {
        std::cout << Name << std::endl;
    }
};
```


## 虚函数

>[!note]
>使用虚函数可能会损失一定的性能，但大多数情况下，没有影响

```cpp
class Entity {
private:
public:
    std::string GetName() {
        return "Entity";
    }
};

class Player : public Entity {
private:
    std::string m_Name;

public:
    Player(const std::string& name) :
        m_Name(name) {
    }

    std::string GetName() {
        return m_Name;
    }
};

int main() {
    Entity* e = new Entity();
    std::cout << e->GetName() << std::endl; // "Entity"

    Player* p = new Player("Piako");
    std::cout << p->GetName() << std::endl; // "Piako"

    Entity* entity = p;

    std::cout << entity->GetName() << std::endl; // "Entity"

    return 0;
}
```

尽管entity实际上是Player指针，但还是被当作了Entity类型。

可以通过添加virtual关键字，创建v表，使得其可以按照预期工作。

```cpp
virtual std::string GetName() {
    return "Entity";
}
```

>[!info]
>在C++ 11 中添加了override标记，提高代码可读性,帮助检查代码
>


## 纯虚函数

类似于其他函数中的抽象方法或接口。强制子类去实现未实现的方法。

```cpp
class Entity {
public:
    virtual void printName() = 0;
};


class Player:public Entity {
public:
    // void printName() {
    //     std::printf("EEE");
    // }
    void print() {
        std::printf("Hello\n");
    }
};
```

Player类型必须实现printName方法，否则它也将是**纯虚函数**，无法实例化。

![](Picture/Pasted%20image%2020230318163847.png)

## 可见性

`public`
皆可见

`protected`
继承体系可见，类外不可见

`private`
类内与友元可见，类外不可见

## 字符串

`const char*`
`string`

```cpp
const char* name = "Piako";
const wchar_t* name2 = L"Piako";
const char16_t* name3 = u"Piako";
const char32_t* name4 = U"Piako";
```

std::string_literals `string("Piako") -> "Piako"s`

R"xxx" 不考虑转义字符

## const

常量指针
`const int* a` 与 `int const* a` 作用相同让指针指向的空间无法被改变

指针常量
`int* const a` 指针本身无法被改变


承诺该函数不会修改值
```cpp
getX() const {
    return x;
}
```

*常量对象只能调用常量函数*，如果有两个同名的函数，该对象将会调用当中常量函数

```cpp
class Entity {
private:
    int m_x;
    mutable int conut = 0;
public:
    int getX() const {
        count ++;
        return m_x;
    }
    int getX() {
        return m_x;
    }
};


void print(const Entity& e) {
    std::cout<< e.getX() << std::endl;
}
```

mutable允许函数是常量方法，但可以修改变量.

## 成员列表

```cpp
class Entity {
private:
    std::string m_Name;
    int m_x;
    mutable int conut = 0;
public:
    Entity() : m_Name("Unknown"),m_x(5) {
        // xxxx
    }
    
};
```

冒号后的内容，每次执行这个函数都会**先执行**一次。

因此编写成员列表需要按照变量的声明顺序。

使用成员列表可以避免在构造对象中的对象元素时重复构造
```cpp
class Example {
    private:
    int x;
public:
    Example(int x) {
        this->x = x;
        std::cout<<"Create "<< x<<std::endl;
    }
    Example() {

        std::cout << "Create" << std::endl;
    }
};

class Entity {
private:
    std::string name;
    Example e;
public:
    Entity() {
        name = "Hello";
        e = Example(6); // 发生重复构造
    }
};
```

```cpp
Entity(): e(Example(6)) {
    name = "Hello";
}
```


## 隐式转换

```cpp
class Entity {
private:
    std::string m_name;
    int m_age;

public:
    Entity(const std::string& name) :
        m_name(name), m_age(-1) {
    }
    Entity(int age) :
        m_name("unknown"), m_age(age) {
    }
};

void PrintEntity(const Entity& entity) {
    // Printing
}

int main() {
    PrintEntity(45);

    Entity a = std::string("Piako");
    Entity b = 22;

    return 0;
}
```

`explicit` 用于禁用隐式转换,必须显式地调用构造函数。

```cpp
class Entity {
private:
    std::string m_name;
    int m_age;

public:
    Entity(const std::string& name) :
        m_name(name), m_age(-1) {
    }
    Entity(int age) :
        m_name("unknown"), m_age(age) {
    }
};

void PrintEntity(const Entity& entity) {
    // Printing
}

int main() {
    PrintEntity(45);

    Entity a = std::string("Piako");
    Entity b = 22;

    return 0;
}
```

## 域指针实现

在堆上创建对象，并能以“栈”上对象的方式自动销毁。

```cpp
class Entity
{
public:
    Entity()
    {
        std::cout <<"Created" <<std::endl;
    }

    ~Entity()
    {
        std::cout<<"Destroyed"<< std::endl;
    }
};


class ScopedPtr
{
private:
    Entity *m_ptr;

public:
    ScopedPtr(Entity *ptr) : m_ptr(ptr) {}
    ~ScopedPtr()
    {
        delete m_ptr;
    }

};



int main()
{
    {   // Entity* e = new Entity(); 不会在作用域结束后被自动销毁
        ScopedPtr e = new Entity(); //在堆上创建Entity 
    }
    // ScopedPtr的作用域结束，Entity对象被自动delete
    return 0;
}
```

## 智能指针

头文件`<memory>`

### unique_ptr

`unique_ptr` 是**作用域指针**，当超出作用域时，对象就会被自动销毁，

只能有一个，否则会发生冲突。不允许被复制

因为 `unique_ptr` 是 `explicit` 的，所以必须显式地调用构造函数

```cpp
std::unique_ptr<Entity> entity(new Entity());
```

更好的实现方法  *C++14 支持*

```cpp
std::unique_ptr<Entity> entity = std::make_unique<Entity>();
```

### shared_ptr

`shared_ptr` 通过引用计数来控制对象。当引用计数为零时，对象被销毁

>[!note]
>`shared_ptr` 的计数系统会增加开销

```cpp
{
    std::shared_ptr<Entity> e0;
    {
        std::shared_ptr<Entity> sharedEntity = std::make_shared<Entity>(); // Print: Created Entity.
        e0 = sharedEntity;
    }
} // Print: Destroyed Entity.
```

### weak_ptr

当shared_ptr赋值给weak_ptr时，不会增加引用计数。weak_ptr仅仅是声明这个对象还存活，不会保持对象的存活。往往用于查看对象的情况。


在使用时优先使用unique_ptr，其次才是shared_ptr。


## 浅拷贝和深拷贝

当两个对象复制时，C++默认会直接复制元素值，然而当元素为指针时，这样会使两个对象的元素指向同一块内存空间。

```cpp
#include <iostream>
#include <ostream>
#include <string>
#include <cstring>

class String {
private:
    char *m_Buffer; //pointer
    unsigned int m_Size;

public:
    String(const char *string) {
        m_Size = strlen(string);
        m_Buffer = new char[m_Size+1];
        memcpy(m_Buffer, string, m_Size + 1);
        m_Buffer[m_Size] = 0;
    }

    ~String() {
        delete [] m_Buffer;
    }

    friend std::ostream &operator<<(std::ostream &stream, const String &string);
};


std::ostream &operator<<(std::ostream &stream, const String &string) {
    stream << string.m_Buffer;
    return stream;
}


int main() {
    String str= "Piako";
    String second = str; 
    std::cout<<str<<std::endl;

    return 0;
}// free(): double free detected in tcache 2

```

此时就需要实现**深拷贝**

1. 实现C++中的拷贝构造函数
2. 重载运算符

```cpp
String(const String &other) :
    m_Size(other.m_Size)
{
    m_Buffer = new char[m_Size + 1];
    memcpy(m_Buffer, other.m_Buffer, m_Size+1);
}

// ...

String second = str; 
```

## Vector

`.reserve()` 设定vector大小
`.emplace_back()` 用设定的参数构造对象，比`.push_back()`效率更高

C++17前
```cpp
std::vector<int> v = {4, 3, 2, 1};
```

C++17后
```cpp
std::vector<int> v = {4, 3, 2, 1}; // CTAD 编译期参数推断
```




## Template 模板

[C++ Template](C++%20Template.md)

C++20 模板

```
template <typename T>
void func(T value)
{
    
}
```

>[!note]
>`template <class T>` 和 `template <typename T>` **完全**等价


只有调用Template时，才会在编译时真正生成Template的代码。

```cpp
template <typename T, int N>
class Array
{
private:
    T m_Array[N];

public:
    int GetSize() const { return N; }
};

int main()
{
    Array<std::string, 5> array;
    std::cout << array.GetSize() << std::endl;
    return 0;
}
```


### 自动推导参数类型

```cpp
template <typename T>
void my_swap(T &a, T &b) // 非优先调用
{
    auto temp = a;
    a = b;
    b = temp;
}
```


### 特化的重载

```cpp
#include <iostream>

template <typename  T>
T twice(T t) {
    return t * 2;
}

std::string twice(std::string t) {
    return t + t;
}

int main() {
    std::cout<<twice(2.3)<<std::endl;
    std::cout<<twice(std::string("Hello"))<<std::endl; // 不会隐式转换
    return 0;
}
```

[C++模板进阶指南：SFINAE - 知乎](https://zhuanlan.zhihu.com/p/21314708)


### 默认参数类型

如果模板类型参数 T 没有出现在函数的参数中，那么编译器就无法推断，就不得不手动指定
```cpp
template <typename  T = int>
T two() {
    return 2;
}

int main() {
    std::cout<<two()<<std::endl;
    return 0;
}
```

### 模版参数（只支持整数）

```cpp
template <int N>
void echo_times(std::string str)
{
    for (int i = 0; i < N; i++)
    {
        std::cout << str << std::endl;
    }
}

int main()
{
    echo_times<3>("Hello");
    return 0;
}
```


## 常用数值算法
### for_each

```cpp
int sum = 0;

void func(int value)
{
    sum += value;
}

int main()
{
    std::vector<int> v = {4, 3, 2, 1};
    std::for_each(v.begin(), v.end(), func);
    std::cout << sum << std::endl; // 10

    return 0;
}
```

### reduce

c++17引入

```cpp
int main()
{
    std::vector<int> v = {4, 3, 2, 1};

    int sum = std::reduce(v.begin(), v.end());
    std::cout << sum << std::endl; // 10

    return 0;
}
```

```cpp
#include <iostream>
#include <numeric>
#include <vector>

int main()
{
    std::vector<int> v = {4, 3, 2, 1};

    int sum = std::reduce(v.begin(), v.end(),0,std::plus());
    std::cout << sum << std::endl; // 10

    return 0;
}
```


## std::function

```cpp
#include <iostream>
#include <functional>

// 定义一个函数
int add(int a, int b) {
    return a + b;
}

int main() {
    // 使用 std::function 封装一个函数指针
    std::function<int(int, int)> func_ptr = &add;
    std::cout << func_ptr(3, 4) << std::endl;  // 输出 7

    // 使用 std::function 封装一个 Lambda 表达式
    std::function<int(int, int)> func_lambda = [](int a, int b) { return a * b; };
    std::cout << func_lambda(3, 4) << std::endl;  // 输出 12

    // 使用 std::function 封装一个函数对象
    struct MyAdd {
        int operator()(int a, int b) {
            return a + b;
        }
    };
    std::function<int(int, int)> func_obj = MyAdd();
    std::cout << func_obj(3, 4) << std::endl;  // 输出 7

    return 0;
}
```


未知类型、数量的参数，以及未知类型的返回值

```cpp
template<typename... Args, typename ReturnType>
std::function<ReturnType(Args...)> create_function(ReturnType (*func)(Args...)) {
    return std::function<ReturnType(Args...)>(func);
}
```

## lambda 表达式

lambda表达式的一般形式如下：
```cpp
[capture-list](parameters) -> return-type {
    // 函数体
}
```
在`capture-list`中，可以指定一组变量，这些变量可以在lambda表达式中被捕获并在函数体中使用。捕获可以是按值（`[=]`）或按引用（`[&]`）进行。当然，还有其他的捕获方式，如按值捕获单个变量（`[x]`）或按引用捕获单个变量（`[&x]`）等。

`parameters`是lambda表达式的参数列表，可以指定参数的类型，也可以使用`auto`进行类型推断。

`return-type`是返回类型，可以使用`auto`进行类型推断，也可以显式指定。


```cpp
int main()
{
    std::vector<int> v = {4, 3, 2, 1};
    
    int sum = 0;
    
    std::for_each(v.begin(), v.end(),[&] (int value){
        sum += value;
    });
    std::cout << sum << std::endl;

    return 0;
}
```

递归
```cpp
#include <iostream>
#include <functional>

int main() {
    std::function<int(int)> factorial = [&](int n) {
        if (n == 0 || n == 1) {
            return 1;
        } else {
            return n * factorial(n - 1);
        }
    };

    std::cout << factorial(5) << std::endl;  // 输出120

    return 0;
}
```
```


C++14的lambda表达式允许使用auto
```cpp
int main()
{
    std::vector<int> v = {4, 3, 2, 1};
    
    int sum = 0;
    
    std::for_each(v.begin(), v.end(),[&] (auto value){
        sum += value;
    });
    std::cout << sum << std::endl;

    return 0;
}
```



## 并发编程

在C++中，有多种方法可以实现并发编程。以下是一些常见的方法：

1. 多线程：使用线程库（如std::thread）创建多个线程来并发执行任务。
2. 互斥锁：使用互斥锁（如std::mutex）来保护共享资源，以避免多个线程同时访问导致的数据竞争。
3. 条件变量：使用条件变量（如std::condition_variable）可以实现线程间的同步和通信。
4. 原子操作：使用原子操作（如std::atomic）来保证对共享数据的原子性操作，避免出现数据竞争。
5. 异步编程：使用异步任务（如std::async）来实现任务的异步执行，可以在任务完成之前继续执行其他任务。
6. 并行算法：使用并行算法（如std::for_each、std::transform等）可以并发地处理大量数据。


详情参见 
English:[Concurrency support library (since C++11) - cppreference.com](https://en.cppreference.com/w/cpp/thread)
Chinese:[并发支持库 - cppreference.com](https://zh.cppreference.com/w/cpp/thread)

[C++多线程并发基础入门教程](https://www.zhihu.com/tardis/zm/art/194198073)
### thread

```cpp
#include <iostream>
#include <thread>

using namespace std;

// basic_thread

int x = 0;

auto add_x() {
    for (int i = 1; i <= 10000; i++) {
        x += 1;
    }
}

auto print() {
    cout<<"value: "<<x<<endl;
} 



auto main() -> int {
    const int numThreads = 10000;
    thread threads[numThreads];

    for (int i = 0; i < numThreads; i++) {
        threads[i] = thread(add_x); // thread构造函数的第一个参数为函数名，之后的参数为这个函数的参数
    }

    for (int i = 0;i<numThreads; i++) {
        threads[i].join(); // 对线程进行阻塞
    }

    print();
    return 0;
}
```

**detach()**

`.detach()`方法用于将线程与主线程分离。一旦线程被分离，它就可以独立运行，不再与主线程关联。主线程不会等待被分离的线程结束，也无法获取被分离线程的返回值。

下面是一个示例：

```cpp
#include <iostream>
#include <thread>

void threadFunction() {
    std::cout << "子线程开始运行" << std::endl;
    // 线程执行一些任务
    // ...
    std::cout << "子线程结束" << std::endl;
}

int main() {
    std::cout << "主线程开始" << std::endl;
    std::thread myThread(threadFunction);

    myThread.detach(); // 分离线程

    std::cout << "主线程结束" << std::endl;
    return 0;
}
```

在上述示例中，主线程创建了一个名为`myThread`的子线程，并使用`.detach()`将其分离。主线程继续执行，不会等待子线程结束。因此，当主线程执行完毕后，程序会立即终止，而不管子线程是否执行完毕。当子线程的任务完成后，它会自动退出。

这会使程序不发生如下错误
```
terminate called without an active exception
[2]    132526 IOT instruction (core dumped)
```

但可能访问已经销毁的变量、造成更严重的风险
### mutex

```cpp
#include <iostream>
#include <mutex>
#include <thread>

using namespace std;

// basic_mutex

mutex m_lock;

int x = 0;

auto add_x() {
    m_lock.lock();
    for (int i = 1; i <= 10000; i++) {
        x += 1;
    }
    m_lock.unlock();
}

auto add_xx() {
    lock_guard<std::mutex> lock(m_lock);
    for (int i = 1; i <= 10000; i++) {
        x += 1;
    }
}

auto print() {
    cout<<"value: "<<x<<endl;
} 



auto main() -> int {
    const int numThreads = 10000;
    thread threads[numThreads];

    for (int i = 0; i < numThreads; i++) {
        threads[i] = thread(add_x);
    }

    for (int i = 0;i<numThreads; i++) {
        threads[i].join();
    }

    print();
    return 0;
}
```

### condition_variable

条件变量通常与互斥锁（mutex）一起使用，以确保线程之间的正确同步。互斥锁用于保护共享数据的访问，而条件变量用于线程之间的等待和唤醒通知。
C++中的条件变量主要由以下两个类组成：

1. `std::condition_variable`：条件变量类，用于等待和唤醒线程。
2. `std::condition_variable_any`：通用条件变量类，可以与任何互斥量一起使用。


使用条件变量，需要进行以下步骤：

1. 创建一个条件变量对象。
2. 创建一个互斥锁对象来保护共享数据。
3. 在等待线程中，使用互斥锁和条件变量的 `wait()` 函数等待满足条件。
4. 在唤醒线程中，用互斥锁锁定共享数据，然后使用条件变量的 `notify_one()` 或 `notify_all()` 函数唤醒等待线程。
5. 在等待线程被唤醒后，重新获取互斥锁，然后检查条件是否满足，如果不满足，则继续等待。


`wait()`: 线程调用`wait()`方法后，会进入等待状态，直到其他线程调用了`notify_one()`或`notify_all()`方法来唤醒它。

`notify_one()`: 唤醒一个等待在条件变量上的线程。

`notify_all()`: 唤醒所有等待在条件变量上的线程。


下面是一个简单的示例代码，演示了如何使用条件变量：
```cpp
#include <iostream>
#include <queue>
#include <thread>
#include <condition_variable>

std::queue<int> data_queue;
std::mutex mtx;
std::condition_variable cond;

void producer()
{
    for (int i = 1; i <= 10; ++i) {
        std::this_thread::sleep_for(std::chrono::milliseconds(500));  // 模拟生产时间
        std::lock_guard<std::mutex> lock(mtx);
        data_queue.push(i);
        std::cout << "Produced: " << i << std::endl;
        cond.notify_all();  // 通知等待的消费者线程
    }
}

void consumer()
{
    while (true) {
        std::unique_lock<std::mutex> lock(mtx); // 使wait时，线程处于阻塞状态
        cond.wait(lock, []{ return !data_queue.empty(); });  // 等待条件满足
        int data = data_queue.front();
        data_queue.pop();
        std::cout << "Consumed: " << data << std::endl;
    }
}

int main()
{
    std::thread producer_thread(producer);
    std::thread consumer_thread(consumer);

    producer_thread.join();
    consumer_thread.join();

    return 0;
}
```

在这个示例中，生产者线程通过循环不断地生产数据，并使用条件变量通知等待的消费者线程。消费者线程在消费数据前等待条件变量的满足，一旦满足就消费数据。两个线程通过互斥量mtx对共享资源data_queue进行保护，保证数据的正确访问。


`.notify_all()` 唤醒所有等待的线程

`.notify_one()`  随机唤醒一个等待的线程

`wait()` 

### scoped_lock

```cpp

// 这个程序提供了使用std::scoped_lock的一个小例子。
// std::scoped_lock是一个互斥锁的包装类，提供了一种RAII风格的方法来获取和释放锁。
// 这意味着当对象被构造时，锁被获取，当对象被销毁时，锁被释放。

// 包含用于演示目的的std::cout（打印）。
#include <iostream>
// 包含互斥锁库的头文件。
#include <mutex>
// 包含线程库的头文件。
#include <thread>

// 定义一个全局计数变量和两个互斥锁，供两个线程使用。
int count = 0;
std::mutex m;

// add_count函数允许一个线程原子地将计数变量加1。
void add_count() {
  // std::scoped_lock的构造函数允许线程获取互斥锁m。
  std::scoped_lock slk(m);
  count += 1;

  // 一旦add_count函数执行完毕，对象slk就超出了作用域，在其析构函数中释放了互斥锁m。
}

// main方法与mutex.cpp中的相同。它构造线程对象，对两个线程运行add_count，然后打印执行后的计数结果。
int main() {
  std::thread t1(add_count);
  std::thread t2(add_count);
  t1.join();
  t2.join();

  std::cout << "Printing count: " << count << std::endl;
  return 0;
}
```

>scoped_lock是C++11中引入的类模板，可以同时管理多个互斥量。scoped_lock通过构造函数接受多个互斥量，并在构造时对这些互斥量进行加锁操作。在析构时，scoped_lock会对所有已加锁的互斥量进行解锁操作。scoped_lock可以防止忘记解锁互斥量而产生死锁的情况。
>
>lock_guard是C++11之前的类，只能管理单个互斥量。lock_guard通过构造函数接受一个互斥量，并在构造时对该互斥量进行加锁操作。在析构时，lock_guard会自动对互斥量进行解锁操作。lock_guard的使用方式更简洁，但只能管理单个互斥量。


### Misc


读写锁
```cpp
/**
 * @file rwlock.cpp
 * @author Abigale Kim (abigalek)
 * @brief C++ STL std::shared_lock 和 std::unique_lock 的教程代码
 * (特别是将它们用作读写锁)
 */

// 虽然C++没有专门的读写锁库，但可以使用 std::shared_mutex、std::shared_lock 和 std::unique_lock 库来模拟一个。
// 这个程序展示了如何使用它们作为读写锁的简单示例。

// std::shared_mutex 是一种允许共享只读锁和独占写锁的互斥锁。std::shared_lock 可以用作 RAII 风格的读锁，
// std::unique_lock 可以用作 RAII 风格的写锁。scoped_lock.cpp 中介绍了 C++ 中的 RAII 风格锁定。

// 如果你更愿意回顾读写锁的概念和读写器问题，可以参考这里的 15-213/513/613 讲义:
// https://www.cs.cmu.edu/afs/cs/academic/class/15213-s23/www/lectures/25-sync-advanced.pdf

// 包含 std::cout（打印）仅用于演示目的。
#include <iostream>
// 包含互斥锁库头文件。
#include <mutex>
// 包含共享互斥锁库头文件。
#include <shared_mutex>
// 包含线程库头文件。
#include <thread>

// 定义一个全局 count 变量和一个共享互斥锁，供所有线程使用。
// std::shared_mutex 是一种允许共享锁定和独占锁定的互斥锁。
int count = 0;
std::shared_mutex m;

// 这个函数使用 std::shared_lock（相当于读锁）来获取只读的共享访问 count 变量，并读取 count 变量的值。
void read_value() {
  std::shared_lock lk(m);
  std::cout << "Reading value " + std::to_string(count) + "\n" << std::flush;
}

// 这个函数使用 std::unique_lock（相当于写锁）来获取独占访问 count 变量，并修改其值。
void write_value() {
  std::unique_lock lk(m);
  count += 3;
}

// 主函数创建了六个线程对象，其中两个线程运行 write_value 函数，四个线程运行 read_value 函数，所有线程并行运行。
// 这意味着输出是不确定的，取决于哪个线程首先获取锁。运行程序几次，看看能否获得不同的输出。
int main() {
  std::thread t1(read_value);
  std::thread t2(write_value);
  std::thread t3(read_value);
  std::thread t4(read_value);
  std::thread t5(write_value);
  std::thread t6(read_value);

  t1.join();
  t2.join();
  t3.join();
  t4.join();
  t5.join();
  t6.join();

  return 0;
}
// 输出结果显然不同
```




## 左值、右值

### T&（左值引用）

- `T&` 表示一个对类型 `T` 的左值引用，你可以用它来引用长期存在的对象。
- 你可以通过 `T&` 修改它所引用的对象（除非它引用的是一个 const 对象）。

### const T&（常量左值引用）

- `const T&` 表示对类型 `T` 的常量左值引用。使用它表示你不打算修改通过这个引用访问的数据。
- 它可以引用 const 或非 const 对象，临时对象，甚至是字面值。
- 常用于函数参数，来表明函数不会修改传入的参数，并且能够接受临时对象作为参数。

### T&&（右值引用）

- `T&&` 表示对类型 `T` 的右值引用。它通常用于实现移动语义和完美转发。
- 右值引用可以绑定到即将被销毁的对象（也就是右值），从而允许你安全地从它们那里“窃取”资源。
- 右值引用本身是一个左值，除非它被 `std::move` 转换为右值。

### const T&&（常量右值引用）

- `const T&&` 是一个相对罕见的类型，它表示对一个常量右值的引用。
- 这种类型的使用频率很低，因为右值引用的主要用途是为了移动对象（也就是说，从源对象中移动资源，而不是复制），而对于常量对象，你通常不会去移动它，而是去复制它。
- 一些模板编程场景可能会遇到 `const T&&`，但在日常使用中你通常不需要它。

在函数的参数中，这些不同类型的引用通常有以下用途：

- **`T&`**
    - 用于需要修改传入对象的函数。
    - 无法接受临时对象、字面值或返回临时对象的表达式作为参数。

- **`const T&`**
    - 用于不需要修改传入对象的函数。
    - 可以接受任何类型的对象，包括临时对象。
    - 常用于读取数据而不改变数据的场景。

- **`T&&`**
    - 用于需要移动资源的函数（例如，将资源从一个对象移动到另一个对象）。
    - 接受一个临时对象作为参数，允许函数改变其值。

- **`const T&&`**
    - 极少使用，通常只在模板编程或者特定的重载解析场景中见到。
    - 通常，你想要移动的对象不应是 const 的，因为移动涉及到改变对象的状态。