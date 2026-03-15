from pydantic import BaseModel, Field
from datetime import datetime
from typing import List, Optional


class RoleBase(BaseModel):
    """角色基础模型"""
    name: str = Field(..., min_length=1, max_length=50, description="角色名称")
    code: str = Field(..., min_length=1, max_length=50, description="角色编码")
    description: Optional[str] = Field(None, description="角色描述")


class RoleCreate(RoleBase):
    """创建角色模型"""
    pass


class RoleUpdate(BaseModel):
    """更新角色模型"""
    name: Optional[str] = Field(None, min_length=1, max_length=50, description="角色名称")
    code: Optional[str] = Field(None, min_length=1, max_length=50, description="角色编码")
    description: Optional[str] = Field(None, description="角色描述")


class Role(RoleBase):
    """角色响应模型"""
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class UserRoleBase(BaseModel):
    """用户角色关联基础模型"""
    user_id: int
    role_id: int


class UserRoleCreate(UserRoleBase):
    """创建用户角色关联模型"""
    pass


class UserRole(UserRoleBase):
    """用户角色关联响应模型"""
    id: int
    created_at: datetime

    class Config:
        from_attributes = True


class UserWithRoles(BaseModel):
    """带角色的用户模型"""
    id: int
    username: str
    email: str
    full_name: Optional[str]
    roles: List[Role]
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True