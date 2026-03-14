from typing import List

from fastapi import APIRouter, HTTPException, status

from app.models.graph_db_password import (
    GraphDBPassword as GraphDBPasswordModel,
)
from app.schemas.graph_db_password import (
    GraphDBPassword,
    GraphDBPasswordCreate,
    GraphDBPasswordUpdate,
)

router = APIRouter()


# 获取所有图数据库密码
@router.get("/graph-db-passwords", response_model=List[GraphDBPassword])
async def get_graph_db_passwords(
    skip: int = 0,
    limit: int = 100,
):
    passwords = await GraphDBPasswordModel.all().offset(skip).limit(limit)
    return passwords


# 根据 ID 获取图数据库密码
@router.get("/graph-db-passwords/{password_id}", response_model=GraphDBPassword)
async def get_graph_db_password(
    password_id: int,
):
    password = await GraphDBPasswordModel.filter(id=password_id).first()
    if password is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"GraphDB password with id {password_id} not found",
        )
    return password


# 新增图数据库密码
@router.post(
    "/graph-db-passwords",
    response_model=GraphDBPassword,
    status_code=status.HTTP_201_CREATED,
)
async def create_graph_db_password(
    password: GraphDBPasswordCreate,
):
    # 检查环境是否已存在
    existing_password = await GraphDBPasswordModel.filter(
        environment=password.environment
    ).first()
    if existing_password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"GraphDB password for environment '{password.environment}' already exists",
        )

    # 创建新密码
    db_password = await GraphDBPasswordModel.create(**password.model_dump())
    return db_password


# 更新图数据库密码
@router.put("/graph-db-passwords/{password_id}", response_model=GraphDBPassword)
async def update_graph_db_password(
    password_id: int,
    password_update: GraphDBPasswordUpdate,
):
    db_password = await GraphDBPasswordModel.filter(id=password_id).first()
    if db_password is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"GraphDB password with id {password_id} not found",
        )

    # 检查环境是否已被其他记录使用
    if (
        password_update.environment
        and password_update.environment != db_password.environment
    ):
        existing_password = await GraphDBPasswordModel.filter(
            environment=password_update.environment
        ).first()
        if existing_password:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=(
                    f"GraphDB password for environment '{password_update.environment}' "
                    "already exists"
                ),
            )

    # 更新密码
    update_data = password_update.model_dump(exclude_unset=True)
    await db_password.update_from_dict(update_data)
    await db_password.save()
    return db_password


# 删除图数据库密码
@router.delete(
    "/graph-db-passwords/{password_id}", status_code=status.HTTP_204_NO_CONTENT
)
async def delete_graph_db_password(
    password_id: int,
):
    db_password = await GraphDBPasswordModel.filter(id=password_id).first()
    if db_password is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"GraphDB password with id {password_id} not found",
        )

    await db_password.delete()
    return None
