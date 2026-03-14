from tortoise import fields, models
from datetime import datetime

class OperationLog(models.Model):
    """操作日志模型"""
    id = fields.IntField(pk=True, index=True)
    operation_type = fields.CharField(max_length=50, null=False, index=True)  # 操作类型
    operation_desc = fields.CharField(max_length=255, null=False)  # 操作描述
    username = fields.CharField(max_length=50, null=True, index=True)  # 操作用户
    status = fields.CharField(max_length=20, default="success", null=False)  # 操作状态 success/failed
    request_url = fields.CharField(max_length=255, null=True)  # 请求URL
    request_method = fields.CharField(max_length=10, null=True)  # 请求方法
    ip_address = fields.CharField(max_length=50, null=True)  # IP地址
    user_agent = fields.CharField(max_length=255, null=True)  # 用户代理
    error_message = fields.TextField(null=True)  # 错误信息
    created_at = fields.DatetimeField(auto_now_add=True, index=True)  # 创建时间

    class Meta:
        table = "operation_logs"
