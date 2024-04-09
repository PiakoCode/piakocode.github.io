# Code-人工智能

#人工智能 #深度学习 #机器学习 #python 

## 深度学习

### Pytorch基础训练

[线性回归](深度学习.md#线性回归)

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

# 创建一个目标张量
target = torch.tensor([[0.0], [1.0]])

# 定义损失函数
loss_fn = nn.MSELoss() # 均方误差

# 定义优化器
optimizer = torch.optim.SGD(model.parameters(), lr=0.01)

# 进行训练
for epoch in range(100):
    # 清零模型的梯度
    optimizer.zero_grad()

    # 进行前向传播
    output = model(x)

    # 计算损失
    loss = loss_fn(output, target)

    # 进行反向传播
    loss.backward()

    # 更新模型参数
    optimizer.step()

    # 每隔10个epoch打印一次训练信息
    if (epoch+1) % 10 == 0:
        print('Epoch [{}/{}], Loss: {:.4f}'.format(epoch+1, 100, loss.item()))
```

这段训练代码会进行100个epoch的训练，并打印每个epoch的损失值。在训练过程中，首先清零模型的梯度，然后进行前向传播和损失计算，接着进行反向传播和参数更新，最后打印训练信息。

```python
# 使用训练好的模型进行预测
predicted = model(x).detach()

# 打印预测值
print(f'predicted: \n{predicted}')
print(f'target: \n{target}')
```

为这个结果绘图

```python
import matplotlib.pyplot as plt
import numpy as np

# 转为numpy格式
predicted = predicted.numpy()
target = target.numpy()

# 创建一个新的图形
plt.figure()

# 绘制预测值和目标值的图表
plt.plot(predicted,label = 'line predicted')
plt.plot(target,label = 'line target')
plt.legend(loc = 'upper left')
plt.show()
```

![](../Picture/Pasted%20image%2020230926193355.png)

如何使用matplotlib，参见[Python-matplotlib画图](Python-matplotlib画图.pdf)




