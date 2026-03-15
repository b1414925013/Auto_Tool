from typing import List

from fastapi import APIRouter, HTTPException, status

from app.dtn.models.graph_db import (
    GraphDB as GraphDBModel,
)
from app.dtn.schemas.graph_db import (
    GraphDB,
    GraphDBCreate,
    GraphDBUpdate,
)

graph_db_router = APIRouter()


# 获取所有图数据库密码
@graph_db_router.get("/graph-db", response_model=List[GraphDB])
async def get_graph_db(
    skip: int = 0,
    limit: int = 100,
):
    passwords = await GraphDBModel.all().offset(skip).limit(limit)
    return passwords


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
    return password


# 新增图数据库密码
@graph_db_router.post(
    "/graph-db",
    response_model=GraphDB,
    status_code=status.HTTP_201_CREATED,
)
async def create_graph_db(
    db: GraphDBCreate,
):
    # 检查环境是否已存在
    existing_password = await GraphDBModel.filter(
        environment=db.environment
    ).first()
    if existing_password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"GraphDB for environment '{db.environment}' already exists",
        )

    # 创建新密码
    db_password = await GraphDBModel.create(**db.model_dump())
    return db_password


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

    # 检查环境是否已被其他记录使用
    if (
        db_update.environment
        and db_update.environment != db_password.environment
    ):
        existing_password = await GraphDBModel.filter(
            environment=db_update.environment
        ).first()
        if existing_password:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=(
                    f"GraphDB for environment '{db_update.environment}' "
                    "already exists"
                ),
            )

    # 更新密码
    update_data = db_update.model_dump(exclude_unset=True)
    await db_password.update_from_dict(update_data)
    await db_password.save()
    return db_password


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
