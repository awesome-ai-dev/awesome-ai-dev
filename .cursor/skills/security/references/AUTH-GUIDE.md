# 认证安全指南

## 1. 密码存储

### 最佳实践

```typescript
import bcrypt from 'bcrypt';
import crypto from 'crypto';

// ✅ 使用 bcrypt
const hashPassword = async (password: string): Promise<string> => {
  const salt = await bcrypt.genSalt(12);
  return bcrypt.hash(password, salt);
};

const verifyPassword = async (
  password: string,
  hash: string
): Promise<boolean> => {
  return bcrypt.compare(password, hash);
};

// ✅ 或使用 Argon2
import argon2 from 'argon2';

const hashPasswordArgon2 = async (password: string): Promise<string> => {
  return argon2.hash(password, {
    type: argon2.argon2id,
    memoryCost: 65536,
    timeCost: 3,
    parallelism: 4,
  });
};
```

### 密码策略

```typescript
const validatePassword = (
  password: string
): { valid: boolean; errors: string[] } => {
  const errors: string[] = [];
  
  if (password.length < 8) {
    errors.push('Password must be at least 8 characters');
  }
  if (!/[a-z]/.test(password)) {
    errors.push('Password must contain lowercase letters');
  }
  if (!/[A-Z]/.test(password)) {
    errors.push('Password must contain uppercase letters');
  }
  if (!/[0-9]/.test(password)) {
    errors.push('Password must contain numbers');
  }
  if (!/[!@#$%^&*]/.test(password)) {
    errors.push('Password must contain special characters');
  }
  
  return { valid: errors.length === 0, errors };
};
```

---

## 2. JWT 安全

### Token 生成

```typescript
import jwt from 'jsonwebtoken';
import crypto from 'crypto';

interface TokenPayload {
  userId: string;
  email: string;
  role: string;
}

const generateTokens = (payload: TokenPayload) => {
  const accessToken = jwt.sign(payload, process.env.JWT_SECRET!, {
    expiresIn: '15m', // 短有效期
    issuer: 'your-app',
  });

  const refreshToken = crypto.randomBytes(64).toString('hex');
  
  // 存储 refresh token
  storeRefreshToken(payload.userId, refreshToken);
  
  return { accessToken, refreshToken };
};
```

### Token 验证

```typescript
const verifyAccessToken = (token: string): TokenPayload => {
  return jwt.verify(token, process.env.JWT_SECRET!, {
    issuer: 'your-app',
    algorithms: ['HS256'],
  }) as TokenPayload;
};
```

### Token 刷新

```typescript
app.post('/auth/refresh', async (req, res) => {
  const { refreshToken } = req.cookies;
  
  if (!refreshToken) {
    return res.status(401).json({ error: 'Refresh token required' });
  }
  
  const user = await verifyRefreshToken(refreshToken);
  if (!user) {
    return res.status(401).json({ error: 'Invalid refresh token' });
  }
  
  const tokens = generateTokens({
    userId: user.id,
    email: user.email,
    role: user.role,
  });
  
  res.json(tokens);
});
```

---

## 3. Session 管理

### 安全的 Session 配置

```typescript
import session from 'express-session';
import RedisStore from 'connect-redis';

app.use(session({
  name: 'sessionId',
  secret: process.env.SESSION_SECRET!,
  resave: false,
  saveUninitialized: false,
  store: new RedisStore({ client: redisClient }),
  cookie: {
    secure: true, // HTTPS only
    httpOnly: true, // 防止 XSS
    sameSite: 'strict', // CSRF 防护
    maxAge: 3600000, // 1 hour
    domain: process.env.COOKIE_DOMAIN,
  },
}));
```

### Session 固定防护

```typescript
app.post('/auth/login', async (req, res) => {
  const user = await authenticate(req.body.email, req.body.password);
  
  // 登录前重新生成 session ID
  req.session.regenerate((err) => {
    if (err) {
      return res.status(500).json({ error: 'Login failed' });
    }
    
    req.session.user = {
      id: user.id,
      email: user.email,
      role: user.role,
    };
    
    res.json({ message: 'Logged in' });
  });
});

app.post('/auth/logout', (req, res) => {
  req.session.destroy((err) => {
    res.json({ message: 'Logged out' });
  });
});
```

---

## 4. 多因素认证 (MFA)

### TOTP 实现

```typescript
import speakeasy from 'speakeasy';
import QRCode from 'qrcode';

// 生成 MFA 密钥
const generateMFA = async (user: User) => {
  const secret = speakeasy.generateSecret({
    name: `YourApp (${user.email})`,
    issuer: 'YourApp',
  });
  
  // 保存 secret（加密存储）
  await saveMFASecret(user.id, secret.base32);
  
  // 生成 QR 码
  const qrCode = await QRCode.toDataURL(secret.otpauth_url);
  
  return { secret: secret.base32, qrCode };
};

// 验证 MFA
const verifyMFA = async (userId: string, token: string) => {
  const secret = await getMFASecret(userId);
  
  return speakeasy.totp.verify({
    secret,
    encoding: 'base32',
    token,
    window: 1, // 允许前后 1 个时间步
  });
};
```

---

## 5. 账户安全

### 登录尝试限制

```typescript
const loginRateLimit = new Map<string, { attempts: number; lockedUntil: number }>();

const checkLoginAttempt = (email: string): boolean => {
  const attempt = loginRateLimit.get(email);
  
  if (attempt && attempt.lockedUntil > Date.now()) {
    throw new Error('Account locked. Try again later.');
  }
  
  return true;
};

const recordFailedAttempt = (email: string) => {
  const attempt = loginRateLimit.get(email) || { attempts: 0, lockedUntil: 0 };
  attempt.attempts += 1;
  
  if (attempt.attempts >= 5) {
    attempt.lockedUntil = Date.now() + 15 * 60 * 1000; // 锁定 15 分钟
  }
  
  loginRateLimit.set(email, attempt);
};

const resetAttempts = (email: string) => {
  loginRateLimit.delete(email);
};
```

### 密码重置

```typescript
const requestPasswordReset = async (email: string) => {
  const user = await getUserByEmail(email);
  
  if (!user) {
    return; // 不泄露用户存在
  }
  
  const resetToken = crypto.randomBytes(32).toString('hex');
  const resetTokenHash = crypto.createHash('sha256').update(resetToken).digest('hex');
  
  // 存储哈希的 token（不要存储明文）
  await savePasswordResetToken(user.id, resetTokenHash, Date.now() + 3600000);
  
  // 发送邮件（包含明文 token）
  await sendEmail(email, 'Password Reset', `Reset token: ${resetToken}`);
};

const resetPassword = async (token: string, newPassword: string) => {
  const tokenHash = crypto.createHash('sha256').update(token).digest('hex');
  
  const resetRequest = await getPasswordResetRequest(tokenHash);
  
  if (!resetRequest || resetRequest.expiresAt < Date.now()) {
    throw new Error('Invalid or expired token');
  }
  
  const passwordHash = await bcrypt.hash(newPassword, 12);
  await updatePassword(resetRequest.userId, passwordHash);
  await deletePasswordResetRequest(tokenHash);
};
```

---

## 6. OAuth / Social Login

### 安全实现

```typescript
import { Strategy as GoogleStrategy } from 'passport-google-oauth20';

passport.use(new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID!,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    callbackURL: '/auth/google/callback',
  },
  async (accessToken, refreshToken, profile, done) => {
    // 验证 email
    const email = profile.emails?.[0]?.value;
    if (!email) {
      return done(new Error('No email provided'));
    }
    
    // 查找或创建用户
    let user = await findUserByGoogleId(profile.id);
    
    if (!user) {
      user = await createUser({
        googleId: profile.id,
        email,
        name: profile.displayName,
      });
    }
    
    return done(null, user);
  }
));
```
