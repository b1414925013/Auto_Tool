from tortoise import fields, models


class Role(models.Model):
    """角色模型"""

    id = fields.IntField(pk=True, index=True)
    name = fields.CharField(max_length=50, unique=True, index=True, null=False)  # 角色名称
    code = fields.CharField(max_length=50, unique=True, index=True, null=False)  # 角色编码
    description = fields.TextField(null=True)  # 角色描述
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)

    class Meta:
        table = "sys_role"