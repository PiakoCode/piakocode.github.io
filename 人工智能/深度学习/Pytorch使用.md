# Tensor 基础操作

#人工智能

## 声明和定义

首先是对 Tensors 的声明和定义方法，分别有以下几种：

-   `torch.empty()`: 声明一个未初始化的矩阵。
```python
import torch
# 创建一个 5*3 的矩阵
x = torch.empty(5, 3)
print(x)


tensor([[2.0535e-19, 4.5080e+21, 1.8389e+25],
        [3.4589e-12, 1.7743e+28, 2.0535e-19],
        [1.4609e-19, 1.8888e+31, 9.8830e+17],
        [4.4653e+30, 3.4593e-12, 7.4086e+28],
        [2.6762e+20, 1.7104e+25, 1.8179e+31]])
```

-   `torch.rand()`：随机初始化一个矩阵

```python
# 创建一个随机初始化的 5*3 矩阵
rand_x = torch.rand(5, 3)
print(rand_x)

tensor([[0.1919, 0.9713, 0.4248],
        [0.5571, 0.5543, 0.6414],
        [0.4645, 0.4026, 0.3857],
        [0.1988, 0.2936, 0.1322],
        [0.8525, 0.1780, 0.2909]])
```

-   `torch.zeros()`：创建数值皆为 0 的矩阵，类似的也可以创建数值都是 1 的矩阵，调用 `torch.one`
```python
# 创建一个数值皆是 0，类型为 long 的矩阵
zero_x = torch.zeros(5, 3, dtype=torch.long)
print(zero_x)
```

## 网络层


### 线性回归

[线性回归](深度学习/深度学习.md#线性回归)

[Pytorch基础训练](深度学习/Code-人工智能.md#Pytorch基础训练)

```python
# 输入特征x和目标值y
x = torch.tensor([[1.0], [2.0], [3.0], [4.0]])
y = torch.tensor([[2.0], [4.0], [6.0], [8.0]])
```

定义模型：

```python
class LinearRegression(nn.Module):
    def __init__(self, input_dim, output_dim):
        super(LinearRegression, self).__init__()
        self.linear = nn.Linear(input_dim, output_dim)

    def forward(self, x):
        return self.linear(x)

# 模型实例化
model = LinearRegression(1, 1)
```

### softmax

[softmax](深度学习/深度学习.md#softmax)

在PyTorch中，可以使用torch.nn.functional.softmax函数来进行softmax操作。softmax函数将一个向量映射成一个概率分布，使得向量中的元素都处于0和1之间，并且所有元素的和等于1。

以下是一个使用PyTorch的softmax函数的示例代码：

```python
import torch
import torch.nn.functional as F

# 输入向量
x = torch.tensor([1.0, 2.0, 3.0])

# 使用softmax函数
output = F.softmax(x, dim=0)

print(output)
```

在上述代码中，我们首先创建了一个输入向量x。然后通过调用F.softmax函数来对输入向量进行softmax操作。dim参数指定了在哪个维度上进行softmax操作，这里我们将其设置为0，表示对向量中的每个元素进行softmax操作。

运行上述代码，将会输出softmax操作后的结果。结果是一个包含三个元素的向量，每个元素都是一个概率值，且所有元素的和等于1。

注意：在PyTorch中，torch.nn.functional.softmax函数会直接对输入进行softmax操作，并返回softmax后的结果。相比之下，torch.nn.Softmax模块会返回一个Softmax函数的实例，需要通过调用该实例的forward方法来进行softmax操作。在大多数情况下，我们使用torch.nn.functional.softmax函数即可。


## 操作


```python
"""
几种加法操作：
"""
tensor3 = torch.ones(5, 3)
tensor4 = torch.ones(5, 3)
 
print(tensor3 + tensor4)
 
print(torch.add(tensor3, tensor4))
 
# 新声明一个 tensor 变量保存加法操作的结果
result = torch.empty(5, 3)
 
torch.add(tensor3, tensor4, out=result)
print(tensor3)
# 直接修改变量
tensor3.add_(tensor4)
print(tensor3)
```

```python
tensor([[2., 2., 2.],
        [2., 2., 2.],
        [2., 2., 2.],
        [2., 2., 2.],
        [2., 2., 2.]])
tensor([[2., 2., 2.],
        [2., 2., 2.],
        [2., 2., 2.],
        [2., 2., 2.],
        [2., 2., 2.]])
tensor([[1., 1., 1.],
        [1., 1., 1.],
        [1., 1., 1.],
        [1., 1., 1.],
        [1., 1., 1.]])
tensor([[2., 2., 2.],
        [2., 2., 2.],
        [2., 2., 2.],
        [2., 2., 2.],
        [2., 2., 2.]])

```


```python
"""
修改尺寸
"""
x = torch.randn(4, 4)
y = x.view(16)
# -1 表示除给定维度外的其余维度的乘积
z = x.view(-1, 8)
print(x.size(), y.size(), z.size())
print(x)
print(y)
print(z)
```

```python
torch.Size([4, 4]) torch.Size([16]) torch.Size([2, 8])
tensor([[-1.9878, -1.0786,  1.5617, -1.9625],
        [ 1.1109, -1.3799, -0.0208, -0.1064],
        [-1.5209, -0.4669, -0.5131, -0.9680],
        [ 1.2179, -0.4595,  0.0947,  0.5684]])
tensor([-1.9878, -1.0786,  1.5617, -1.9625,  1.1109, -1.3799, -0.0208, -0.1064,
        -1.5209, -0.4669, -0.5131, -0.9680,  1.2179, -0.4595,  0.0947,  0.5684])
tensor([[-1.9878, -1.0786,  1.5617, -1.9625,  1.1109, -1.3799, -0.0208, -0.1064],
        [-1.5209, -0.4669, -0.5131, -0.9680,  1.2179, -0.4595,  0.0947,  0.5684]])
```


```python
"""
和 Numpy 数组的转换
"""
import numpy as np
# Tensor 转换为 Numpy 数组
a = torch.ones(5)
# 共享内存
b = a.numpy()
# 新建变量
c = np.array(a)
print(type(b))
print(type(c))
#  Numpy 数组转换为 Tensor
 
a = np.ones(5)
b = torch.from_numpy(a)
print(type(a))
print(type(b))
 
```

```python
<class 'numpy.ndarray'>
<class 'numpy.ndarray'>
<class 'numpy.ndarray'>
<class 'torch.Tensor'>
```

## 计算

### 随机函数

随机函数的示例：

1. 生成随机整数：
```
import torch
random_int = torch.randint(low=0, high=10, size=(5,))
print(random_int)
```
输出示例：tensor([7, 5, 1, 9, 7])

2. 生成随机浮点数：
```
import torch
random_float = torch.rand(size=(3, 2))
print(random_float)
```
输出示例：tensor([[0.3551, 0.5042],
        [0.3932, 0.6807],
        [0.2734, 0.1050]])

3. 生成服从正态分布的随机数：
```
import torch
random_normal = torch.randn(size=(2, 3))
print(random_normal)
```
输出示例：tensor([[ 0.2323, -0.2769, -0.1031],
        [ 1.2114,  1.2016,  0.1766]])






### autograd 自动求导

![](Picture/Pasted%20image%2020230502235408.png)

### 前向传播和反向传播


使用Torch进行前向传播和反向传播的示例代码：

```python
import torch
import torch.nn as nn

# 定义一个简单的神经网络模型
class NeuralNetwork(nn.Module):
    def __init__(self):
        super(NeuralNetwork, self).__init__()
        self.linear = nn.Linear(2, 1)  # 输入维度为2，输出维度为1

    def forward(self, x):
        return self.linear(x)  # 线性映射

# 创建一个输入张量
x = torch.tensor([[1.0, 2.0], [3.0, 4.0]])

# 创建神经网络模型实例
model = NeuralNetwork()

# 进行前向传播
output = model(x)

# 打印前向传播的结果
print(output)

# 创建一个目标张量
target = torch.tensor([[0.0], [1.0]])

# 定义损失函数
loss_fn = nn.MSELoss()

# 计算损失
loss = loss_fn(output, target)

# 打印损失值
print(loss)

# 清零模型的梯度
model.zero_grad()

# 进行反向传播
loss.backward()

# 打印输入层到输出层的权重梯度
print(model.linear.weight.grad)
```

在这个示例中，我们首先定义了一个简单的神经网络模型，然后创建了一个输入张量x。接着我们使用模型进行前向传播，得到输出张量output。然后我们创建了一个目标张量target，定义了一个均方误差损失函数，计算出损失loss。接下来，我们将模型的梯度清零，然后进行反向传播，利用损失函数计算出模型中各个参数的梯度。最后，我们打印出输入层到输出层的权重梯度。


### 多层感知器

```python
class MLP(nn.Module):
    def __init__(self, input_dim, hidden_dim, output_dim):
        super(MLP, self).__init__()
        self.fc1 = nn.Linear(input_dim, hidden_dim)
        self.relu = nn.ReLU()
        self.fc2 = nn.Linear(hidden_dim, output_dim)

    def forward(self, x):
        out = self.fc1(x)
        out = self.relu(out)
        out = self.fc2(out)
        return out
```

在`__init__`方法中，我们定义了MLP的各个层，包括一个输入层、一个隐藏层和一个输出层。在`forward`方法中，我们将输入通过各个层传递，并返回输出。

接下来，你可以创建一个MLP模型的实例：

```python
input_dim = 10
hidden_dim = 20
output_dim = 2

model = MLP(input_dim, hidden_dim, output_dim)
```





## 数据处理

### 下载数据集

以MNIST为例

```python
import torch
from torchvision import datasets, transforms

# 定义数据转换
transform = transforms.Compose([
    transforms.ToTensor(),                  # 将图像转换为Tensor
    transforms.Normalize((0.1307,), (0.3081,))  # 对图像进行标准化
])

# 下载MNIST训练集
train_dataset = datasets.MNIST(root='./data', train=True, transform=transform, download=True)

# 下载MNIST测试集
test_dataset = datasets.MNIST(root='./data', train=False, transform=transform, download=True)
```





### 数据加载

### 数据预处理

## 查看每一层的结构

1.
```python
X = torch.rand(size = (1,1,28,28),dtype=torch.float32)

for layer in net:
    X = layer(X)
    print(layer.__class__.__name__, 'output shape: \t',X.shape)
```

```text
Reshape output shape: 	 torch.Size([1, 1, 28, 28])
Conv2d output shape: 	 torch.Size([1, 6, 28, 28])
Sigmoid output shape: 	 torch.Size([1, 6, 28, 28])
AvgPool2d output shape: 	 torch.Size([1, 6, 14, 14])
Conv2d output shape: 	 torch.Size([1, 16, 10, 10])
Sigmoid output shape: 	 torch.Size([1, 16, 10, 10])
AvgPool2d output shape: 	 torch.Size([1, 16, 5, 5])
Flatten output shape: 	 torch.Size([1, 400])
Linear output shape: 	 torch.Size([1, 120])
Sigmoid output shape: 	 torch.Size([1, 120])
Linear output shape: 	 torch.Size([1, 84])
Sigmoid output shape: 	 torch.Size([1, 84])
Linear output shape: 	 torch.Size([1, 10])
```

2.


```python
class net(nn.Module):
    def __init__(self):
        super(net,self).__init__()
        self.model = nn.Sequential(
            nn. Conv2d(1,2,3,1,2)
        )
    def forward(self, x):
        x = self.model(x)
        return x


test =  net().to(torch.device('cuda'))
summary(test,(1,28,28),batch_size=64)
```

```text
----------------------------------------------------------------
        Layer (type)               Output Shape         Param #
================================================================
            Conv2d-1            [64, 2, 30, 30]              20
================================================================
Total params: 20
Trainable params: 20
Non-trainable params: 0
----------------------------------------------------------------
Input size (MB): 0.19
Forward/backward pass size (MB): 0.88
Params size (MB): 0.00
Estimated Total Size (MB): 1.07
----------------------------------------------------------------
```

>[!note] 
>Conv2d结构为 (batch_size, channels, height,width)



## pytorch GPU训练


```python
import torch
import torchvision
from torch.utils.tensorboard import SummaryWriter

# from model import *
# 准备数据集
from torch import nn
from torch.utils.data import DataLoader

# 定义训练的设备
device =torch.device('cuda')if torch.cuda.is_available() else torch.device('cpu')

train_data = torchvision.datasets.CIFAR10(root="../data", train=True, transform=torchvision.transforms.ToTensor(),
                                          download=True)
test_data = torchvision.datasets.CIFAR10(root="../data", train=False, transform=torchvision.transforms.ToTensor(),
                                         download=True)

# length 长度
train_data_size = len(train_data)
test_data_size = len(test_data)
# 如果train_data_size=10, 训练数据集的长度为：10
print("训练数据集的长度为：{}".format(train_data_size))
print("测试数据集的长度为：{}".format(test_data_size))


# 利用 DataLoader 来加载数据集
train_dataloader = DataLoader(train_data, batch_size=64)
test_dataloader = DataLoader(test_data, batch_size=64)

# 创建网络模型
class Tudui(nn.Module):
    def __init__(self):
        super(Tudui, self).__init__()
        self.model = nn.Sequential(
            nn.Conv2d(3, 32, 5, 1, 2),
            nn.MaxPool2d(2),
            nn.Conv2d(32, 32, 5, 1, 2),
            nn.MaxPool2d(2),
            nn.Conv2d(32, 64, 5, 1, 2),
            nn.MaxPool2d(2),
            nn.Flatten(),
            nn.Linear(64*4*4, 64),
            nn.Linear(64, 10)
        )

    def forward(self, x):
        x = self.model(x)
        return x
tudui = Tudui()
tudui = tudui.to(device)

# 损失函数
loss_fn = nn.CrossEntropyLoss()
loss_fn = loss_fn.to(device)
# 优化器
# learning_rate = 0.01
# 1e-2=1 x (10)^(-2) = 1 /100 = 0.01
learning_rate = 1e-2
optimizer = torch.optim.SGD(tudui.parameters(), lr=learning_rate)

# 设置训练网络的一些参数
# 记录训练的次数
total_train_step = 0
# 记录测试的次数
total_test_step = 0
# 训练的轮数
epoch = 10

# 添加tensorboard
writer = SummaryWriter("../logs_train")

for i in range(epoch):
    print("-------第 {} 轮训练开始-------".format(i+1))

    # 训练步骤开始
    tudui.train()
    for data in train_dataloader:
        imgs, targets = data
        imgs = imgs.to(device)
        print(imgs.shape)
        targets = targets.to(device)
        outputs = tudui(imgs)
        loss = loss_fn(outputs, targets)

        # 优化器优化模型
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        total_train_step = total_train_step + 1
        if total_train_step % 100 == 0:
            print("训练次数：{}, Loss: {}".format(total_train_step, loss.item()))
            writer.add_scalar("train_loss", loss.item(), total_train_step)

    # 测试步骤开始
    tudui.eval()
    total_test_loss = 0
    total_accuracy = 0
    with torch.no_grad():
        for data in test_dataloader:
            imgs, targets = data
            imgs = imgs.to(device)
            targets = targets.to(device)
            outputs = tudui(imgs)
            loss = loss_fn(outputs, targets)
            total_test_loss = total_test_loss + loss.item()
            accuracy = (outputs.argmax(1) == targets).sum()
            total_accuracy = total_accuracy + accuracy

    print("整体测试集上的Loss: {}".format(total_test_loss))
    print("整体测试集上的正确率: {}".format(total_accuracy/test_data_size))
    writer.add_scalar("test_loss", total_test_loss, total_test_step)
    writer.add_scalar("test_accuracy", total_accuracy/test_data_size, total_test_step)
    total_test_step = total_test_step + 1

    torch.save(tudui, "tudui_{}.pth".format(i))
    print("模型已保存")

writer.close()

```