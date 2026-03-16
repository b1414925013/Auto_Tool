from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


class MachineAccountBase(BaseModel):
    environment_id: str = Field(..., min_length=1, max_length=50, description="环境编号")
    ip: str = Field(..., min_length=1, max_length=100, description="IP地址")
    port: int = Field(default=45339, ge=1, le=65535, description="端口")
    account: str = Field(..., min_length=1, max_length=100, description="账号")
    password: str = Field(..., min_length=1, max_length=255, description="密码")
    type: Optional[str] = Field(None, max_length=50, description="类型")
    machine_account: Optional[str] = Field(None, max_length=100, description="机机账号")
    machine_password: Optional[str] = Field(None, max_length=255, description="机机密码")


class MachineAccountCreate(MachineAccountBase):
    pass


class MachineAccountUpdate(BaseModel):
    environment_id: Optional[str] = Field(None, min_length=1, max_length=50, description="环境编号")
    ip: Optional[str] = Field(None, min_length=1, max_length=100, description="IP地址")
    port: Optional[int] = Field(None, ge=1, le=65535, description="端口")
    account: Optional[str] = Field(None, min_length=1, max_length=100, description="账号")
    password: Optional[str] = Field(None, min_length=1, max_length=255, description="密码")
    type: Optional[str] = Field(None, max_length=50, description="类型")
    machine_account: Optional[str] = Field(None, max_length=100, description="机机账号")
    machine_password: Optional[str] = Field(None, max_length=255, description="机机密码")


class MachineAccount(MachineAccountBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True