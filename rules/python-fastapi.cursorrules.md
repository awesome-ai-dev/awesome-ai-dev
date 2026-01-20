# Python / FastAPI 开发规范

## 项目结构

```
app/
├── api/                    # API 路由
│   ├── v1/
│   │   ├── __init__.py
│   │   ├── endpoints/
│   │   │   ├── __init__.py
│   │   │   ├── users.py
│   │   │   └── auth.py
│   │   └── router.py
│   └── deps.py            # 依赖注入
├── core/                   # 核心配置
│   ├── __init__.py
│   ├── config.py          # 配置管理
│   ├── security.py        # 安全相关
│   └── exceptions.py      # 异常处理
├── models/                 # SQLAlchemy 模型
│   ├── __init__.py
│   └── user.py
├── schemas/                # Pydantic 模型
│   ├── __init__.py
│   ├── user.py
│   └── common.py
├── services/               # 业务逻辑
│   ├── __init__.py
│   └── user.py
├── db/                     # 数据库
│   ├── __init__.py
│   ├── session.py
│   └── base.py
├── utils/                  # 工具函数
│   └── __init__.py
├── main.py
└── __init__.py
```

---

## 代码风格

### 命名规范

```python
# ✅ 文件命名：snake_case
user_service.py
create_user.py

# ✅ 类命名：PascalCase
class UserService:
    pass

class CreateUserSchema:
    pass

# ✅ 函数/变量命名：snake_case
def get_user_by_id():
    pass

user_name = "john"

# ✅ 常量命名：UPPER_SNAKE_CASE
MAX_PAGE_SIZE = 100
DEFAULT_TIMEOUT = 5000

# ✅ 私有方法/变量：前缀下划线
def _validate_email():
    pass

_internal_cache = {}
```

### 类型注解（必须）

```python
# ✅ 所有函数必须有类型注解
from typing import Optional, List

def get_users(
    skip: int = 0,
    limit: int = 100,
    keyword: Optional[str] = None
) -> List[User]:
    pass

async def create_user(user_data: CreateUserSchema) -> User:
    pass
```

---

## Pydantic Schema 规范

### 基础 Schema

```python
from pydantic import BaseModel, Field, EmailStr, ConfigDict
from datetime import datetime
from typing import Optional

# 基础配置
class BaseSchema(BaseModel):
    model_config = ConfigDict(
        from_attributes=True,  # 支持 ORM 模型转换
        str_strip_whitespace=True,  # 自动去除空白
    )

# 创建 Schema
class UserCreate(BaseSchema):
    username: str = Field(..., min_length=3, max_length=50, description="用户名")
    email: EmailStr = Field(..., description="邮箱")
    password: str = Field(..., min_length=6, description="密码")
    phone: Optional[str] = Field(None, pattern=r"^1[3-9]\d{9}$", description="手机号")

# 更新 Schema（所有字段可选）
class UserUpdate(BaseSchema):
    username: Optional[str] = Field(None, min_length=3, max_length=50)
    email: Optional[EmailStr] = None
    phone: Optional[str] = None

# 响应 Schema
class UserResponse(BaseSchema):
    id: int
    username: str
    email: str
    created_at: datetime
    
    # 排除敏感字段
    model_config = ConfigDict(
        from_attributes=True,
        json_schema_extra={
            "example": {
                "id": 1,
                "username": "john_doe",
                "email": "john@example.com",
                "created_at": "2026-01-20T10:00:00"
            }
        }
    )
```

### 分页 Schema

```python
from typing import Generic, TypeVar, List
from pydantic import BaseModel, Field

T = TypeVar("T")

class PaginationParams(BaseModel):
    page: int = Field(1, ge=1, description="页码")
    page_size: int = Field(10, ge=1, le=100, description="每页数量")

class PaginatedResponse(BaseModel, Generic[T]):
    data: List[T]
    total: int
    page: int
    page_size: int
    total_pages: int

    @classmethod
    def create(
        cls, 
        data: List[T], 
        total: int, 
        page: int, 
        page_size: int
    ) -> "PaginatedResponse[T]":
        return cls(
            data=data,
            total=total,
            page=page,
            page_size=page_size,
            total_pages=(total + page_size - 1) // page_size
        )
```

---

## 统一响应格式

```python
# schemas/common.py
from typing import Generic, TypeVar, Optional
from pydantic import BaseModel

T = TypeVar("T")

class ApiResponse(BaseModel, Generic[T]):
    code: int = 200
    data: Optional[T] = None
    message: str = "success"

    @classmethod
    def success(cls, data: T = None, message: str = "success") -> "ApiResponse[T]":
        return cls(code=200, data=data, message=message)

    @classmethod
    def error(cls, code: int = 400, message: str = "error") -> "ApiResponse":
        return cls(code=code, data=None, message=message)
```

### 响应中间件

```python
# core/middleware.py
from fastapi import Request
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.responses import JSONResponse
import json

class ResponseMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        response = await call_next(request)
        
        # 只处理 JSON 响应
        if response.headers.get("content-type", "").startswith("application/json"):
            body = b""
            async for chunk in response.body_iterator:
                body += chunk
            
            data = json.loads(body)
            
            # 如果已经是标准格式，直接返回
            if isinstance(data, dict) and "code" in data:
                return response
            
            # 包装为标准格式
            wrapped = {
                "code": 200,
                "data": data,
                "message": "success"
            }
            return JSONResponse(content=wrapped, status_code=200)
        
        return response
```

---

## 路由规范

```python
# api/v1/endpoints/users.py
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List

from app.api.deps import get_db, get_current_user
from app.schemas.user import UserCreate, UserUpdate, UserResponse
from app.schemas.common import ApiResponse, PaginatedResponse
from app.services.user import UserService

router = APIRouter(prefix="/users", tags=["用户管理"])

@router.get("", response_model=PaginatedResponse[UserResponse], summary="获取用户列表")
async def get_users(
    page: int = Query(1, ge=1, description="页码"),
    page_size: int = Query(10, ge=1, le=100, description="每页数量"),
    keyword: str = Query(None, description="搜索关键词"),
    db: AsyncSession = Depends(get_db),
):
    """
    获取用户列表，支持分页和搜索
    """
    service = UserService(db)
    return await service.get_users(page=page, page_size=page_size, keyword=keyword)

@router.get("/{user_id}", response_model=UserResponse, summary="获取用户详情")
async def get_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
):
    """
    根据 ID 获取用户详情
    """
    service = UserService(db)
    user = await service.get_user(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.post("", response_model=UserResponse, status_code=status.HTTP_201_CREATED, summary="创建用户")
async def create_user(
    user_data: UserCreate,
    db: AsyncSession = Depends(get_db),
):
    """
    创建新用户
    """
    service = UserService(db)
    return await service.create_user(user_data)

@router.patch("/{user_id}", response_model=UserResponse, summary="更新用户")
async def update_user(
    user_id: int,
    user_data: UserUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """
    更新用户信息
    """
    service = UserService(db)
    return await service.update_user(user_id, user_data)

@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT, summary="删除用户")
async def delete_user(
    user_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    """
    删除用户
    """
    service = UserService(db)
    await service.delete_user(user_id)
```

---

## Service 层规范

```python
# services/user.py
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from typing import Optional

from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate
from app.schemas.common import PaginatedResponse
from app.core.security import get_password_hash

class UserService:
    def __init__(self, db: AsyncSession):
        self.db = db

    async def get_users(
        self, 
        page: int = 1, 
        page_size: int = 10, 
        keyword: Optional[str] = None
    ) -> PaginatedResponse:
        # 构建查询条件
        query = select(User).where(User.deleted_at.is_(None))
        count_query = select(func.count(User.id)).where(User.deleted_at.is_(None))
        
        if keyword:
            filter_condition = User.username.ilike(f"%{keyword}%")
            query = query.where(filter_condition)
            count_query = count_query.where(filter_condition)
        
        # 分页
        offset = (page - 1) * page_size
        query = query.offset(offset).limit(page_size).order_by(User.created_at.desc())
        
        # 执行查询
        result = await self.db.execute(query)
        users = result.scalars().all()
        
        total_result = await self.db.execute(count_query)
        total = total_result.scalar()
        
        return PaginatedResponse.create(
            data=users,
            total=total,
            page=page,
            page_size=page_size
        )

    async def get_user(self, user_id: int) -> Optional[User]:
        result = await self.db.execute(
            select(User).where(User.id == user_id, User.deleted_at.is_(None))
        )
        return result.scalar_one_or_none()

    async def create_user(self, user_data: UserCreate) -> User:
        # 检查邮箱是否已存在
        existing = await self.db.execute(
            select(User).where(User.email == user_data.email)
        )
        if existing.scalar_one_or_none():
            raise ValueError("Email already exists")
        
        user = User(
            **user_data.model_dump(exclude={"password"}),
            hashed_password=get_password_hash(user_data.password)
        )
        self.db.add(user)
        await self.db.commit()
        await self.db.refresh(user)
        return user

    async def update_user(self, user_id: int, user_data: UserUpdate) -> User:
        user = await self.get_user(user_id)
        if not user:
            raise ValueError("User not found")
        
        update_data = user_data.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(user, field, value)
        
        await self.db.commit()
        await self.db.refresh(user)
        return user

    async def delete_user(self, user_id: int) -> None:
        user = await self.get_user(user_id)
        if not user:
            raise ValueError("User not found")
        
        # 软删除
        user.deleted_at = datetime.utcnow()
        await self.db.commit()
```

---

## 异常处理

```python
# core/exceptions.py
from fastapi import HTTPException, Request
from fastapi.responses import JSONResponse
from pydantic import ValidationError

class BusinessException(Exception):
    def __init__(self, code: int, message: str):
        self.code = code
        self.message = message

# 全局异常处理器
async def business_exception_handler(request: Request, exc: BusinessException):
    return JSONResponse(
        status_code=200,
        content={
            "code": exc.code,
            "data": None,
            "message": exc.message
        }
    )

async def validation_exception_handler(request: Request, exc: ValidationError):
    return JSONResponse(
        status_code=422,
        content={
            "code": 422,
            "data": None,
            "message": "Validation error",
            "errors": exc.errors()
        }
    )

async def http_exception_handler(request: Request, exc: HTTPException):
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "code": exc.status_code,
            "data": None,
            "message": exc.detail
        }
    )

# main.py 中注册
app.add_exception_handler(BusinessException, business_exception_handler)
app.add_exception_handler(ValidationError, validation_exception_handler)
app.add_exception_handler(HTTPException, http_exception_handler)
```

---

## 依赖注入

```python
# api/deps.py
from typing import AsyncGenerator
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from jose import JWTError, jwt

from app.db.session import async_session
from app.core.config import settings
from app.models.user import User

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

async def get_db() -> AsyncGenerator[AsyncSession, None]:
    async with async_session() as session:
        try:
            yield session
        finally:
            await session.close()

async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: AsyncSession = Depends(get_db),
) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=["HS256"])
        user_id: int = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    result = await db.execute(select(User).where(User.id == user_id))
    user = result.scalar_one_or_none()
    
    if user is None:
        raise credentials_exception
    return user

def get_current_active_user(
    current_user: User = Depends(get_current_user),
) -> User:
    if not current_user.is_active:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user
```

---

## 配置管理

```python
# core/config.py
from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    # 应用配置
    APP_NAME: str = "My API"
    DEBUG: bool = False
    
    # 数据库
    DATABASE_URL: str
    
    # Redis
    REDIS_URL: Optional[str] = None
    
    # JWT
    SECRET_KEY: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days
    
    # CORS
    CORS_ORIGINS: list[str] = ["*"]
    
    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
```

---

## 数据库模型

```python
# models/base.py
from sqlalchemy import Column, DateTime, Integer
from sqlalchemy.ext.declarative import declared_attr
from sqlalchemy.sql import func

class TimestampMixin:
    created_at = Column(DateTime, server_default=func.now(), nullable=False)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now(), nullable=False)
    deleted_at = Column(DateTime, nullable=True)

# models/user.py
from sqlalchemy import Column, Integer, String, Boolean, Enum
from sqlalchemy.orm import relationship
import enum

from app.db.base import Base
from app.models.base import TimestampMixin

class UserRole(str, enum.Enum):
    USER = "user"
    ADMIN = "admin"

class User(Base, TimestampMixin):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), nullable=False)
    email = Column(String(100), unique=True, index=True, nullable=False)
    hashed_password = Column(String(255), nullable=False)
    role = Column(Enum(UserRole), default=UserRole.USER, nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)
    
    # 关联
    posts = relationship("Post", back_populates="author")
```

---

## 流式响应（大模型场景）

```python
from fastapi import APIRouter
from fastapi.responses import StreamingResponse
from typing import AsyncGenerator
import asyncio

router = APIRouter()

async def generate_stream() -> AsyncGenerator[str, None]:
    """生成 SSE 流式响应"""
    for i in range(10):
        data = {"chunk": i, "content": f"This is chunk {i}"}
        yield f"data: {json.dumps(data)}\n\n"
        await asyncio.sleep(0.1)
    yield "data: [DONE]\n\n"

@router.get("/stream")
async def stream_response():
    return StreamingResponse(
        generate_stream(),
        media_type="text/event-stream",
        headers={
            "Cache-Control": "no-cache",
            "Connection": "keep-alive",
        }
    )
```

---

## 测试规范

```python
# tests/conftest.py
import pytest
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker

from app.main import app
from app.api.deps import get_db
from app.db.base import Base

TEST_DATABASE_URL = "sqlite+aiosqlite:///./test.db"

@pytest.fixture
async def db_session():
    engine = create_async_engine(TEST_DATABASE_URL, echo=True)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    
    async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
    async with async_session() as session:
        yield session
    
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)

@pytest.fixture
async def client(db_session):
    def override_get_db():
        return db_session
    
    app.dependency_overrides[get_db] = override_get_db
    async with AsyncClient(app=app, base_url="http://test") as ac:
        yield ac
    app.dependency_overrides.clear()

# tests/test_users.py
@pytest.mark.asyncio
async def test_create_user(client: AsyncClient):
    response = await client.post("/api/v1/users", json={
        "username": "testuser",
        "email": "test@example.com",
        "password": "password123"
    })
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "test@example.com"
```

---

## 常见错误避免

```markdown
❌ 不要忘记 async/await 关键字
❌ 不要在同步函数中调用异步函数
❌ 不要忘记类型注解
❌ 不要直接暴露数据库模型，应该转换为 Schema
❌ 不要在路由中写业务逻辑，应该放在 Service 层
❌ 不要硬编码配置，使用 Settings 类
❌ 不要忘记处理数据库事务
❌ 不要在生产环境开启 Debug 模式
```
