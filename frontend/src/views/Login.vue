<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h2><el-icon><Tools /></el-icon> Auto_Tool 登录</h2>
      </div>
      <el-form
        ref="loginFormRef"
        :model="loginForm"
        :rules="loginRules"
        label-width="80px"
        class="login-form"
      >
        <el-form-item label="用户名" prop="username">
          <el-input v-model="loginForm.username" placeholder="请输入用户名" prefix-icon="UserFilled" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" prefix-icon="Lock" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleLogin" :loading="loading" class="login-btn">
            登录
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import api from '../api'

const router = useRouter()
const loginForm = reactive({
  username: 'user',
  password: '123456'
})

const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' }
  ]
}

const loading = ref(false)
const loginFormRef = ref(null)

const handleLogin = async () => {
  try {
    loading.value = true
    // 实际调用登录 API
    const response = await api.auth.login(loginForm)
    
    // 保存 token、用户名到本地存储
    localStorage.setItem('token', response.access_token)
    localStorage.setItem('username', loginForm.username)
    
    // 调用 /api/system/users/me 接口获取当前用户信息和角色
    try {
      const userInfoResponse = await api.user.getCurrentUser()
      // 保存用户ID
      if (userInfoResponse.id) {
        localStorage.setItem('user_id', userInfoResponse.id)
      }
      // 检查用户角色
      if (userInfoResponse.role) {
        localStorage.setItem('role', userInfoResponse.role)
      } else {
        // 如果没有角色信息，设置为normal_user
        localStorage.setItem('role', 'normal_user')
      }
    } catch (userInfoError) {
      console.error('获取用户信息失败:', userInfoError)
      // 如果获取用户信息失败，根据用户名设置默认角色
      if (loginForm.username === 'super_admin' || loginForm.username === 'admin') {
        localStorage.setItem('role', loginForm.username)
      } else {
        localStorage.setItem('role', 'normal_user')
      }
    }
    
    ElMessage.success('登录成功')
    router.push('/dashboard')
  } catch (error) {
    ElMessage.error('登录失败，请检查用户名和密码')
    console.error('Login error:', error)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
/* 全局变量 */
:root {
  /* 主色调 - 专业蓝色系 */
  --primary-color: #3b82f6;
  --primary-light: #60a5fa;
  --primary-dark: #2563eb;
  --primary-hover: #2563eb;
  
  /* 辅助色 */
  --secondary-color: #8b5cf6;
  --success-color: #10b981;
  --warning-color: #f59e0b;
  --danger-color: #ef4444;
  --info-color: #3b82f6;
  
  /* 中性色 */
  --text-color: #1f2937;
  --text-color-secondary: #6b7280;
  --text-color-light: #9ca3af;
  --border-color: #e5e7eb;
  --border-color-light: #f3f4f6;
  
  /* 背景色 */
  --background-color: #f9fafb;
  --background-color-light: #ffffff;
  --background-color-dark: #f3f4f6;
  
  /* 过渡 */
  --transition: all 0.3s ease;
  --transition-slow: all 0.5s ease;
  
  /* 圆角 */
  --border-radius-sm: 4px;
  --border-radius-md: 8px;
  --border-radius-lg: 12px;
  
  /* 间距 */
  --spacing-xs: 4px;
  --spacing-sm: 8px;
  --spacing-md: 16px;
  --spacing-lg: 24px;
  --spacing-xl: 32px;
  --spacing-2xl: 48px;
  
  /* 字体 */
  --font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  --font-family-mono: 'Fira Code', 'Courier New', monospace;
  
  /* 字号 */
  --font-size-xs: 12px;
  --font-size-sm: 14px;
  --font-size-base: 16px;
  --font-size-lg: 18px;
  --font-size-xl: 20px;
  --font-size-2xl: 24px;
  --font-size-3xl: 30px;
  
  /* 行高 */
  --line-height-xs: 1.2;
  --line-height-sm: 1.4;
  --line-height-base: 1.5;
  --line-height-lg: 1.6;
  --line-height-xl: 1.8;
  
  /* 字重 */
  --font-weight-light: 300;
  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-semibold: 600;
  --font-weight-bold: 700;
}

.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
  position: relative;
  overflow: hidden;
  font-family: var(--font-family);
}

.login-container::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 70%);
  animation: pulse 8s ease-in-out infinite;
}

@keyframes pulse {
  0% {
    transform: scale(1);
    opacity: 0.5;
  }
  50% {
    transform: scale(1.1);
    opacity: 0.8;
  }
  100% {
    transform: scale(1);
    opacity: 0.5;
  }
}

.login-box {
  background: rgba(255, 255, 255, 0.95);
  border-radius: var(--border-radius-lg);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
  padding: var(--spacing-xl);
  width: 420px;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  transition: var(--transition-slow);
  position: relative;
  z-index: 1;
}

.login-box:hover {
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.25);
  transform: translateY(-5px);
}

.login-header {
  text-align: center;
  margin-bottom: 32px;
  position: relative;
}

.login-header::after {
  content: '';
  position: absolute;
  bottom: -16px;
  left: 50%;
  transform: translateX(-50%);
  width: 60px;
  height: 3px;
  background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
  border-radius: 2px;
}

.login-header h2 {
  margin: 0;
  color: var(--text-color);
  font-size: var(--font-size-2xl);
  font-weight: var(--font-weight-semibold);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: var(--spacing-sm);
  animation: slideDown 0.6s ease-out;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-header :deep(.el-icon) {
  font-size: 32px;
  color: var(--primary-color);
  animation: rotateIn 0.8s ease-out;
}

@keyframes rotateIn {
  from {
    opacity: 0;
    transform: rotate(-360deg);
  }
  to {
    opacity: 1;
    transform: rotate(0);
  }
}

.login-form {
  margin-top: 32px;
  animation: fadeIn 0.8s ease-out 0.3s both;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

:deep(.el-form-item) {
  margin-bottom: 24px;
}

:deep(.el-form-item:nth-child(1)) {
  animation: slideUp 0.6s ease-out 0.4s both;
}

:deep(.el-form-item:nth-child(2)) {
  animation: slideUp 0.6s ease-out 0.5s both;
}

:deep(.el-form-item:nth-child(3)) {
  animation: slideUp 0.6s ease-out 0.6s both;
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

:deep(.el-form-item__label) {
  font-weight: 500;
  color: var(--text-color);
  font-size: 14px;
}

:deep(.el-input) {
  border-radius: 8px;
  transition: var(--transition);
  border: 1px solid var(--border-color);
}

:deep(.el-input:focus-within) {
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
  border-color: var(--primary-color);
}

:deep(.el-input__prefix-inner) {
  color: var(--info-color);
}

.el-button.login-btn {
  width: 100%;
  margin-top: 16px;
  height: 44px;
  font-size: 16px;
  font-weight: 500;
  border-radius: var(--border-radius-md);
  background-color: var(--primary-color) !important;
  border: none;
  transition: var(--transition);
  position: relative;
  overflow: hidden;
  color: var(--white) !important;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  line-height: 44px;
  opacity: 1 !important;
  visibility: visible !important;
}

.el-button.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
  background-color: var(--primary-hover) !important;
}

.el-button.login-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
  transition: var(--transition);
}

.el-button.login-btn:hover::before {
  left: 100%;
}

.el-button.login-btn:disabled {
  background: var(--info-color) !important;
  transform: none;
  box-shadow: none;
  color: #ffffff !important;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .login-box {
    width: 90%;
    padding: 32px;
  }

  .login-header h2 {
    font-size: 24px;
  }

  .login-header :deep(.el-icon) {
    font-size: 28px;
  }
}

@media (max-width: 480px) {
  .login-box {
    width: 95%;
    padding: 24px;
  }

  .login-header h2 {
    font-size: 20px;
  }

  .login-header :deep(.el-icon) {
    font-size: 24px;
  }
}
</style>
