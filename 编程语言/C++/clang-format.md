# clang-format & clang-tidy


>相关 [GitHub - VS Code C++项目模板](https://github.com/Codesire-Deng/TemplateRepoCxx)


## clang-format

`.clang-format`


```
BasedOnStyle: LLVM
IndentWidth: 4
TabWidth: 4
Language: Cpp
AlignAfterOpenBracket: AlwaysBreak # BlockIndent
AlignConsecutiveBitFields: true
AlignConsecutiveMacros: true
AlignEscapedNewlines: Left
AlignOperands: true
AlignTrailingComments: true
AllowAllArgumentsOnNextLine: true
AllowAllConstructorInitializersOnNextLine: true
AllowAllParametersOfDeclarationOnNextLine: true
AllowShortBlocksOnASingleLine: Always
AllowShortCaseLabelsOnASingleLine: false
AllowShortEnumsOnASingleLine: true
AllowShortFunctionsOnASingleLine: InlineOnly
AllowShortIfStatementsOnASingleLine: Always
AllowShortLambdasOnASingleLine: Inline
AllowShortLoopsOnASingleLine: true
AlwaysBreakBeforeMultilineStrings: false
AlwaysBreakTemplateDeclarations: Yes
BinPackArguments: true
BinPackParameters: false
BreakBeforeBinaryOperators: NonAssignment
BreakBeforeBraces: Attach
BreakBeforeConceptDeclarations: true
BreakBeforeTernaryOperators: true
BreakConstructorInitializers: BeforeComma
BreakInheritanceList: BeforeComma
BreakStringLiterals: false
ColumnLimit: 80
CompactNamespaces: false
ConstructorInitializerAllOnOneLineOrOnePerLine: true
ConstructorInitializerIndentWidth: 4
ContinuationIndentWidth: 4
Cpp11BracedListStyle: true
EmptyLineBeforeAccessModifier: Always
FixNamespaceComments: true
IndentCaseLabels: true
IndentExternBlock: Indent
IndentGotoLabels: true
IndentPPDirectives: None
# IndentPragmas: false
IndentRequires: true
IndentWrappedFunctionNames: false
KeepEmptyLinesAtTheStartOfBlocks: false
MaxEmptyLinesToKeep: 1
NamespaceIndentation: Inner
PointerAlignment: Right
ReflowComments: true
# RequiresClausePosition: OwnLine
ShortNamespaceLines: 5
SortIncludes:    false
SortUsingDeclarations: false
SpaceAfterCStyleCast: false
SpaceAfterLogicalNot: false
SpaceAfterTemplateKeyword: false
SpaceBeforeAssignmentOperators: true
SpaceBeforeCpp11BracedList: false
SpaceBeforeCtorInitializerColon: true
SpaceBeforeInheritanceColon: true
SpaceBeforeParens: ControlStatements
SpaceBeforeRangeBasedForLoopColon: true
SpaceBeforeSquareBrackets: false
SpaceInEmptyBlock: false
SpaceInEmptyParentheses: false
SpacesBeforeTrailingComments: 1
SpacesInAngles:  false
SpacesInCStyleCastParentheses: false
SpacesInConditionalStatement: false
SpacesInContainerLiterals: true
SpacesInParentheses: false
SpacesInSquareBrackets: false
Standard: Latest
UseCRLF:         false
UseTab:          Never
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