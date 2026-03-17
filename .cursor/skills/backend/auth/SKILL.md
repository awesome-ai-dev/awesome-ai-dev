---
name: backend-auth
description: 认证授权 - JWT/Session/OAuth2/SSO/RBAC
---

# 后端认证授权

## JWT

```typescript
// 生成 Token
import jwt from 'jsonwebtoken';

const token = jwt.sign(
  { userId: user.id, role: user.role },
  process.env.JWT_SECRET!,
  { expiresIn: '7d' }
);

// 验证 Token
const payload = jwt.verify(token, process.env.JWT_SECRET!) as JWTPayload;
```

## Session

```typescript
// Express Session
import session from 'express-session';

app.use(session({
  secret: 'secret',
  resave: false,
  saveUninitialized: false,
  cookie: { secure: true }
}));
```

## RBAC

```typescript
// 权限检查中间件
function checkPermission(permission: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    const user = req.user as User;
    if (!user.permissions.includes(permission)) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    next();
  };
}

// 使用
router.delete('/users/:id', checkPermission('user:delete'), deleteUser);
```

## OAuth2

```typescript
// GitHub 登录
import { Strategy as GitHubStrategy } from 'passport-github2';

passport.use(new GitHubStrategy({
  clientID: process.env.GITHUB_CLIENT_ID!,
  clientSecret: process.env.GITHUB_CLIENT_SECRET!,
  callbackURL: '/auth/github/callback'
}, (accessToken, refreshToken, profile, done) => {
  // 处理用户
}));
```

## 最佳实践

1. 密码加密 bcrypt
2. Token 过期时间
3. 刷新令牌机制
4. HTTPS only cookie

## 参考

- `.cursor/rules/nestjs.mdc`
