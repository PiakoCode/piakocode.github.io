# clang-format

`.clang-format`


```
BasedOnStyle: LLVM 
UseTab: Never 
IndentWidth: 4 
TabWidth: 4 
BreakBeforeBraces: Allman 
AllowShortIfStatementsOnASingleLine: false 
IndentCaseLabels: false 
ColumnLimit: 0 
AccessModifierOffset: -4
NamespaceIndentation: All
FixNamespaceComments: false
```

```
Language: Cpp
BasedOnStyle: WebKit
```

```
Language: Cpp
BasedOnStyle: Microsoft
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