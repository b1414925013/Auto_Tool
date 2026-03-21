<template>
  <div class="not-found-container">
    <div class="not-found-content">
      <div class="error-code">404</div>
      <h2 class="error-title">页面不存在</h2>
      <p class="error-subtitle">抱歉，您访问的页面不存在或已被移除</p>
      <div class="error-actions">
        <el-button type="primary" @click="goHome" class="home-button">
          <el-icon><HomeFilled /></el-icon>
          返回首页
        </el-button>
        <el-button @click="goBack" class="back-button">
          <el-icon><ArrowLeft /></el-icon>
          返回上一页
        </el-button>
      </div>
      <div class="error-illustration">
        <img src="https://trae-api-cn.mchost.guru/api/ide/v1/text_to_image?prompt=modern%20404%20error%20illustration%20with%20abstract%20geometric%20shapes%20in%20purple%20and%20blue%20colors%2C%20minimalist%20design&image_size=square_hd" alt="404 Error" class="illustration-image">
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { HomeFilled, ArrowLeft } from '@element-plus/icons-vue'

const router = useRouter()

const goHome = () => {
  router.push('/dashboard')
}

const goBack = () => {
  router.back()
}
</script>

<style scoped>
.not-found-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: var(--spacing-lg);
  font-family: var(--font-family);
}

.not-found-content {
  width: 100%;
  max-width: 600px;
  text-align: center;
  background: var(--background-color-light);
  border-radius: var(--border-radius-xl);
  padding: var(--spacing-3xl);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
  transition: all 0.3s ease;
  animation: fadeIn 0.6s ease-in-out;
}

.not-found-content:hover {
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.2);
  transform: translateY(-2px);
}

.error-code {
  font-size: 8rem;
  font-weight: var(--font-weight-bold);
  color: #667eea;
  margin-bottom: var(--spacing-md);
  line-height: 1;
  animation: pulse 2s infinite;
}

.error-title {
  font-size: var(--font-size-2xl);
  font-weight: var(--font-weight-semibold);
  color: var(--text-color-primary);
  margin-bottom: var(--spacing-md);
}

.error-subtitle {
  font-size: var(--font-size-lg);
  color: var(--text-color-secondary);
  margin-bottom: var(--spacing-xl);
  line-height: 1.5;
}

.error-actions {
  display: flex;
  gap: var(--spacing-md);
  justify-content: center;
  margin-bottom: var(--spacing-2xl);
  flex-wrap: wrap;
}

.home-button {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  background-color: #667eea !important;
  border: 1px solid #667eea !important;
  padding: var(--spacing-sm) var(--spacing-xl);
  font-size: var(--font-size-md);
  font-weight: var(--font-weight-medium);
}

.home-button:hover {
  background-color: #5a6fd8 !important;
  border-color: #5a6fd8 !important;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
  transform: translateY(-1px);
}

.back-button {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  padding: var(--spacing-sm) var(--spacing-xl);
  font-size: var(--font-size-md);
  font-weight: var(--font-weight-medium);
}

.back-button:hover {
  border-color: #667eea;
  color: #667eea;
  transform: translateY(-1px);
}

.error-illustration {
  margin-top: var(--spacing-xl);
}

.illustration-image {
  max-width: 100%;
  height: auto;
  border-radius: var(--border-radius-lg);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  animation: float 3s ease-in-out infinite;
}

/* 动画效果 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes pulse {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
  100% {
    transform: scale(1);
  }
}

@keyframes float {
  0% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
  100% {
    transform: translateY(0);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .not-found-content {
    padding: var(--spacing-xl);
  }
  
  .error-code {
    font-size: 6rem;
  }
  
  .error-title {
    font-size: var(--font-size-xl);
  }
  
  .error-subtitle {
    font-size: var(--font-size-md);
  }
  
  .error-actions {
    flex-direction: column;
    align-items: center;
  }
  
  .home-button,
  .back-button {
    width: 100%;
    max-width: 200px;
  }
}

@media (max-width: 480px) {
  .error-code {
    font-size: 4rem;
  }
  
  .not-found-content {
    padding: var(--spacing-lg);
  }
}
</style>
