from typing import List

from fastapi import APIRouter, HTTPException, status

from app.dim.models.dim_db import (
    DimDB as DimDBModel,
)
from app.dim.schemas.dim_db import (
    DimDB,
    DimDBCreate,
    DimDBUpdate,
)

dim_db_router = APIRouter()


# 获取所有DIM数据库密码
@dim_db_router.get("/dim-db", response_model=List[DimDB])
async def get_dim_db(
    skip: int = 0,
    limit: int = 100,
):
    passwords = await DimDBModel.all().offset(skip).limit(limit)
    return passwords


# 根据 ID 获取DIM数据库密码
@dim_db_router.get("/dim-db/{db_id}", response_model=DimDB)
async def get_dim_db(
    db_id: int,
):
    password = await DimDBModel.filter(id=db_id).first()
    if password is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"DimDB with id {db_id} not found",
        )
    return password


# 新增DIM数据库密码
@dim_db_router.post(
    "/dim-db",
    response_model=DimDB,
    status_code=status.HTTP_201_CREATED,
)
async def create_dim_db(
    db: DimDBCreate,
):
    # 检查环境是否已存在
    existing_password = await DimDBModel.filter(
        environment=db.environment
    ).first()
    if existing_password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"DimDB for environment '{db.environment}' already exists",
        )

    # 创建新密码
    db_password = await DimDBModel.create(**db.model_dump())
    return db_password


# 更新DIM数据库密码
@dim_db_router.put("/dim-db/{db_id}", response_model=DimDB)
async def update_dim_db(
    db_id: int,
    db_update: DimDBUpdate,
):
    db_password = await DimDBModel.filter(id=db_id).first()
    if db_password is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"DimDB with id {db_id} not found",
        )

    # 检查环境是否已被其他记录使用
    if (
        db_update.environment
        and db_update.environment != db_password.environment
    ):
        existing_password = await DimDBModel.filter(
            environment=db_update.environment
        ).first()
        if existing_password:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=(
                    f"DimDB for environment '{db_update.environment}' "
                    "already exists"
                ),
            )

    # 更新密码
    update_data = db_update.model_dump(exclude_unset=True)
    await db_password.update_from_dict(update_data)
    await db_password.save()
    return db_password


# 删除DIM数据库密码
@dim_db_router.delete(
    "/dim-db/{db_id}", status_code=status.HTTP_204_NO_CONTENT
)
async def delete_dim_db(
    db_id: int,
):
    db_password = await DimDBModel.filter(id=db_id).first()
    if db_password is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"DimDB with id {db_id} not found",
        )

    await db_password.delete()
    return None
