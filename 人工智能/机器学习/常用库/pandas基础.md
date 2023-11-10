# pandas 基础

#pandas #python #基础

相关内容：[matplotlib](常用库/matplotlib/matplotlib.md), [numpy](常用库/numpy.md), [sklearn 入门](常用库/sklearn/sklearn%20入门.md), [机器学习](机器学习.md)


## pandas 基本数据类型

- Series：一维数组，类似于带有标签的一维数组，可以存储任意类型的数据。
- DataFrame：二维表格，类似于Excel表格或SQL表，是最常用的pandas数据结构，可以存储不同类型的数据。
- Index：索引，类似于数据库表中的主键，用于标识数据。
- DateTime：日期和时间类型，用于处理时间序列数据。
- Timedelta：时间差类型，用于计算时间间隔。
- Categorical：分类类型，用于存储分类数据，可以提高计算效率。
- Sparse：稀疏类型，用于存储稀疏数据，可以节省内存空间。
###  Series

```python
import pandas as pd

data = [1, 2, 3, 4, 5]
s = pd.Series(data = None, index = None, dtype = None)
s = pd.Series(data，index= [2,3,4,5,1])
```

```
# 运行结果
2    1
3    2
4    3
5    4
1    5
dtype: int64
```

- 通过字典数据进行创建

```python
import pandas as pd

# 创建一个字典
data = {'a': 10, 'b': 20, 'c': 30}

# 通过字典创建Series
series = pd.Series(data)

print(series)
```

输出：

```
a    10
b    20
c    30
dtype: int64
```

Series对象具有以下属性：

1. `index`：Series对象的索引，用于标识每个数据点。
2. `values`：Series对象的实际数据值，以NumPy数组的形式存储。
3. `name`：Series对象的名称。
4. `dtype`：Series对象中数据的数据类型。
5. `size`：Series对象中数据的数量。
6. `shape`：Series对象的维度，以元组形式表示。
7. `ndim`：Series对象的维数，即维度的数量。
8. `empty`：一个布尔值，表示Series对象是否为空。
9. `axes`：Series对象的轴标签列表。
10. `iat`：用于获取特定位置的数据的快速访问器。
11. `iloc`：用于按位置选择数据的快速访问器。
12. `loc`：用于按标签选择数据的快速访问器。


### DataFrame

```python
import pandas as pd

df = pd.DataFrame(data=None, index=None, colums=None,dtype=None)
```

axis（轴）是指数据的方向。pandas的axis参数有两个选项：
- axis=0：表示沿着行的方向进行操作，即对每一列进行操作。
- axis=1：表示沿着列的方向进行操作，即对每一行进行操作。

1. 从列表或数组创建DataFrame：

```python
import pandas as pd

data = [['Alice', 25], ['Bob', 30], ['Charlie', 35]]
df = pd.DataFrame(data, columns=['Name', 'Age'])
df
```

结果：
```
	Name	Age
0	Alice	25
1	Bob	    30
2	Charlie	35
```


2. 从字典创建DataFrame：

```python
import pandas as pd

data = {'Name': ['Alice', 'Bob', 'Charlie'], 'Age': [25, 30, 35]}
df = pd.DataFrame(data)
```


3. 从CSV文件创建DataFrame：

```python
import pandas as pd

df = pd.read_csv('data.csv')
```


4. 从SQL数据库创建DataFrame：

```python
import pandas as pd
import sqlite3

conn = sqlite3.connect('database.db')
query = 'SELECT * FROM table_name'
df = pd.read_sql(query, conn)
```

DataFrame的一些常用属性包括：

1. shape：返回DataFrame的形状，即行数和列数。
2. columns：返回DataFrame的列标签。
3. index：返回DataFrame的行标签。
4. dtypes：返回DataFrame各列的数据类型。
5. values：返回DataFrame的数据内容，以二维数组形式表示。
6. size：返回DataFrame的元素个数，即行数乘以列数。
7. empty：返回一个布尔值，表示DataFrame是否为空。
8. T：返回DataFrame的转置，即行列互换。
9. axes：返回DataFrame的行、列轴标签。
10. ndim：返回DataFrame的维度数，即2。
11. nbytes：返回DataFrame的内存大小（以字节为单位）。
12. itemsize：返回DataFrame每个元素的字节大小。
13. memory_usage()：返回DataFrame各列的内存使用情况。
14. describe()：返回DataFrame各列的统计描述信息（如均值、标准差等）。
15. info()：打印出DataFrame的基本信息，包括列数、行数、各列的非空值数量和数据类型等。

```python
df.head(n) # 获取df前n行，默认5行
df.tail(n) # 获取df后n行，默认5行
```

**修改行列索引值**

```python
new_index = [5,4,3,2,1]

# 必须整体修改
df.index = new_index

# 错误方式
df.index[2] = 12
```

**重设索引**

`reset_index()`方法会将旧索引添加为一个新的列，然后创建一个从0开始的新索引。

```python
import pandas as pd

# 创建一个示例DataFrame
data = {'Name': ['John', 'Emily', 'Michael'],
        'Age': [25, 30, 35],
        'City': ['New York', 'London', 'Paris']}

df = pd.DataFrame(data)

# 输出原始DataFrame
print(df)

# 重设索引
df = df.reset_index() # 默认drop为False，不删除原来的索引

# 输出重设索引后的DataFrame
print(df)
```

输出：
```
原始DataFrame:
      Name  Age      City
一     John   25  New York
二    Emily   30    London
三  Michael   35     Paris
重设索引后的DataFrame:
  index     Name  Age      City
0     一     John   25  New York
1     二    Emily   30    London
2     三  Michael   35     Paris

drop = True:
      Name  Age      City
0     John   25  New York
1    Emily   30    London
2  Michael   35     Paris
```

**设置索引**

set_index方法有几种常见的用法：
1. 传入一个列名或列名的列表作为参数，将这些列作为索引列，并返回一个新的DataFrame，原DataFrame的索引将被替换掉。例如：

```python
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6]})
df.set_index('A', inplace=True)
```

```
# 输出
	B
A	
1	4
2	5
3	6
```


2. 传入一个Series作为参数，将该Series作为索引列，并返回一个新的DataFrame，原DataFrame的索引将被替换掉。例如：

```python
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6]})
s = pd.Series(['a', 'b', 'c'])
df.set_index(s, inplace=True)
```

3. 传入一个函数作为参数，该函数会被应用于DataFrame的每一行或每一列，并返回一个新的DataFrame，原DataFrame的索引将被替换掉。例如：

```python
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6]})
df.set_index(lambda x: x['A'] + x['B'], inplace=True)
```


### MultiIndex

MultiIndex是一种多层次索引的数据结构，它使得在一个轴上可以有多个索引级别。MultiIndex可以用于处理高维数据，并提供了一些便捷的方法来对数据进行操作。

在Pandas中创建MultiIndex可以通过多种方式，包括从Python的列表、数组或元组创建。下面是一个使用元组创建MultiIndex的简单示例：

```python
import pandas as pd

index = pd.MultiIndex.from_tuples([('A', 1), ('A', 2), ('B', 1), ('B', 2)])
data = pd.DataFrame({'values': [1, 2, 3, 4]}, index=index)

print(data)
```

输出结果如下：

```
     values
A 1       1
  2       2
B 1       3
  2       4
```

在这个示例中，我们使用元组创建了一个包含两个级别的MultiIndex。第一个级别是字母'A'和'B'，第二个级别是数字1和2。然后，我们创建了一个带有values列的DataFrame，并使用创建的MultiIndex作为索引。

使用MultiIndex后，我们可以通过索引的多个级别来选择数据。例如，要选择A级别为1的所有数据，可以使用以下代码：

```python
print(data.loc['A', 1])
```

输出结果如下：

```
values    1
Name: (A, 1), dtype: int64
```

## 索引操作


在pandas中，索引操作非常重要，它用于选择、过滤和修改数据。以下是一些常用的索引操作：

直接索引：只能先列后行`df[column_name][row_name]`

1. 使用标签索引：可以使用 `.loc` 属性来通过行标签和列标签进行索引操作。例如：`df.loc[row_label, column_label]`。

2. 使用位置索引：可以使用 `.iloc` 属性来通过行索引和列索引进行索引操作。例如：`df.iloc[row_index, column_index]`。

3. 使用布尔索引：可以使用布尔条件来选择满足条件的行或列。例如：`df[condition]`，其中 `condition` 是一个布尔条件。

4. 使用切片索引：可以使用切片操作来选择一定范围内的行或列。例如：`df[start:end]`。

5. 使用列索引：可以使用列名来选择指定的列。例如：`df[column_name]`。

6. 使用行索引：可以使用 `.loc` 属性来选择指定的行。例如：`df.loc[row_label]`

7. 使用多重索引：可以使用多个标签或位置索引来选择多层次的数据。例如：`df.loc[(label1, label2), (column1, column2)]`。

## 赋值操作

在pandas中，有多种方式可以进行赋值操作。以下是常见的几种方式：

1. 使用赋值运算符（=）：可以使用赋值运算符将一个值赋给一个变量。例如，可以将一个标量值赋给一个DataFrame中的某一列，或者将一个Series赋给一个新的列。

``` python
import pandas as pd

# 创建一个空的DataFrame
df = pd.DataFrame()

# 添加一列，并赋值为标量值
df['column_name'] = 10

# 添加一列，并赋值为Series
series = pd.Series([1, 2, 3])
df['new_column_name'] = series
```

2. 使用`.loc`和`.iloc`索引器：可以使用`.loc`和`.iloc`来选择指定的行和列，并将其赋给一个新的变量。

``` python
import pandas as pd

# 创建一个DataFrame
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6]})

# 使用.loc选择指定的行和列，并赋给新的变量
new_df = df.loc[:, 'A']
```

3. 使用`.at`和`.iat`索引器：可以使用`.at`和`.iat`来选择指定位置的值，并将其赋给一个新的变量。

``` python
import pandas as pd

# 创建一个DataFrame
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6]})

# 使用.at选择指定位置的值，并赋给新的变量
new_value = df.at[0, 'A']
```

4. 使用`[]`操作符：可以使用`[]`操作符来选择指定的行和列，并将其赋给一个新的变量。

``` python
import pandas as pd

# 创建一个DataFrame
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6]})

# 使用[]选择指定的行和列，并赋给新的变量
new_df = df[['A', 'B']]
```


## 排序操作

### DataFrame排序

在Pandas中，可以使用`sort_values()`函数对数据进行排序操作。以下是一些常见的排序操作示例：

按照某一列升序排序：

```python
df.sort_values('column_name')
```

按照某一列降序排序：

```python
df.sort_values('column_name', ascending=False)
```

按照多列进行排序：

```python
df.sort_values(['column_name1', 'column_name2'])
```

如果需要对DataFrame的索引进行排序，可以使用`sort_index()`函数：

```python
df.sort_index()
```

另外，还可以使用`nlargest()`和`nsmallest()`函数获取最大或最小的几个值：

```python
df.nlargest(n, 'column_name')  # 获取某一列中最大的n个值
df.nsmallest(n, 'column_name')  # 获取某一列中最小的n个值
```

### series排序

pandas的Series对象可以使用sort_values()方法进行排序操作。该方法会返回一个新的Series对象，其中的元素按照指定的排序顺序排列。

以下是一个示例：

```python
import pandas as pd

# 创建一个Series对象
data = {'a': 5, 'b': 3, 'c': 8, 'd': 2}
series = pd.Series(data)

# 按照索引值进行升序排序
sorted_series = series.sort_values()
print(sorted_series)

# 按照值进行降序排序
sorted_series_desc = series.sort_values(ascending=False)
print(sorted_series_desc)
```

输出结果为：

```
d    2
b    3
a    5
c    8
dtype: int64

c    8
a    5
b    3
d    2
dtype: int64
```



## 运算

### 基础运算
#### 算数运算

下面是一些常见的算数运算操作：

1. 加法：使用 "+" 操作符进行两个数据结构的加法运算。示例：df1 + df2

2. 减法：使用 "-" 操作符进行两个数据结构的减法运算。示例：df1 - df2

3. 乘法：使用 "\*" 操作符进行两个数据结构的乘法运算。示例：df1 \* df2

4. 除法：使用 "/" 操作符进行两个数据结构的除法运算。示例：df1 / df2

5. 幂运算：使用 "\*\*" 操作符进行数据结构的幂运算。示例：df1 \*\* 2

此外，Pandas还提供了其他一些常用的算数运算函数，例如：

- 加法运算：使用 add() 函数进行两个数据结构的加法运算。示例：df1.add(df2)

- 减法运算：使用 sub() 函数进行两个数据结构的减法运算。示例：df1.sub(df2)

- 乘法运算：使用 mul() 函数进行两个数据结构的乘法运算。示例：df1.mul(df2)

- 除法运算：使用 div() 函数进行两个数据结构的除法运算。示例：df1.div(df2)

这些函数还可以接受其他参数，例如 fill_value 参数可以指定在运算过程中缺失值的填充方式。

#### 逻辑运算

1. 逻辑操作符：
   - `&`：与操作符，用于逐元素的逻辑与运算。
   - `|`：或操作符，用于逐元素的逻辑或运算。
   - `~`：非操作符，用于逐元素的逻辑非运算。

2. 逻辑函数：
   - `all()`：判断是否所有元素都为True。
   - `any()`：判断是否至少有一个元素为True。
   - `isin()`：判断元素是否在给定的值列表中。
   - `where()`：根据条件进行元素的选择，条件为True的元素保留，否则用指定值替换。
   - `query()`：使用表达式查询数据。

3. 大小比较：
    - `>`
    - `<`
    - `<=`
    - `>=`
    - ==

下面是一些示例：

```python
import pandas as pd

# 创建示例DataFrame
df = pd.DataFrame({'A': [True, True, False, False],
                   'B': [True, False, True, False],
                   'C': [False, True, False, True]})

# 逻辑与运算
result_and = df['A'] & df['B']
print(result_and)
# 输出：0     True
#      1    False
#      2    False
#      3    False
#      dtype: bool

# 逻辑或运算
result_or = df['A'] | df['B']
print(result_or)
# 输出：0    True
#      1    True
#      2    True
#      3    False
#      dtype: bool

# 逻辑非运算
result_not = ~df['A']
print(result_not)
# 输出：0    False
#      1    False
#      2     True
#      3     True
#      Name: A, dtype: bool

# 判断是否所有元素都为True
all_true = df.all()
print(all_true)
# 输出：A    False
#      B    False
#      C    False
#      dtype: bool

# 判断是否至少有一个元素为True
any_true = df.any()
print(any_true)
# 输出：A     True
#      B     True
#      C     True
#      dtype: bool

# 判断元素是否在给定的值列表中
isin_result = df['A'].isin([True, False])
print(isin_result)
# 输出：0     True
#      1     True
#      2    False
#      3    False
#      Name: A, dtype: bool

# 根据条件进行元素的选择
where_result = df['A'].where(df['B'], False)
print(where_result)
# 输出：0     True
#      1    False
#      2    False
#      3    False
#      Name: A, dtype: bool

# 使用表达式查询数据
query_result = df.query('A & B')
print(query_result)
# 输出：      A      B      C
#      0  True   True  False
```


### 统计

常用的统计运算和函数的示例：

1. 描述统计
    常用的Pandas统计函数：
    - describe()：计算数据的基本统计信息，包括计数、均值、标准差、最小值、25%分位数、中位数、75%分位数和最大值。
    - mean()：计算数据的平均值。
    - median()：计算数据的中位数。
    - mode()：计算数据的众数。
    - min()：计算数据的最小值。
    - max()：计算数据的最大值。
    - var()：计算数据的方差。
    - std()：计算数据的标准差。
    - sum()：计算数据的和。
    - count()：计算数据的非缺失值的数量。
    - unique()：返回数据中的唯一值。
    - nunique()：返回数据中唯一值的数量。
    - quantile()：计算数据的分位数。
    - corr()：计算数据的相关系数矩阵。
    - cov()：计算数据的协方差矩阵。
    - idxmax()：最大值的位置
    - idxmin()：最小值的位置


2. 分组统计
Pandas的groupby函数可以实现按照某个列的值进行分组，并对每个分组进行统计计算。常用的统计方法包括count（计数）、sum（求和）、mean（平均值）、median（中位数）等。

```python
import pandas as pd

# 创建一个DataFrame对象
data = pd.DataFrame({
    'Name': ['Alice', 'Bob', 'Charlie', 'David', 'Alice'],
    'Age': [25, 30, 22, 35, 27],
    'Salary': [5000, 6000, 4500, 7000, 5500]
})

# 按照Name列进行分组，并计算每个分组的平均年龄和工资
grouped_data = data.groupby('Name')
grouped_mean = grouped_data.mean()
print(grouped_mean)
```

3. 直方图
Pandas的hist函数可以绘制数据的直方图。直方图是一种可视化工具，用于展示数据的分布情况。

```python
import pandas as pd
import matplotlib.pyplot as plt

# 创建一个Series对象
data = pd.Series([1, 2, 3, 4, 5, 5, 6, 7, 8, 9, 10])

# 绘制直方图
data.hist() # pandas 内部封装的画图
plt.show()
```

4. 累计统计函数
    常用的累计统计函数：

1. cumsum()：计算累计和。
```python
df['column'].cumsum()
```

2. cumprod()：计算累计乘积。
```python
df['column'].cumprod()
```

3. cummax()：计算累计最大值。
```python
df['column'].cummax()
```

4. cummin()：计算累计最小值。
```python
df['column'].cummin()
```

5. cumcount()：计算累计非空值的个数。
```python
df['column'].cumcount()
```

这些函数都会返回一个与输入数据相同长度的Series，其中每个元素都是累计统计的结果。

>[!info]
>累计统计是指在一段时间内不断累加某一指标或数据的过程。它可以用来跟踪和分析数据的总量或趋势。
>
举个例子，假设某个企业每月销售额如下：
>
>- 1月：10000元
>- 2月：15000元
>- 3月：20000元
>
通过累计统计，可以计算得到每月销售额的累计值：
>
>- 1月累计销售额：10000元
>- 2月累计销售额：10000元 + 15000元 = 25000元
>- 3月累计销售额：25000元 + 20000元 = 45000元


### 自定义运算

如何使用自定义函数进行运算：

创建一个包含数据的DataFrame：
```python
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6]})
```

定义一个自定义函数，用于对每个元素进行运算：
```python
def custom_function(x):
    return x * 2
```

使用`apply()`方法将自定义函数应用到DataFrame的每个元素上：
```python
df.apply(custom_function)
```

这将返回一个新的DataFrame，其中每个元素都被自定义函数处理过。

还可以在`apply()`方法中指定轴参数，以便对行或列进行运算。例如，如果要对每一列应用自定义函数，可以使用`axis=0`参数：
```python
df.apply(custom_function, axis=0)
```

如果要对每一行应用自定义函数，可以使用`axis=1`参数：
```python
df.apply(custom_function, axis=1)
```

## 绘图

[matplotlib](常用库/matplotlib/matplotlib.md)

```python 
# 创建一个DataFrame对象
data = {'Year': [2010, 2011, 2012, 2013, 2014, 2015],
        'Sales': [100, 200, 300, 400, 500, 600]}

df = pd.DataFrame(data)

# 绘制折线图
df.plot(x='Year', y='Sales', kind='line')

# 显示图形
plt.show()
```

## 文件读取和存储

常见的文件读取和存储方法：

### 文件读取

1. 读取CSV文件：使用`pandas.read_csv()`方法来读取CSV文件。例如：
   ```python
   import pandas as pd
   data = pd.read_csv('data.csv')
   ```

常用的read_csv函数的参数：
- `filepath_or_buffer`: 必需参数，指定要读取的文件的路径或URL。
- `sep`: 指定字段之间的分隔符，默认为逗号。
- `delimiter`: 同`sep`，指定字段之间的分隔符，与`sep`参数相同。
- `header`: 指定哪一行作为列名，默认为0，表示第一行作为列名，如果设置为None，则表示没有列名。
- `index_col`: 指定某一列作为索引列，默认为None，表示不使用任何列作为索引。
- `usecols`: 指定要读取的列的列表，默认为None，表示读取所有列。
- `dtype`: 指定每一列的数据类型，可以是字典或者函数，默认为None，表示自动推断数据类型。
- `parse_dates`: 指定要解析成日期的列的列表，默认为False，表示不解析日期。
- `na_values`: 指定要识别为缺失值的值的列表，默认为None，表示根据pandas的默认规则来识别。
- `skiprows`: 指定要跳过的行数，默认为None，表示不跳过任何行。


2. 读取Excel文件：使用`pandas.read_excel()`方法来读取Excel文件。需要安装`xlrd`库来支持Excel文件读取。例如：
   ```python
   import pandas as pd
   data = pd.read_excel('data.xlsx')
   ```

常用的参数包括：
- `io`：指定要读取的Excel文件的路径、URL、文件类型对象或者原始文件内容。
- `sheet_name`：指定要读取的工作表名称或索引，默认为第一个工作表。
- `header`：指定表头所在的行，默认为0，表示第一行。
- `names`：指定列名，可以是一个列表。
- `index_col`：指定作为索引的列，可以是一个列名或者列的位置。
- `usecols`：指定要读取的列，可以是一个列表。


3. 读取文本文件：使用`pandas.read_table()`方法来读取文本文件，可以指定分隔符等参数。例如：
   ```python
   import pandas as pd
   data = pd.read_table('data.txt', delimiter=',')
   ```


4. 读取json文件：使用`read_json()`函数来读取JSON文件。
```python
# 读取JSON文件
df = pd.read_json('file.json')

# 显示DataFrame
print(df)
```

read_json函数的常用参数如下：
- `path`：要读取的 JSON 文件的路径，可以是本地路径或远程 URL。
- `orient`：指定 JSON 数据的结构，可选值包括 `'columns'`、`'index'`、`'values'`和`'split'`。默认为 `'columns'`，表示 JSON 数据的每个顶级属性将作为 `DataFrame` 的列。
- `typ`：指定读取的 JSON 数据的数据类型，可选值为 `None`、`'series'` 或 `'frame'`。默认为 `None`，表示根据数据结构自动推断数据类型。
- `dtype`：指定列的数据类型，可以是字典、`Series` 或 `DataFrame`。
- `convert_axes`：指定是否将行索引转换为列名，默认为 `True`，表示将行索引转换为列名。
- `convert_dates`：指定是否将日期字符串自动转换为日期类型，默认为 `True`。
- `keep_default_dates`：指定在转换日期字符串时是否保留缺省日期，默认为 `True`。
- `numpy`：指定是否使用 NumPy 进行数据类型推断，默认为 `False`。
- `precise_float`：指定是否使用精确的浮点数表示，默认为 `False`。



### 文件存储

1. 存储为CSV文件：使用`DataFrame.to_csv()`方法来将数据存储为CSV文件。例如：
   ```python
   import pandas as pd
   data.to_csv('data.csv', index=False)
   ```

2. 存储为Excel文件：使用`DataFrame.to_excel()`方法来将数据存储为Excel文件。需要安装`openpyxl`库来支持Excel文件写入。例如：
   ```python
   import pandas as pd
   data.to_excel('data.xlsx', index=False)
   ```

3. 存储为文本文件：使用`DataFrame.to_csv()`方法来将数据存储为文本文件，可以指定分隔符等参数。例如：
   ```python
   import pandas as pd
   data.to_csv('data.txt', sep='\t', index=False)
   ```


4. 存储为json文件：`to_json()`方法用于将DataFrame或Series对象转换为JSON格式的字符串或文件。

```python
data = {'name': ['Alice', 'Bob', 'Charlie'],
        'age': [25, 30, 35],
        'city': ['New York', 'San Francisco', 'Los Angeles']}

df = pd.DataFrame(data)

# 将DataFrame转换为JSON字符串
json_string = df.to_json(orient='records')
print(json_string)

# 将DataFrame保存为JSON文件
df.to_json('data.json', orient='records')
```

在上述示例中，`df.to_json(orient='records')`将DataFrame对象转换为JSON字符串，并将结果打印输出。`df.to_json('data.json', orient='records')`将DataFrame保存为名为`data.json`的文件，JSON格式为每行作为一个JSON对象。

常用的参数：

- `path_or_buf`：指定生成的JSON文件的路径或文件对象，默认为None。如果不指定该参数，则`to_json()`方法会返回生成的JSON字符串而不保存到文件中。
- `orient`：指定生成的JSON格式。可选值包括`'split'`（每个对象的每个值都作为一个独立的JSON对象），`'records'`（每行作为一个JSON对象），`'index'`（行索引作为JSON对象的键），`'columns'`（列名作为JSON对象的键），`'values'`（只包含数据值）等，默认为`'columns'`。
- `date_format`：指定日期类型的序列化格式，默认为`'iso'`（ISO8601格式）。可以使用`'epoch'`（以毫秒为单位的时间戳）或自定义日期格式字符串。
- `double_precision`：指定浮点数的精度，默认为10。
- `force_ascii`：指定是否将非ASCII字符转义为其转义编码，默认为True。



## 高级处理

### 处理缺失值

常用的方法：

1. 删除缺失值：使用`dropna()`函数可以删除包含缺失值的行或列。可以通过设置`axis`参数来指定删除行还是列，默认是删除行。可以使用`thresh`参数来指定每行/列至少要有多少个非缺失值才保留。

2. 填充缺失值：使用`fillna()`函数可以填充缺失值。可以通过设置`value`参数来指定填充的值，可以是一个具体的数值或一个字典。可以使用`method`参数来指定填充的方法，如使用前一个非缺失值填充（`ffill`）或使用后一个非缺失值填充（`bfill`）。

3. 插值填充缺失值：使用`interpolate()`函数可以通过插值方法来填充缺失值。可以使用`method`参数来指定插值方法，如线性插值（`linear`）或多项式插值（`polynomial`）。

4. 判断缺失值：使用`isnull()` 或 `isna()` 函数可以判断每个元素是否为缺失值，返回一个布尔值的DataFrame或Series。

5. 替换缺失值：使用`replace()`函数可以将缺失值替换为特定的值。例如：`df.replace(np.nan, 0)`将NaN替换为0。

`isna()` `notna()`
`isnull()` `notnull()`
这里isna是isnull的别名


需要注意的是，在处理缺失值之前，通常要先使用`astype()`函数将数据类型转换为适当的类型，以确保缺失值被正确处理。

```python
df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6]})
pd.isna(df)
```

```
# 输出

    A	    B
0	False	False
1	False	False
2	False	False
```

### 离散化

pandas离散化的实际作用是将连续型的数据划分为离散的数据区间，便于分析和处理。离散化可以帮助我们更好地理解和解释数据的分布情况，并进行进一步的数据分析和挖掘。

举个例子，假设我们有一份汽车销售数据，其中包含了汽车的价格信息。如果我们想要对这些汽车的价格进行分析，但是价格是一个连续的变量，难以直接进行分析。

这时，我们可以使用离散化技术将价格划分为若干个价格区间，例如0-10万、10-20万、20-30万等，然后统计每个区间中的汽车数量，进一步分析不同价格区间中汽车的销售情况，比较不同价格区间的销售量和销售额，找出销售热点和市场需求。
这样一来，我们可以更好地理解和解释汽车销售数据，为制定销售策略和决策提供支持。


常用的离散化方法：

1. 等宽离散化（binning）：将数据根据数值范围进行等宽划分。可以使用 pandas 的 `cut()` 函数实现。例如：

```python
import pandas as pd

# 创建一个示例数据集
data = pd.DataFrame({'score': [80, 90, 70, 85, 95, 65, 75, 100]})

# 将 score 列按照 3 个等宽区间进行离散化
data['score_bin'] = pd.cut(data['score'], bins=3)

print(data)
```

输出结果：

```
   score       score_bin
0     80  (64.933, 80.0]
1     90   (80.0, 95.0]
2     70  (64.933, 80.0]
3     85   (80.0, 95.0]
4     95   (80.0, 95.0]
5     65  (64.933, 80.0]
6     75  (64.933, 80.0]
7    100  (95.0, 109.067]
```

`pd.cut()`函数返回的结果是一个Categorical对象，可以通过`result.codes`获取每个数据所属的区间的编号，通过`result.categories`获取所有标签。



2. 等频离散化（quantile）：将数据分成相同数量的区间，每个区间包含近似相同数量的数据。可以使用 pandas 的 `qcut()` 函数实现。例如：

```python
import pandas as pd

# 创建一个示例数据集
data = pd.DataFrame({'score': [80, 90, 70, 85, 95, 65, 75, 100]})

# 将 score 列按照 3 个等频区间进行离散化
data['score_bin'] = pd.qcut(data['score'], q=3)

print(data)
```

输出结果：

```
   score       score_bin
0     80  (64.999, 75.0]
1     90   (87.5, 100.0]
2     70  (64.999, 75.0]
3     85   (75.0, 87.5]
4     95   (87.5, 100.0]
5     65  (64.999, 75.0]
6     75  (64.999, 75.0]
7    100   (87.5, 100.0]
```


### 合并

1. `pd.concat()`

连接可以按行（垂直方向）或按列（水平方向）进行。

使用concat函数的示例：

```python
# 创建两个数据框
df1 = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6]})
df2 = pd.DataFrame({'A': [7, 8, 9], 'B': [10, 11, 12]})

# 按行连接两个数据框
result = pd.concat([df1, df2], axis=0)
print(result)

# 按列连接两个数据框
result = pd.concat([df1, df2], axis=1)
print(result)
```

输出结果为：
```
   A   B
0  1   4
1  2   5
2  3   6
0  7  10
1  8  11
2  9  12

   A  B  A   B
0  1  4  7  10
1  2  5  8  11
2  3  6  9  12
```

2. `pd.merge()`

允许将两个或多个数据框（DataFrame）按照一个或多个键（key）进行连接。

Pandas的merge函数有以下常用参数：

- left：左侧的数据框。
- right：右侧的数据框。
- on：指定要合并的键（key）的列名，可以是一个列名或多个列名。如果两个数据框中的列名不同，可以使用left_on和right_on参数进行指定。
- how：指定合并方式，默认为"inner"，表示内连接。其他常用的合并方式包括"outer"（外连接）、"left"（左连接）和"right"（右连接）。
- suffixes：指定在合并时，如果两个数据框中存在相同列名的情况下，对列名进行重命名的后缀。一般左侧数据框的列名添加"\_x"后缀，右侧数据框的列名添加"\_y"后缀。

merge的功能相较更多

```python
# 创建第一个DataFrame对象
data1 = {'Name': ['John', 'Emma', 'Tom'],
         'Age': [25, 28, 30],
         'City': ['New York', 'London', 'Paris']}
df1 = pd.DataFrame(data1)

# 创建第二个DataFrame对象
data2 = {'Name': ['John', 'Emma', 'Lily'],
         'Salary': [5000, 6000, 7000],
         'City': ['New York', 'London', 'Tokyo']}
df2 = pd.DataFrame(data2)

# 使用merge函数合并两个DataFrame对象
merged_df = pd.merge(df1, df2, on='Name')

print(merged_df)
```

输出结果：

```
   Name  Age       City_x  Salary     City_y
0  John   25     New York    5000   New York
1  Emma   28       London    6000     London
```

>[!info]
>内连接（Inner Join）：内连接是一种通过两个表中的共同列进行匹配，并返回匹配结果的连接方式。只有在**两个表中都存在匹配的行**时，才会返回结果。
>
>外连接（Outer Join）：外连接是一种连接方式，它可以返回**匹配的行以及左表或右表中没有匹配的行**。外连接可以分为左外连接和右外连接。
>
>左连接（Left Join）：左连接是一种外连接，它返回**左表中所有的行以及与右表中匹配的行**。如果右表中没有匹配的行，那么返回的结果中对应的列值为NULL。
>
>右连接（Right Join）：右连接是一种外连接，它返回**右表中所有的行以及与左表中匹配的行**。如果左表中没有匹配的行，那么返回的结果中对应的列值为NULL。



### 交叉表、透视表

**交叉表**可以帮助我们快速了解两个变量之间的关系，以及它们在不同组别或类别上的分布情况。交叉表可以用于定性数据（如类别、标签等）和定量数据（如数值型数据）。

`pd.crosstab()`

pandas的交叉表功能：

```python
# 创建一个示例数据集
data = {
    'Gender': ['Male', 'Male', 'Female', 'Female', 'Male', 'Female'],
    'Age': [25, 30, 20, 35, 40, 25],
    'Smoker': ['Yes', 'No', 'Yes', 'No', 'No', 'Yes']
}

df = pd.DataFrame(data)

# 使用交叉表计算两个变量之间的交叉频数
cross_tab = pd.crosstab(df['Gender'], df['Smoker'])

print(cross_tab)
```

输出结果为：

```
Smoker  No  Yes
Gender         
Female   1    2
Male     2    1
```

在这个示例中，我们创建了一个包含性别、年龄和吸烟情况的数据集。通过调用`pd.crosstab()`函数，并传入需要统计的两个变量，可以得到一个交叉表，显示了各个类别在交叉点上的频数。

在结果中，每一行代表一个性别类别（Female和Male），每一列代表一个吸烟情况类别（No和Yes）。交叉点上的数字表示了对应性别和吸烟情况的频数。


**透视表**是一种数据汇总和重塑的操作，它可以通过聚合和分组来创建新的数据表格。透视表可以按照指定的行和列进行分组，并根据特定的聚合函数计算汇总值。

在Pandas中，可以使用`pd.pivot_table()`函数创建透视表。

- values：需要聚合的列或列的列表。默认为所有数值列。
- index：用于分组的列或列的列表。默认为所有非数值列。
- columns：用于分组的列或列的列表。默认为所有非数值列。
- aggfunc：用于聚合的函数或函数的列表。默认为np.mean，即计算平均值。
- fill_value：用于填充缺失值的值。
- margins：是否计算所有行/列的总计，默认为False。
- dropna：是否删除包含缺失值的行/列，默认为True。
- observed：只适用于分类变量，指定是否包含所有可能的组合值，默认为False。

下面是一个示例代码，演示了如何使用透视表对销售数据进行汇总：

```python
import pandas as pd

# 创建一个包含销售数据的DataFrame
data = {
    '城市': ['北京', '上海', '北京', '上海', '北京', '上海'],
    '产品': ['A', 'A', 'B', 'B', 'C', 'C'],
    '销售额': [100, 200, 150, 300, 120, 250]
}
df = pd.DataFrame(data)

# 使用透视表对销售数据进行汇总
pivot_table = pd.pivot_table(df, values='销售额', index='城市', columns='产品', aggfunc=np.sum)

print(pivot_table)
```

运行以上代码，将会得到如下的透视表：

```
产品    A    B    C
城市                
上海  200  300  250
北京  100  150  120
```

透视表中的每一行表示一个城市，每一列表示一个产品类型，单元格中的数值表示该城市中对应产品类型的销售额的汇总值。


### 分组、聚合

Pandas中，分组指的是将数据按照某个条件进行分组，而聚合则是对每个分组计算一个统计指标。以下是一些常用的Pandas分组与聚合操作：

1. groupby(): 使用groupby函数对数据进行分组。可以按照一列或多列的值进行分组。

2. 聚合函数：可以使用各种统计函数对分组后的数据进行聚合操作，如sum、mean、max、min、count等。

3. agg(): 使用agg函数对分组后的数据进行多个聚合操作。可以一次性对多个列应用不同的聚合函数。

4. transform(): 使用transform函数将聚合结果返回到原始数据的每一行。

5. apply(): 使用apply函数对分组后的数据进行自定义的聚合操作。

下面是一个简单的示例代码，展示了如何使用Pandas进行分组与聚合操作：

```python
import pandas as pd

# 创建一个示例数据集
data = {'Name': ['Alice', 'Bob', 'Charlie', 'Alice', 'Bob', 'Charlie'],
        'Age': [25, 30, 35, 40, 45, 50],
        'Salary': [5000, 6000, 7000, 8000, 9000, 10000]}

df = pd.DataFrame(data)

# 按照姓名进行分组，并计算平均年龄和总薪资
grouped = df.groupby('Name').agg({'Age': 'mean', 'Salary': 'sum'})

print(grouped)
```

输出结果为：

```
         Age  Salary
Name                
Alice   32.5   13000
Bob     37.5   15000
Charlie 42.5   17000
```

这个示例代码中，首先创建了一个包含姓名、年龄和薪资的数据集。然后，使用groupby函数按照姓名进行分组，并使用agg函数计算每个分组的平均年龄和总薪资。最后，将聚合结果打印出来。




groupby方法的参数包括：

1. by：表示根据哪些列进行分组，可以是列名（单个列名或多个列名组成的列表），也可以是函数、字典、Series等。默认为None。

2. axis：表示分组的轴，可以是0表示按行分组，1表示按列分组。默认为0。

3. level：表示对于多级索引数据，指定在哪个级别上进行分组。默认为None。

4. as_index：表示是否将分组的列作为索引，默认为True。

5. sort：表示是否对分组结果进行排序，默认为True。

6. group_keys：表示是否在结果中包含分组键，默认为True。

7. squeeze：表示是否对结果进行压缩，默认为False。如果分组只有一个组，且as_index为True，则结果会以Series的形式返回。

8. observed：表示在分组过程中是否包含所有的观测值，默认为False。如果为True，则会包含所有观测值，即使它们没有出现在分组的列中。

9. dropna：表示在分组过程中是否忽略缺失值，默认为True。

10. as_index：表示是否将分组的列作为索引，默认为True。

11. level：表示对于多级索引数据，指定在哪个级别上进行分组。默认为None。








## 其他

可以使用`get_dummies()`函数来将分类变量转换成one-hot编码

```python

import pandas as pd

# 假设你有一个DataFrame df，包含了一个分类变量category_column
# 例如：df = pd.DataFrame({'category_column': ['A', 'B', 'A', 'C', 'B', 'C']})

# 使用get_dummies函数将分类变量转换为one-hot编码
one_hot_df = pd.get_dummies(df['category_column'])

# 将one-hot编码的结果与原始DataFrame合并
df = pd.concat([df, one_hot_df], axis=1)

# 删除原始的分类变量列
df.drop(['category_column'], axis=1, inplace=True)

```



