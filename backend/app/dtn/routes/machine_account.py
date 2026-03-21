from typing import List, Optional, Dict, Any

from fastapi import APIRouter, HTTPException, status, Query

from app.dtn.models.machine_account import (
    MachineAccount as MachineAccountModel,
)
from app.dtn.schemas.machine_account import (
    MachineAccount,
    MachineAccountCreate,
    MachineAccountUpdate,
)

machine_account_router = APIRouter()


# 模拟第三方接口生成机机账号密码
def generate_machine_account(ip: str, port: int, account: str, password: str) -> tuple:
    """
    模拟第三方接口生成机机账号密码
    实际项目中，这里应该调用真实的第三方接口
    """
    # 模拟生成机机账号密码的逻辑
    # 这里只是简单的示例，实际项目中需要根据第三方接口的要求实现
    machine_account = f"machine_{ip.replace('.', '_')}_{port}"
    machine_password = f"MachinePass_{ip}_{port}_{account[-4:]}"
    return machine_account, machine_password


# 获取所有机机账号
@machine_account_router.get("/machine-account", response_model=Dict[str, Any])
async def get_machine_accounts(
    skip: int = 0,
    limit: int = 100,
    ip: Optional[str] = Query(None, description="根据IP查询"),
    environment_id: Optional[str] = Query(None, description="根据环境编号查询"),
):
    if ip:
        # 根据IP查询
        total = await MachineAccountModel.filter(ip=ip).count()
        accounts = await MachineAccountModel.filter(ip=ip).offset(skip).limit(limit)
    elif environment_id:
        # 根据环境编号查询
        total = await MachineAccountModel.filter(environment_id=environment_id).count()
        accounts = await MachineAccountModel.filter(environment_id=environment_id).offset(skip).limit(limit)
    else:
        # 获取所有
        total = await MachineAccountModel.all().count()
        accounts = await MachineAccountModel.all().offset(skip).limit(limit)
    # 将模型实例转换为 Pydantic 模型实例
    account_list = [MachineAccount.model_validate(account) for account in accounts]
    page = skip // limit + 1
    return {"total": total, "items": account_list, "page": page, "page_size": limit}


# 根据 ID 获取机机账号
@machine_account_router.get("/machine-account/{account_id}", response_model=MachineAccount)
async def get_machine_account(
    account_id: int,
):
    account = await MachineAccountModel.filter(id=account_id).first()
    if account is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"MachineAccount with id {account_id} not found",
        )
    # 将模型实例转换为 Pydantic 模型实例
    return MachineAccount.model_validate(account)


# 新增机机账号
@machine_account_router.post(
    "/machine-account",
    response_model=MachineAccount,
    status_code=status.HTTP_201_CREATED,
)
async def create_machine_account(
    account: MachineAccountCreate,
):
    # 检查IP是否已存在
    existing_account = await MachineAccountModel.filter(
        ip=account.ip
    ).first()
    if existing_account:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"MachineAccount for IP '{account.ip}' already exists",
        )
    
    # 检查环境编号是否已存在
    existing_env = await MachineAccountModel.filter(
        environment_id=account.environment_id
    ).first()
    if existing_env:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"MachineAccount for environment ID '{account.environment_id}' already exists",
        )

    # 调用第三方接口生成机机账号密码
    # 注意：这里使用的是模拟函数，实际项目中需要调用真实的第三方接口
    machine_account, machine_password = generate_machine_account(
        account.ip, account.port, account.account, account.password
    )

    # 创建新账号
    db_account = await MachineAccountModel.create(
        **account.model_dump(),
        machine_account=machine_account,
        machine_password=machine_password
    )
    # 将模型实例转换为 Pydantic 模型实例
    return MachineAccount.model_validate(db_account)


# 更新机机账号
@machine_account_router.put("/machine-account/{account_id}", response_model=MachineAccount)
async def update_machine_account(
    account_id: int,
    account_update: MachineAccountUpdate,
    regenerate: bool = Query(False, description="是否重新生成机机账号密码"),
):
    db_account = await MachineAccountModel.filter(id=account_id).first()
    if db_account is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"MachineAccount with id {account_id} not found",
        )

    # 检查IP是否已被其他记录使用
    if (
        account_update.ip
        and account_update.ip != db_account.ip
    ):
        existing_account = await MachineAccountModel.filter(
            ip=account_update.ip
        ).first()
        if existing_account:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=(
                    f"MachineAccount for IP '{account_update.ip}' "
                    "already exists"
                ),
            )
    
    # 检查环境编号是否已被其他记录使用
    if (
        account_update.environment_id
        and account_update.environment_id != db_account.environment_id
    ):
        existing_env = await MachineAccountModel.filter(
            environment_id=account_update.environment_id
        ).first()
        if existing_env:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=(
                    f"MachineAccount for environment ID '{account_update.environment_id}' "
                    "already exists"
                ),
            )

    # 更新账号
    update_data = account_update.model_dump(exclude_unset=True)
    
    # 如果需要重新生成机机账号密码
    if regenerate:
        # 获取最新的IP、端口、账号、密码
        ip = update_data.get('ip', db_account.ip)
        port = update_data.get('port', db_account.port)
        account = update_data.get('account', db_account.account)
        password = update_data.get('password', db_account.password)
        
        # 调用第三方接口重新生成机机账号密码
        machine_account, machine_password = generate_machine_account(
            ip, port, account, password
        )
        
        # 更新机机账号密码
        update_data['machine_account'] = machine_account
        update_data['machine_password'] = machine_password

    await db_account.update_from_dict(update_data)
    await db_account.save()
    # 将模型实例转换为 Pydantic 模型实例
    return MachineAccount.model_validate(db_account)


# 删除机机账号
@machine_account_router.delete(
    "/machine-account/{account_id}", status_code=status.HTTP_204_NO_CONTENT
)
async def delete_machine_account(
    account_id: int,
):
    db_account = await MachineAccountModel.filter(id=account_id).first()
    if db_account is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"MachineAccount with id {account_id} not found",
        )

    await db_account.delete()
    return None