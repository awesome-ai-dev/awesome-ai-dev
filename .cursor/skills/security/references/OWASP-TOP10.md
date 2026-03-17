# OWASP Top 10 (2021) 安全风险详解

## 1. A01:2021 - 访问控制失效 (Broken Access Control)

### 描述
用户能够超出其权限范围执行操作。访问控制依赖于用户身份和权限的强制执行。

### 常见漏洞
- 未验证用户身份
- 水平越权（访问其他用户资源）
- 垂直越权（普通用户执行管理员操作）

### 防御措施
```typescript
// ❌ 不安全的实现
app.get('/api/users/:id', (req, res) => {
  const user = db.users.find(req.params.id);
  res.json(user);
});

// ✅ 安全实现
app.get('/api/users/:id', authenticate, (req, res) => {
  if (req.user.id !== req.params.id && !req.user.isAdmin) {
    return res.status(403).json({ error: 'Forbidden' });
  }
  const user = db.users.find(req.params.id);
  res.json(user);
});
```

---

## 2. A02:2021 - 加密失败 (Cryptographic Failures)

### 描述
未正确加密敏感数据或使用弱加密算法。

### 常见漏洞
- 使用弱加密算法（MD5、SHA1）
- 未加密敏感数据
- 密钥管理不当

### 防御措施
```typescript
// ✅ 使用强加密算法
import bcrypt from 'bcrypt';

const hashPassword = async (password: string): Promise<string> => {
  return bcrypt.hash(password, 12); // 12 轮哈希
};

// ✅ 使用现代加密库
import crypto from 'crypto';

const encrypt = (text: string, key: string): string => {
  const iv = crypto.randomBytes(16);
  const cipher = crypto.createCipheriv('aes-256-gcm', Buffer.from(key), iv);
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  const authTag = cipher.getAuthTag();
  return iv.toString('hex') + ':' + authTag.toString('hex') + ':' + encrypted;
};
```

---

## 3. A03:2021 - 注入 (Injection)

### 描述
应用程序将不可信数据作为命令或查询的一部分发送给解释器。

### 常见漏洞
- SQL 注入
- NoSQL 注入
- 命令注入
- LDAP 注入

### 防御措施
```typescript
// ❌ SQL 注入漏洞
const query = `SELECT * FROM users WHERE email = '${email}'`;

// ✅ 参数化查询
const query = 'SELECT * FROM users WHERE email = $1';
const result = await db.query(query, [email]);

// ✅ 使用 ORM
const user = await prisma.user.findUnique({
  where: { email }
});
```

---

## 4. A04:2021 - 不安全设计 (Insecure Design)

### 描述
应用程序架构和设计层面的安全缺陷。

### 防御措施
- 威胁建模
- 安全设计模式
- 单元测试安全逻辑

---

## 5. A05:2021 - 安全配置错误 (Security Misconfiguration)

### 描述
系统、框架、应用的不安全默认配置。

### 常见问题
- 错误页面泄露敏感信息
- 开启调试模式
- 使用默认凭据
- CORS 配置不当

### 防御措施
```typescript
// ✅ 安全的 CORS 配置
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || [],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// ✅ 禁用错误详情
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    error: process.env.NODE_ENV === 'production' 
      ? 'Internal server error' 
      : err.message 
  });
});
```

---

## 6. A06:2021 - 危险组件 (Vulnerable Components)

### 描述
使用的库、框架、组件存在已知漏洞。

### 防御措施
```bash
# 定期审计依赖
npm audit
npm audit fix

# 使用 Snyk
npx snyk test

# 锁定依赖版本
npm shrinkwrap
```

---

## 7. A07:2021 - 身份认证失败 (Identification and Authentication Failures)

### 描述
身份验证和会话管理实现不当。

### 常见问题
- 弱密码策略
- Session fixation
- Session 泄露

### 防御措施
```typescript
// ✅ 安全的 Session 管理
app.use(session({
  name: 'sessionId',
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: true,
    httpOnly: true,
    sameSite: 'strict',
    maxAge: 3600000 // 1 hour
  }
}));

// ✅ 账户锁定
const MAX_ATTEMPTS = 5;
const LOCKOUT_TIME = 15 * 60 * 1000; // 15 minutes

async function authenticate(email, password) {
  const user = await getUser(email);
  
  if (user.lockedUntil > Date.now()) {
    throw new Error('Account temporarily locked');
  }
  
  if (!await bcrypt.compare(password, user.passwordHash)) {
    await incrementFailedAttempts(user);
    throw new Error('Invalid credentials');
  }
  
  await resetFailedAttempts(user);
  return user;
}
```

---

## 8. A08:2021 - 数据完整性失败 (Software and Data Integrity Failures)

### 描述
应用程序不保护数据完整性。

### 常见问题
- 不验证更新来源
- 使用不安全的反序列化
- CDN/CI 供应链攻击

### 防御措施
```typescript
// ✅ 验证数据完整性
import crypto from 'crypto';

function verifyWebhook(payload: string, signature: string, secret: string): boolean {
  const expected = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');
  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(expected)
  );
}
```

---

## 9. A09:2021 - 日志和监控不足 (Security Logging and Monitoring Failures)

### 描述
不足以检测、响应和恢复入侵。

### 防御措施
```typescript
// ✅ 关键操作日志
app.post('/api/transfer', authenticate, async (req, res) => {
  try {
    const result = await performTransfer(req.user.id, req.body);
    
    logger.info('Transfer completed', {
      userId: req.user.id,
      amount: req.body.amount,
      targetAccount: req.body.targetAccount,
      ip: req.ip,
      timestamp: new Date().toISOString()
    });
    
    res.json(result);
  } catch (error) {
    logger.error('Transfer failed', {
      userId: req.user.id,
      error: error.message,
      ip: req.ip
    });
    throw error;
  }
});
```

---

## 10. A10:2021 - 服务端请求伪造 (SSRF)

### 描述
应用程序从用户控制的 URL 获取资源而未验证。

### 防御措施
```typescript
// ❌ 存在 SSRF 漏洞
app.get('/proxy', async (req, res) => {
  const response = await fetch(req.query.url);
  res.json(response);
});

// ✅ 防御 SSRF
import { isIP, isPublic, parseURL } from '@net/fetch';

app.get('/proxy', async (req, res) => {
  const url = parseURL(req.query.url);
  
  // 验证是 HTTP/HTTPS
  if (!['http:', 'https:'].includes(url.protocol)) {
    return res.status(400).json({ error: 'Invalid protocol' });
  }
  
  // 验证不是内部 IP
  if (isIP(url.host)) {
    if (!isPublic(url.host)) {
      return res.status(400).json({ error: 'Internal IP not allowed' });
    }
  }
  
  const response = await fetch(url.toString());
  res.json(response);
});
```
