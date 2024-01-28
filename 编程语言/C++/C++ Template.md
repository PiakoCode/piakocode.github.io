---
C++:
---

```cpp
#include <iostream>

using namespace std;

template <typename T>
void my_swap(T &a, T &b) // 非优先调用
{
    auto temp = a;
    a = b;
    b = temp;
}
template <typename T, typename U>
void my_swap(T &a, U &b)
{
    auto temp = a;
    a = b;
    b = temp;
}

void my_swap(int &a, int &b) // 优先调用
{
    cout << "YYY" << endl;
    auto temp = a;
    a = b;
    b = temp;
}

int main()
{
    int aa = 1;
    int bb = 2;
    my_swap(aa, bb); // 调用int
    cout << aa << " " << bb << endl;

    double a = 1;
    float b = 2.1;
    my_swap(a, b);
    cout << a << " " << b << endl;
    return 0;
}
```

```
YYY
21
2.1 1
```

模版函数不支持隐式转换，必须匹配
当函数重载与模版函数冲突时，优先调用普通函数



**C++20**

模板约束

```cpp
#include <iostream>
#include <type_traits>


// C++ 17 之前

template<typename T,typename = std::enable_if<std::is_integralv<T>>>
void f(T a){
    std::cout<<a<<std::endl;
}


// C++ 17

template<typename T,typename = std::enable_if_t<std::is_integral_v<T>>>
void f(T a){
    std::cout<<a<<std::endl;
}

// 以下为C++ 20 支持

template<typename T>
    requires std::is_same_v<T, int>
void f2(T){}


// template <typename T>
// concept have_func=requires{T::func; }; // 要求拥有成员变量

template <typename T>
concept have_func = requires(T t) {t.func; t.f();};

template <typename T>
concept Int = std::is_same_v<T, int>;


void f3(have_func auto a) { // 简写模板函数
    // do nothing
}

template <typename Int>
void f4(Int a) {

}

template <typename T>
    requires requires (T t) {t.func; t.f();}
struct Y{};

int main() {
    f(1);
    //f(1.0);
    f('c');
    f(1l);
    f2(1);
    //f2(1l);
    
    struct X{int func; void f();};
    f3(X{});

    Int auto r = 1;

    f4(1);
    f4(1l);
}
```