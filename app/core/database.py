import os

from dotenv import load_dotenv
from tortoise import Tortoise

# 加载环境变量
load_dotenv()

# 数据库配置
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite://db.sqlite3")

# Tortoise-ORM 配置，用于 Aerich 迁移工具
TORTOISE_ORM = {
    "connections": {"default": DATABASE_URL},
    "apps": {
        "models": {
            "models": [
                "app.system.models.user",
                "app.system.models.role",
                "app.system.models.user_role",
                "app.common.models.operation_log",
                "app.dtn.models.graph_db",
                "app.dtn.models.machine_account",
                "app.dim.models.dim_db"
            ],
            "default_connection": "default",
        },
    },
}


# 初始化 Tortoise-ORM
async def init_db():
    """初始化数据库连接"""
    print(f"开始初始化数据库，连接字符串: {DATABASE_URL}")

    # 初始化 Tortoise-ORM
    await Tortoise.init(
        db_url=DATABASE_URL,
        modules={
            "models": [
                "app.system.models.user",
                "app.system.models.role",
                "app.system.models.user_role",
                "app.common.models.operation_log",
                "app.dtn.models.graph_db",
                "app.dtn.models.machine_account",
                "app.dim.models.dim_db"
            ]
        },
        # 设置时区为上海时区
        timezone="Asia/Shanghai"
    )

    # 生成数据库表
    print("开始生成数据库表结构...")
    await Tortoise.generate_schemas()
    print("数据库连接成功，表结构已创建")

    # 执行数据库初始化脚本（插入默认数据）
    print("数据库初始化完成")


# 初始化默认数据
async def init_default_data():
    """初始化默认数据"""
    try:
        from app.system.models.user import User
        from app.system.models.role import Role
        from app.system.models.user_role import UserRole
        
        # 1. 初始化默认角色
        default_roles = [
            {"name": "超级管理员", "code": "super_admin", "description": "拥有所有权限"},
            {"name": "普通管理员", "code": "admin", "description": "拥有管理权限"},
            {"name": "普通用户", "code": "normal_user", "description": "拥有基础权限"},
        ]
        
        for role_data in default_roles:
            role_code = role_data["code"]
            if not await Role.filter(code=role_code).exists():
                await Role.create(**role_data)
                print(f"已添加默认角色: {role_data['name']} ({role_code})")
        
        # 2. 初始化默认用户
        default_users = [
            {
                "username": "super_admin",
                "email": "super_admin@example.com",
                "password_hash": (
                    "$2b$12$Jl5xQPsCcxu5BfI/MLLDAuy2rD8aywy2DZzNSe4NbBCjHWi3NIuOu"
                ),
                "full_name": "超级管理员",
                "roles": ["super_admin"]
            },
            {
                "username": "user",
                "email": "user@example.com",
                "password_hash": (
                    "$2b$12$Jl5xQPsCcxu5BfI/MLLDAuy2rD8aywy2DZzNSe4NbBCjHWi3NIuOu"
                ),
                "full_name": "普通用户",
                "roles": ["normal_user"]
            },
        ]
        
        for user_data in default_users:
            username = user_data["username"]
            user_roles = user_data.pop("roles")
            
            if not await User.filter(username=username).exists():
                user = await User.create(**user_data)
                print(f"已添加默认用户: {username}")
                
                # 为用户分配角色
                for role_code in user_roles:
                    role = await Role.filter(code=role_code).first()
                    if role:
                        await UserRole.create(user=user, role=role)
                        print(f"已为用户 {username} 分配角色: {role.name}")
        
        print("默认数据初始化完成")
    except Exception as e:
        print(f"初始化默认数据时出错: {e}")
        import traceback
        traceback.print_exc()


# 关闭数据库连接
async def close_db():
    """关闭数据库连接"""
    await Tortoise.close_connections()
