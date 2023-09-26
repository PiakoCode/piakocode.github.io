# SKlearn

下面是一些sklearn的基本使用方法：

1. 安装sklearn库：在命令行中使用`pip install scikit-learn`命令进行安装。

2. 导入sklearn模块：通常，我们使用以下方式导入sklearn的相关模块：

```python
import sklearn
from sklearn import 模块名
```

3. 加载数据集：sklearn提供了很多常用的数据集，可以使用`datasets`模块来加载数据集。例如，加载Iris数据集的代码如下：

```python
from sklearn import datasets
iris = datasets.load_iris()
   ```

4. 划分数据集：通常，我们需要将数据集划分为训练集和测试集，以便评估模型的性能。可以使用`model_selection`模块的`train_test_split`函数来实现。例如，将数据集划分为训练集和测试集的代码如下：

```python
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(iris.data, iris.target, test_size=0.2, random_state=42)
   ```

5. 创建模型：根据任务的需求选择合适的机器学习模型，并创建模型对象。例如，创建一个支持向量机（SVM）分类模型的代码如下：

```python
from sklearn import svm
clf = svm.SVC()
   ```

6. 训练模型：使用训练数据集训练模型。可以使用模型对象的`fit`方法来实现。例如，训练SVM模型的代码如下：

```python
clf.fit(X_train, y_train)
   ```

7. 预测：使用训练好的模型对新样本进行预测。可以使用模型对象的`predict`方法来实现。例如，对测试集进行预测的代码如下：

```python
y_pred = clf.predict(X_test)
   ```

8. 评估模型：使用评估指标来评估模型的性能。sklearn提供了很多评估指标，例如准确率、精确率、召回率等。例如，计算模型准确率的代码如下：

```python
from sklearn import metrics
accuracy = metrics.accuracy_score(y_test, y_pred)
   ```





[Examples — scikit-learn](https://scikit-learn.org/stable/auto_examples/index.html)