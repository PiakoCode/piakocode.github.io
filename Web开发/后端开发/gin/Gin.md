## 基础

**Gin** 示例1

```go

func solveFunc(c *gin.Context) {
    
}

func main () {
    r := gin.Default()
    r.GET("\info",solveFunc)
    
    r.Run(":8080")
}
```


**Gin** 示例2

```go
package main

import (
	"encoding/json"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/thinkerou/favicon"
)

// 中间件（拦截器），功能：预处理，登录授权、验证、分页、耗时统计...
// func myHandler() gin.HandlerFunc {
// 	return func(ctx *gin.Context) {
// 		// 通过自定义中间件，设置的值，在后续处理只要调用了这个中间件的都可以拿到这里的参数
// 		ctx.Set("usersesion", "userid-1")
// 		ctx.Next()  // 放行
// 		ctx.Abort() // 阻止
// 	}
// }

func main() {
	// 创建一个服务
	ginServer := gin.Default()
	ginServer.Use(favicon.New("./Arctime.ico")) // 这里如果添加了东西然后再运行没有变化，请重启浏览器，浏览器有缓存

	// 加载静态页面
	ginServer.LoadHTMLGlob("templates/*") // 一种是全局加载，一种是加载指定的文件

	// 加载资源文件
	ginServer.Static("/static", "./static")

	// 相应一个页面给前端

	ginServer.GET("/index", func(ctx *gin.Context) {
		ctx.HTML(http.StatusOK, "index.html", gin.H{
			"msg": "This data is come from Go background.",
		})
	})

	// 能加载静态页面也可以加载测试文件

	// 获取请求中的参数

	// 传统方式：usl?userid=xxx&username=conqueror712
	// Restful方式：/user/info/1/conqueror712

	// 下面是传统方式的例子
	ginServer.GET("/user/info", func(context *gin.Context) { // 这个格式是固定的
		userid := context.Query("userid")
		username := context.Query("username")
		// 拿到之后返回给前端
		context.JSON(http.StatusOK, gin.H{
			"userid":   userid,
			"username": username,
		})
	})
	// 此时执行代码之后，在浏览器中可以输入http://localhost:8081/user/info?userid=111&username=666
	// 就可以看到返回了JSON格式的数据

	// 下面是Restful方式的例子
	ginServer.GET("/user/info/:userid/:username", func(context *gin.Context) {
		userid := context.Param("userid")
		username := context.Param("username")
		// 还是一样，返回给前端
		context.JSON(http.StatusOK, gin.H{
			"userid":   userid,
			"username": username,
		})
	})
	// 指定代码后，只需要在浏览器中http://localhost:8081/user/info/111/555
	// 就可以看到返回了JSON数据了，非常方便简洁

	// 序列化
	// 前端给后端传递JSON
	ginServer.POST("/json", func(ctx *gin.Context) {
		// request.body
		data, _ := ctx.GetRawData()
		var m map[string]interface{} // Go语言中object一般用空接口来表示，可以接收anything
		// 顺带一提，1.18以上，interface可以直接改成any
		_ = json.Unmarshal(data, &m)
		ctx.JSON(http.StatusOK, m)
	})
	// 用apipost或者postman写一段json传到localhost:8081/json里就可以了
	/*
		json示例：
		{
			"name": "Conqueror712",
			"age": 666,
			"address": "Mars"
		}
	*/
	// 看到后端的实时响应里面接收到数据就可以了

	// 处理表单请求 这些都是支持函数式编程，Go语言特性，可以把函数作为参数传进来
	ginServer.POST("/user/add", func(ctx *gin.Context) {
		username := ctx.PostForm("username")
		password := ctx.PostForm("password")
		ctx.JSON(http.StatusOK, gin.H{
			"msg":      "ok",
			"username": username,
			"password": password,
		})
	})

	// 路由
	ginServer.GET("/test", func(ctx *gin.Context) {
		// 重定向 -> 301
		ctx.Redirect(301, "https://conqueror712.gitee.io/conqueror712.gitee.io/")
	})
	// http://localhost:8081/test

	// 404
	ginServer.NoRoute(func(ctx *gin.Context) {
		ctx.HTML(404, "404.html", nil)
	})

	// 路由组暂略

	// 服务器端口，用服务器端口来访问地址
	ginServer.Run(":8081") // 不写的话默认是8080，也可以更改
}
```
[Gin样例](Gin样例.md)

**API用法示例**：`https://gin-gonic.com/zh-cn/docs/examples/`

`gin.Context`是gin最重要的一部分，它能传递request信息、验证和序列化JSON....

## 实现RESTful形式
```go


// declaration of album  
type album struct {  
    ID     string  `json:"id"`  
    Title  string  `json:"title"`  
    Artist string  `json:"artist"`  
    Price  float64 `json:"price"`  
}  
  
// albums slice to seed record album data.
var albums = []album {  
    {ID: "1", Title: "Blue Train", Artist: "John Coltrane", Price: 56.99},  
    {ID: "2", Title: "Jeru", Artist: "Gerry Mulligan", Price: 17.99},  
    {ID: "3", Title: "Sarah Vaughan and Clifford Brown", Artist: "Sarah Vaughan", Price: 39.99},  
}  
  
func getAlbums(c *gin.Context) {  
    c.IndentedJSON(http.StatusOK, albums)  
}  
  
func postAlbums(c *gin.Context) {  
    var newAlbum album  
    // 绑定JSON  
    if err := c.BindJSON(&newAlbum); err != nil {  
        fmt.Println("BindJSON error", err)  
    }  
  
    albums = append(albums, newAlbum)  
    c.IndentedJSON(http.StatusCreated, newAlbum)  
  
}  
  
func getAlbumByID(c *gin.Context) {  
    id := c.Param("id")  
  
    for _, a := range albums {  
        if a.ID == id {  
            c.IndentedJSON(http.StatusOK, a)  
            return  
        }  
    }    c.IndentedJSON(http.StatusNotFound, gin.H{"message": "album not found"})  
}  
  
func main() {  
    router := gin.Default()  
    router.GET("/albums", getAlbums)  
    router.GET("/albums/:id", getAlbumByID)  
    router.POST("/albums", postAlbums)  
  
    router.Run("localhost:8080")  
}
```

## 与Gorm共同使用

[Gorm样例](Gorm样例.md)
[Gin + Gorm](Gin%20+%20Gorm.md)


## other

`BindJSON()` 和 `shouldBindJSON()` 区别

`BindJSON()` 是 `c.MustBindWith(obj, binding.JSON)` 的简写
`shouldBindJSON()` 是 `c.ShouldBindWith(obj, binding.JSON)` 的简写

`BindJSON()` 会在header中写一个400的状态码，而`shouldBindJSON()`不会

参考:
[Gin + Gorm实战CRUD丨学习记录 - 掘金 (juejin.cn)](https://juejin.cn/post/7192053234620432441#heading-9)