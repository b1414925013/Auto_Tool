from tortoise import fields, models


class GraphDBPassword(models.Model):
    """图数据库密码模型"""

    id = fields.IntField(pk=True, index=True)
    environment = fields.CharField(max_length=50, null=False, index=True)  # 环境名称
    password = fields.CharField(max_length=255, null=False)  # 密码
    description = fields.CharField(max_length=255, null=True)  # 描述
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)

    class Meta:
        table = "graph_db_passwords"
