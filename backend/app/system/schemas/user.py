from datetime import datetime
from typing import Optional

from pydantic import BaseModel, EmailStr, Field


class UserBase(BaseModel):
    """用户基础模型"""
    username: str = Field(..., min_length=3, max_length=50, description="用户名")
    email: EmailStr = Field(..., description="邮箱")
    full_name: Optional[str] = Field(None, max_length=100, description="全名")


class UserCreate(UserBase):
    password: str = Field(..., min_length=6, max_length=50, description="密码")
    role_code: Optional[str] = Field(None, description="角色编码")


class UserUpdate(BaseModel):
    email: Optional[EmailStr] = Field(None, description="邮箱")
    full_name: Optional[str] = Field(None, max_length=100, description="全名")
    password: Optional[str] = Field(
        None, min_length=6, max_length=50, description="密码"
    )
    role_code: Optional[str] = Field(None, description="角色编码")


class User(UserBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime]
    last_login_at: Optional[datetime]
    role: str = Field(default="normal_user", description="角色编码")

    class Config:
        from_attributes = True


class UserLogin(BaseModel):
    username: str = Field(..., description="用户名")
    password: str = Field(..., description="密码")


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
