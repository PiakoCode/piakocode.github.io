# numpy

#python




**linespace()**

在 NumPy 中，`linspace` 是一个函数，用于在指定的间隔内返回均匀间隔的数字序列。它的语法如下：

```python
numpy.linspace(start, stop, num=50, endpoint=True, retstep=False, dtype=None)
````

参数说明：

- `start`：序列的起始值。
- `stop`：序列的结束值。
- `num`：要生成的等间距样本数量，默认为 50。
- `endpoint`：布尔值，表示序列是否包括 `stop` 值。如果设置为 `True`，则序列包括 `stop` 值；如果设置为 `False`，则序列不包括 `stop` 值。默认为 `True`。
- `retstep`：布尔值，表示是否返回间距（步长）。如果设置为 `True`，则除了返回等间距的序列之外，还会返回每个相邻样本之间的间距。默认为 `False`。
- `dtype`：返回数组的数据类型，如果未提供，则根据输入参数自动确定。

下面是几个示例：

```python
import numpy as np

# 返回从 0 到 10 的等间距序列，共有 5 个样本点（包括 0 和 10）
arr1 = np.linspace(0, 10, 5)
print(arr1)
# 输出：[ 0.   2.5  5.   7.5 10. ]

# 返回从 0 到 100 的等间距序列，共有 11 个样本点（包括 0 和 100）
arr2 = np.linspace(0, 100, 11)
print(arr2)
# 输出：[  0.  10.  20.  30.  40.  50.  60.  70.  80.  90. 100.]

# 返回从 -1 到 1 的等间距序列，共有 7 个样本点（包括 -1 和 1），并返回间距
arr3, step = np.linspace(-1, 1, 7, retstep=True)
print(arr3)
print(step)
# 输出：
# [-1.  -0.6 -0.2  0.2  0.6  1. ]
# 0.4
```


通过使用 `linspace` 函数，你可以轻松地生成指定间隔的等间距序列，这在数值计算和绘图等领域非常有用。


**c_**

`numpy` 的 `c_` 是一个用于按列连接（concatenate）的特殊对象，它可以将两个或多个 `numpy` 数组按列堆叠起来。它的作用类似于 `numpy` 中的 `hstack` 函数，但是 `c_` 提供了更简洁的语法。

使用 `c_` 对象可以通过将数组作为参数传递给它来实现按列连接。下面是几个示例：

```python
import numpy as np

# 示例 1
arr1 = np.array([1, 2, 3])
arr2 = np.array([4, 5, 6])
result1 = np.c_[arr1, arr2]
print(result1)
# 输出：
# [[1 4]
#  [2 5]
#  [3 6]]

# 示例 2
arr3 = np.array([[1, 2], [3, 4]])
arr4 = np.array([[5, 6]])
result2 = np.c_[arr3, arr4]
print(result2)
# 输出：
# [[1 2 5]
#  [3 4 6]]

# 示例 3
arr5 = np.array([[1, 2], [3, 4]])
arr6 = np.array([[5], [6]])
result3 = np.c_[arr5, arr6]
print(result3)
# 输出：
# [[1 2 5]
#  [3 4 6]]

```

