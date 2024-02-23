# seaborn


导入
```
import seaborn as sns
```

## 单变量分布

Seaborn绘制**单变量分布图**的一般步骤：

1. 导入需要的库和数据。首先，确保已经安装了Seaborn和其他必要的库，如numpy和pandas。然后，导入需要可视化的数据。

```python
import seaborn as sns
import numpy as np
import pandas as pd

# 导入数据
data = pd.read_csv('data.csv')
```

2. 选择合适的单变量分布图。Seaborn提供了多种单变量分布图的方法，包括直方图（distplot）、核密度估计图（kdeplot）、箱线图（boxplot）等。根据数据类型和需求选择合适的图表。

3. 绘制图表。使用选择的图表方法，传入需要可视化的数据即可绘制单变量分布图。

```python
# 绘制直方图
sns.distplot(data['column_name'])

# 绘制核密度估计图
sns.kdeplot(data['column_name'])

# 绘制箱线图
sns.boxplot(data['column_name'])
```

![](Picture/Pasted%20image%2020230916162622.png)


4. 添加其他参数。根据需要，可以添加其他参数来调整图表的样式和显示效果，如设置标题、调整图表大小、修改颜色等。

```python
# 设置标题
plt.title('Title')

# 调整图表大小
plt.figure(figsize=(8, 6))

# 修改颜色
sns.distplot(data['column_name'], color='red')
```

## 双变量分布

seaborn绘制**双变量分布**，可以使用`jointplot`函数。`jointplot`函数可以绘制双变量之间的关系，并且可以同时显示两个变量的单变量分布。

以下是一个绘制双变量分布的示例代码：

```python
import seaborn as sns
import matplotlib.pyplot as plt

# 加载数据
tips = sns.load_dataset("tips")

# 绘制双变量分布
sns.jointplot(x="total_bill", y="tip", data=tips)

# 显示图形
plt.show()
```

![](Picture/Pasted%20image%2020230916162342.png)


在上面的示例中，我们使用了seaborn内置的一个名为"tips"的数据集，该数据集包含了餐厅顾客的消费总金额和给予的小费金额。我们使用`jointplot`函数来绘制`total_bill`和`tip`这两个变量之间的关系。

你还可以通过设置`kind`参数来选择不同的绘图类型，例如设置`kind="hex"`可以绘制六边形热力图。例如：

```python
sns.jointplot(x="total_bill", y="tip", data=tips, kind="hex")
```

![](Picture/Pasted%20image%2020230916162411.png)