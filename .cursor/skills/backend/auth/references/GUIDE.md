# 认证授权指南

## 认证方案对比

| 方案 | 适用场景 | 优点 | 缺点 |
|------|----------|------|------|
| JWT | SPA、微服务 | 无状态、易扩展 | 难以注销 |
| Session | 传统 Web | 易于管理 | 难以扩展 |
| OAuth2 | 第三方登录 | 标准化 | 复杂 |
| SSO | 多应用 | 统一登录 | 成本高 |

## JWT 最佳实践

### Token 结构

```json
{
  "header": { "alg": "HS256", "typ": "JWT" },
  "payload": {
    "sub": "1234567890",
    "name": "John",
    "role": "admin",
    "iat": 1516239022,
    "exp": 1516242622
  }
}
```markdown

### 安全建议

1. 使用强密钥 (256-bit)
2. 设置合理过期时间
3. 存储在 httpOnly cookie
4. 验证所有 claims

## RBAC vs ABAC

### RBAC (基于角色)

```typescript
const permissions = {
  admin: ['read', 'write', 'delete'],
  user: ['read', 'write'],
  guest: ['read']
};
```markdown

### ABAC (基于属性)

```typescript
// 用户属性 + 资源属性 + 环境属性
canAccess = (user, resource, action) => {
  return user.department === resource.department 
    && user.level >= resource.requiredLevel;
}
```markdown

## 密码安全

### Bcrypt

```typescript
import bcrypt from 'bcrypt';

const hash = await bcrypt.hash(password, 10);
const match = await bcrypt.compare(password, hash);
```markdown

### 验证规则

- 最小长度 8 位
- 大小写 + 数字 + 特殊字符
- 不使用常见密码

## OAuth2 流程

```markdown
用户 → 授权页面 → 授权码 → 换 Access Token → 资源
```markdown

## 最佳实践

1. HTTPS 强制
2. 失败次数限制
3. 敏感操作二次验证
4. 审计日志

---
