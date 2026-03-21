from tortoise import fields, models


class GraphDB(models.Model):
    """图数据库密码模型"""

    id = fields.IntField(pk=True, index=True)
    environment_id = fields.CharField(max_length=50, null=False, index=True)  # 环境编号
    jump_server_ip = fields.CharField(max_length=100, null=False, index=True)  # 跳板机IP
    jump_server_port = fields.IntField(default=22, null=False)  # 跳板机端口
    jump_server_account = fields.CharField(max_length=100, null=False)  # 跳板机账号
    jump_server_password = fields.CharField(max_length=255, null=False)  # 跳板机密码
    pass_core_ip = fields.CharField(max_length=100, null=False)  # pass-core节点IP
    pass_core_port = fields.IntField(default=22, null=False)  # pass-core节点端口
    pass_core_account = fields.CharField(max_length=100, null=False)  # pass-core节点账号
    pass_core_password = fields.CharField(max_length=255, null=False)  # pass-core节点密码
    pass_core_root_password = fields.CharField(max_length=255, null=False)  # pass-core节点root密码
    graph_db_password = fields.CharField(max_length=255, null=False)  # 图数据库密码
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)

    class Meta:
        table = "graph_db"
