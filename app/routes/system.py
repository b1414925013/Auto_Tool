from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import HTTPBearer
from typing import List
from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext
import os
from dotenv import load_dotenv
from app.models.user import User as UserModel
from app.schemas.user import User, UserCreate, UserUpdate, UserLogin, Token

# 加载环境变量
load_dotenv()

router = APIRouter()

# 密码加密上下文
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# 安全配置
SECRET_KEY = os.getenv("SECRET_KEY", "your-secret-key-here")
ALGORITHM = os.getenv("ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30"))

# 密码加密
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    # 确保密码长度不超过72字节
    if len(password) > 72:
        password = password[:72]
    return pwd_context.hash(password)

# 创建访问令牌
def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

# 获取当前用户信息
async def get_current_user(token: str = Depends(HTTPBearer())):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token.credentials, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    # 从数据库获取用户信息
    user = await UserModel.filter(username=username).first()
    if user is None:
        raise credentials_exception
    
    return user

# 获取所有用户
@router.get("/users", response_model=List[User])
async def get_users(
    skip: int = 0,
    limit: int = 100,
):
    users = await UserModel.all().offset(skip).limit(limit)
    return users

# 获取当前用户信息
@router.get("/users/me", response_model=User)
async def get_me(
    current_user: UserModel = Depends(get_current_user)
):
    return current_user

# 根据 ID 获取用户
@router.get("/users/{user_id}", response_model=User)
async def get_user(
    user_id: int,
):
    user = await UserModel.filter(id=user_id).first()
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User with id {user_id} not found"
        )
    return user

# 新增用户
@router.post("/users", response_model=User, status_code=status.HTTP_201_CREATED)
async def create_user(
    user: UserCreate,
):
    # 检查用户名是否已存在
    existing_user = await UserModel.filter(
        username=user.username
    ).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"User with username '{user.username}' already exists"
        )
    
    # 检查邮箱是否已存在
    existing_email = await UserModel.filter(
        email=user.email
    ).first()
    if existing_email:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"User with email '{user.email}' already exists"
        )
    
    # 创建新用户
    # 截断密码长度，bcrypt最多支持72字节
    password = user.password
    if len(password) > 72:
        password = password[:72]
    hashed_password = get_password_hash(password)
    db_user = await UserModel.create(
        username=user.username,
        email=user.email,
        password_hash=hashed_password,
        full_name=user.full_name,
        role=user.role
    )
    return db_user

# 更新用户
@router.put("/users/{user_id}", response_model=User)
async def update_user(
    user_id: int,
    user_update: UserUpdate,
):
    db_user = await UserModel.filter(id=user_id).first()
    if db_user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User with id {user_id} not found"
        )
    
    # 检查邮箱是否已被其他用户使用
    if user_update.email and user_update.email != db_user.email:
        existing_email = await UserModel.filter(
            email=user_update.email
        ).first()
        if existing_email:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"User with email '{user_update.email}' already exists"
            )
    
    # 更新用户信息
    update_data = user_update.model_dump(exclude_unset=True)
    
    # 处理密码更新
    if "password" in update_data:
        # 截断密码长度，bcrypt最多支持72字节
        password = update_data.pop("password")
        if len(password) > 72:
            password = password[:72]
        update_data["password_hash"] = get_password_hash(password)
    
    await db_user.update_from_dict(update_data)
    await db_user.save()
    return db_user

# 删除用户
@router.delete("/users/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(
    user_id: int,
):
    db_user = await UserModel.filter(id=user_id).first()
    if db_user is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User with id {user_id} not found"
        )
    
    await db_user.delete()
    return None

# 用户登录
@router.post("/login", response_model=Token)
async def login(
    user_login: UserLogin,
):
    # 查找用户
    user = await UserModel.filter(username=user_login.username).first()
    if not user or not verify_password(user_login.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # 创建访问令牌
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    
    return {"access_token": access_token, "token_type": "bearer"}
