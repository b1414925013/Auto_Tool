from tortoise import fields, models


class MachineAccount(models.Model):
    """机机账号模型"""

    id = fields.IntField(pk=True, index=True)
    ip = fields.CharField(max_length=100, null=False, index=True)  # IP地址
    port = fields.IntField(default=45339, null=False)  # 端口，默认45339
    account = fields.CharField(max_length=100, null=False)  # 账号
    password = fields.CharField(max_length=255, null=False)  # 密码
    type = fields.CharField(max_length=50, null=True)  # 类型
    machine_account = fields.CharField(max_length=100, null=True)  # 机机账号
    machine_password = fields.CharField(max_length=255, null=True)  # 机机密码
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)

    class Meta:
        table = "machine_account"