from typing import List, Dict, Any

from fastapi import APIRouter, HTTPException, status, Depends

from app.system.models.role import Role
from app.system.models.user import User
from app.system.models.user_role import UserRole
from app.system.schemas.role import Role as RoleSchema, RoleCreate, RoleUpdate, UserWithRoles
from app.system.routes.system import get_current_user

router = APIRouter()


# 获取所有角色
@router.get("/roles", response_model=Dict[str, Any])
async def get_roles(
    skip: int = 0,
    limit: int = 100
):
    total = await Role.all().count()
    roles = await Role.all().offset(skip).limit(limit)
    # 将模型实例转换为 Pydantic 模型实例
    role_list = [RoleSchema.model_validate(role) for role in roles]
    return {"total": total, "items": role_list}


# 根据ID获取角色
@router.get("/roles/{role_id}", response_model=RoleSchema)
async def get_role(
    role_id: int
):
    role = await Role.filter(id=role_id).first()
    if not role:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"角色ID {role_id} 不存在"
        )
    # 将模型实例转换为 Pydantic 模型实例
    return RoleSchema.model_validate(role)


# 创建角色
@router.post("/roles", response_model=RoleSchema, status_code=status.HTTP_201_CREATED)
async def create_role(
    role: RoleCreate
):
    # 检查角色名称是否已存在
    existing_role = await Role.filter(name=role.name).first()
    if existing_role:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"角色名称 '{role.name}' 已存在"
        )
    
    # 检查角色编码是否已存在
    existing_role_code = await Role.filter(code=role.code).first()
    if existing_role_code:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"角色编码 '{role.code}' 已存在"
        )
    
    # 创建角色
    db_role = await Role.create(**role.model_dump())
    # 将模型实例转换为 Pydantic 模型实例
    return RoleSchema.model_validate(db_role)


# 更新角色
@router.put("/roles/{role_id}", response_model=RoleSchema)
async def update_role(
    role_id: int,
    role_update: RoleUpdate
):
    # 查找角色
    db_role = await Role.filter(id=role_id).first()
    if not db_role:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"角色ID {role_id} 不存在"
        )
    
    # 检查角色名称是否已被其他角色使用
    if role_update.name and role_update.name != db_role.name:
        existing_role = await Role.filter(name=role_update.name).first()
        if existing_role:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"角色名称 '{role_update.name}' 已存在"
            )
    
    # 检查角色编码是否已被其他角色使用
    if role_update.code and role_update.code != db_role.code:
        existing_role_code = await Role.filter(code=role_update.code).first()
        if existing_role_code:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"角色编码 '{role_update.code}' 已存在"
            )
    
    # 更新角色
    update_data = role_update.model_dump(exclude_unset=True)
    await db_role.update_from_dict(update_data)
    await db_role.save()
    # 将模型实例转换为 Pydantic 模型实例
    return RoleSchema.model_validate(db_role)


# 删除角色
@router.delete("/roles/{role_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_role(
    role_id: int
):
    # 查找角色
    db_role = await Role.filter(id=role_id).first()
    if not db_role:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"角色ID {role_id} 不存在"
        )
    
    # 检查是否有用户关联此角色
    user_roles_count = await UserRole.filter(role_id=role_id).count()
    if user_roles_count > 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="此角色已被用户使用，无法删除"
        )
    
    # 删除角色
    await db_role.delete()
    return None


# 为用户分配角色
@router.post("/users/{user_id}/roles", status_code=status.HTTP_201_CREATED)
async def assign_role_to_user(
    user_id: int,
    role_id: int
):
    # 检查用户是否存在
    user = await User.filter(id=user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"用户ID {user_id} 不存在"
        )
    
    # 检查角色是否存在
    role = await Role.filter(id=role_id).first()
    if not role:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"角色ID {role_id} 不存在"
        )
    
    # 检查用户是否已拥有此角色
    existing_user_role = await UserRole.filter(user_id=user_id, role_id=role_id).first()
    if existing_user_role:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="用户已拥有此角色"
        )
    
    # 分配角色
    await UserRole.create(user_id=user_id, role_id=role_id)
    return {"message": f"已为用户分配角色: {role.name}"}


# 移除用户角色
@router.delete("/users/{user_id}/roles/{role_id}", status_code=status.HTTP_204_NO_CONTENT)
async def remove_role_from_user(
    user_id: int,
    role_id: int
):
    # 查找用户角色关联
    user_role = await UserRole.filter(user_id=user_id, role_id=role_id).first()
    if not user_role:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="用户角色关联不存在"
        )
    
    # 移除角色
    await user_role.delete()
    return None


# 获取用户的角色
@router.get("/users/{user_id}/roles", response_model=List[RoleSchema])
async def get_user_roles(
    user_id: int
):
    # 检查用户是否存在
    user = await User.filter(id=user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"用户ID {user_id} 不存在"
        )
    
    # 获取用户角色
    user_roles = await user.user_roles.all().prefetch_related("role")
    roles = [ur.role for ur in user_roles]
    return roles


# 获取带角色的用户信息
@router.get("/users-with-roles/{user_id}", response_model=UserWithRoles)
async def get_user_with_roles(
    user_id: int
):
    # 检查用户是否存在
    user = await User.filter(id=user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"用户ID {user_id} 不存在"
        )
    
    # 获取用户角色
    user_roles = await user.user_roles.all().prefetch_related("role")
    roles = [ur.role for ur in user_roles]
    
    # 构建响应
    user_data = {
        "id": user.id,
        "username": user.username,
        "email": user.email,
        "full_name": user.full_name,
        "roles": roles,
        "created_at": user.created_at,
        "updated_at": user.updated_at
    }
    
    return UserWithRoles(**user_data)