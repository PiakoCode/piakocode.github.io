# jwt-go

1. 自定义Claims结构体

```go
type Claims struct {
	Id       int64  `json:"id"`
	Username string `json:"username"`
	jwt.RegisteredClaims
}
```

2. 设置token的过期时间
```go
expireTime := time.Now().Add(24 * time.Hour)
```

3. 定义Secret
```go
var jwtKey = []byte("my_secret_key")
```


## 生成token

```go
import (
	"errors"
	"github.com/golang-jwt/jwt/v5"
	"time"
)

var jwtKey = []byte("my_secret_key")

type Claims struct {
	Id       int64  `json:"id"`
	Username string `json:"username"`
	jwt.RegisteredClaims
}

func GenerateToken(id int64, username string) (string, error) {
	expireTime := time.Now().Add(24 * time.Hour)

	c := Claims{
		Id:       id,
		Username: username,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expireTime), // 过期时间
			Issuer:    "todo_list",                    // 签发人
		},
	}

	// 使用指定的签名方法创建签名对象
	tokenClaims := jwt.NewWithClaims(jwt.SigningMethodHS256, c)

	// 签名产生token
	token, err := tokenClaims.SignedString(jwtKey)
	return token, err
}
```

## 检验token

```go
// ParseToken 解析JWT
func ParseToken(token string) (*Claims, error) {

	// 解析token
	tokenClaims, err := jwt.ParseWithClaims(token, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	if err != nil {
		return nil, err
	}

	// 校验token
	if claims, ok := tokenClaims.Claims.(*Claims); ok && tokenClaims.Valid {
		return claims, nil
	}

	return nil, errors.New("invalid token")
}
```