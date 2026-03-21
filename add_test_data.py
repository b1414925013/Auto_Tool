import requests
import random
import string
import time

# 后端API基础URL
BASE_URL = "http://localhost:8000/api"

# 生成随机字符串
def generate_random_string(length=10):
    letters = string.ascii_letters + string.digits
    return ''.join(random.choice(letters) for _ in range(length))

# 生成随机IP地址
def generate_random_ip():
    return f"{random.randint(1, 255)}.{random.randint(0, 255)}.{random.randint(0, 255)}.{random.randint(0, 255)}"

# 生成随机端口
def generate_random_port():
    return random.randint(1024, 65535)

# 生成随机环境编号
def generate_environment_id(index):
    environments = ["dev", "test", "staging", "prod"]
    env = random.choice(environments)
    return f"{env}_{index:03d}"

# 为DIM数据库管理添加数据
def add_dim_db_data(count):
    print(f"开始为DIM数据库管理添加{count}条数据...")
    success_count = 0
    for i in range(count):
        try:
            data = {
                "environment": f"env_{i:03d}",
                "password": generate_random_string(20),
                "description": f"DIM数据库 {i:03d}"
            }
            response = requests.post(f"{BASE_URL}/dim/dim-db", json=data)
            if response.status_code == 201:
                success_count += 1
            else:
                print(f"添加DIM数据库失败: {response.text}")
            # 避免请求过快
            time.sleep(0.01)
        except Exception as e:
            print(f"添加DIM数据库时发生错误: {e}")
    print(f"DIM数据库管理数据添加完成，成功{success_count}条，失败{count - success_count}条")

# 为图数据库密码管理添加数据
def add_graph_db_data(count):
    print(f"开始为图数据库密码管理添加{count}条数据...")
    success_count = 0
    for i in range(count):
        try:
            data = {
                "environment_id": generate_environment_id(i),
                "jump_server_ip": generate_random_ip(),
                "jump_server_port": generate_random_port(),
                "jump_server_account": f"jump_user_{i:03d}",
                "jump_server_password": generate_random_string(20),
                "pass_core_ip": generate_random_ip(),
                "pass_core_port": generate_random_port(),
                "pass_core_account": f"pass_user_{i:03d}",
                "pass_core_password": generate_random_string(20),
                "pass_core_root_password": generate_random_string(20),
                "graph_db_password": generate_random_string(20)
            }
            response = requests.post(f"{BASE_URL}/dtn/graph-db", json=data)
            if response.status_code == 201:
                success_count += 1
            else:
                print(f"添加图数据库密码失败: {response.text}")
            # 避免请求过快
            time.sleep(0.01)
        except Exception as e:
            print(f"添加图数据库密码时发生错误: {e}")
    print(f"图数据库密码管理数据添加完成，成功{success_count}条，失败{count - success_count}条")

# 为机机账号管理添加数据
def add_machine_account_data(count):
    print(f"开始为机机账号管理添加{count}条数据...")
    success_count = 0
    for i in range(count):
        try:
            data = {
                "environment_id": generate_environment_id(i),
                "ip": generate_random_ip(),
                "port": generate_random_port(),
                "account": f"account_{i:03d}",
                "password": generate_random_string(20),
                "type": random.choice(["type1", "type2", "type3"]),
                "machine_account": f"machine_{i:03d}",
                "machine_password": generate_random_string(20)
            }
            response = requests.post(f"{BASE_URL}/dtn/machine-account", json=data)
            if response.status_code == 201:
                success_count += 1
            else:
                print(f"添加机机账号失败: {response.text}")
            # 避免请求过快
            time.sleep(0.01)
        except Exception as e:
            print(f"添加机机账号时发生错误: {e}")
    print(f"机机账号管理数据添加完成，成功{success_count}条，失败{count - success_count}条")

if __name__ == "__main__":
    # 检查后端服务是否运行
    try:
        response = requests.get(f"{BASE_URL}/common/health")
        if response.status_code != 200:
            print("后端服务未运行，请先启动后端服务")
            exit(1)
    except Exception as e:
        print(f"无法连接到后端服务: {e}")
        exit(1)
    
    # 为每个模块添加500条数据
    add_dim_db_data(500)
    add_graph_db_data(500)
    add_machine_account_data(500)
    
    print("所有数据添加完成！")
