# NestJS 开发规范

## 项目结构

```
src/
├── common/                 # 通用模块
│   ├── decorators/        # 自定义装饰器
│   ├── filters/           # 异常过滤器
│   ├── guards/            # 守卫
│   ├── interceptors/      # 拦截器
│   ├── pipes/             # 管道
│   └── dto/               # 通用 DTO
├── config/                # 配置模块
├── modules/               # 业务模块
│   └── [module-name]/
│       ├── dto/
│       ├── entities/
│       ├── [module].controller.ts
│       ├── [module].service.ts
│       ├── [module].module.ts
│       └── [module].spec.ts
├── prisma/                # Prisma 相关
│   ├── prisma.module.ts
│   └── prisma.service.ts
├── app.module.ts
└── main.ts
```

---

## 代码风格

### 命名规范

```typescript
// ✅ 文件命名：kebab-case
user-profile.controller.ts
create-user.dto.ts

// ✅ 类命名：PascalCase
export class UserProfileController {}
export class CreateUserDto {}

// ✅ 方法命名：camelCase，动词开头
findAll()
findOne()
create()
update()
remove()

// ✅ 常量命名：UPPER_SNAKE_CASE
const MAX_PAGE_SIZE = 100;
const DEFAULT_TIMEOUT = 5000;
```

### 模块组织

```typescript
// ✅ 每个模块必须包含
@Module({
  imports: [],      // 导入依赖模块
  controllers: [],  // 控制器
  providers: [],    // 服务提供者
  exports: [],      // 导出供其他模块使用
})
export class UserModule {}
```

---

## 接口规范

### 统一响应格式

```typescript
// common/interfaces/response.interface.ts
export interface ApiResponse<T = any> {
  code: number;
  data: T;
  message: string;
  timestamp: string;
}

// 成功响应
{
  "code": 200,
  "data": { ... },
  "message": "success",
  "timestamp": "2026-01-20T10:00:00.000Z"
}

// 错误响应
{
  "code": 400,
  "data": null,
  "message": "Validation failed",
  "timestamp": "2026-01-20T10:00:00.000Z"
}
```

### 响应拦截器

```typescript
// common/interceptors/transform.interceptor.ts
@Injectable()
export class TransformInterceptor<T> implements NestInterceptor<T, ApiResponse<T>> {
  intercept(context: ExecutionContext, next: CallHandler): Observable<ApiResponse<T>> {
    return next.handle().pipe(
      map((data) => ({
        code: 200,
        data,
        message: 'success',
        timestamp: new Date().toISOString(),
      })),
    );
  }
}
```

---

## DTO 规范

### 创建 DTO

```typescript
// ✅ 使用 class-validator 进行验证
import { IsString, IsEmail, IsOptional, MinLength, MaxLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ description: '用户名', example: 'john_doe' })
  @IsString()
  @MinLength(3)
  @MaxLength(20)
  username: string;

  @ApiProperty({ description: '邮箱', example: 'john@example.com' })
  @IsEmail()
  email: string;

  @ApiPropertyOptional({ description: '手机号' })
  @IsOptional()
  @IsString()
  phone?: string;
}
```

### 更新 DTO（使用 PartialType）

```typescript
// ✅ 复用 CreateDto，所有字段变为可选
import { PartialType } from '@nestjs/swagger';

export class UpdateUserDto extends PartialType(CreateUserDto) {}
```

### 查询 DTO

```typescript
// ✅ 分页查询标准化
export class PaginationDto {
  @ApiPropertyOptional({ default: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ default: 10 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  pageSize?: number = 10;
}

export class QueryUserDto extends PaginationDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  keyword?: string;
}
```

---

## Controller 规范

```typescript
@ApiTags('用户管理')
@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get()
  @ApiOperation({ summary: '获取用户列表' })
  findAll(@Query() query: QueryUserDto) {
    return this.userService.findAll(query);
  }

  @Get(':id')
  @ApiOperation({ summary: '获取用户详情' })
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.userService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: '创建用户' })
  create(@Body() createUserDto: CreateUserDto) {
    return this.userService.create(createUserDto);
  }

  @Patch(':id')
  @ApiOperation({ summary: '更新用户' })
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() updateUserDto: UpdateUserDto,
  ) {
    return this.userService.update(id, updateUserDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: '删除用户' })
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.userService.remove(id);
  }
}
```

---

## Service 规范

```typescript
@Injectable()
export class UserService {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(query: QueryUserDto) {
    const { page, pageSize, keyword } = query;
    const skip = (page - 1) * pageSize;

    const where: Prisma.UserWhereInput = keyword
      ? {
          OR: [
            { username: { contains: keyword } },
            { email: { contains: keyword } },
          ],
        }
      : {};

    const [data, total] = await Promise.all([
      this.prisma.user.findMany({
        where,
        skip,
        take: pageSize,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.user.count({ where }),
    ]);

    return {
      data,
      meta: {
        page,
        pageSize,
        total,
        totalPages: Math.ceil(total / pageSize),
      },
    };
  }

  async findOne(id: number) {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) {
      throw new NotFoundException(`User #${id} not found`);
    }
    return user;
  }

  async create(createUserDto: CreateUserDto) {
    // 检查唯一性
    const exists = await this.prisma.user.findUnique({
      where: { email: createUserDto.email },
    });
    if (exists) {
      throw new ConflictException('Email already exists');
    }
    return this.prisma.user.create({ data: createUserDto });
  }

  async update(id: number, updateUserDto: UpdateUserDto) {
    await this.findOne(id); // 确保存在
    return this.prisma.user.update({
      where: { id },
      data: updateUserDto,
    });
  }

  async remove(id: number) {
    await this.findOne(id);
    return this.prisma.user.delete({ where: { id } });
  }
}
```

---

## 异常处理

### 自定义业务异常

```typescript
// common/exceptions/business.exception.ts
export class BusinessException extends HttpException {
  constructor(message: string, code: number = 400) {
    super({ code, message, data: null }, HttpStatus.OK);
  }
}

// 使用
throw new BusinessException('余额不足', 10001);
```

### 全局异常过滤器

```typescript
// common/filters/http-exception.filter.ts
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();

    let code = 500;
    let message = 'Internal server error';

    if (exception instanceof HttpException) {
      code = exception.getStatus();
      const res = exception.getResponse();
      message = typeof res === 'string' ? res : (res as any).message;
    }

    response.status(200).json({
      code,
      data: null,
      message,
      timestamp: new Date().toISOString(),
    });
  }
}
```

---

## 认证与授权

### JWT 守卫

```typescript
// 使用 @nestjs/passport + passport-jwt
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  handleRequest(err: any, user: any) {
    if (err || !user) {
      throw new UnauthorizedException('Invalid token');
    }
    return user;
  }
}
```

### 角色守卫

```typescript
// common/decorators/roles.decorator.ts
export const Roles = (...roles: string[]) => SetMetadata('roles', roles);

// common/guards/roles.guard.ts
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const roles = this.reflector.get<string[]>('roles', context.getHandler());
    if (!roles) return true;
    
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    return roles.some((role) => user.roles?.includes(role));
  }
}

// 使用
@Get('admin')
@Roles('admin')
@UseGuards(JwtAuthGuard, RolesGuard)
getAdminData() {}
```

---

## 数据库规范（Prisma）

### Schema 设计

```prisma
model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  username  String
  password  String
  role      Role     @default(USER)
  status    Status   @default(ACTIVE)
  
  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")
  deletedAt DateTime? @map("deleted_at")
  
  posts     Post[]

  @@map("users")
  @@index([email])
}

enum Role {
  USER
  ADMIN
}

enum Status {
  ACTIVE
  INACTIVE
}
```

### 软删除

```typescript
// 使用 Prisma middleware 实现软删除
prisma.$use(async (params, next) => {
  if (params.model === 'User') {
    if (params.action === 'delete') {
      params.action = 'update';
      params.args['data'] = { deletedAt: new Date() };
    }
    if (params.action === 'findMany' || params.action === 'findFirst') {
      params.args['where'] = { ...params.args['where'], deletedAt: null };
    }
  }
  return next(params);
});
```

---

## 配置管理

```typescript
// config/configuration.ts
export default () => ({
  port: parseInt(process.env.PORT, 10) || 3000,
  database: {
    url: process.env.DATABASE_URL,
  },
  jwt: {
    secret: process.env.JWT_SECRET,
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
  },
  redis: {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT, 10) || 6379,
  },
});

// 使用
@Injectable()
export class AppService {
  constructor(private configService: ConfigService) {}

  getPort(): number {
    return this.configService.get<number>('port');
  }
}
```

---

## 测试规范

```typescript
describe('UserService', () => {
  let service: UserService;
  let prisma: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: PrismaService,
          useValue: {
            user: {
              findMany: jest.fn(),
              findUnique: jest.fn(),
              create: jest.fn(),
              update: jest.fn(),
              delete: jest.fn(),
              count: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  describe('findOne', () => {
    it('should return a user', async () => {
      const mockUser = { id: 1, username: 'test' };
      jest.spyOn(prisma.user, 'findUnique').mockResolvedValue(mockUser as any);
      
      const result = await service.findOne(1);
      expect(result).toEqual(mockUser);
    });

    it('should throw NotFoundException', async () => {
      jest.spyOn(prisma.user, 'findUnique').mockResolvedValue(null);
      
      await expect(service.findOne(999)).rejects.toThrow(NotFoundException);
    });
  });
});
```

---

## 常见错误避免

```markdown
❌ 不要在 Controller 中写业务逻辑，应该放在 Service 中
❌ 不要忘记添加 @Injectable() 装饰器
❌ 不要在 Service 中直接返回 Prisma 实体，应该转换为 DTO
❌ 不要忘记处理数据库唯一约束冲突
❌ 不要在生产环境暴露详细错误信息
❌ 不要硬编码配置，使用 ConfigService
❌ 不要忘记添加 Swagger 文档注解
```
