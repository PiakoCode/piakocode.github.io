
基础
```go
package main

import (
	"fmt"
	"math/rand"
	"strconv"
	
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

type People struct {
	Name string
	Age  uint
}

// 实现接口 定义表名
func (p People) TableName() string {
	return "ppp"
}

func main() {

	dsn := "root:SHILIub99325@tcp(127.0.0.1:3307)/go_database?charset=utf8mb4&parseTime=True&loc=Local"
	db, err := gorm.Open(mysql.Open(dsn),&gorm.Config{
		Logger:logger.Default.LogMode(logger.Info), //设置log的模式
		})

	if err != nil {
		fmt.Println("failed to connect database.")
	}
	
    //  迁移 schema | 如果没有表会自动创建
	db.AutoMigrate(&People{}) 

	var peoples []People

	db.Create(&People{Name: "小明", Age: 12890}) //插入
	for i := 0; i < 5; i++ {
		name := strconv.Itoa(i)
		rand.Seed(int64(i))
		age := rand.Intn(100)
		peoples = append(peoples, People{Name: name, Age: uint(age)})
	}

	db.Create(peoples) //切片

	var people People
	db.First(&people, 1)

	fmt.Printf("%v\n", people) // 根据整型主键查找

}
```