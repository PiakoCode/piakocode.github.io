# opencv

#python #计算机视觉

## 图像变换


### 透视变换


```python
# 透视变换

# 1.定义变换矩阵M， 需要有输入源图像上的四个点和目标图像上的对应四个点。
# 输入源：approx_contours[0] shape:(4, 1, 2)
src_points = approx_contours[0]

src_points = src_points.reshape(4,2)
print(src_points)

def get_dst_points(src_points):
    points = np.zeros((4,2),dtype='float32')
    
    s = src_points.sum(axis=1) # 行的和 x+y
    # 左上角的点
    points[0] = src_points[np.argmin(s)]
    # 右下角的点
    points[2] = src_points[np.argmax(s)]
    
    d = np.diff(src_points,axis=1) # 行的差 x-y
    # 右上角的点 
    points[1] = src_points[np.argmin(d)]
    # 左下角的点
    points[3] = src_points[np.argmax(d)]
    
    # 必须按这个索引顺序
    
    w1 = np.sqrt((points[0][0] -points[1][0])**2 + (points[0][1]-points[1][1])**2)
    w2 = np.sqrt((points[2][0] -points[3][0])**2 + (points[2][1]-points[3][1])**2) 
    h1 = np.sqrt((points[0][0] -points[3][0])**2 + (points[0][1]-points[3][1])**2)
    h2 = np.sqrt((points[1][0] -points[2][0])**2 + (points[1][1]-points[2][1])**2)

    width = max(int(w1),int(w2))
    print(width)
    height = max(int(h1),int(h2))
    print(height)
    
    # -1 只是为了防止误差
    
    dst = np.array(
        [[0,0],[width-1,0],[width-1,height-1],[0,height-1]],
        dtype='float32'
    )
    return points,dst,width,height
    
src,dst,width,height =  get_dst_points(src_points)

M = cv.getPerspectiveTransform(src,dst)

warped = cv.warpPerspective(image,M,(width,height))
```



## 阈值化

### 简单阈值化

```python
ret, threshold = cv2.threshold(src, thresh, maxval, type)
```

- `src`：输入图像，应为灰度图像。
- `thresh`：阈值，大于阈值的像素被分配为 `maxval`，小于等于阈值的像素被分配为0。
- `maxval`：分配给大于阈值的像素的值。
- `type`：阈值化类型，可以是以下值之一：
	- `cv2.THRESH_BINARY`：二值阈值化。
	- `cv2.THRESH_BINARY_INV`：反向二值阈值化。
	- `cv2.THRESH_TRUNC`：截断阈值化，大于阈值的像素值设为阈值，小于等于阈值的像素值保持不变。
	- `cv2.THRESH_TOZERO`：超过阈值的像素值保持不变，小于等于阈值的像素值设为0。
	- `cv2.THRESH_TOZERO_INV`：低于阈值的像素值保持不变，大于阈值的像素值设为0。
- `ret`：计算得到的阈值。


### 自适应阈值化

```python
threshold = cv2.adaptiveThreshold(src, maxval, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, blockSize, C)
```

## inRange()

`cv2.inRange()`

多通道版的threshold


## 轮廓

```python
contours, _ = cv2.findContours(threshold, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
```

一般步骤：
1. 转换为灰度图像
2. 模糊处理
3. 阈值化处理
4. 查找轮廓
5. 处理轮廓


### 轮廓检索模式

1. **cv.RETR_EXTERNAL**：仅检测外部轮廓。也就是说，它只返回图像中的最外层轮廓，不关心内部的轮廓。

2. **cv.RETR_LIST**：检测所有的轮廓并将其存储在列表中，不进行任何层级关系的建立。
  
3. **cv.RETR_CCOMP**：检测所有的轮廓并将其存储在两层的层级结构中。顶层层级包含图像中的整体轮廓，而次层层级包含内部的孔洞轮廓。如果一个轮廓位于另一个轮廓的内部，则将其视为次层轮廓。

4. **cv.RETR_TREE**：检测所有的轮廓并将其存储在树形结构中。该模式可以检测轮廓之间的完整层级关系，包括父子关系和兄弟关系。

## 轮廓的相关方法

### 计算轮廓面积

*计算轮廓面积并排序*

```python
import cv2

# 读取图像并转换为灰度图像
image = cv2.imread('image.jpg')
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# 进行边缘检测
edges = cv2.Canny(gray, 100, 200)

# 查找轮廓
contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

# 按照轮廓面积进行排序
contours = sorted(contours, key=cv2.contourArea, reverse=True)

# 绘制轮廓
output = image.copy()
for i, contour in enumerate(contours):
	# -1 表示列表中的所有值
    cv2.drawContours(output, [contour], -1, (0, 255, 0), 2)
    cv2.putText(output, str(i + 1), tuple(contour[0][0]), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

# 显示结果
cv2.imshow('Contours', output)
cv2.waitKey(0)
cv2.destroyAllWindows()

```


### 轮廓近似处理

```python
# 对每个轮廓执行近似
approx_contours = []
for contour in contours:
    # 近似轮廓
    epsilon = 0.02 * cv2.arcLength(contour, True)
    approx = cv2.approxPolyDP(contour, epsilon, True)
    
    # 如果近似后的轮廓有4个点，则将其添加到结果列表中
    if len(approx) == 4:
        approx_contours.append(approx)

# 在原始图像上绘制筛选后的轮廓 
cv2.drawContours(image, approx_contours, -1, (0, 255, 0), 3)

```

### 轮廓最小矩形边界框

`cv2.boundingRect()` 用于计算给定轮廓的最小矩形边界框。它接受一个轮廓作为输入，并返回一个矩形坐标 `(x, y, width, height)`，该矩形是能够完全包围该轮廓的最小矩形。

```python
x, y, width, height = cv2.boundingRect(contour)
```

其中：

- `contour` 是一个表示轮廓的 NumPy 数组或列表。
- `(x, y)` 是矩形左上角的坐标。
- `width` 是矩形的宽度。
- `height` 是矩形的高度。



##  形态学运算

`cv2.morphologyEx()`

基本语法
```python
dst = cv2.morphologyEx(src, op, kernel)
```

参数说明：

- `src`：输入图像，可以是灰度图像或彩色图像。
- `op`：指定形态学运算的类型，可以是`cv2.MORPH_ERODE`（腐蚀）、`cv2.MORPH_DILATE`（膨胀）、`cv2.MORPH_OPEN`（开运算）、`cv2.MORPH_CLOSE`（闭运算）等。
- `kernel`：形态学操作的内核（结构元素），用于定义运算的形状和大小。


### HAT

HAT操作可以分为两种类型：顶帽（Top Hat）和黑帽（Black Hat）。

- 顶帽（Top Hat）: 顶帽操作实质上是原始图像与经过开运算的图像的差异。开运算是先对图像进行腐蚀操作，再进行膨胀操作。顶帽操作可以用于检测图像中的小尺寸亮区域（例如噪点）或者突出显示暗背景中的亮细节。

- 黑帽（Black Hat）: 黑帽操作是原始图像与经过闭运算的图像的差异。闭运算是先对图像进行膨胀操作，再进行腐蚀操作。黑帽操作可以用于检测图像中的小尺寸暗区域或者突出显示亮背景中的暗细节。

**TOP HAT**

```python
image = cv2.imread("input_image.jpg", 0)

tophat = cv2.morphologyEx(image, cv2.MORPH_TOPHAT, kernel)
```

**BLACK HAT**

```python
tophat = cv2.morphologyEx(image, cv2.MORPH_TOPHAT, kernel)
```


## 霍夫变换检测直线

#TODO

## 角点检测

### Harris角点检测

```python
corner_image = cv2.cornerHarris(gray, blockSize, ksize, k)
```

其中，`blockSize`是指角点检测中考虑邻域大小的参数，`ksize`是指Sobel求导中使用的窗口大小，`k`是Harris角点检测方程中的自由参数。

*对角点进行筛选和标记*

```python
threshold = 0.01 # 阈值可以根据实际情况进行调整
corner_image = cv2.dilate(corner_image, None) # 膨胀操作，增强角点
image[corner_image > threshold * corner_image.max()] = [0, 0, 255] # # 通过阈值筛选角点，并将角点标记为红色
```



## 光流估计

`calcOpticalFlowPyrLK` 函数的输入参数和返回值：

**输入参数：**
1. `prevImg`：先前帧的灰度图像或彩色图像。
2. `nextImg`：后续帧的灰度图像或彩色图像。
3. `prevPts`：先前帧中的特征点位置集合（2D点向量）。
4. `nextPts`：输出参数，估计出的后续帧中的特征点位置集合。
5. `status`：输出参数，状态向量，指示每个特征点是否成功跟踪。
6. `err`：输出参数，误差向量，指示每个特征点的跟踪误差。

*其他可选参数：*

1. `winSize`：窗口大小，表示搜索光流的区域大小。
2. `maxLevel`：金字塔层数的最大值，用于多尺度处理。
3. `criteria`：迭代停止准则，用于确定光流估计的精度和迭代次数。

**返回值：**

1. `nextPts` 向量将包含估计的后续帧中的特征点位置。
2. `status` 向量指示每个特征点的跟踪状态（1 表示成功跟踪，0 表示失败）。
3. `err` 向量包含每个特征点的跟踪误差。


代码示例：

```python
# 光流估计

import numpy as np
import cv2 as cv

cap = cv.VideoCapture("videos/720p_Road_traffic_video_for_object_detection_and_tracking.mp4")

# 定义Lucas-Kanade算法所需要的参数
lk_params = dict(winSize = (15,15),
                 maxLevel = 2)
print(good_new.shape)
# 定义随机颜色条
color = np.random.randint(0,255,(100,3))


# 拿到第一帧图像并作灰度处理
ret, first_frame = cap.read()
old_gray = cv.cvtColor(first_frame,cv.COLOR_BGR2GRAY)

# 角点检测 (Shi-Tomasi角点检测)
# mask：掩码
# maxCorners：角点最大数量
# qualityLevel：品质因子，特征值越大的越好，用来筛选，品质因子越大，得到的角点越少
# minDistance：最小距离，相当于在这个距离中有其他角点比这个角点更适合，就舍弃这个弱的角点
p0 = cv.goodFeaturesToTrack(old_gray, mask = None, maxCorners=100,qualityLevel=0.3,minDistance=7)


mask = np.zeros_like(first_frame)
while(True):
    ret,frame = cap.read()
    frame_gray = cv.cvtColor(frame,cv.COLOR_BGR2GRAY)
    print(frame_gray.shape)
    
    # 需要传入前一帧和当前图像以及前一帧检测到的角点
    p1, st, err = cv.calcOpticalFlowPyrLK(old_gray, frame_gray, p0,None, **lk_params)

    # st = 1 表示
    good_new = p1[st==1]
    good_old = p0[st==1]
    
    # 绘制轨迹
    for i,(new,old) in enumerate(zip(good_new,good_old)):
        a,b = new.ravel()
        
        c,d = old.ravel()
        a,b,c,d = int(a),int(b),int(c),int(d)
        mask = cv.line(mask,(a,b),(c,d),color[i].tolist(),2)
        frame = cv.circle(frame,(a,b),5,color[i].tolist(),-1)
    img = cv.add(frame,mask)
    
    cv.imshow('frame',img)
    if cv.waitKey(33) & 0xFF==ord('d'):
        break 
    
    # 更新
    old_gray = frame_gray.copy()
    p0 = good_new.reshape(-1,1,2)

cap.release()    
cv.destroyAllWindows()
    

```

## 多目标追踪


```python
# 多目标追踪器

import cv2 as cv
import numpy as np

cap = cv.VideoCapture(
    "videos/Road traffic video for object recognition [wqctLW0Hb_0].mp4"
)

# 实例化opencv 中的多目标追踪器
# trackers = cv.MultiTracker_create() opencv4 没有该方法
# 相关内容都要加上 legacy.
# 参见 https://github.com/opencv/opencv-python/issues/441
trackers = cv.legacy.MultiTracker_create()

# 将opencv已经实现了的追踪算法写入字典方便调用
OPENCV_OBJECT_TRACKERS = {
    "csrt": cv.legacy.TrackerCSRT_create,
    "kcf": cv.legacy.TrackerKCF_create,
    "boosting": cv.legacy.TrackerBoosting_create,
    "mil": cv.legacy.TrackerMIL_create,
    "tld": cv.legacy.TrackerTLD_create,
    "medianflow": cv.legacy.TrackerMedianFlow_create,
    "mosse": cv.legacy.TrackerMOSSE_create,
}

while True:
    # 取当前帧
    ret, frame = cap.read()

    if not ret:
        break

    # print(frame.shape)
    # resize
    h, w, c = frame.shape
    width = 1200
    r = width / float(w)
    dim = (width, int(h * r))
    frame = cv.resize(frame, dim, interpolation=cv.INTER_AREA)

    # 追踪结果
    success, boxes = trackers.update(frame)

    # 绘制矩形
    for box in boxes:
        x, y, w, h = [int(v) for v in box]
        cv.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)

    # 显示
    cv.imshow("Frame", frame)

    key = cv.waitKey(100) & 0xFF

    if key == ord('s'):
        # 选择区域
        box = cv.selectROI("Frame", frame, fromCenter=False, showCrosshair=True)

        # 创建一个新的追踪器
        tracker = OPENCV_OBJECT_TRACKERS['kcf']()
        trackers.add(tracker, frame, box)
    elif key == ord('q'):
        break
    
    
cap.release()
cv.destroyAllWindows()
```


## 其他

### getStructElement()

`cv2.getStructuringElement()` 用于创建图像处理中常用的结构元素

`cv2.getStructuringElement(shape, ksize, anchor)` 函数接受以下参数：

- `shape`：结构元素的形状，可以是 `cv2.MORPH_RECT`（矩形）、`cv2.MORPH_ELLIPSE`（椭圆形）或 `cv2.MORPH_CROSS`（十字形）。
- `ksize`：结构元素的大小，指定为一个二元组 `(width, height)` 或整数。如果是二元组，则分别表示结构元素的宽度和高度；如果是整数，则表示结构元素是一个正方形，边长为该整数。
- `anchor`（可选）：锚点的位置，默认为结构元素的中心。可以通过设置 `(x, y)` 的二元组来改变锚点的位置。


```python
kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (5, 5))
```



***

tips: 在使用matplotlib打开opencv的图像时，要将BGR转换为RGB（现在的似乎会自动转换）