import os
from contextlib import asynccontextmanager

import uvicorn
from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from fastapi.staticfiles import StaticFiles

from app.core.database import close_db, init_db, init_default_data
from app.common.middleware import OperationLogMiddleware
from app.system.routes import role, system
from app.dtn.routes import graph_db_router as dtn_router
from app.dim.routes import dim_db_router
from app.common.routes import common

# 加载环境变量
load_dotenv()


# 应用生命周期管理
@asynccontextmanager
async def lifespan(app: FastAPI):
    # 启动时初始化数据库
    try:
        await init_db()
        print("数据库连接成功，表结构已创建")

        # 异步执行默认数据初始化
        import asyncio

        asyncio.create_task(init_default_data())
        print("已启动默认数据初始化任务")
    except Exception as e:
        print(f"警告：数据库连接失败，部分功能可能无法使用: {e}")

    yield

    # 关闭时清理数据库连接
    await close_db()


# 初始化示例操作日志函数
async def init_sample_logs():
    """初始化示例操作日志"""
    print("开始初始化示例操作日志...")
    from datetime import datetime, timedelta

    from app.common.models.operation_log import OperationLog

    try:
        # 检查是否已有操作日志
        log_count = await OperationLog.all().count()
        print(f"当前操作日志数量: {log_count}")

        if log_count == 0:
            print("添加示例操作日志...")

            # 创建示例操作日志
            sample_logs = [
                {
                    "operation_type": "登录",
                    "operation_desc": "系统登录",
                    "username": "管理员",
                    "status": "success",
                },
                {
                    "operation_type": "查询",
                    "operation_desc": "查看图数据库密码列表",
                    "username": "管理员",
                    "status": "success",
                },
                {
                    "operation_type": "创建",
                    "operation_desc": "添加图数据库密码",
                    "username": "管理员",
                    "status": "success",
                },
                {
                    "operation_type": "查询",
                    "operation_desc": "查看用户列表",
                    "username": "管理员",
                    "status": "success",
                },
                {
                    "operation_type": "更新",
                    "operation_desc": "更新用户信息",
                    "username": "管理员",
                    "status": "success",
                },
            ]

            # 插入示例日志，设置不同的时间
            now = datetime.now()
            for i, log_data in enumerate(sample_logs):
                log_data["created_at"] = now - timedelta(
                    minutes=(len(sample_logs) - i) * 15
                )
                await OperationLog.create(**log_data)

            print(f"已添加 {len(sample_logs)} 条示例操作日志")
        else:
            print("已有操作日志，跳过初始化")
    except Exception as e:
        print(f"初始化示例操作日志失败: {e}")
        import traceback

        print(f"错误详情: {traceback.format_exc()}")


# 创建 FastAPI 应用
app = FastAPI(
    title=os.getenv("APP_NAME", "Auto_Tool"),
    version=os.getenv("APP_VERSION", "1.0.0"),
    description="Auto_Tool 后台管理系统",
    lifespan=lifespan,
)


# 配置 CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 生产环境中应该设置具体的前端域名
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 添加操作日志中间件
app.add_middleware(OperationLogMiddleware)

# 注册路由
app.include_router(dtn_router, prefix="/api/dtn", tags=["DTN"])
app.include_router(dim_db_router, prefix="/api/dtn", tags=["DIM"])
app.include_router(system.router, prefix="/api/system", tags=["系统管理"])
app.include_router(role.router, prefix="/api/role", tags=["角色管理"])
app.include_router(common.router, prefix="/api/common", tags=["公共"])

# 添加静态文件服务
app.mount("/frontend", StaticFiles(directory="frontend"), name="frontend")

# 根路径返回前端页面


@app.get("/")
async def read_root():
    # 在第一次访问时初始化示例数据
    await init_sample_logs()
    return FileResponse("frontend/index.html")


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
