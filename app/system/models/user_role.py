from tortoise import fields, models


class UserRole(models.Model):
    """用户角色关联表"""

    id = fields.IntField(pk=True, index=True)
    user = fields.ForeignKeyField("models.User", related_name="user_roles")
    role = fields.ForeignKeyField("models.Role", related_name="user_roles")
    created_at = fields.DatetimeField(auto_now_add=True)

    class Meta:
        table = "sys_user_role"
        unique_together = ("user", "role")