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
cmake_minimum_required(VERSION 3.10)

# 项目信息
project(hello)

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