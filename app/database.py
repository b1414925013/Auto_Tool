import os

from dotenv import load_dotenv
from tortoise import Tortoise

# 加载环境变量
load_dotenv()

# 数据库配置
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite://db.sqlite3")


# 初始化 Tortoise-ORM
async def init_db():
    """初始化数据库连接"""
    print(f"开始初始化数据库，连接字符串: {DATABASE_URL}")

    # 初始化 Tortoise-ORM
    await Tortoise.init(
        db_url=DATABASE_URL,
        modules={
            "models": [
                "app.models.user",
                "app.models.operation_log",
                "app.models.graph_db_password",
            ]
        },
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
        from app.models.user import User

        # 检查是否存在 admin 用户
        admin_exists = await User.filter(username="admin").exists()
        # 检查是否存在 user 用户
        user_exists = await User.filter(username="user").exists()

        # 如果两个用户都存在，则跳过
        if admin_exists and user_exists:
            print("默认用户已存在，跳过初始化")
            return

        # 定义默认用户数据
        default_users = [
            {
                "username": "admin",
                "email": "admin@example.com",
                "password_hash": (
                    "$2b$12$Jl5xQPsCcxu5BfI/MLLDAuy2rD8aywy2DZzNSe4NbBCjHWi3NIuOu"
                ),
                "full_name": "系统管理员",
                "role": "admin",
            },
            {
                "username": "user",
                "email": "user@example.com",
                "password_hash": (
                    "$2b$12$Jl5xQPsCcxu5BfI/MLLDAuy2rD8aywy2DZzNSe4NbBCjHWi3NIuOu"
                ),
                "full_name": "测试用户",
                "role": "user",
            },
        ]

        # 逐个检查并添加用户
        for user_data in default_users:
            username = user_data["username"]
            if not await User.filter(username=username).exists():
                await User.create(**user_data)
                print(f"已添加默认用户: {username}")

        print("默认用户数据初始化完成")
    except Exception as e:
        print(f"初始化默认数据时出错: {e}")
        import traceback

        traceback.print_exc()


# 关闭数据库连接
async def close_db():
    """关闭数据库连接"""
    await Tortoise.close_connections()
