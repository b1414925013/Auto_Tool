from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


class GraphDBBase(BaseModel):
    environment_id: str = Field(..., min_length=1, max_length=50, description="环境编号")
    jump_server_ip: str = Field(..., min_length=1, max_length=100, description="跳板机IP")
    jump_server_port: int = Field(default=22, ge=1, le=65535, description="跳板机端口")
    jump_server_account: str = Field(..., min_length=1, max_length=100, description="跳板机账号")
    jump_server_password: str = Field(..., min_length=1, max_length=255, description="跳板机密码")
    pass_core_ip: str = Field(..., min_length=1, max_length=100, description="pass-core节点IP")
    pass_core_port: int = Field(default=22, ge=1, le=65535, description="pass-core节点端口")
    pass_core_account: str = Field(..., min_length=1, max_length=100, description="pass-core节点账号")
    pass_core_password: str = Field(..., min_length=1, max_length=255, description="pass-core节点密码")
    pass_core_root_password: str = Field(..., min_length=1, max_length=255, description="pass-core节点root密码")


class GraphDBCreate(GraphDBBase):
    pass


class GraphDBUpdate(BaseModel):
    environment_id: Optional[str] = Field(None, min_length=1, max_length=50, description="环境编号")
    jump_server_ip: Optional[str] = Field(None, min_length=1, max_length=100, description="跳板机IP")
    jump_server_port: Optional[int] = Field(None, ge=1, le=65535, description="跳板机端口")
    jump_server_account: Optional[str] = Field(None, min_length=1, max_length=100, description="跳板机账号")
    jump_server_password: Optional[str] = Field(None, min_length=1, max_length=255, description="跳板机密码")
    pass_core_ip: Optional[str] = Field(None, min_length=1, max_length=100, description="pass-core节点IP")
    pass_core_port: Optional[int] = Field(None, ge=1, le=65535, description="pass-core节点端口")
    pass_core_account: Optional[str] = Field(None, min_length=1, max_length=100, description="pass-core节点账号")
    pass_core_password: Optional[str] = Field(None, min_length=1, max_length=255, description="pass-core节点密码")
    pass_core_root_password: Optional[str] = Field(None, min_length=1, max_length=255, description="pass-core节点root密码")
    graph_db_password: Optional[str] = Field(None, min_length=1, max_length=255, description="图数据库密码")


class GraphDB(GraphDBBase):
    id: int
    graph_db_password: str = Field(..., min_length=1, max_length=255, description="图数据库密码")
    created_at: datetime
    updated_at: Optional[datetime]

    class Config:
        from_attributes = True
