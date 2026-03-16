// API 基础 URL
const API_BASE_URL = 'http://localhost:8000/api';
const PAGES_BASE_URL = '/frontend/pages';

// API 请求封装
class ApiService {
    /**
     * 获取认证令牌
     * @returns {string|null} - 认证令牌
     */
    static getAuthToken() {
        return localStorage.getItem('token');
    }
    
    /**
     * 构建请求头
     * @returns {object} - 请求头
     */
    static getHeaders() {
        const headers = {
            'Content-Type': 'application/json'
        };
        
        const token = this.getAuthToken();
        if (token) {
            headers['Authorization'] = `Bearer ${token}`;
        }
        
        return headers;
    }
    
    /**
     * 发送 GET 请求
     * @param {string} endpoint - API 端点
     * @returns {Promise<any>} - 返回数据
     */
    static async get(endpoint) {
        try {
            const response = await fetch(`${API_BASE_URL}${endpoint}`, {
                method: 'GET',
                headers: this.getHeaders()
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            return await response.json();
        } catch (error) {
            console.error('GET request error:', error);
            throw error;
        }
    }
    
    /**
     * 发送 POST 请求
     * @param {string} endpoint - API 端点
     * @param {object} data - 请求数据
     * @returns {Promise<any>} - 返回数据
     */
    static async post(endpoint, data) {
        try {
            const response = await fetch(`${API_BASE_URL}${endpoint}`, {
                method: 'POST',
                headers: this.getHeaders(),
                body: JSON.stringify(data)
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            return await response.json();
        } catch (error) {
            console.error('POST request error:', error);
            throw error;
        }
    }
    
    /**
     * 发送 PUT 请求
     * @param {string} endpoint - API 端点
     * @param {object} data - 请求数据
     * @returns {Promise<any>} - 返回数据
     */
    static async put(endpoint, data) {
        try {
            const response = await fetch(`${API_BASE_URL}${endpoint}`, {
                method: 'PUT',
                headers: this.getHeaders(),
                body: JSON.stringify(data)
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            return await response.json();
        } catch (error) {
            console.error('PUT request error:', error);
            throw error;
        }
    }
    
    /**
     * 发送 DELETE 请求
     * @param {string} endpoint - API 端点
     * @returns {Promise<void>}
     */
    static async delete(endpoint) {
        try {
            const response = await fetch(`${API_BASE_URL}${endpoint}`, {
                method: 'DELETE',
                headers: this.getHeaders()
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
        } catch (error) {
            console.error('DELETE request error:', error);
            throw error;
        }
    }
}

// 导出 ApiService
export { ApiService };

// 图数据库密码相关 API
export const GraphDBPasswordApi = {
    /**
     * 获取所有图数据库密码
     * @param {number} skip - 跳过的记录数
     * @param {number} limit - 返回的记录数
     * @returns {Promise<any[]>} - 密码列表
     */
    getAll: async (skip = 0, limit = 100) => {
        return await ApiService.get(`/dtn/graph-db?skip=${skip}&limit=${limit}`);
    },
    
    /**
     * 获取图数据库密码总数
     * @returns {Promise<number>} - 密码总数
     */
    getTotalCount: async () => {
        // 由于后端没有提供获取总数的API，我们通过获取所有记录来计算总数
        // 在实际生产环境中，应该添加一个专门的API来获取总数
        const allPasswords = await ApiService.get('/dtn/graph-db?skip=0&limit=1000');
        return allPasswords.length;
    },
    
    /**
     * 根据 ID 获取图数据库密码
     * @param {number} id - 密码 ID
     * @returns {Promise<any>} - 密码信息
     */
    getById: async (id) => {
        return await ApiService.get(`/dtn/graph-db/${id}`);
    },
    
    /**
     * 创建图数据库密码
     * @param {object} password - 密码信息
     * @returns {Promise<any>} - 创建的密码信息
     */
    create: async (password) => {
        return await ApiService.post('/dtn/graph-db', password);
    },
    
    /**
     * 更新图数据库密码
     * @param {number} id - 密码 ID
     * @param {object} password - 密码信息
     * @returns {Promise<any>} - 更新后的密码信息
     */
    update: async (id, password) => {
        return await ApiService.put(`/dtn/graph-db/${id}`, password);
    },
    
    /**
     * 删除图数据库密码
     * @param {number} id - 密码 ID
     * @returns {Promise<void>}
     */
    delete: async (id) => {
        return await ApiService.delete(`/dtn/graph-db/${id}`);
    }
};

// DIM数据库相关 API
export const DimDBApi = {
    /**
     * 获取所有DIM数据库密码
     * @param {number} skip - 跳过的记录数
     * @param {number} limit - 返回的记录数
     * @returns {Promise<any[]>} - 密码列表
     */
    getAll: async (skip = 0, limit = 100) => {
        return await ApiService.get(`/dtn/dim-db?skip=${skip}&limit=${limit}`);
    },
    
    /**
     * 获取DIM数据库密码总数
     * @returns {Promise<number>} - 密码总数
     */
    getTotalCount: async () => {
        // 由于后端没有提供获取总数的API，我们通过获取所有记录来计算总数
        // 在实际生产环境中，应该添加一个专门的API来获取总数
        const allPasswords = await ApiService.get('/dtn/dim-db?skip=0&limit=1000');
        return allPasswords.length;
    },
    
    /**
     * 根据 ID 获取DIM数据库密码
     * @param {number} id - 密码 ID
     * @returns {Promise<any>} - 密码信息
     */
    getById: async (id) => {
        return await ApiService.get(`/dtn/dim-db/${id}`);
    },
    
    /**
     * 创建DIM数据库密码
     * @param {object} password - 密码信息
     * @returns {Promise<any>} - 创建的密码信息
     */
    create: async (password) => {
        return await ApiService.post('/dtn/dim-db', password);
    },
    
    /**
     * 更新DIM数据库密码
     * @param {number} id - 密码 ID
     * @param {object} password - 密码信息
     * @returns {Promise<any>} - 更新后的密码信息
     */
    update: async (id, password) => {
        return await ApiService.put(`/dtn/dim-db/${id}`, password);
    },
    
    /**
     * 删除DIM数据库密码
     * @param {number} id - 密码 ID
     * @returns {Promise<void>}
     */
    delete: async (id) => {
        return await ApiService.delete(`/dtn/dim-db/${id}`);
    }
};

// 机机账号相关 API
export const MachineAccountApi = {
    /**
     * 获取所有机机账号
     * @param {number} skip - 跳过的记录数
     * @param {number} limit - 返回的记录数
     * @param {string} searchTerm - 搜索关键词（IP或环境编号）
     * @returns {Promise<any[]>} - 账号列表
     */
    getAll: async (skip = 0, limit = 100, searchTerm = null) => {
        let url = `/dtn/machine-account?skip=${skip}&limit=${limit}`;
        if (searchTerm) {
            // 尝试判断是IP还是环境编号
            // IP格式：包含点号
            if (searchTerm.includes('.')) {
                url += `&ip=${encodeURIComponent(searchTerm)}`;
            } else {
                url += `&environment_id=${encodeURIComponent(searchTerm)}`;
            }
        }
        return await ApiService.get(url);
    },
    
    /**
     * 获取机机账号总数
     * @returns {Promise<number>} - 账号总数
     */
    getTotalCount: async () => {
        // 由于后端没有提供获取总数的API，我们通过获取所有记录来计算总数
        // 在实际生产环境中，应该添加一个专门的API来获取总数
        const allAccounts = await ApiService.get('/dtn/machine-account?skip=0&limit=1000');
        return allAccounts.length;
    },
    
    /**
     * 根据 ID 获取机机账号
     * @param {number} id - 账号 ID
     * @returns {Promise<any>} - 账号信息
     */
    getById: async (id) => {
        return await ApiService.get(`/dtn/machine-account/${id}`);
    },
    
    /**
     * 创建机机账号
     * @param {object} account - 账号信息
     * @returns {Promise<any>} - 创建的账号信息
     */
    create: async (account) => {
        return await ApiService.post('/dtn/machine-account', account);
    },
    
    /**
     * 更新机机账号
     * @param {number} id - 账号 ID
     * @param {object} account - 账号信息
     * @param {boolean} regenerate - 是否重新生成机机账号密码
     * @returns {Promise<any>} - 更新后的账号信息
     */
    update: async (id, account, regenerate = false) => {
        return await ApiService.put(`/dtn/machine-account/${id}?regenerate=${regenerate}`, account);
    },
    
    /**
     * 删除机机账号
     * @param {number} id - 账号 ID
     * @returns {Promise<void>}
     */
    delete: async (id) => {
        return await ApiService.delete(`/dtn/machine-account/${id}`);
    }
};

// 用户相关 API
export const UserApi = {
    /**
     * 获取所有用户
     * @param {number} skip - 跳过的记录数
     * @param {number} limit - 返回的记录数
     * @returns {Promise<any[]>} - 用户列表
     */
    getAll: async (skip = 0, limit = 100) => {
        return await ApiService.get(`/system/users?skip=${skip}&limit=${limit}`);
    },
    
    /**
     * 获取用户总数
     * @returns {Promise<number>} - 用户总数
     */
    getTotalCount: async () => {
        // 由于后端没有提供获取总数的API，我们通过获取所有记录来计算总数
        // 在实际生产环境中，应该添加一个专门的API来获取总数
        const allUsers = await ApiService.get('/system/users?skip=0&limit=1000');
        return allUsers.length;
    },
    
    /**
     * 根据 ID 获取用户
     * @param {number} id - 用户 ID
     * @returns {Promise<any>} - 用户信息
     */
    getById: async (id) => {
        return await ApiService.get(`/system/users/${id}`);
    },
    
    /**
     * 获取带角色的用户信息
     * @param {number} id - 用户 ID
     * @returns {Promise<any>} - 带角色的用户信息
     */
    getWithRoles: async (id) => {
        return await ApiService.get(`/role/users-with-roles/${id}`);
    },
    
    /**
     * 获取用户的角色
     * @param {number} id - 用户 ID
     * @returns {Promise<any[]>} - 角色列表
     */
    getRoles: async (id) => {
        return await ApiService.get(`/role/users/${id}/roles`);
    },
    
    /**
     * 为用户分配角色
     * @param {number} userId - 用户 ID
     * @param {number} roleId - 角色 ID
     * @returns {Promise<any>} - 分配结果
     */
    assignRole: async (userId, roleId) => {
        return await ApiService.post(`/role/users/${userId}/roles`, roleId);
    },
    
    /**
     * 移除用户角色
     * @param {number} userId - 用户 ID
     * @param {number} roleId - 角色 ID
     * @returns {Promise<void>}
     */
    removeRole: async (userId, roleId) => {
        return await ApiService.delete(`/role/users/${userId}/roles/${roleId}`);
    },
    
    /**
     * 创建用户
     * @param {object} user - 用户信息
     * @returns {Promise<any>} - 创建的用户信息
     */
    create: async (user) => {
        return await ApiService.post('/system/users', user);
    },
    
    /**
     * 更新用户
     * @param {number} id - 用户 ID
     * @param {object} user - 用户信息
     * @returns {Promise<any>} - 更新后的用户信息
     */
    update: async (id, user) => {
        return await ApiService.put(`/system/users/${id}`, user);
    },
    
    /**
     * 删除用户
     * @param {number} id - 用户 ID
     * @returns {Promise<void>}
     */
    delete: async (id) => {
        return await ApiService.delete(`/system/users/${id}`);
    },
    
    /**
     * 用户登录
     * @param {object} credentials - 登录凭证
     * @returns {Promise<any>} - 登录结果
     */
    login: async (credentials) => {
        return await ApiService.post('/system/login', credentials);
    }
};

// 角色相关 API
export const RoleApi = {
    /**
     * 获取所有角色
     * @param {number} skip - 跳过的记录数
     * @param {number} limit - 返回的记录数
     * @returns {Promise<any[]>} - 角色列表
     */
    getAll: async (skip = 0, limit = 100) => {
        return await ApiService.get(`/role/roles?skip=${skip}&limit=${limit}`);
    },
    
    /**
     * 根据 ID 获取角色
     * @param {number} id - 角色 ID
     * @returns {Promise<any>} - 角色信息
     */
    getById: async (id) => {
        return await ApiService.get(`/role/roles/${id}`);
    },
    
    /**
     * 创建角色
     * @param {object} role - 角色信息
     * @returns {Promise<any>} - 创建的角色信息
     */
    create: async (role) => {
        return await ApiService.post('/role/roles', role);
    },
    
    /**
     * 更新角色
     * @param {number} id - 角色 ID
     * @param {object} role - 角色信息
     * @returns {Promise<any>} - 更新后的角色信息
     */
    update: async (id, role) => {
        return await ApiService.put(`/role/roles/${id}`, role);
    },
    
    /**
     * 删除角色
     * @param {number} id - 角色 ID
     * @returns {Promise<void>}
     */
    delete: async (id) => {
        return await ApiService.delete(`/role/roles/${id}`);
    }
};

// 将 ApiService 暴露到全局作用域
window.ApiService = ApiService;

// 工具函数
export const Utils = {
    /**
     * 格式化日期时间
     * @param {string} dateTimeString - 日期时间字符串
     * @returns {string} - 格式化后的日期时间
     */
    formatDateTime: (dateTimeString) => {
        const date = new Date(dateTimeString);
        return date.toLocaleString('zh-CN', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
    },
    
    /**
     * 显示提示信息
     * @param {string} message - 提示信息
     * @param {string} type - 提示类型 (success, danger, warning, info)
     */
    showAlert: (message, type = 'info') => {
        const alertDiv = $(`<div class="alert alert-${type} position-fixed top-0 end-0 m-4 z-500" style="z-index: 9999;" role="alert">
            <i class="fas ${type === 'success' ? 'fa-check-circle' : type === 'danger' ? 'fa-exclamation-circle' : type === 'warning' ? 'fa-exclamation-triangle' : 'fa-info-circle'} mr-2"></i>
            ${message}
        </div>`);
        $('body').append(alertDiv);
        setTimeout(() => alertDiv.fadeOut(), 3000);
    },
    
    /**
     * 加载页面
     * @param {string} pageName - 页面名称
     */
    loadPage: (pageName) => {
        // 显示加载动画
        $('#content-container').html(`
            <div class="page-loading">
                <div class="spinner-border text-primary" role="status">
                    <span class="sr-only">加载中...</span>
                </div>
            </div>
        `);

        // 根据页面名称设置页面标题
        const pageTitles = {
            'dashboard': '首页',
            'graph-db-password': '图数据库密码管理',
            'machine-account': '机机账号管理',
            'user-management': '用户管理',
            'role-management': '角色管理'
        };

        // 更新页面标题
        $('#page-title').text(pageTitles[pageName] || 'Auto_Tool 后台管理系统');

        // 加载对应的页面文件
        $.ajax({
            url: `/frontend/pages/${pageName}.html`,
            method: 'GET',
            dataType: 'html',
            success: function(html) {
                // 将页面内容加载到容器中
                $('#content-container').html(html);
                
                // 执行页面特定的初始化函数
                window.initPage(pageName);
            },
            error: function(xhr, status, error) {
                console.error(`Error loading page ${pageName}:`, error);
                $('#content-container').html(`
                    <div class="alert alert-danger text-center py-5">
                        <i class="fas fa-exclamation-circle fa-3x mb-3"></i>
                        <h4 class="alert-heading">页面加载失败</h4>
                        <p>无法加载页面内容，请检查网络连接或服务器状态</p>
                        <button class="btn btn-primary mt-3" onclick="Utils.loadPage('${pageName}')">
                            <i class="fas fa-sync-alt mr-1"></i> 重试
                        </button>
                    </div>
                `);
            }
        });
    }
};
