from tortoise import BaseDBAsyncClient

RUN_IN_TRANSACTION = True


async def upgrade(db: BaseDBAsyncClient) -> str:
    return """
        CREATE TABLE IF NOT EXISTS "sys_user" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "username" VARCHAR(50) NOT NULL UNIQUE,
    "email" VARCHAR(100) NOT NULL UNIQUE,
    "password_hash" VARCHAR(255) NOT NULL,
    "full_name" VARCHAR(100),
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP
) /* 用户模型 */;
CREATE INDEX IF NOT EXISTS "idx_sys_user_usernam_29caba" ON "sys_user" ("username");
CREATE INDEX IF NOT EXISTS "idx_sys_user_email_451315" ON "sys_user" ("email");
CREATE TABLE IF NOT EXISTS "sys_role" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "name" VARCHAR(50) NOT NULL UNIQUE,
    "code" VARCHAR(50) NOT NULL UNIQUE,
    "description" TEXT,
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP
) /* 角色模型 */;
CREATE INDEX IF NOT EXISTS "idx_sys_role_name_616e55" ON "sys_role" ("name");
CREATE INDEX IF NOT EXISTS "idx_sys_role_code_6edd9d" ON "sys_role" ("code");
CREATE TABLE IF NOT EXISTS "sys_user_role" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "role_id" INT NOT NULL REFERENCES "sys_role" ("id") ON DELETE CASCADE,
    "user_id" INT NOT NULL REFERENCES "sys_user" ("id") ON DELETE CASCADE,
    CONSTRAINT "uid_sys_user_ro_user_id_48d541" UNIQUE ("user_id", "role_id")
) /* 用户角色关联表 */;
CREATE TABLE IF NOT EXISTS "operation_logs" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "operation_type" VARCHAR(50) NOT NULL,
    "operation_desc" VARCHAR(255) NOT NULL,
    "username" VARCHAR(50),
    "status" VARCHAR(20) NOT NULL  DEFAULT 'success',
    "request_url" VARCHAR(255),
    "request_method" VARCHAR(10),
    "ip_address" VARCHAR(50),
    "user_agent" VARCHAR(255),
    "error_message" TEXT,
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP
) /* 操作日志模型 */;
CREATE INDEX IF NOT EXISTS "idx_operation_l_operati_a5c5c0" ON "operation_logs" ("operation_type");
CREATE INDEX IF NOT EXISTS "idx_operation_l_usernam_5399e9" ON "operation_logs" ("username");
CREATE INDEX IF NOT EXISTS "idx_operation_l_created_de1446" ON "operation_logs" ("created_at");
CREATE TABLE IF NOT EXISTS "graph_db" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "environment" VARCHAR(50) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "description" VARCHAR(255),
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP
) /* 图数据库密码模型 */;
CREATE INDEX IF NOT EXISTS "idx_graph_db_environ_2632ad" ON "graph_db" ("environment");
CREATE TABLE IF NOT EXISTS "machine_account" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "environment_id" VARCHAR(50) NOT NULL,
    "ip" VARCHAR(100) NOT NULL,
    "port" INT NOT NULL  DEFAULT 45339,
    "account" VARCHAR(100) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "type" VARCHAR(50),
    "machine_account" VARCHAR(100),
    "machine_password" VARCHAR(255),
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP
) /* 机机账号模型 */;
CREATE INDEX IF NOT EXISTS "idx_machine_acc_environ_3c2d2b" ON "machine_account" ("environment_id");
CREATE INDEX IF NOT EXISTS "idx_machine_acc_ip_b2325e" ON "machine_account" ("ip");
CREATE TABLE IF NOT EXISTS "dim_db" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "environment" VARCHAR(50) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "description" VARCHAR(255),
    "created_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP
) /* DIM数据库模型 */;
CREATE INDEX IF NOT EXISTS "idx_dim_db_environ_2b3491" ON "dim_db" ("environment");
CREATE TABLE IF NOT EXISTS "aerich" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "version" VARCHAR(255) NOT NULL,
    "app" VARCHAR(100) NOT NULL,
    "content" JSON NOT NULL
);"""


async def downgrade(db: BaseDBAsyncClient) -> str:
    return """
        """


MODELS_STATE = (
    "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"
    "eQ=="
)
