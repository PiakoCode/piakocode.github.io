# CMake


[GitHub - ttroy50/cmake-examples: Useful CMake Examples](https://github.com/ttroy50/cmake-examples)

CMake项目的配置文件：`CMakeLists.txt`



`cmake .`

执行后的结构

```
.
├── CMakeCache.txt
├── CMakeFiles
├── cmake_install.cmake
├── CMakeLists.txt
├── main.cpp
└── Makefile
```

再执行`make`，生成可执行文件



由于文件太多，所以通常单独创建一个`build`文件夹，在这个文件夹下执行`cmake ..`

执行后的结构

```
.
├── build
│   ├── CMakeCache.txt
│   ├── CMakeFiles
│   ├── cmake_install.cmake
│   └── Makefile
├── CMakeLists.txt
└── main.cpp
```


## CMakeLists 文件


基本
```cmake
# CMake 最低版本号要求
cmake_minimum_required(VERSION 3.25)

# 项目信息
project(hello)

# 设置C++标准
set(CMAKE_CXX_STANDARD 20

# 指定生成目标
add_executable(hello main.cpp)
```


### 同一目录，多个源文件

```
.
├── main.cpp
├── String.cpp
└── String.hpp
```

```cmake
cmake_minimum_required(VERSION 3.10)

set(CMAKE_CXX_STANDARD 17) # 设置C++版本

project(hello)

add_executable(hello main.cpp String.cpp)
```

自动查找指定目录下的源文件

```cmake
cmake_minimum_required(VERSION 3.10)

project(hello)

aux_source_directory(. DIR_SRCS) # 自动寻找保存'./'中的源文件名到DIR_SRCS变量中

add_executable(hello ${DIR_SRCS}) # 生成指定目标
```


### 多个目录。多个源文件

```
.
├── main.cpp
└── String
    ├── String.cpp
    └── String.hpp
```

对于这种情况，需要分别在根目录和`String`目录中各自再编写一个CMakeLists.txt文件

为了方便，我们可以先将 `String` 目录里的文件编译成静态库再由 main 函数调用

根目录中的CMakeLists.txt

```cmake
aux_source_directory(. DIR_LIB_SRCS)

# 生成链接库
add_library(StringFunctions ${DIR_LIB_SRCS})
```

CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.10)

project(hello)

set(CMAKE_C_STANDARD 17) # 设置C语言版本
set(CMAKE_CXX_STANDARD 17) # 设置C++版本


aux_source_directory(. DIR_SRCS)

# 添加String子目录
add_subdirectory(String)

add_executable(hello main.cpp)

# 添加链接库
target_link_libraries(hello StringFunctions)
```



### 为每个cpp文件进行单独编译

```cmake
# 设置CMake的最小版本要求
cmake_minimum_required(VERSION 3.10)

# 设置项目名称
project(SingleFileExecutables)

# 获取当前目录下所有的.cpp文件
file(GLOB APP_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.cpp)

# 遍历所有的.cpp文件
foreach(testsourcefile ${APP_SOURCES})
    # 获取单个文件的文件名，不包含扩展名
    get_filename_component(testname ${testsourcefile} NAME_WE)
    
    # 添加一个可执行文件的构建目标
    add_executable(${testname} ${testsourcefile})

    # 如果你的项目有特定的编译选项或需要链接额外的库
    # 可以在此处设置这些属性。
    # target_compile_options(${testname} PRIVATE -Wall -O2)
    # target_link_libraries(${testname} your_libraries_here)

endforeach(testsourcefile ${APP_SOURCES})

```

## 其他

```
.
├── CMakeLists.txt
├── main.cpp
├── mandel.cpp
├── mandel.h
├── rainbow.cpp
├── rainbow.h
├── README.md
└── stbiw
    ├── CMakeLists.txt <------- this file
    ├── stb_image_write.cpp
    └── stb_image_write.h

```


```cmake
add_library(stbiw STATIC stb_image_write.cpp)
target_include_directories(stbiw PUBLIC .)
```

stb_image_write.cpp

```cpp
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
```


`add_library(stbiw STATIC stb_image_write.cpp)`:
add_library 是一个CMake命令，用于将一个库添加到项目中。
stbiw 是库的名称，你可以根据需要更改它。
STATIC 指定库的类型，这里是一个静态库。静态库在链接时会被整体地链接到可执行文件中。
stb_image_write.cpp 是库的源代码文件，它将被编译并链接到最终的库中。

`target_include_directories(stbiw PUBLIC .)`:
target_include_directories 是用于向目标（在这里是库 stbiw）添加包含目录的命令。
stbiw 是目标的名称，你可以根据实际情况修改。
PUBLIC 表示这些包含目录将被添加到库的接口（即公共头文件）中，以便其他使用该库的目标也可以访问这些头文件。
. 是当前目录的路径，这里指定将当前目录包含到 stbiw 库的接口中，使得在使用该库的其他目标中可以直接包含 #include 声明指向当前目录的头文件。
这两行代码一起完成了将 stb_image_write.cpp 编译成一个静态库 stbiw，并将该库的包含目录设置为当前目录。这样，其他项目或目标可以使用 stbiw 库，并通过 #include 指令包含库中的头文件。


---

`include_directories`

```cmake
# 添加 include 目录作为包含目录
include_directories(include)

add_executable(hello src/test.c)
```

```shell
# 结构
.
├── CMakeLists.txt
├── include
│   └── test.h
└── src
    └── test.c
```

```c
#include "test.h" // 实现效果
#include <stdio.h>

int main() {
    int a = add(2, 3);
}
```





**编译选项**

```cmake
# 在这里添加你的项目配置

# 添加 -ffast-math 编译选项
add_executable(your_target source1.cpp source2.cpp)
target_compile_options(your_target PRIVATE -ffast-math) # 使用`-ffast-math`可能会导致一些数学计算的不确定性

```


```cmake
add_compile_options(-fcoroutines)
```
## vscode + cmake命令行参数debug

1. 在.vscode文件夹里新建一个`settings.json`
2. 粘贴以下参数

```json
{
    "cmake.debugConfig": {
        "args": [
            "-code",
            "8"
        ]
    }
}
```

就相当于命令行参数 -code 8


## CMake静态编译

```cmake
set(CMAKE_EXE_LINKER_FLAGS "-static")
```



---


## 常用代码

`set` 设置环境变量

```cmake
# 设置C++标准
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS True)
```

`include_directories`

```cmake
# 设置头文件目录
include_directories("${CMAKE_SOURCE_DIR}/src/include")
include_directories("${CMAKE_SOURCE_DIR}/third_party/gtest/googletest/include")
```

`add_subdirectory` 添加子目录

```cmake
add_subdirectory(src)
add_subdirectory(test)
add_subdirectory("${CMAKE_SOURCE_DIR}/third_party/gtest")
```


`aux_source_directory` 自动寻找、添加源代码

```cmake
aux_source_directory(. DIR_SRCS)
```

