# GTest

使用GTest对C++进行测试

## 安装

Archlinux

```
sudo pacman -S gtest
```

## 基础

```cmake
cmake_minimum_required(VERSION 3.26)
project(review)

set(CMAKE_CXX_STANDARD 17)

enable_testing() # 启用了测试功能

add_executable(review main.cpp)


include(FetchContent) # 引入了 CMake 的 FetchContent 模块，用于下载和管理依赖项
FetchContent_Declare( # 定义了一个名为 "googletest" 的依赖项，并指定了它的下载地址
  googletest
  URL https://github.com/google/googletest/archive/03597a01ee50ed33e9dfd640b249b4be3799d395.zip
)

target_link_libraries( # "review" 可执行文件与 GTest 的主程序库（gtest_main）进行链接，以便在测试中  
使用 GTest。
    review
    GTest::gtest_main
)


set(gtest_force_shared_crt ON CACHE BOOL "" FORCE) # 设置了 GTest 的一个选项，用于兼容 Windows 平台
FetchContent_MakeAvailable(googletest) # 从下载的依赖项中生成目标（这里是 GTest），以便在项目中使用。
```

```cpp
#include <cstdlib>
#include <gtest/gtest.h>

// 静态断言在测试的时候不会将程序中断
long long fact(int n)
{
    long long result = 1;
    for (int i = 1; i <= n; i++) result = result * i;
    return result;
}

TEST(first_group, negtive)  // TEST可以直接进行分组测试，然后通过断言来生成其测试结果
{
  EXPECT_EQ(1, fact(-5));
  EXPECT_EQ(1, fact(-1));
  EXPECT_GT(fact(-10), 0);
}

TEST(first_group, zero)
{
  EXPECT_EQ(1, fact(0));
}

TEST(first_group, Positive) 
{
  EXPECT_EQ(1, fact(1));
  EXPECT_EQ(2, fact(2));
  EXPECT_EQ(6, fact(3));
  EXPECT_EQ(40320, fact(8));
}
// 错误信息
TEST(failure_froup, first)
{
    EXPECT_EQ(1, fact(2));
}

int main()
{
    // static_assert(1 == 2); // 会将程序直接终止 静态断言，完全没有对程序运行期之间的消耗。
    EXPECT_EQ(1, 2); // 这个不会，但是会得到错误信息
    testing::InitGoogleTest();
    return RUN_ALL_TESTS();
}
```

```
Expected equality of these values:
  1
  2
[==========] Running 4 tests from 2 test suites.
[----------] Global test environment set-up.
[----------] 3 tests from first_group
[ RUN      ] first_group.negtive
[       OK ] first_group.negtive (0 ms)
[ RUN      ] first_group.zero
[       OK ] first_group.zero (0 ms)
[ RUN      ] first_group.Positive
[       OK ] first_group.Positive (0 ms)
[----------] 3 tests from first_group (0 ms total)

[----------] 1 test from failure_froup
[ RUN      ] failure_froup.first
/home/Piako/code/c++/review/main.cpp:34: Failure
Expected equality of these values:
  1
  fact(2)
    Which is: 2
[  FAILED  ] failure_froup.first (0 ms)
[----------] 1 test from failure_froup (0 ms total)

[----------] Global test environment tear-down
[==========] 4 tests from 2 test suites ran. (0 ms total)
[  PASSED  ] 3 tests.
[  FAILED  ] 1 test, listed below:
[  FAILED  ] failure_froup.first

 1 FAILED TEST
```