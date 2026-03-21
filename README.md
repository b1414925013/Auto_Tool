# Auto_Tool 后台管理系统

一个基于 FastAPI 和 Vue 3 开发的功能完善的后台管理系统，提供图数据库密码管理、DIM 数据库管理、机机账号管理、用户管理、角色管理、操作日志记录、公共工具等功能。

## 技术栈

- **后端**: FastAPI + Python 3.8+
- **数据库**: MySQL / SQLite / PostgreSQL (多数据库支持)
- **前端**: Vue 3 + Element Plus + Vite
- **ORM**: Tortoise-ORM (异步 ORM)
- **认证**: JWT
- **密码加密**: bcrypt
- **AOP 中间件**: FastAPI 自定义中间件

## 项目结构

```
Auto_Tool/
├── backend/             # 后端代码
│   ├── app/
│   │   ├── core/             # 核心模块
│   │   │   └── database.py   # 数据库配置
│   │   ├── common/           # 公共模块
│   │   │   ├── middleware/   # 中间件
│   │   │   │   └── operation_log.py  # 操作日志 AOP 中间件
│   │   │   ├── models/       # 数据模型
│   │   │   │   └── operation_log.py  # 操作日志模型
│   │   │   ├── schemas/      # Pydantic 模型
│   │   │   │   └── operation_log.py
│   │   │   └── routes/       # API 路由
│   │   │       └── common.py # 公共路由（仪表盘、操作日志、工具）
│   │   ├── dim/              # DIM 模块
│   │   │   ├── models/       # 数据模型
│   │   │   │   └── dim_db.py # DIM 数据库模型
│   │   │   ├── schemas/      # Pydantic 模型
│   │   │   │   └── dim_db.py
│   │   │   └── routes/       # API 路由
│   │   │       └── dim_db.py # DIM 相关路由
│   │   ├── dtn/              # DTN 模块
│   │   │   ├── models/       # 数据模型
│   │   │   │   ├── graph_db.py        # 图数据库密码模型
│   │   │   │   └── machine_account.py # 机机账号模型
│   │   │   ├── schemas/      # Pydantic 模型
│   │   │   │   ├── graph_db.py
│   │   │   │   └── machine_account.py
│   │   │   └── routes/       # API 路由
│   │   │       ├── graph_db.py        # 图数据库密码路由
│   │   │       └── machine_account.py # 机机账号路由
│   │   ├── system/           # 系统管理模块
│   │   │   ├── models/       # 数据模型
│   │   │   │   ├── user.py           # 用户模型
│   │   │   │   ├── role.py           # 角色模型
│   │   │   │   └── user_role.py      # 用户角色关联模型
│   │   │   ├── schemas/      # Pydantic 模型
│   │   │   │   ├── user.py
│   │   │   │   └── role.py
│   │   │   └── routes/       # API 路由
│   │   │       ├── system.py  # 系统管理路由
│   │   │       └── role.py    # 角色管理路由
│   ├── main.py               # FastAPI 应用入口
│   ├── requirements.txt      # 依赖包列表
│   ├── pyproject.toml        # 项目配置文件
│   ├── migrations/           # 数据库迁移文件
│   ├── sql/                  # SQL 相关文件
│   ├── libs/                 # 库文件
│   ├── .env                  # 环境变量配置（需自行创建）
│   └── run.bat               # Windows 启动脚本
├── frontend/              # 前端代码
│   ├── src/
│   │   ├── views/            # 页面目录
│   │   │   ├── dtn/          # DTN 相关页面
│   │   │   │   ├── GraphDBPassword.vue    # 图数据库密码管理
│   │   │   │   └── MachineAccount.vue     # 机机账号管理
│   │   │   ├── dim/          # DIM 相关页面
│   │   │   │   └── DimDatabase.vue        # DIM 数据库管理
│   │   │   ├── system/       # 系统管理页面
│   │   │   │   ├── RoleManagement.vue     # 角色管理
│   │   │   │   └── UserManagement.vue     # 用户管理
│   │   │   ├── common/       # 公共工具页面
│   │   │   │   ├── CommonTools.vue        # 公共工具
│   │   │   │   └── CustomTools.vue        # 自定义工具
│   │   │   ├── Login.vue     # 登录页面
│   │   │   ├── Dashboard.vue # 仪表盘页面
│   │   │   └── NotFound.vue  # 404页面
│   │   ├── router/           # 路由配置
│   │   │   └── index.js
│   │   ├── store/            # 状态管理
│   │   │   └── index.js
│   │   ├── api/              # API 服务
│   │   │   └── index.js
│   │   ├── main.js           # 主入口文件
│   │   └── App.vue           # 根组件
│   ├── index.html            # 前端入口文件
│   ├── package.json          # 前端项目配置文件
│   ├── package-lock.json     # 前端依赖锁定文件
│   └── vite.config.js        # Vite 配置文件
├── .gitignore
├── README.md             # 项目说明
```

## 环境要求

- **Python**: 3.8+
- **Node.js**: 18.0+ (前端开发和构建)
- **数据库选项**:
  - MySQL 5.7+ (推荐)
  - SQLite 3.30+
  - PostgreSQL 12+

## 依赖说明

项目使用以下主要依赖包：

### 后端依赖
- `fastapi` - FastAPI 框架
- `uvicorn` - ASGI 服务器
- `python-dotenv` - 环境变量管理
- `passlib` + `bcrypt` - 密码加密
- `python-jose` - JWT 认证
- `email-validator` - 邮箱验证
- `tortoise-orm` - 异步 ORM
- `aiomysql` - MySQL 异步驱动
- `asyncpg` - PostgreSQL 异步驱动
- `aerich` - 数据库迁移工具

### 前端依赖
- `vue@^3.5.30` - Vue.js 3 框架
- `vue-router@^5.0.4` - 路由管理
- `pinia@^3.0.4` - 状态管理
- `element-plus@^2.13.5` - UI 组件库
- `axios@^1.13.6` - HTTP 客户端
- `vite@^5.0.0` - 构建工具
- `@vitejs/plugin-vue@^5.0.0` - Vue 插件

## 安装步骤

### 后端安装

1. **克隆仓库**

   ```bash
   git clone https://github.com/b1414925013/Auto_Tool.git
   cd Auto_Tool
   ```

2. **创建虚拟环境**

   ```bash
   # Windows
   python -m venv .venv
   .venv\Scripts\activate

   # Linux/Mac
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. **安装后端依赖**

   ```bash
   cd backend
   pip install -r requirements.txt
   ```

4. **配置环境变量**

   在 `backend` 目录创建 `.env` 文件并修改配置：

   ```bash
   # 数据库连接信息 - MySQL
   DATABASE_URL="mysql://用户名:密码@localhost:3306/数据库名"

   # 数据库连接信息 - SQLite (可选)
   # DATABASE_URL="sqlite://db.sqlite3"

   # 数据库连接信息 - PostgreSQL (可选)
   # DATABASE_URL="postgres://用户名:密码@localhost:5432/数据库名"

   # JWT 密钥
   SECRET_KEY="your-secret-key"

   # 应用配置
   APP_NAME="Auto_Tool"
   APP_VERSION="1.0.0"
   ```

5. **初始化数据库**

   启动应用时，Tortoise-ORM 会自动创建数据库表结构并初始化默认数据：

   ```bash
   python main.py
   ```

   系统会自动创建：
   - `sys_user` 表（用户）
   - `sys_role` 表（角色）
   - `sys_user_role` 表（用户角色关联）
   - `graph_db` 表（图数据库密码）
   - `dim_db` 表（DIM 数据库）
   - `machine_account` 表（机机账号）
   - `operation_logs` 表（操作日志）
   - 并插入默认角色和用户数据

6. **启动后端服务**

   ```bash
   # Windows 可以使用 run.bat
   run.bat

   # 或直接运行
   python main.py
   ```

   后端服务将在 `http://localhost:8000` 启动。

### 前端安装

1. **安装前端依赖**

   ```bash
   cd frontend
   npm install
   ```

2. **开发模式运行**

   ```bash
   npm run dev
   ```

   前端开发服务器将在 `http://localhost:3000` 启动。

3. **生产环境构建**

   ```bash
   npm run build
   ```

   构建产物将生成到 `frontend/dist/` 目录。

## 功能特性

### 1. 首页仪表盘

- 实时显示系统状态
- 统计用户数量、图数据库密码数量、DIM 数据库数量、机机账号数量
- 最近操作日志展示
- 系统详细信息展示
- 美观的图表和数据可视化

### 2. DIM 数据库管理

- 查看所有 DIM 数据库
- 添加新的 DIM 数据库
- 编辑现有 DIM 数据库
- 删除 DIM 数据库
- 支持环境名称、密码、描述等信息管理

### 3. 图数据库密码管理

- 查看所有图数据库密码
- 添加新的图数据库密码
- 编辑现有图数据库密码
- 删除图数据库密码
- 密码自动生成（由后端计算）
- 支持环境编号、跳板机信息、pass-core 节点信息管理

### 4. 机机账号管理

- 查看所有机机账号
- 添加新的机机账号
- 编辑现有机机账号
- 删除机机账号
- 支持环境编号、IP 地址、端口、账号、密码、类型等信息管理

### 5. 用户管理

- 查看所有用户
- 添加新用户
- 编辑现有用户
- 删除用户
- 用户密码加密存储（bcrypt）
- 用户角色分配
- 支持用户状态管理
- 显示最后登录时间

### 6. 角色管理

- 查看所有角色
- 添加新角色
- 编辑现有角色
- 删除角色
- 基于角色的访问控制
- 默认角色：
  - 超级管理员 (super_admin)：拥有所有权限
  - 普通管理员 (admin)：拥有管理权限
  - 普通用户 (normal_user)：拥有基础权限

### 7. 操作日志系统

- **AOP 中间件自动记录**：所有 API 操作自动记录到数据库
- 记录信息包括：操作类型、操作描述、用户、状态、请求 URL、请求方法、IP 地址、User-Agent、错误信息、时间戳
- 首页实时展示最近操作日志
- 支持查询操作日志列表

### 8. 公共工具

- **IP 检查工具**：检查 IP 地址的有效性和归属地
- **密码生成工具**：生成强密码
- **JSON 格式化工具**：格式化和美化 JSON 数据
- **时间戳转换工具**：在时间戳和日期时间之间转换
- **变量命名转换工具**：支持多种命名格式互相转换
  - 驼峰命名法 (camelCase)
  - 帕斯卡命名法 (PascalCase)
  - 下划线+小写 (snake_case)
  - 下划线+大写 (SNAKE_CASE)
  - 包名格式 (package.name)
  - 中横线+小写 (kebab-case)

### 9. 自定义工具

- **自定义长耗时任务**：支持配置参数执行长时间任务

### 10. 系统特性

- **Vue 3 Composition API**：使用最新的组合式 API，代码结构更清晰
- **Element Plus**：现代化的 UI 组件库，提供丰富的组件
- **响应式设计**：支持移动端和桌面端
- **模块化前端架构**：按需加载页面和组件
- **完善的错误处理**：友好的错误提示和处理机制
- **实时通知系统**：操作结果实时反馈
- **左侧导航栏**：支持多级菜单和折叠功能
- **路由守卫**：基于 JWT 的权限控制
- **状态管理**：使用 Pinia 进行全局状态管理
- **API 服务**：统一的 API 调用封装
- **流畅的过渡动画**：提升用户体验

## 默认账号

系统初始化时会创建以下默认账号：

| 用户名 | 密码 | 角色 | 说明 |
|--------|------|------|------|
| super_admin | admin123 | 超级管理员 | 拥有所有权限 |
| user | user123 | 普通用户 | 拥有基础权限 |

> **安全提示**：请在首次登录后立即修改默认密码！

## API 文档

启动应用后，可以访问以下地址查看 API 文档：

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

### 主要 API 端点

#### 公共接口 (`/api/common`)

- `GET /api/common/health` - 健康检查
- `GET /api/common/info` - 获取系统信息
- `GET /api/common/dashboard/stats` - 获取仪表盘统计数据
- `GET /api/common/dashboard/system-info` - 获取系统详细信息
- `GET /api/common/operation-logs` - 获取操作日志列表
- `POST /api/common/custom-task` - 自定义长耗时任务

#### DIM 接口 (`/api/dim`)

- `GET /api/dim/dim-db` - 获取 DIM 数据库列表（分页）
- `POST /api/dim/dim-db` - 创建 DIM 数据库
- `GET /api/dim/dim-db/{id}` - 获取 DIM 数据库详情
- `PUT /api/dim/dim-db/{id}` - 更新 DIM 数据库
- `DELETE /api/dim/dim-db/{id}` - 删除 DIM 数据库

#### DTN 接口 (`/api/dtn`)

##### 图数据库密码
- `GET /api/dtn/graph-db` - 获取图数据库密码列表（分页）
- `POST /api/dtn/graph-db` - 创建图数据库密码
- `GET /api/dtn/graph-db/{id}` - 获取图数据库密码详情
- `PUT /api/dtn/graph-db/{id}` - 更新图数据库密码
- `DELETE /api/dtn/graph-db/{id}` - 删除图数据库密码

##### 机机账号
- `GET /api/dtn/machine-account` - 获取机机账号列表（分页）
- `POST /api/dtn/machine-account` - 创建机机账号
- `GET /api/dtn/machine-account/{id}` - 获取机机账号详情
- `PUT /api/dtn/machine-account/{id}` - 更新机机账号
- `DELETE /api/dtn/machine-account/{id}` - 删除机机账号

#### 系统管理接口 (`/api/system`)

- `GET /api/system/users` - 获取用户列表（分页）
- `POST /api/system/users` - 创建用户
- `GET /api/system/users/{id}` - 获取用户详情
- `PUT /api/system/users/{id}` - 更新用户
- `DELETE /api/system/users/{id}` - 删除用户
- `POST /api/system/login` - 用户登录
- `GET /api/system/me` - 获取当前用户信息

#### 角色管理接口 (`/api/role`)

- `GET /api/role/roles` - 获取角色列表（分页）
- `POST /api/role/roles` - 创建角色
- `GET /api/role/roles/{id}` - 获取角色详情
- `PUT /api/role/roles/{id}` - 更新角色
- `DELETE /api/role/roles/{id}` - 删除角色
- `GET /api/role/users/{user_id}/roles` - 获取用户角色
- `POST /api/role/users/{user_id}/roles` - 分配用户角色

## 分页接口规范

所有列表接口都支持分页，返回格式统一为：

```json
{
  "total": 100,
  "items": [...]
}
```

请求参数：
- `skip`: 跳过的记录数（默认 0）
- `limit`: 每页记录数（默认 10）

## 开发指南

### 后端开发

1. **添加新路由**：在对应模块的 `routes/` 目录下创建新的路由文件
2. **添加新模型**：在对应模块的 `models/` 目录下创建新的数据模型
3. **添加新 Schema**：在对应模块的 `schemas/` 目录下创建新的 Pydantic 模型
4. **添加新中间件**：在 `app/common/middleware/` 目录下创建中间件

#### 操作日志中间件使用

系统已内置操作日志中间件，会自动记录 API 操作。如需自定义操作描述，可修改 `app/common/middleware/operation_log.py` 中的 `OPERATION_DESC_MAP` 字典：

```python
OPERATION_DESC_MAP = {
    '/api/your-path': {
        'GET': '查询操作',
        'POST': '创建操作',
    },
}
```

#### 数据库迁移

项目使用 Aerich 进行数据库迁移：

```bash
# 初始化迁移
aerich init -t app.core.database.TORTOISE_ORM

# 创建迁移文件
aerich migrate --name "your_migration_name"

# 执行迁移
aerich upgrade
```

### 前端开发

1. **添加新页面**：在 `frontend/src/views/` 目录下创建新的 Vue 组件
2. **添加路由**：在 `frontend/src/router/index.js` 文件中添加新的路由配置
3. **添加 API 调用**：在 `frontend/src/api/` 目录下添加对应的 API 调用
4. **添加页面到导航菜单**：在 `frontend/src/App.vue` 文件中添加新页面到左侧导航栏

#### 组件开发规范

- 使用 Vue 3 Composition API
- 使用 Element Plus 组件库
- 组件命名使用 PascalCase
- 路由命名使用 kebab-case
- 每个函数添加函数级中文注释

#### API 调用规范

- 所有 API 调用通过 `api/index.js` 中的封装函数进行
- 使用 async/await 语法
- 统一的错误处理
- 支持请求和响应拦截

#### 时间格式化

项目使用统一的时间格式化函数，格式为 `YYYY-MM-DD HH:mm:ss`：

```javascript
const formatDateTime = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}
```

## 部署

### 生产环境部署

#### 后端部署

1. **使用 Uvicorn 作为 ASGI 服务器**

   ```bash
   cd backend
   uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
   ```

2. **使用 Nginx 作为反向代理**

   配置 Nginx 转发请求到 Uvicorn 服务器：

   ```nginx
   server {
       listen 80;
       server_name your-domain.com;

       # 后端 API 接口
       location /api {
           proxy_pass http://127.0.0.1:8000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }

       # 前端静态文件
       location / {
           root /path/to/frontend/dist;
           index index.html;
           try_files $uri $uri/ /index.html;
       }
   }
   ```

#### 前端部署

1. **构建前端项目**

   ```bash
   cd frontend
   npm run build
   ```

2. **部署静态文件**

   将 `frontend/dist/` 目录下的所有文件复制到 Nginx 的根目录或指定的静态文件目录。

3. **配置前端 API 地址**

   在生产环境中，确保前端能正确访问后端 API 地址。

## 注意事项

1. **Python 版本**：本项目要求 Python 3.8 版本
2. **Node.js 版本**：前端开发要求 Node.js 18.0+ 版本
3. **数据库配置**：需要在 `backend` 目录的 `.env` 文件中正确配置数据库连接信息
4. **生产环境**：生产环境中应修改 CORS 配置，限制允许的源
5. **安全**：生产环境中应使用强密钥并定期更新
6. **操作日志**：系统会自动记录所有 API 操作，避免循环记录（操作日志查询接口本身不被记录）
7. **前端构建**：生产环境部署前需要执行 `npm run build` 构建前端项目
8. **API 地址**：确保前端能正确访问后端 API 地址，可在 `vite.config.js` 中配置
9. **环境变量**：后端和前端的环境变量配置要保持一致
10. **默认密码**：首次登录后请立即修改默认账号的密码

## 常见问题

### Q: 如何重置数据库？

A: 删除数据库后重新启动应用，Tortoise-ORM 会自动重新创建表结构并初始化默认数据：

```bash
# MySQL
mysql -u 用户名 -p -e "DROP DATABASE IF EXISTS 数据库名;"
mysql -u 用户名 -p -e "CREATE DATABASE 数据库名 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 然后重新启动应用
cd backend
python main.py
```

### Q: 如何修改中间件记录的操作？

A: 编辑 `app/common/middleware/operation_log.py` 中的 `OPERATION_DESC_MAP` 字典，添加或修改路径和操作描述的映射。

### Q: 如何添加新的公共工具？

A: 在 `frontend/src/views/common/CommonTools.vue` 中添加新工具的组件结构，并在对应的 JavaScript 部分添加逻辑。

### Q: 如何切换数据库类型？

A: 修改 `backend` 目录的 `.env` 文件中的 `DATABASE_URL` 配置：

```bash
# MySQL
DATABASE_URL="mysql://用户名:密码@localhost:3306/数据库名"

# SQLite
DATABASE_URL="sqlite://db.sqlite3"

# PostgreSQL
DATABASE_URL="postgres://用户名:密码@localhost:5432/数据库名"
```

### Q: 数据库连接失败怎么办？

A: 检查以下几点：
1. 数据库服务是否运行
2. 数据库连接信息是否正确
3. 数据库用户是否有足够的权限
4. 对于 MySQL，需要安装 `aiomysql` 依赖
5. 对于 PostgreSQL，需要安装 `asyncpg` 依赖

### Q: 前端开发服务器启动失败怎么办？

A: 检查以下几点：
1. Node.js 版本是否为 18.0+
2. 是否已安装依赖：`npm install`
3. 端口 3000 是否被占用
4. 查看错误信息，针对性解决

### Q: 前端无法访问后端 API 怎么办？

A: 检查以下几点：
1. 后端服务是否运行在 `http://localhost:8000`
2. 前端 `vite.config.js` 中的 API 代理配置是否正确
3. 后端 CORS 配置是否允许前端访问
4. 检查浏览器控制台的网络请求和错误信息

### Q: 分页接口返回的数据格式是什么？

A: 所有分页接口统一返回以下格式：
```json
{
  "total": 总数,
  "items": [数据列表]
}
```

前端应从 `response.items` 获取数据，从 `response.total` 获取总数。

## 许可证

MIT

## 贡献

欢迎提交 Issue 和 Pull Request！

## 联系方式

- 项目地址：https://github.com/b1414925013/Auto_Tool
