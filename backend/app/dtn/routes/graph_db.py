from typing import List, Optional, Dict, Any

from fastapi import APIRouter, HTTPException, status, Query

from app.dtn.models.graph_db import (
    GraphDB as GraphDBModel,
)
from app.dtn.schemas.graph_db import (
    GraphDB,
    GraphDBCreate,
    GraphDBUpdate,
)

graph_db_router = APIRouter()


def generate_graph_db_password(environment_id: str, jump_server_ip: str, pass_core_ip: str) -> str:
    """
    生成图数据库密码
    根据环境编号、跳板机IP和pass-core节点IP计算生成图数据库密码
    
    Args:
        environment_id: 环境编号
        jump_server_ip: 跳板机IP
        pass_core_ip: pass-core节点IP
    
    Returns:
        生成的图数据库密码
    """
    # TODO: 实现具体的密码生成逻辑
    # 这里提供一个示例实现，实际使用时需要根据业务需求修改
    import hashlib
    
    # 组合输入参数
    combined_str = f"{environment_id}_{jump_server_ip}_{pass_core_ip}"
    
    # 使用SHA256哈希生成密码
    hash_obj = hashlib.sha256(combined_str.encode())
    password = hash_obj.hexdigest()[:32]  # 取前32位作为密码
    
    return password


# 获取所有图数据库密码
@graph_db_router.get("/graph-db", response_model=Dict[str, Any])
async def get_graph_db(
    skip: int = 0,
    limit: int = 100,
    environment_id: Optional[str] = Query(None, description="根据环境编号查询"),
    jump_server_ip: Optional[str] = Query(None, description="根据跳板机IP查询"),
):
    if environment_id:
        # 根据环境编号查询
        total = await GraphDBModel.filter(environment_id=environment_id).count()
        passwords = await GraphDBModel.filter(environment_id=environment_id).offset(skip).limit(limit)
    elif jump_server_ip:
        # 根据跳板机IP查询
        total = await GraphDBModel.filter(jump_server_ip=jump_server_ip).count()
        passwords = await GraphDBModel.filter(jump_server_ip=jump_server_ip).offset(skip).limit(limit)
    else:
        # 获取所有
        total = await GraphDBModel.all().count()
        passwords = await GraphDBModel.all().offset(skip).limit(limit)
    # 将模型实例转换为 Pydantic 模型实例
    password_list = [GraphDB.model_validate(password) for password in passwords]
    page = skip // limit + 1
    return {"total": total, "items": password_list, "page": page, "page_size": limit}


# 根据 ID 获取图数据库密码
@graph_db_router.get("/graph-db/{db_id}", response_model=GraphDB)
async def get_graph_db(
    db_id: int,
):
    password = await GraphDBModel.filter(id=db_id).first()
    if password is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"GraphDB with id {db_id} not found",
        )
    # 将模型实例转换为 Pydantic 模型实例
    return GraphDB.model_validate(password)


# 新增图数据库密码
@graph_db_router.post(
    "/graph-db",
    response_model=GraphDB,
    status_code=status.HTTP_201_CREATED,
)
async def create_graph_db(
    db: GraphDBCreate,
):
    # 检查环境编号是否已存在
    existing_password = await GraphDBModel.filter(
        environment_id=db.environment_id
    ).first()
    if existing_password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"GraphDB for environment ID '{db.environment_id}' already exists",
        )

    # 生成图数据库密码
    graph_db_password = generate_graph_db_password(
        db.environment_id,
        db.jump_server_ip,
        db.pass_core_ip
    )

    # 创建新密码
    db_data = db.model_dump()
    db_data['graph_db_password'] = graph_db_password
    db_password = await GraphDBModel.create(**db_data)
    # 将模型实例转换为 Pydantic 模型实例
    return GraphDB.model_validate(db_password)


# 更新图数据库密码
@graph_db_router.put("/graph-db/{db_id}", response_model=GraphDB)
async def update_graph_db(
    db_id: int,
    db_update: GraphDBUpdate,
):
    db_password = await GraphDBModel.filter(id=db_id).first()
    if db_password is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"GraphDB with id {db_id} not found",
        )

    # 检查环境编号是否已被其他记录使用
    if (
        db_update.environment_id
        and db_update.environment_id != db_password.environment_id
    ):
        existing_password = await GraphDBModel.filter(
            environment_id=db_update.environment_id
        ).first()
        if existing_password:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=(
                    f"GraphDB for environment ID '{db_update.environment_id}' "
                    "already exists"
                ),
            )

    # 更新密码
    update_data = db_update.model_dump(exclude_unset=True)
    
    # 如果更新了环境编号、跳板机IP或pass-core节点IP，重新生成图数据库密码
    if any(key in update_data for key in ['environment_id', 'jump_server_ip', 'pass_core_ip']):
        env_id = update_data.get('environment_id', db_password.environment_id)
        jump_ip = update_data.get('jump_server_ip', db_password.jump_server_ip)
        core_ip = update_data.get('pass_core_ip', db_password.pass_core_ip)
        update_data['graph_db_password'] = generate_graph_db_password(env_id, jump_ip, core_ip)
    
    await db_password.update_from_dict(update_data)
    await db_password.save()
    # 将模型实例转换为 Pydantic 模型实例
    return GraphDB.model_validate(db_password)


# 删除图数据库密码
@graph_db_router.delete(
    "/graph-db/{db_id}", status_code=status.HTTP_204_NO_CONTENT
)
async def delete_graph_db(
    db_id: int,
):
    db_password = await GraphDBModel.filter(id=db_id).first()
    if db_password is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"GraphDB with id {db_id} not found",
        )

    await db_password.delete()
    return None
