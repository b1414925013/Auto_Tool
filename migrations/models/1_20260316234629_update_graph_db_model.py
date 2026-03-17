from tortoise import BaseDBAsyncClient

RUN_IN_TRANSACTION = True


async def upgrade(db: BaseDBAsyncClient) -> str:
    return """
        ALTER TABLE "graph_db" RENAME COLUMN "password" TO "graph_db_password";
        ALTER TABLE "graph_db" ADD "jump_server_password" VARCHAR(255) NOT NULL;
        ALTER TABLE "graph_db" ADD "jump_server_account" VARCHAR(100) NOT NULL;
        ALTER TABLE "graph_db" ADD "pass_core_port" INT NOT NULL DEFAULT 22;
        ALTER TABLE "graph_db" ADD "jump_server_port" INT NOT NULL DEFAULT 22;
        ALTER TABLE "graph_db" RENAME COLUMN "environment" TO "environment_id";
        ALTER TABLE "graph_db" ADD "pass_core_account" VARCHAR(100) NOT NULL;
        ALTER TABLE "graph_db" ADD "pass_core_password" VARCHAR(255) NOT NULL;
        ALTER TABLE "graph_db" ADD "pass_core_root_password" VARCHAR(255) NOT NULL;
        ALTER TABLE "graph_db" ADD "jump_server_ip" VARCHAR(100) NOT NULL;
        ALTER TABLE "graph_db" ADD "pass_core_ip" VARCHAR(100) NOT NULL;
        ALTER TABLE "graph_db" DROP COLUMN "description";
        CREATE INDEX "idx_graph_db_jump_se_974896" ON "graph_db" ("jump_server_ip");"""


async def downgrade(db: BaseDBAsyncClient) -> str:
    return """
        DROP INDEX IF EXISTS "idx_graph_db_jump_se_974896";
        ALTER TABLE "graph_db" RENAME COLUMN "environment_id" TO "environment";
        ALTER TABLE "graph_db" ADD "description" VARCHAR(255);
        ALTER TABLE "graph_db" RENAME COLUMN "graph_db_password" TO "password";
        ALTER TABLE "graph_db" DROP COLUMN "jump_server_password";
        ALTER TABLE "graph_db" DROP COLUMN "jump_server_account";
        ALTER TABLE "graph_db" DROP COLUMN "pass_core_port";
        ALTER TABLE "graph_db" DROP COLUMN "jump_server_port";
        ALTER TABLE "graph_db" DROP COLUMN "pass_core_account";
        ALTER TABLE "graph_db" DROP COLUMN "pass_core_password";
        ALTER TABLE "graph_db" DROP COLUMN "pass_core_root_password";
        ALTER TABLE "graph_db" DROP COLUMN "jump_server_ip";
        ALTER TABLE "graph_db" DROP COLUMN "pass_core_ip";"""


MODELS_STATE = (
    "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"
    "pmluLA=="
)
