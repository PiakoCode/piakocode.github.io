# clang-format & clang-tidy


>相关 [GitHub - VS Code C++项目模板](https://github.com/Codesire-Deng/TemplateRepoCxx)


## clang-format

`.clang-format`


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