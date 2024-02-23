# Jwt结构

1. Header
2. Payload
3. Signature

HEADER

```json
{
    "alg": "HS256",
    "typ": "JWT"
}
```

alg 使用的算法
typ token的类型

PAYLOAD

```json
{
  "sub": "1234567890",
  "name": "John Doe",
  "iat": 1516239022
}
```

-   iss (issuer)：签发人
-   exp (expiration time)：过期时间
-   sub (subject)：主题
-   aud (audience)：受众
-   nbf (Not Before)：生效时间
-   iat (Issued At)：签发时间
-   jti (JWT ID)：编号

VERIFY SIGNATURE

```json
HMACSHA256(
  base64UrlEncode(header) + "." +
  base64UrlEncode(payload),
  $your-256-bit-secret
)
```