# CSS基础

CSS的基本语法：

1.  选择器（Selector）：用于选择要应用样式的HTML元素，可以是标签名、类名、ID等等。
2.  声明（Declaration）：在选择器后面加上一对花括号，括号中包含一个或多个样式属性和值的键值对，用冒号分隔，用分号结束。
3.  属性（Property）：描述要修改的样式属性的名称，如font-size、color等。
4.  值（Value）：描述要设置的属性值，可以是长度、颜色、字体名称、背景图像等等。


```css
// 选择器样例
p {
  color: red;
  background-color: gray;
}
```

## 如何在HTML文件中使用CSS

1. 内联样式：在HTML元素中使用style属性，直接定义CSS样式。例如：

```html
<p style="color: red;">这是一段红色文字。</p>
```

   内联样式的优点是简单方便，可以直接针对单个元素定义样式，但是不利于复用和维护。

2. 内部样式表：在HTML文档头部使用`<style>`标签，定义CSS样式表。例如：
```html
<head>
    <style>
        p {
            color: red;
        }
    </style>
</head>

<body>
    <p>这是一段红色文字。</p>
</body>
```

   内部样式表的优点是可以定义多个样式，并且可以在多个页面中共享，但是会导致HTML文件变得臃肿，不利于页面的结构化和模块化。
    
3.  外部样式表：将CSS样式表放在外部文件中，通过HTML的`<link>`标签引用。例如：
```html
<head>
  <link rel="stylesheet" href="style.css">
</head>

<body>
  <p>这是一段红色文字。</p>
</body>
```
   外部样式表的优点是可以将样式与HTML文档分离，有利于页面的结构化和模块化，并且可以缓存，提高页面加载速度。同时，多个页面可以共用同一个外部样式表，有利于代码的复用和维护。

>[!note] 
>一般只用外部样式表


## 类

在CSS中，可以使用类选择器（以点`.`开头）来选择具有特定类名的元素。
```css
/* 类  */
.我不知道这是什么{
    color: red;
}
```

```html
<div class="我不知道这是什么">
        this is a doc
</div>
```


## 继承

CSS中的某些属性具有继承特性，这意味着当父元素应用这些属性时，子元素会继承这些属性的值。例如，`color`（文字颜色）、`font-family`（字体系列）、`font-size`（字体大小）等属性都具有继承特性。

*子元素的style > 父元素的style*

继承示例:

```css
body{
    color: red;
}
```

```html
<body>
    <p1>
        字体为红色
    </p1>
</body>

```

```html
<head>
        <div>
            字为红色
        </div>
</head>

<body>

</body>
```

可以通过使用`inherit`关键字来明确指定某个属性的值要继承自父元素，即使该属性默认不具有继承特性。

```html
<style>
  .parent {
    font-size: 16px;
  }

  .child {
    font-size: inherit;
  }
</style>

<div class="parent">
  <p class="child">This is a paragraph with inherited font size.</p>
</div>

```

>[!note]
>在CSS中，类（Class）之间并不存在直接的继承关系。CSS中的继承主要是指属性值的继承，而不是类本身的继承。


## 选择器

通过选择器，你可以根据元素的标签名、类名、ID、属性等特征来选择元素。以下是一些常见的选择器示例：

1. 标签选择器（Tag Selector）：通过标签名选择元素。例如，`p`选择器将选择所有`<p>`元素。
    
2. 类选择器（Class Selector）：通过类名选择元素。类选择器以`.`开头，后面跟着类名。例如，`.highlight`选择器将选择所有具有`highlight`类的元素。
    
3. ID选择器（ID Selector）：通过ID选择元素。ID选择器以`#`开头，后面跟着ID值。例如，`#header`选择器将选择具有`header` ID的元素。
    
4. 属性选择器（Attribute Selector）：通过元素的属性选择元素。属性选择器使用方括号`[]`来指定属性名和属性值。例如，`[type="text"]`选择器将选择所有`type`属性值为"text"的元素。
    
5. 后代选择器（Descendant Selector）：选择某个元素的后代元素。后代选择器使用空格分隔两个选择器。例如，`.container p`选择器将选择所有位于`.container`元素内部的`<p>`元素。
    
6. 子元素选择器（Child Selector）：选择某个元素的直接子元素。子元素选择器使用大于号`>`分隔两个选择器。例如，`.container > p`选择器将选择`.container`元素的直接子元素中的`<p>`元素。

7. 伪类选择器（Pseudo-Class Selectors）：伪类选择器可以用来选择元素的特定状态，比如悬停、被点击、被访问等。伪类选择器以冒号`:`开头，后面跟着伪类名称。例如，`:hover`选择器将选择鼠标悬停在元素上时的状态。

还有其他选择器，详细可查看：[CSS 选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Selectors)

关于HTML属性可以查看：[HTML属性](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Attributes)

**多个选择器的组合**

下选择器选择具有类名为`box`且位于`<div>`元素内部的直接子元素的`<p>`元素：

```css
div .box > p {
  /* 样式定义 */
}

```

选择器是CSS中非常重要的概念，通过合理运用选择器，你可以精确地选择并样式化页面中的元素。

ID
```HTML
<!-- 注意 ID应该在整个HTML文档中是唯一的 -->
<div id="123">id 为 123</div>
```

标签选择器与伪类选择器的组合
```css
h1:hover {
    color: red;
}
```

![](Picture/Pasted%20image%2020230510175203.png)

![](Picture/Pasted%20image%2020230510175221.png)

## 盒模型

每个HTML元素都可以被视为一个矩形的盒子，该盒子包括内容区域（content）、内边距（padding）、边框（border）和外边距（margin）四个部分，它们相互叠加形成最终的元素布局。

具体来说，盒模型的组成部分包括：

1. 内容区域（Content）：该区域包含元素的实际内容，例如文本、图像或其他嵌套的元素。内容区域的大小由元素的宽度（width）和高度（height）属性确定。
    
2. 内边距（Padding）：内边距是内容区域与边框之间的空白区域，用于控制内容与边框之间的间距。内边距的大小由元素的内边距属性（padding）控制。
    
3. 边框（Border）：边框是围绕内容和内边距的线条或样式。边框的大小、样式和颜色由元素的边框属性（border）控制。
    
4. 外边距（Margin）：外边距是元素与其周围元素之间的空白区域，用于控制元素之间的间距。外边距的大小由元素的外边距属性（margin）控制。
    

这些部分组成了一个完整的盒子，它们的尺寸和排列方式决定了元素在页面上的布局。CSS提供了一系列的属性和值，可以用于控制和调整盒模型的各个部分，从而实现所需的页面布局效果。

需要注意的是，盒模型的尺寸计算包括内容区域、内边距和边框，但不包括外边距。也就是说，元素的实际尺寸是内容区域、内边距和边框的总和。外边距用于控制元素之间的间距，不会影响元素自身的尺寸。

简单实例：
```css
.container {
  display: flex;
}
.container > div {
  flex: 1 1 auto;
}
```


## 动画


## FlexBox布局


## Grid网格布局

有些浏览器不支持，所以很少用