from tortoise import fields, models


class User(models.Model):
    """用户模型"""

    id = fields.IntField(pk=True, index=True)
    username = fields.CharField(max_length=50, unique=True, index=True, null=False)
    email = fields.CharField(max_length=100, unique=True, index=True, null=False)
    password_hash = fields.CharField(max_length=255, null=False)
    full_name = fields.CharField(max_length=100, null=True)
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)
    last_login_at = fields.DatetimeField(null=True)

    class Meta:
        table = "sys_user"
