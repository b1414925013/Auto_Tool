// API 服务
import axios from 'axios'

// 创建 axios 实例
const apiClient = axios.create({
  baseURL: '/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
apiClient.interceptors.request.use(
  config => {
    // 从本地存储获取 token
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 响应拦截器
apiClient.interceptors.response.use(
  response => {
    return response.data
  },
  error => {
    // 处理错误
    if (error.response) {
      // 服务器返回错误
      const status = error.response.status
      if (status === 401) {
        // 未授权，跳转到登录页
        localStorage.removeItem('token')
        window.location.href = '/login'
      }
    }
    return Promise.reject(error)
  }
)

// API 接口
const api = {
  // 认证相关
  auth: {
    login: (data) => apiClient.post('/system/login', data),
    logout: () => apiClient.post('/system/logout')
  },

  // 图数据库密码
  graphDb: {
    getList: (params) => apiClient.get('/dtn/graph-db', { params }),
    create: (data) => apiClient.post('/dtn/graph-db', data),
    update: (id, data) => apiClient.put(`/dtn/graph-db/${id}`, data),
    delete: (id) => apiClient.delete(`/dtn/graph-db/${id}`)
  },

  // 机机账号
  machineAccount: {
    getList: (params) => apiClient.get('/dtn/machine-account', { params }),
    create: (data) => apiClient.post('/dtn/machine-account', data),
    update: (id, data) => apiClient.put(`/dtn/machine-account/${id}`, data),
    delete: (id) => apiClient.delete(`/dtn/machine-account/${id}`)
  },

  // DIM数据库
  dimDb: {
    getList: (params) => apiClient.get('/dim/dim-db', { params }),
    create: (data) => apiClient.post('/dim/dim-db', data),
    update: (id, data) => apiClient.put(`/dim/dim-db/${id}`, data),
    delete: (id) => apiClient.delete(`/dim/dim-db/${id}`)
  },

  // 用户管理
  user: {
    getList: (params) => apiClient.get('/system/users', { params }),
    create: (data) => apiClient.post('/system/users', data),
    update: (id, data) => apiClient.put(`/system/users/${id}`, data),
    delete: (id) => apiClient.delete(`/system/users/${id}`),
    getRoles: () => apiClient.get('/role/roles'),
    getUserRoles: (userId) => apiClient.get(`/system/users/${userId}/roles`),
    getCurrentUser: () => apiClient.get('/system/users/me')
  },

  // 角色管理
  role: {
    getList: (params) => apiClient.get('/role/roles', { params }),
    create: (data) => apiClient.post('/role/roles', data),
    update: (id, data) => apiClient.put(`/role/roles/${id}`, data),
    delete: (id) => apiClient.delete(`/role/roles/${id}`)
  }
}

export default api
