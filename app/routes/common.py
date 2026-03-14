import json
import platform
import sys
import time
from typing import Dict, List, Optional

import fastapi
from fastapi import APIRouter
from pydantic import BaseModel

from app.models.graph_db_password import GraphDBPassword
from app.models.operation_log import OperationLog
from app.models.user import User
from app.schemas.operation_log import OperationLogCreate, OperationLogResponse

router = APIRouter()


# 自定义任务请求模型
class CustomTaskRequest(BaseModel):
    base_url: str
    username: str
    password: str
    params: Optional[Dict] = None


# JSONPath验证请求模型
class JsonPathRequest(BaseModel):
    json_data: str
    expression: str


# 时间戳转换请求模型
class TimestampRequest(BaseModel):
    timestamp: Optional[int] = None
    datetime: Optional[str] = None


# Base64工具请求模型
class Base64Request(BaseModel):
    operation: str  # encode or decode
    input: str


# JSON工具请求模型
class JsonRequest(BaseModel):
    operation: str  # beautify or minify
    input: str


# URL工具请求模型
class UrlRequest(BaseModel):
    operation: str  # encode or decode
    input: str


# 随机密码生成请求模型
class PasswordRequest(BaseModel):
    length: int = 12
    include_uppercase: bool = True
    include_lowercase: bool = True
    include_numbers: bool = True
    include_symbols: bool = True


# 文本哈希请求模型
class HashRequest(BaseModel):
    algorithm: str  # md5, sha1, sha256, sha512
    input: str


# IP地址工具请求模型
class IpRequest(BaseModel):
    ip: str


# 颜色转换请求模型
class ColorRequest(BaseModel):
    input_format: str  # hex, rgb, hsl
    input: str


# 变量命名转换请求模型
class NamingRequest(BaseModel):
    input: str


# Python字典转JSON请求模型
class PythonDictRequest(BaseModel):
    input: str


# 健康检查接口
@router.get("/health")
async def health_check():
    return {"status": "healthy", "message": "Auto_Tool API is running"}


# 获取系统信息
@router.get("/info")
async def get_app_info():
    return {
        "app_name": "Auto_Tool",
        "version": "1.0.0",
        "description": "Auto_Tool 后台管理系统",
    }


# 获取仪表盘统计数据
@router.get("/dashboard/stats")
async def get_dashboard_stats():
    """获取仪表盘统计数据，包括用户数量、图数据库连接数等"""
    try:
        # 获取用户数量
        user_count = await User.all().count()

        # 获取图数据库密码数量
        graph_db_count = await GraphDBPassword.all().count()

        # 检查数据库连接状态
        db_connected = True
        try:
            # 尝试执行一个简单的查询来检查连接
            await User.all().limit(1).first()
        except Exception:
            db_connected = False

        # 获取当前时间
        from datetime import datetime

        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        return {
            "success": True,
            "data": {
                "system_status": "运行正常",
                "graph_db_count": graph_db_count,
                "user_count": user_count,
                "last_activity": current_time,
                "db_connected": db_connected,
            },
        }
    except Exception as e:
        return {
            "success": False,
            "message": f"获取统计数据失败: {str(e)}",
            "data": {
                "system_status": "异常",
                "graph_db_count": 0,
                "user_count": 0,
                "last_activity": "-",
                "db_connected": False,
            },
        }


# 获取操作日志列表
@router.get("/operation-logs", response_model=List[OperationLogResponse])
async def get_operation_logs(
    skip: int = 0,
    limit: int = 10,
):
    """
    获取操作日志列表，按时间倒序排列
    """
    logs = await OperationLog.all().order_by("-created_at").offset(skip).limit(limit)
    return logs


# 创建操作日志（内部使用，也可通过API调用）
async def create_operation_log(log_data: OperationLogCreate):
    """
    创建操作日志
    """
    db_log = await OperationLog.create(**log_data.model_dump())
    return db_log


# 获取系统详细信息
@router.get("/dashboard/system-info")
async def get_system_info():
    """获取系统详细信息，包括版本号、数据库状态等"""
    try:
        # 检查数据库连接状态
        db_connected = True
        try:
            # 尝试执行一个简单的查询来检查连接
            await User.all().limit(1).first()
        except Exception:
            db_connected = False

        # 获取当前时间
        from datetime import datetime

        current_time = datetime.now().strftime("%Y-%m-%d")

        return {
            "success": True,
            "data": {
                "app_name": "Auto_Tool",
                "app_version": "1.0.0",
                "python_version": f"{sys.version_info.major}.{sys.version_info.minor}",
                "fastapi_version": fastapi.__version__,
                "db_status": "已连接" if db_connected else "未连接",
                "db_status_color": "text-success" if db_connected else "text-danger",
                "last_update": current_time,
                "platform": platform.system(),
                "architecture": platform.architecture()[0],
            },
        }
    except Exception as e:
        return {
            "success": False,
            "message": f"获取系统信息失败: {str(e)}",
            "data": {
                "app_name": "Auto_Tool",
                "app_version": "1.0.0",
                "python_version": "3.8",
                "fastapi_version": "0.124.4",
                "db_status": "未知",
                "db_status_color": "text-warning",
                "last_update": "-",
                "platform": "-",
                "architecture": "-",
            },
        }


# 自定义长耗时任务接口
@router.post("/custom-task")
async def custom_task(request: CustomTaskRequest):
    """
    自定义长耗时任务接口
    模拟执行需要5分钟左右的任务
    """
    # 记录开始时间
    start_time = time.time()

    # 模拟长耗时操作（5秒用于演示，实际项目中可改为300秒=5分钟）
    # 这里暂时使用5秒作为演示，后续可以根据实际需要修改
    time.sleep(5)

    # 计算耗时
    elapsed_time = time.time() - start_time

    # 返回结果
    return {
        "success": True,
        "message": "任务执行完成",
        "input_params": {
            "base_url": request.base_url,
            "username": request.username,
            "password": "***",  # 隐藏密码
            "params": request.params,
        },
        "execution_time": f"{elapsed_time:.2f}秒",
        "estimated_time": "5分钟",
        "status": "completed",
    }


# JSONPath验证接口
@router.post("/jsonpath")
async def jsonpath_validate(request: JsonPathRequest):
    """
    JSONPath验证接口
    使用jsonpath_ng库解析JSONPath表达式并返回匹配结果
    """
    try:
        from jsonpath_ng import parse

        # 解析JSON数据
        json_obj = json.loads(request.json_data)

        # 解析JSONPath表达式
        jsonpath_expr = parse(request.expression)

        # 执行查询
        matches = [match.value for match in jsonpath_expr.find(json_obj)]

        return {
            "success": True,
            "matches": matches,
            "match_count": len(matches),
            "expression": request.expression,
        }
    except json.JSONDecodeError as e:
        return {
            "success": False,
            "error": f"JSON解析错误: {str(e)}",
            "matches": [],
            "match_count": 0,
        }
    except Exception as e:
        return {
            "success": False,
            "error": f"JSONPath解析错误: {str(e)}",
            "matches": [],
            "match_count": 0,
        }


# 时间戳转换接口
@router.post("/timestamp")
async def timestamp_convert(request: TimestampRequest):
    """
    时间戳转换接口
    将时间戳转换为日期时间格式，或反之
    """
    try:
        from datetime import datetime

        result = {}

        if request.timestamp:
            # 时间戳转日期时间
            dt = datetime.fromtimestamp(request.timestamp)
            result = {
                "timestamp": request.timestamp,
                "datetime": dt.strftime("%Y-%m-%d %H:%M:%S"),
                "iso": dt.isoformat(),
                "utc": datetime.utcnow().isoformat(),
            }
        elif request.datetime:
            # 日期时间转时间戳
            dt = datetime.fromisoformat(request.datetime.replace("Z", "+00:00"))
            result = {
                "datetime": request.datetime,
                "timestamp": int(dt.timestamp()),
                "milliseconds": int(dt.timestamp() * 1000),
            }
        else:
            # 获取当前时间
            now = datetime.now()
            result = {
                "current_datetime": now.strftime("%Y-%m-%d %H:%M:%S"),
                "current_timestamp": int(now.timestamp()),
                "current_milliseconds": int(now.timestamp() * 1000),
                "iso": now.isoformat(),
                "utc": datetime.utcnow().isoformat(),
            }

        return {"success": True, "result": result}
    except Exception as e:
        return {"success": False, "error": f"转换失败: {str(e)}"}


# Base64工具接口
@router.post("/base64")
async def base64_tool(request: Base64Request):
    """
    Base64加密解密接口
    对文本进行Base64编码或解码操作
    """
    try:
        import base64

        if request.operation == "encode":
            # 编码
            encoded = base64.b64encode(request.input.encode("utf-8")).decode("utf-8")
            return {"success": True, "result": encoded}
        elif request.operation == "decode":
            # 解码
            decoded = base64.b64decode(request.input).decode("utf-8")
            return {"success": True, "result": decoded}
        else:
            return {
                "success": False,
                "error": "操作类型无效，支持的操作：encode, decode",
            }
    except Exception as e:
        return {"success": False, "error": f"操作失败: {str(e)}"}


# JSON工具接口
@router.post("/json")
async def json_tool(request: JsonRequest):
    """
    JSON格式化接口
    美化或压缩JSON字符串
    """
    try:
        json_obj = json.loads(request.input)

        if request.operation == "beautify":
            # 美化
            result = json.dumps(json_obj, ensure_ascii=False, indent=2)
        elif request.operation == "minify":
            # 压缩
            result = json.dumps(json_obj, ensure_ascii=False, separators=(",", ":"))
        else:
            return {
                "success": False,
                "error": "操作类型无效，支持的操作：beautify, minify",
            }

        return {"success": True, "result": result}
    except json.JSONDecodeError as e:
        return {"success": False, "error": f"JSON解析错误: {str(e)}"}
    except Exception as e:
        return {"success": False, "error": f"操作失败: {str(e)}"}


# URL工具接口
@router.post("/url")
async def url_tool(request: UrlRequest):
    """
    URL编码解码接口
    对URL进行编码或解码操作
    """
    try:
        import urllib.parse

        if request.operation == "encode":
            # 编码
            encoded = urllib.parse.quote(request.input)
            return {"success": True, "result": encoded}
        elif request.operation == "decode":
            # 解码
            decoded = urllib.parse.unquote(request.input)
            return {"success": True, "result": decoded}
        else:
            return {
                "success": False,
                "error": "操作类型无效，支持的操作：encode, decode",
            }
    except Exception as e:
        return {"success": False, "error": f"操作失败: {str(e)}"}


# 随机密码生成接口
@router.post("/password")
async def password_generator(request: PasswordRequest):
    """
    随机密码生成接口
    生成指定长度和复杂度的随机密码
    """
    try:
        import random
        import string

        # 验证参数
        if request.length < 6 or request.length > 50:
            return {"success": False, "error": "密码长度必须在6-50之间"}

        # 构建字符集
        charset = ""
        if request.include_uppercase:
            charset += string.ascii_uppercase
        if request.include_lowercase:
            charset += string.ascii_lowercase
        if request.include_numbers:
            charset += string.digits
        if request.include_symbols:
            charset += string.punctuation

        if not charset:
            return {"success": False, "error": "至少需要选择一种字符类型"}

        # 生成密码
        password = "".join(random.choice(charset) for _ in range(request.length))

        return {"success": True, "result": password}
    except Exception as e:
        return {"success": False, "error": f"生成失败: {str(e)}"}


# 文本哈希接口
@router.post("/hash")
async def hash_tool(request: HashRequest):
    """
    文本哈希接口
    计算文本的MD5、SHA1等哈希值
    """
    try:
        import hashlib

        if request.algorithm == "md5":
            hash_obj = hashlib.md5(request.input.encode("utf-8"))
        elif request.algorithm == "sha1":
            hash_obj = hashlib.sha1(request.input.encode("utf-8"))
        elif request.algorithm == "sha256":
            hash_obj = hashlib.sha256(request.input.encode("utf-8"))
        elif request.algorithm == "sha512":
            hash_obj = hashlib.sha512(request.input.encode("utf-8"))
        else:
            return {
                "success": False,
                "error": "算法类型无效，支持的算法：md5, sha1, sha256, sha512",
            }

        return {"success": True, "result": hash_obj.hexdigest()}
    except Exception as e:
        return {"success": False, "error": f"计算失败: {str(e)}"}


# IP地址工具接口
@router.post("/ip")
async def ip_tool(request: IpRequest):
    """
    IP地址工具接口
    IP地址信息查询和验证
    """
    try:
        import re

        # 验证IPv4地址
        ipv4_pattern = (
            r"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}"
            r"(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        )

        if re.match(ipv4_pattern, request.ip):
            # 验证通过
            return {
                "success": True,
                "result": {"ip": request.ip, "format": "IPv4", "valid": True},
            }
        else:
            # 验证失败
            return {"success": False, "error": "无效的IP地址格式"}
    except Exception as e:
        return {"success": False, "error": f"验证失败: {str(e)}"}


# 颜色转换接口
@router.post("/color")
async def color_converter(request: ColorRequest):
    """
    颜色转换接口
    HEX、RGB、HSL颜色格式转换
    """
    try:
        if request.input_format == "hex":
            # HEX转RGB和HSL
            hex_value = request.input.lstrip("#")
            if len(hex_value) != 6:
                return {"success": False, "error": "无效的HEX格式"}

            r = int(hex_value[0:2], 16)
            g = int(hex_value[2:4], 16)
            b = int(hex_value[4:6], 16)

            # RGB转HSL
            r_norm = r / 255.0
            g_norm = g / 255.0
            b_norm = b / 255.0

            max_val = max(r_norm, g_norm, b_norm)
            min_val = min(r_norm, g_norm, b_norm)

            h = 0
            s = 0
            lightness = (max_val + min_val) / 2

            if max_val != min_val:
                d = max_val - min_val
                s = d / (1 - abs(2 * lightness - 1))

                if max_val == r_norm:
                    h = ((g_norm - b_norm) / d) % 6
                elif max_val == g_norm:
                    h = (b_norm - r_norm) / d + 2
                else:
                    h = (r_norm - g_norm) / d + 4

                h *= 60
                if h < 0:
                    h += 360

            return {
                "success": True,
                "result": {
                    "hex": f"#{hex_value}",
                    "rgb": f"rgb({r}, {g}, {b})",
                    "hsl": f"hsl({int(h)}, {int(s * 100)}%, {int(lightness * 100)}%)",
                },
            }
        elif request.input_format == "rgb":
            # RGB转HEX和HSL
            import re

            match = re.match(r"rgb\((\d+),\s*(\d+),\s*(\d+)\)", request.input)
            if not match:
                return {"success": False, "error": "无效的RGB格式"}

            r = int(match.group(1))
            g = int(match.group(2))
            b = int(match.group(3))

            if not (0 <= r <= 255 and 0 <= g <= 255 and 0 <= b <= 255):
                return {"success": False, "error": "RGB值必须在0-255之间"}

            # RGB转HEX
            hex_value = f"{r:02x}{g:02x}{b:02x}".upper()

            # RGB转HSL
            r_norm = r / 255.0
            g_norm = g / 255.0
            b_norm = b / 255.0

            max_val = max(r_norm, g_norm, b_norm)
            min_val = min(r_norm, g_norm, b_norm)

            h = 0
            s = 0
            lightness = (max_val + min_val) / 2

            if max_val != min_val:
                d = max_val - min_val
                s = d / (1 - abs(2 * lightness - 1))

                if max_val == r_norm:
                    h = ((g_norm - b_norm) / d) % 6
                elif max_val == g_norm:
                    h = (b_norm - r_norm) / d + 2
                else:
                    h = (r_norm - g_norm) / d + 4

                h *= 60
                if h < 0:
                    h += 360

            return {
                "success": True,
                "result": {
                    "hex": f"#{hex_value}",
                    "rgb": f"rgb({r}, {g}, {b})",
                    "hsl": f"hsl({int(h)}, {int(s * 100)}%, {int(lightness * 100)}%)",
                },
            }
        elif request.input_format == "hsl":
            # HSL转RGB和HEX
            import re

            match = re.match(r"hsl\((\d+),\s*(\d+)%,\s*(\d+)%\)", request.input)
            if not match:
                return {"success": False, "error": "无效的HSL格式"}

            h = int(match.group(1))
            s = int(match.group(2)) / 100.0
            lightness = int(match.group(3)) / 100.0

            if not (0 <= h <= 360 and 0 <= s <= 1 and 0 <= lightness <= 1):
                return {"success": False, "error": "HSL值超出范围"}

            # HSL转RGB
            def hue_to_rgb(p, q, t):
                if t < 0:
                    t += 1
                if t > 1:
                    t -= 1
                if t < 1 / 6:
                    return p + (q - p) * 6 * t
                if t < 1 / 2:
                    return q
                if t < 2 / 3:
                    return p + (q - p) * (2 / 3 - t) * 6
                return p

            if s == 0:
                r = g = b = lightness
            else:
                q = lightness * (1 + s) if lightness < 0.5 else lightness + s - lightness * s
                p = 2 * lightness - q
                r = hue_to_rgb(p, q, h / 360 + 1 / 3)
                g = hue_to_rgb(p, q, h / 360)
                b = hue_to_rgb(p, q, h / 360 - 1 / 3)

            r = int(r * 255)
            g = int(g * 255)
            b = int(b * 255)

            # RGB转HEX
            hex_value = f"{r:02x}{g:02x}{b:02x}".upper()

            return {
                "success": True,
                "result": {
                    "hex": f"#{hex_value}",
                    "rgb": f"rgb({r}, {g}, {b})",
                    "hsl": f"hsl({h}, {int(s * 100)}%, {int(lightness * 100)}%)",
                },
            }
        else:
            return {
                "success": False,
                "error": "输入格式无效，支持的格式：hex, rgb, hsl",
            }
    except Exception as e:
        return {"success": False, "error": f"转换失败: {str(e)}"}


# 变量命名转换接口
@router.post("/naming")
async def naming_converter(request: NamingRequest):
    """
    变量命名转换接口
    多种变量命名格式的互相转换
    """
    try:
        # 解析输入为单词
        words = []
        current_word = ""

        for char in request.input:
            if char in "_- .":
                if current_word:
                    words.append(current_word.lower())
                    current_word = ""
            elif char.isupper():
                if current_word and not (
                    len(current_word) > 0 and current_word[-1].isupper()
                ):
                    words.append(current_word.lower())
                    current_word = char.lower()
                else:
                    current_word += char.lower()
            else:
                current_word += char.lower()

        if current_word:
            words.append(current_word.lower())

        words = [word for word in words if word]

        if not words:
            return {"success": False, "error": "输入无效"}

        # 生成各种命名格式
        camel_case = words[0] + "".join(word.capitalize() for word in words[1:])
        pascal_case = "".join(word.capitalize() for word in words)
        snake_case = "_".join(words)
        snake_case_upper = "_".join(word.upper() for word in words)
        package_name = ".".join(words)
        kebab_case = "-".join(words)

        return {
            "success": True,
            "result": {
                "camel_case": camel_case,
                "pascal_case": pascal_case,
                "snake_case": snake_case,
                "snake_case_upper": snake_case_upper,
                "package_name": package_name,
                "kebab_case": kebab_case,
            },
        }
    except Exception as e:
        return {"success": False, "error": f"转换失败: {str(e)}"}


# Python字典转JSON接口
@router.post("/python-dict-to-json")
async def python_dict_to_json(request: PythonDictRequest):
    """
    Python字典转JSON接口
    将Python字典字符串转换为格式化的JSON
    """
    try:
        # 移除可能的注释和多余空格
        code = request.input

        # 处理Python语法
        # 1. 将单引号替换为双引号
        # 2. 处理True/False/None
        # 3. 移除Python特有的语法
        json_str = (
            code.replace("'", '"')
            .replace("True", "true")
            .replace("False", "false")
            .replace("None", "null")
        )

        # 解析并格式化
        json_obj = json.loads(json_str)
        formatted_json = json.dumps(json_obj, ensure_ascii=False, indent=2)

        return {"success": True, "result": formatted_json}
    except json.JSONDecodeError as e:
        return {"success": False, "error": f"JSON解析错误: {str(e)}"}
    except Exception as e:
        return {"success": False, "error": f"转换失败: {str(e)}"}
