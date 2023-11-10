



[Gin + Gorm实战CRUD](https://juejin.cn/post/7192053234620432441)

```go
package main  
  
import (  
    "fmt"  
    "github.com/gin-gonic/gin"
    "gorm.io/driver/mysql"
    "gorm.io/gorm"   
    "gorm.io/gorm/schema"   
    "net/http"   
    "time"
)  
  
func main() {  
   dsn := "root:SHILIub99325@tcp(127.0.0.1:3307)/go_database?charset=utf8mb4&parseTime=True&loc=Local"  
    db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{  
        Logger:logger.Default.LogMode(logger.Info), //设置log的模式
        NamingStrategy: schema.NamingStrategy{  
            SingularTable: true,  //表名不加s
        },  
    })  
  
    fmt.Println("database = ", db)  
    fmt.Println("error = ", err)  
  
    // 连接池  
    sqlDB, err := db.DB()  
  
    // 设置空闲连接池中的最大数量  
    sqlDB.SetMaxIdleConns(10)  
    // 设置打开数据库连接的最大数量  
    sqlDB.SetMaxOpenConns(100)  
    // 设置连接可复用的最大时间  
    sqlDB.SetConnMaxLifetime(10 * time.Second)  
  
    // 结构体  
    type List struct {  
        gorm.Model        //主键  
        Name       string `gorm:"type:varchar(20); not null" json:"name" binding:"required"`  
        State      string `gorm:"type:varchar(20); not null" json:"state" binding:"required"`  
        Phone      string `gorm:"type:varchar(20); not null" json:"phone" binding:"required"`  
        Email      string `gorm:"type:varchar(40); not null" json:"email" binding:"required"`  
        Address    string `gorm:"type:varchar(200); not null" json:"address" binding:"required"`  
    }  
  
    // 迁移  
    db.AutoMigrate(&List{})  
  
    r := gin.Default()  
    // 测试  
    //r.GET("/", func(c *gin.Context) {  
    //    c.IndentedJSON(http.StatusOK, gin.H{    //        "message": "请求成功",  
    //    })    //})  
    // 增  
    r.POST("/user/add", func(c *gin.Context) {  
        var data List  
        err := c.ShouldBindJSON(&data)  
        if err != nil {  
            c.JSON(200, gin.H{  
                "msg":  "添加失败",  
                "data": gin.H{},  
                "code": "400",  
            })  
        } else {  
            db.Create(&data)  
            c.JSON(200, gin.H{  
                "msg":  "success",  
                "data": data,  
                "code": "200",  
            })  
        }  
  
    })  
  
    // 删  
  
    r.DELETE("/user/delete/:id", func(c *gin.Context) {  
        var data []List  
  
        id := c.Param("id")  
  
        db.Where("id = ?", id).Find(&data)  
  
        if len(data) == 0 {  
            c.JSON(http.StatusOK, gin.H{  
                "msg":  "未查找到相关内容，删除失败",  
                "code": "400",  
            })  
        } else {  
            db.Delete(&data)  
            c.JSON(http.StatusOK, gin.H{  
                "msg":  "删除成功",  
                "code": 200,  
            })  
        }  
    })  
  
    // 改  
    r.PUT("/user/update/:id", func(c *gin.Context) {  
        var data List  
        id := c.Param("id")  
  
        db.Select("id").Where("id = ?", id).Find(&data)  
        if data.ID == 0 {  
            c.JSON(http.StatusOK, gin.H{  
                "msg":  "用户id没有找到",  
                "code": 400,  
            })  
        } else {  
  
            err := c.ShouldBindJSON(&data)  
            if err != nil {  
                c.JSON(http.StatusOK, gin.H{  
                    "mag":  "修改失败",  
                    "code": 400,  
                })  
            } else {  
                db.Where("id = ?", id).Updates(&data)  
                c.JSON(http.StatusOK, gin.H{  
                    "msg":  "修改成功",  
                    "code": 200,  
                })  
            }  
  
        }    })  
  
    // 查  
    r.GET("/user/list/:name", func(c *gin.Context) {  
        name := c.Param("name")  
        var dataList []List  
  
        db.Where("name = ?", name).Find(&dataList)  
  
        if len(dataList) == 0 {  
            c.JSON(http.StatusOK, gin.H{  
                "msg":  "未查找到相关内容",  
                "data": gin.H{},  
                "code": 400,  
            })  
        } else {  
            c.JSON(http.StatusOK, gin.H{  
                "msg":  "查询成功",  
                "data": dataList,  
                "code": 200,  
            })  
        }  
  
    })  
    // 分页查找
    // https://juejin.cn/post/7192053234620432441



  
    r.Run(":8080")  
}
```