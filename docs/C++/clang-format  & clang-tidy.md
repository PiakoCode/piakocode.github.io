# clang-format & clang-tidy


>相关 [GitHub - VS Code C++项目模板](https://github.com/Codesire-Deng/TemplateRepoCxx)


## clang-format

`.clang-format`


```
# 基于LLVM
BasedOnStyle: LLVM

# 设置缩进是 4 空格
IndentWidth: 4 

# 使用空格
UseTab: Never

# 设置访问修饰符（public、private、protected）的偏移量为-4，使得与class对其
AccessModifierOffset: -4  

# 允许排序#include
SortIncludes: false

# 指针和引用的对齐: Left, Right, Middle
PointerAlignment: Left

# 允许重新排版注释
ReflowComments: true

# 对齐连续的尾随的注释
AlignTrailingComments: true

# 连续声明时，对齐所有声明的变量名
AlignConsecutiveDeclarations: true

# 总是在template声明后换行
AlwaysBreakTemplateDeclarations: true

# 连续空行的最大数量
MaxEmptyLinesToKeep: 1

```

```
# 基于LLVM
BasedOnStyle: LLVM

# 设置缩进是 4 空格
IndentWidth: 4 

# 使用空格
UseTab: Never

# 设置访问修饰符（public、private、protected）的偏移量为-4，使得与class对其
AccessModifierOffset: -4  

# 允许排序#include
SortIncludes: false

# 指针和引用的对齐: Left, Right, Middle
PointerAlignment: Left


# 允许重新排版注释
ReflowComments: true

# 对齐连续的尾随的注释
AlignTrailingComments: true

ColumnLimit: 120

# 设置初始化的
Cpp11BracedListStyle: false
SpaceBeforeCpp11BracedList: true
```

```
BasedOnStyle: LLVM
IndentWidth: 4
TabWidth: 4
Language: Cpp
```

```
Language: Cpp
BasedOnStyle: WebKit
```

```
Language: Cpp
BasedOnStyle: Microsoft
```

```
BasedOnStyle: Google
DerivePointerAlignment: false
PointerAlignment: Right
ColumnLimit: 120
IncludeBlocks: Preserve
```


```
# 语言: None, Cpp, Java, JavaScript, ObjC, Proto, TableGen, TextProto
Language: Cpp
# BasedOnStyle:	LLVM

# 访问说明符(public、private等)的偏移
AccessModifierOffset: -4

# 开括号(开圆括号、开尖括号、开方括号)后的对齐: Align, DontAlign, AlwaysBreak(总是在开括号后换行)
AlignAfterOpenBracket: Align

# 连续赋值时，对齐所有等号
AlignConsecutiveAssignments: false

# 连续声明时，对齐所有声明的变量名
AlignConsecutiveDeclarations: false

# 右对齐逃脱换行(使用反斜杠换行)的反斜杠
AlignEscapedNewlines: Right

# 水平对齐二元和三元表达式的操作数
AlignOperands: true

# 对齐连续的尾随的注释
AlignTrailingComments: true

# 不允许函数声明的所有参数在放在下一行
AllowAllParametersOfDeclarationOnNextLine: false

# 不允许短的块放在同一行
AllowShortBlocksOnASingleLine: true

# 允许短的case标签放在同一行
AllowShortCaseLabelsOnASingleLine: true

# 允许短的函数放在同一行: None, InlineOnly(定义在类中), Empty(空函数), Inline(定义在类中，空函数), All
AllowShortFunctionsOnASingleLine: None

# 允许短的if语句保持在同一行
AllowShortIfStatementsOnASingleLine: true

# 允许短的循环保持在同一行
AllowShortLoopsOnASingleLine: true

# 总是在返回类型后换行: None, All, TopLevel(顶级函数，不包括在类中的函数), 
# AllDefinitions(所有的定义，不包括声明), TopLevelDefinitions(所有的顶级函数的定义)
AlwaysBreakAfterReturnType: None

# 总是在多行string字面量前换行
AlwaysBreakBeforeMultilineStrings: false

# 总是在template声明后换行
AlwaysBreakTemplateDeclarations: true

# false表示函数实参要么都在同一行，要么都各自一行
BinPackArguments: true

# false表示所有形参要么都在同一行，要么都各自一行
BinPackParameters: true

# 大括号换行，只有当BreakBeforeBraces设置为Custom时才有效
BraceWrapping:
  # class定义后面
  AfterClass: false
  # 控制语句后面
  AfterControlStatement: false
  # enum定义后面
  AfterEnum: false
  # 函数定义后面
  AfterFunction: false
  # 命名空间定义后面
  AfterNamespace: false
  # struct定义后面
  AfterStruct: false
  # union定义后面
  AfterUnion: false
  # extern之后
  AfterExternBlock: false
  # catch之前
  BeforeCatch: false
  # else之前
  BeforeElse: false
  # 缩进大括号
  IndentBraces: false
  # 分离空函数
  SplitEmptyFunction: false
  # 分离空语句
  SplitEmptyRecord: false
  # 分离空命名空间
  SplitEmptyNamespace: false

# 在二元运算符前换行: None(在操作符后换行), NonAssignment(在非赋值的操作符前换行), All(在操作符前换行)
BreakBeforeBinaryOperators: NonAssignment

# 在大括号前换行: Attach(始终将大括号附加到周围的上下文), Linux(除函数、命名空间和类定义，与Attach类似), 
#   Mozilla(除枚举、函数、记录定义，与Attach类似), Stroustrup(除函数定义、catch、else，与Attach类似), 
#   Allman(总是在大括号前换行), GNU(总是在大括号前换行，并对于控制语句的大括号增加额外的缩进), WebKit(在函数前换行), Custom
#   注：这里认为语句块也属于函数
BreakBeforeBraces: Custom

# 在三元运算符前换行
BreakBeforeTernaryOperators: false

# 在构造函数的初始化列表的冒号后换行
BreakConstructorInitializers: AfterColon

#BreakInheritanceList: AfterColon

BreakStringLiterals: false

# 每行字符的限制，0表示没有限制
ColumnLimit: 0

CompactNamespaces: true

# 构造函数的初始化列表要么都在同一行，要么都各自一行
ConstructorInitializerAllOnOneLineOrOnePerLine: false

# 构造函数的初始化列表的缩进宽度
ConstructorInitializerIndentWidth: 4

# 延续的行的缩进宽度
ContinuationIndentWidth: 4

# 去除C++11的列表初始化的大括号{后和}前的空格
Cpp11BracedListStyle: true

# 继承最常用的指针和引用的对齐方式
DerivePointerAlignment: false

# 固定命名空间注释
FixNamespaceComments: true

# 缩进case标签
IndentCaseLabels: false

IndentPPDirectives: None

# 缩进宽度
IndentWidth: 4

# 函数返回类型换行时，缩进函数声明或函数定义的函数名
IndentWrappedFunctionNames: false

# 保留在块开始处的空行
KeepEmptyLinesAtTheStartOfBlocks: false

# 连续空行的最大数量
MaxEmptyLinesToKeep: 1

# 命名空间的缩进: None, Inner(缩进嵌套的命名空间中的内容), All
NamespaceIndentation: None

# 指针和引用的对齐: Left, Right, Middle
PointerAlignment: Right

# 允许重新排版注释
ReflowComments: true

# 允许排序#include
SortIncludes: false

# 允许排序 using 声明
SortUsingDeclarations: false

# 在C风格类型转换后添加空格
SpaceAfterCStyleCast: false

# 在Template 关键字后面添加空格
SpaceAfterTemplateKeyword: true

# 在赋值运算符之前添加空格
SpaceBeforeAssignmentOperators: true

# SpaceBeforeCpp11BracedList: true

# SpaceBeforeCtorInitializerColon: true

# SpaceBeforeInheritanceColon: true

# 开圆括号之前添加一个空格: Never, ControlStatements, Always
SpaceBeforeParens: ControlStatements

# SpaceBeforeRangeBasedForLoopColon: true

# 在空的圆括号中添加空格
SpaceInEmptyParentheses: false

# 在尾随的评论前添加的空格数(只适用于//)
SpacesBeforeTrailingComments: 1

# 在尖括号的<后和>前添加空格
SpacesInAngles: false

# 在C风格类型转换的括号中添加空格
SpacesInCStyleCastParentheses: false

# 在容器(ObjC和JavaScript的数组和字典等)字面量中添加空格
SpacesInContainerLiterals: true

# 在圆括号的(后和)前添加空格
SpacesInParentheses: false

# 在方括号的[后和]前添加空格，lamda表达式和未指明大小的数组的声明不受影响
SpacesInSquareBrackets: false

# 标准: Cpp03, Cpp11, Auto
Standard: Cpp11

# tab宽度
TabWidth: 4

# 使用tab字符: Never, ForIndentation, ForContinuationAndIndentation, Always
UseTab: Never
```


BasedOnStyle

```
LLVM, Google, Chromium, Mozilla, WebKit, Microsoft
```


快速生成`.clang-format`文件

```
clang-format -style=llvm -dump-config > .clang-format
```

```
clang-format -style=Microsoft -dump-config > .clang-format
```

```
clang-format -style=Google -dump-config > .clang-format
```


## clang-tidy

`.clang-tidy`

```
---
Checks:    "bugprone-*,\
            cert-*,\
            clang-analyzer-*,\
            concurrency-*,\
            google-*,\
            llvm-*,\
            misc-*,\
            modernize-*,\
            portability-*,\
            performance-*,\
            readability-*,\
            -bugprone-easily-swappable-parameters,\
            -bugprone-reserved-identifier,\
            -cert-dcl51-cpp,\
            -cert-dcl37-c,\
            -readability-magic-numbers,\
            -readability-identifier-length,\
            -readability-implicit-bool-conversion,\
            -readability-isolate-declaration,\
            -readability-static-accessed-through-instance,\
            -readability-redundant-access-specifiers,\
            -google-build-using-namespace,\
            -google-readability-casting,\
            -google-readability-todo,\
            -modernize-avoid-c-arrays,\
            -modernize-use-trailing-return-type,\
            -misc-non-private-member-variables-in-classes"
WarningsAsErrors:   '-*'
HeaderFilterRegex: '^.*\.hpp$'
FormatStyle: file
AnalyzeTemporaryDtors: false
# check https://clang.llvm.org/extra/clang-tidy/checks/readability/identifier-naming.html
CheckOptions:
  - key:             readability-identifier-naming.ClassCase
    value:           aNy_CasE
  - key:             readability-identifier-naming.ClassConstantCase
    value:           aNy_CasE
  - key:             readability-identifier-naming.ClassConstantPrefix
    value:           ''
  - key:             readability-identifier-naming.EnumCase
    value:           aNy_CasE
  - key:             readability-identifier-naming.EnumConstantCase
    value:           aNy_CasE
  - key:             readability-identifier-naming.FunctionCase
    value:           aNy_CasE
  - key:             readability-identifier-naming.GlobalConstantCase
    value:           aNy_CasE
  - key:             readability-identifier-naming.MemberCase
    value:           aNy_CasE
  - key:             readability-identifier-naming.NamespaceCase
    value:           aNy_CasE
  - key:             readability-identifier-naming.PublicMemberSuffix
    value:           ''
  - key:             readability-identifier-naming.PrivateMemberSuffix
    value:           ''
  - key:             readability-identifier-naming.ProtectedMemberSuffix
    value:           ''
  - key:             readability-identifier-naming.MethodCase
    value:           aNy_CasE
  - key:             readability-identifier-naming.ParameterCase
    value:           aNy_CasE
  - key:             readability-identifier-naming.VariableCase
    value:           aNy_CasE
```

```
---
Checks:     '
            bugprone-*,
            clang-analyzer-*,
            google-*,
            modernize-*,
            performance-*,
            portability-*,
            readability-*,
            -bugprone-easily-swappable-parameters,
            -bugprone-implicit-widening-of-multiplication-result,
            -bugprone-narrowing-conversions,
            -bugprone-reserved-identifier,
            -bugprone-signed-char-misuse,
            -bugprone-suspicious-include,
            -bugprone-unhandled-self-assignment,
            -clang-analyzer-cplusplus.NewDelete,
            -clang-analyzer-cplusplus.NewDeleteLeaks,
            -clang-analyzer-security.insecureAPI.rand,
            -clang-diagnostic-implicit-int-float-conversion,
            -google-readability-avoid-underscore-in-googletest-name,
            -modernize-avoid-c-arrays,
            -modernize-use-nodiscard,
            -readability-convert-member-functions-to-static,
            -readability-identifier-length,
            -readability-function-cognitive-complexity,
            -readability-magic-numbers,
            -readability-make-member-function-const,
            -readability-qualified-auto,
            -readability-redundant-access-specifiers,
            -bugprone-exception-escape,
            '
CheckOptions:
  - { key: readability-identifier-naming.ClassCase,           value: CamelCase  }
  - { key: readability-identifier-naming.EnumCase,            value: CamelCase  }
  - { key: readability-identifier-naming.FunctionCase,        value: CamelCase  }
  - { key: readability-identifier-naming.GlobalConstantCase,  value: UPPER_CASE }
  - { key: readability-identifier-naming.MemberCase,          value: lower_case }
  - { key: readability-identifier-naming.MemberSuffix,        value: _          }
  - { key: readability-identifier-naming.NamespaceCase,       value: lower_case }
  - { key: readability-identifier-naming.StructCase,          value: CamelCase  }
  - { key: readability-identifier-naming.UnionCase,           value: CamelCase  }
  - { key: readability-identifier-naming.VariableCase,        value: lower_case }
WarningsAsErrors: '*'
HeaderFilterRegex: '/(src|test)/include'
AnalyzeTemporaryDtors: true
```


## My clang-format & clang-tidy file

`.clang-format`

```
# 基于LLVM
BasedOnStyle: LLVM

# 设置缩进是 4 空格
IndentWidth: 4 

# 使用空格
UseTab: Never

# 设置访问修饰符（public、private、protected）的偏移量为-4，使得与class对其
AccessModifierOffset: -4  
```


```
# 基于LLVM
BasedOnStyle: LLVM

# 设置缩进是 4 空格
IndentWidth: 4

# 使用空格
UseTab: Never

AccessModifierOffset: -4

# 允许排序#include
SortIncludes: false

# 指针和引用的对齐: Left, Right, Middle
PointerAlignment: Right

# 允许重新排版注释
ReflowComments: true

# 对齐连续的尾随的注释
AlignTrailingComments: true

# 总是在template声明后换行
AlwaysBreakTemplateDeclarations: true

# 连续空行的最大数量
MaxEmptyLinesToKeep: 1

# false表示函数实参要么都在同一行，要么都各自一行
BinPackArguments: false

# false表示所有形参要么都在同一行，要么都各自一行
BinPackParameters: true
```


`.clang-tidy`

```
---
Checks: "bugprone-*,\
  cert-*,\
  clang-analyzer-*,\
  concurrency-*,\
  google-*,\
  llvm-*,\
  misc-*,\
  modernize-*,\
  portability-*,\
  performance-*,\
  readability-*,\
  -bugprone-easily-swappable-parameters,\
  -bugprone-reserved-identifier,\
  -cert-dcl51-cpp,\
  -cert-dcl37-c,\
  -readability-magic-numbers,\
  -readability-identifier-length,\
  -readability-implicit-bool-conversion,\
  -readability-isolate-declaration,\
  -readability-static-accessed-through-instance,\
  -readability-redundant-access-specifiers,\
  -google-build-using-namespace,\
  -google-readability-casting,\
  -google-readability-todo,\
  -modernize-avoid-c-arrays,\
  -modernize-use-trailing-return-type,\
  -misc-non-private-member-variables-in-classes"
WarningsAsErrors: "-*"
HeaderFilterRegex: '.*'
FormatStyle: file
AnalyzeTemporaryDtors: false
# check https://clang.llvm.org/extra/clang-tidy/checks/readability/identifier-naming.html
CheckOptions:
  - key: readability-identifier-naming.ClassCase
    value: aNy_CasE
  - key: readability-identifier-naming.ClassConstantCase
    value: aNy_CasE
  - key: readability-identifier-naming.ClassConstantPrefix
    value: ""
  - key: readability-identifier-naming.EnumCase
    value: aNy_CasE
  - key: readability-identifier-naming.EnumConstantCase
    value: aNy_CasE
  - key: readability-identifier-naming.FunctionCase
    value: aNy_CasE
  - key: readability-identifier-naming.GlobalConstantCase
    value: aNy_CasE
  - key: readability-identifier-naming.MemberCase
    value: aNy_CasE
  - key: readability-identifier-naming.NamespaceCase
    value: aNy_CasE
  - key: readability-identifier-naming.PublicMemberSuffix
    value: ""
  - key: readability-identifier-naming.PrivateMemberSuffix
    value: ""
  - key: readability-identifier-naming.ProtectedMemberSuffix
    value: ""
  - key: readability-identifier-naming.MethodCase
    value: aNy_CasE
  - key: readability-identifier-naming.ParameterCase
    value: aNy_CasE
  - key: readability-identifier-naming.VariableCase
    value: aNy_CasE
```