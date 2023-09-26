# C++

#基础
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


## Template 模板

```
template <typename T>
void func(T value)
{
    
}
```

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