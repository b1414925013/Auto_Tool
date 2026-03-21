<template>
  <div v-if="route.path === '/login'">
    <router-view v-slot="{ Component }">
      <transition name="fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
  </div>
  <div v-else class="app-container">
    <!-- 侧边栏 -->
    <el-aside :width="sidebarWidth" class="sidebar" style="background: linear-gradient(180deg, var(--sidebar-bg-light) 0%, var(--sidebar-bg) 100%) !important; color: var(--sidebar-text) !important;">
      <div class="sidebar-header">
        <h3><el-icon><Tools /></el-icon> Auto_Tool</h3>
      </div>
      <el-menu
        :default-active="activeMenu"
        class="sidebar-menu"
        router
        :collapse="isCollapse"
        @select="handleMenuSelect"
        style="background-color: transparent !important; border-right: none !important;"
      >
        <!-- 首页 -->
        <el-menu-item index="/dashboard">
          <el-icon><House /></el-icon>
          <template #title>首页</template>
        </el-menu-item>

        <!-- DTN 菜单 -->
        <el-sub-menu index="/dtn">
          <template #title>
            <el-icon><DataAnalysis /></el-icon>
            <span>DTN</span>
          </template>
          <el-menu-item index="/dtn/graph-db">
            <el-icon><Key /></el-icon>
            <template #title>图数据库</template>
          </el-menu-item>
          <el-menu-item index="/dtn/machine-account">
            <el-icon><Monitor /></el-icon>
            <template #title>机机账号</template>
          </el-menu-item>
        </el-sub-menu>

        <!-- DIM 菜单 -->
        <el-sub-menu index="/dim">
          <template #title>
            <el-icon><DataAnalysis /></el-icon>
            <span>DIM</span>
          </template>
          <el-menu-item index="/dim/database">
            <el-icon><DataAnalysis /></el-icon>
            <template #title>DIM数据库</template>
          </el-menu-item>
        </el-sub-menu>

        <!-- 系统管理菜单 -->
        <el-sub-menu v-if="['admin', 'super_admin'].includes(userRole)" index="/system">
          <template #title>
            <el-icon><Setting /></el-icon>
            <span>系统管理</span>
          </template>
          <el-menu-item index="/system/users">
            <el-icon><User /></el-icon>
            <template #title>用户管理</template>
          </el-menu-item>
          <el-menu-item index="/system/roles">
            <el-icon><User /></el-icon>
            <template #title>角色管理</template>
          </el-menu-item>
        </el-sub-menu>

        <!-- 公共菜单 -->
        <el-sub-menu index="/common">
          <template #title>
            <el-icon><DataAnalysis /></el-icon>
            <span>公共</span>
          </template>
          <el-menu-item index="/common/tools">
            <el-icon><Tools /></el-icon>
            <template #title>公共工具</template>
          </el-menu-item>
          <el-menu-item index="/common/custom">
            <el-icon><Setting /></el-icon>
            <template #title>自定义工具</template>
          </el-menu-item>
        </el-sub-menu>
      </el-menu>
    </el-aside>

    <!-- 主内容区域 -->
    <el-container class="main-container">
      <!-- 顶部导航栏 -->
      <el-header height="60px" class="top-navbar">
        <div class="navbar-left">
          <el-button 
            link
            @click="toggleSidebar"
            class="sidebar-toggle"
          >
            <el-icon><Menu /></el-icon>
          </el-button>
          <el-breadcrumb separator="/" class="breadcrumb">
            <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item v-if="breadcrumbItems.length > 0" v-for="(item, index) in breadcrumbItems" :key="index" :to="{ path: item.path }">
              {{ item.label }}
            </el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <div class="navbar-right">
          <span class="welcome-text">欢迎，{{ username }}</span>
          <el-button 
            link
            @click="logout"
            class="logout-btn"
          >
            <el-icon><Switch /></el-icon>
            退出
          </el-button>
        </div>
      </el-header>

      <!-- 页面内容 -->
      <el-main class="page-content">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Menu } from '@element-plus/icons-vue'


const router = useRouter()
const route = useRoute()

// 侧边栏状态
const isCollapse = ref(false)
const sidebarWidth = computed(() => isCollapse.value ? '64px' : '200px')

// 活跃菜单
const activeMenu = computed(() => {
  const path = route.path
  return path
})

// 页面标题
const pageTitle = ref('Auto_Tool')

// 面包屑导航项
const breadcrumbItems = ref([])

// 用户名
const username = ref('管理员')
// 用户角色
const userRole = ref('normal_user')

// 切换侧边栏
const toggleSidebar = () => {
  isCollapse.value = !isCollapse.value
}

// 生成面包屑导航项
const generateBreadcrumbItems = () => {
  const path = route.path
  const items = []
  
  // 根据路由路径生成面包屑导航项
  const pathParts = path.split('/').filter(part => part)
  let currentPath = ''
  
  for (const part of pathParts) {
    currentPath += `/${part}`
    
    // 为每个路径部分添加对应的标签
    let label = part
    switch (currentPath) {
      case '/dashboard':
        label = '首页'
        break
      case '/dtn':
        label = 'DTN'
        break
      case '/dtn/graph-db':
        label = '图数据库'
        break
      case '/dtn/machine-account':
        label = '机机账号'
        break
      case '/dim':
        label = 'DIM'
        break
      case '/dim/database':
        label = 'DIM数据库'
        break
      case '/system':
        label = '系统管理'
        break
      case '/system/users':
        label = '用户管理'
        break
      case '/system/roles':
        label = '角色管理'
        break
      case '/common':
        label = '公共工具'
        break
      case '/common/tools':
        label = '工具列表'
        break
      case '/common/custom':
        label = '自定义工具'
        break
      case '/tools':
        label = '工具'
        break
      case '/tools/ip':
        label = 'IP地址工具'
        break
      case '/tools/password':
        label = '密码生成器'
        break
      case '/tools/json':
        label = 'JSON工具'
        break
      case '/tools/timestamp':
        label = '时间戳转换'
        break
      case '/tools/naming':
        label = '命名转换工具'
        break
      case '/tools/base64':
        label = 'Base64工具'
        break
      case '/tools/url':
        label = 'URL工具'
        break
      case '/tools/hash':
        label = '哈希工具'
        break
      case '/tools/color':
        label = '颜色转换工具'
        break
      case '/tools/python':
        label = 'Python字典转JSON'
        break
      case '/tools/jsonpath':
        label = 'JSONPath工具'
        break
      default:
        // 对于未明确指定的路径，使用路径部分作为标签
        label = part
    }
    
    items.push({ path: currentPath, label })
  }
  
  breadcrumbItems.value = items
}

// 处理菜单选择
const handleMenuSelect = (key, keyPath) => {
  // 根据路由设置页面标题
  const titleMap = {
    '/dashboard': '首页',
    '/dtn/graph-db': '图数据库',
    '/dtn/machine-account': '机机账号',
    '/dim/database': 'DIM数据库',
    '/system/users': '用户管理',
    '/system/roles': '角色管理',
    '/common/tools': '公共工具',
    '/common/custom': '自定义工具'
  }
  pageTitle.value = titleMap[route.path] || 'Auto_Tool 后台管理系统'
  
  // 生成面包屑导航项
  generateBreadcrumbItems()
}

// 监听路由变化，更新面包屑导航
watch(() => route.path, () => {
  generateBreadcrumbItems()
}, { immediate: true }) // 立即执行一次

// 退出登录
const logout = () => {
  // 清除本地存储
  localStorage.removeItem('token')
  localStorage.removeItem('username')
  // 跳转到登录页
  router.push('/login')
}

// 检查登录状态
const checkAuth = () => {
  const token = localStorage.getItem('token')
  if (!token && route.path !== '/login') {
    router.push('/login')
  }
}

// 更新用户信息
const updateUserInfo = () => {
  // 获取用户名
  const storedUsername = localStorage.getItem('username')
  if (storedUsername) {
    username.value = storedUsername
  }
  // 获取用户角色
  const storedRole = localStorage.getItem('role')
  if (storedRole) {
    userRole.value = storedRole
  } else {
    // 如果没有存储角色，根据用户名设置默认角色
    if (storedUsername === 'super_admin' || storedUsername === 'admin') {
      userRole.value = storedUsername
      localStorage.setItem('role', storedUsername)
    } else {
      userRole.value = 'normal_user'
      localStorage.setItem('role', 'normal_user')
    }
  }
}

onMounted(() => {
  checkAuth()
  updateUserInfo()
})

// 监听路由变化，当从登录页跳转时更新用户信息
router.afterEach((to, from) => {
  if (from.path === '/login' && to.path !== '/login') {
    updateUserInfo()
  }
})
</script>

<style>
/* 全局重置 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

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
  
  /* 侧边栏 */
  --sidebar-bg: #111827;
  --sidebar-bg-light: #1f2937;
  --sidebar-active-bg: rgba(59, 130, 246, 0.2);
  --sidebar-text: #f3f4f6;
  --sidebar-text-secondary: #9ca3af;
  
  /* 阴影 */
  --header-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
  --card-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  --hover-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
  
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
  
  /* 白色 */
  --white: #ffffff;
}

/* 全局字体样式 */
body {
  font-family: var(--font-family);
  font-size: var(--font-size-base);
  line-height: var(--line-height-base);
  color: var(--text-color);
  background-color: var(--background-color);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
</style>

<style scoped>
.app-container {
  display: flex;
  height: 100vh;
  overflow: hidden;
  background: var(--background-color);
}

/* 侧边栏样式 */
.app-container .el-aside.sidebar {
  background: linear-gradient(180deg, var(--sidebar-bg-light) 0%, var(--sidebar-bg) 100%) !important;
  color: var(--sidebar-text) !important;
  transition: var(--transition-slow);
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
  z-index: 100;
  border-right: 1px solid rgba(255, 255, 255, 0.1);
}

.app-container .el-aside.sidebar .sidebar-header {
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  background: rgba(0, 0, 0, 0.2);
  backdrop-filter: blur(10px);
}

.app-container .el-aside.sidebar .sidebar-header h3 {
  margin: 0;
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  transition: var(--transition);
  color: var(--sidebar-text) !important;
}

.app-container .el-aside.sidebar .sidebar-header h3:hover {
  transform: scale(1.02);
}

.app-container .el-aside.sidebar .sidebar-header :deep(.el-icon) {
  font-size: 20px;
  color: var(--primary-color);
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
  100% {
    transform: scale(1);
  }
}

.app-container .el-aside.sidebar .sidebar-menu {
  border-right: none !important;
  background-color: transparent !important;
  padding: 16px 0;
}

.app-container .el-aside.sidebar .sidebar-menu :deep(.el-menu-item) {
  color: var(--sidebar-text);
  margin: 6px 12px;
  border-radius: var(--border-radius-md);
  height: 44px;
  line-height: 44px;
  transition: var(--transition-slow);
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
}

.app-container .el-aside.sidebar .sidebar-menu :deep(.el-menu-item::before) {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  width: 3px;
  height: 100%;
  background: var(--primary-color);
  transform: scaleY(0);
  transition: var(--transition);
}

.app-container .el-aside.sidebar .sidebar-menu :deep(.el-menu-item:hover),
.app-container .el-aside.sidebar .sidebar-menu :deep(.el-menu-item.is-active) {
  background-color: var(--sidebar-active-bg);
  color: var(--white);
  transform: translateX(4px);
}

.app-container .el-aside.sidebar .sidebar-menu :deep(.el-menu-item:hover::before),
.app-container .el-aside.sidebar .sidebar-menu :deep(.el-menu-item.is-active::before) {
  transform: scaleY(1);
}

.app-container .el-aside.sidebar .sidebar-menu :deep(.el-sub-menu__title) {
  color: var(--sidebar-text);
  margin: 6px 12px;
  border-radius: var(--border-radius-md);
  height: 44px;
  line-height: 44px;
  transition: var(--transition-slow);
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
}

.app-container .el-aside.sidebar .sidebar-menu :deep(.el-sub-menu__title:hover) {
  background-color: var(--sidebar-active-bg);
  color: var(--white);
  transform: translateX(4px);
}

.app-container .el-aside.sidebar .sidebar-menu :deep(.el-sub-menu__title i) {
  color: var(--sidebar-text-secondary);
  transition: var(--transition);
}

.app-container .el-aside.sidebar .sidebar-menu :deep(.el-sub-menu__title:hover i) {
  color: var(--primary-color);
}

.app-container .el-aside.sidebar .sidebar-menu :deep(.el-sub-menu .el-menu) {
  background-color: rgba(255, 255, 255, 0.05) !important;
  border-radius: 0 0 8px 8px;
  margin: 0 12px;
  overflow: hidden;
}

.app-container .el-aside.sidebar .sidebar-menu :deep(.el-sub-menu .el-menu-item) {
  color: var(--sidebar-text-secondary);
  margin: 2px 8px;
  border-radius: var(--border-radius-sm);
  height: 40px;
  line-height: 40px;
  padding-left: 32px !important;
  transition: var(--transition-slow);
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
}

.app-container .el-aside.sidebar .sidebar-menu :deep(.el-sub-menu .el-menu-item:hover),
.app-container .el-aside.sidebar .sidebar-menu :deep(.el-sub-menu .el-menu-item.is-active) {
  color: var(--white);
  transform: translateX(2px);
}

/* 主容器样式 */
.main-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: var(--background-color);
  overflow: hidden;
}

/* 顶部导航栏 */
.top-navbar {
  background: var(--background-color-light);
  box-shadow: var(--header-shadow);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 var(--spacing-lg);
  height: 64px;
  position: relative;
  z-index: 10;
  border-bottom: 1px solid var(--border-color);
}

.top-navbar::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, var(--primary-color), transparent);
}

.navbar-left {
  display: flex;
  align-items: center;
  gap: 20px;
}

.sidebar-toggle {
  font-size: 22px;
  color: var(--text-color);
  transition: var(--transition-slow);
  padding: var(--spacing-sm);
  border-radius: var(--border-radius-md);
  display: flex;
  align-items: center;
  justify-content: center;
}

.sidebar-toggle:hover {
  background-color: rgba(59, 130, 246, 0.1);
  color: var(--primary-color);
  transform: rotate(90deg);
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.2);
}

.breadcrumb {
  margin: 0;
  font-size: var(--font-size-base);
  color: var(--text-color);
}

.breadcrumb :deep(.el-breadcrumb__item:last-child .el-breadcrumb__inner) {
  font-weight: var(--font-weight-semibold);
  color: var(--primary-color);
}

.breadcrumb :deep(.el-breadcrumb__inner) {
  color: var(--text-color);
  transition: var(--transition);
}

.breadcrumb :deep(.el-breadcrumb__inner:hover) {
  color: var(--primary-color);
}

.breadcrumb :deep(.el-breadcrumb__separator) {
  color: var(--text-color-light);
  margin: 0 var(--spacing-sm);
}

.navbar-right {
  display: flex;
  align-items: center;
  gap: 24px;
}

.welcome-text {
  font-size: var(--font-size-sm);
  color: var(--text-color-secondary);
  font-weight: var(--font-weight-medium);
}

.logout-btn {
  color: var(--text-color-secondary);
  transition: var(--transition-slow);
  padding: 6px 12px;
  border-radius: var(--border-radius-md);
  display: flex;
  align-items: center;
  gap: var(--spacing-xs);
}

.logout-btn:hover {
  background-color: rgba(239, 68, 68, 0.1);
  color: var(--danger-color);
  box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2);
}

/* 页面内容区域 */
.page-content {
  flex: 1;
  padding: var(--spacing-lg);
  overflow-y: auto;
  background: linear-gradient(135deg, var(--background-color) 0%, var(--background-color-dark) 100%);
}

/* 卡片样式 */
.card {
  background: var(--background-color-light);
  border-radius: var(--border-radius-md);
  box-shadow: var(--card-shadow);
  padding: var(--spacing-lg);
  margin-bottom: var(--spacing-lg);
  transition: var(--transition);
  border: 1px solid var(--border-color);
}

.card:hover {
  box-shadow: var(--hover-shadow);
  transform: translateY(-2px);
}

.card-header {
  margin-bottom: var(--spacing-md);
  padding-bottom: var(--spacing-md);
  border-bottom: 1px solid var(--border-color);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-title {
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-semibold);
  color: var(--text-color);
  margin: 0;
}

.card-body {
  color: var(--text-color-secondary);
  line-height: var(--line-height-lg);
}

.page-content::-webkit-scrollbar {
  width: 8px;
}

.page-content::-webkit-scrollbar-track {
  background: var(--background-color-dark);
  border-radius: var(--border-radius-sm);
}

.page-content::-webkit-scrollbar-thumb {
  background: var(--text-color-light);
  border-radius: var(--border-radius-sm);
  transition: var(--transition);
}

.page-content::-webkit-scrollbar-thumb:hover {
  background: var(--text-color-secondary);
}

/* 过渡动画 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.4s ease, transform 0.4s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .app-container .el-aside.sidebar {
    position: fixed;
    left: 0;
    top: 0;
    height: 100vh;
    z-index: 1000;
    transform: translateX(-100%);
    box-shadow: 2px 0 20px rgba(0, 0, 0, 0.2);
  }

  .app-container .el-aside.sidebar.open {
    transform: translateX(0);
  }

  .top-navbar {
    padding: 0 var(--spacing-md);
  }

  .navbar-left {
    gap: var(--spacing-md);
  }

  .page-title {
    font-size: var(--font-size-base);
  }

  .page-title::after {
    display: none;
  }

  .navbar-right {
    gap: var(--spacing-md);
  }

  .welcome-text {
    display: none;
  }

  .page-content {
    padding: var(--spacing-md);
  }

  .card {
    padding: var(--spacing-md);
    margin-bottom: var(--spacing-md);
  }

  .card-header {
    margin-bottom: var(--spacing-sm);
    padding-bottom: var(--spacing-sm);
  }

  .card-title {
    font-size: var(--font-size-lg);
  }
}

@media (max-width: 480px) {
  .app-container .el-aside.sidebar .sidebar-header h3 span {
    display: none;
  }

  .app-container .el-aside.sidebar {
    width: 64px !important;
  }

  .app-container .el-aside.sidebar:hover {
    width: 200px !important;
  }

  .top-navbar {
    padding: 0 var(--spacing-sm);
  }

  .sidebar-toggle {
    font-size: 20px;
    padding: var(--spacing-xs);
  }

  .page-title {
    font-size: var(--font-size-sm);
  }

  .logout-btn {
    padding: 4px 8px;
    font-size: var(--font-size-xs);
  }

  .page-content {
    padding: var(--spacing-sm);
  }

  .card {
    padding: var(--spacing-sm);
    margin-bottom: var(--spacing-sm);
  }

  .card-title {
    font-size: var(--font-size-base);
  }
}

/* 加载动画 */
.loading-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
}

.loading-spinner {
  width: 40px;
  height: 40px;
  border: 3px solid rgba(64, 158, 255, 0.2);
  border-top-color: var(--primary-color);
  border-radius: 50%;
  animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* 通用按钮样式 */
.el-button {
  border-radius: var(--border-radius-md);
  transition: var(--transition);
  font-weight: var(--font-weight-medium);
  padding: 8px 16px;
}

.el-button--primary {
  background-color: #667eea !important;
  border-color: #667eea !important;
}

.el-button--primary:hover {
  background-color: #5a6fd8 !important;
  border-color: #5a6fd8 !important;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

.el-button--default:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

/* 全局工具卡片样式 */
.tool-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.tool-card:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
}

.tool-card .card-header {
  padding: var(--spacing-lg);
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-bottom: none;
  margin-bottom: 0;
  padding-bottom: var(--spacing-lg);
  border-bottom: none;
  display: block;
}

.tool-card .card-header h3 {
  margin: 0 0 var(--spacing-xs) 0;
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: white;
}

.tool-card .card-header .card-description {
  margin: 0;
  font-size: var(--font-size-sm);
  color: rgba(255, 255, 255, 0.8);
}

.tool-card .tool-content {
  padding: var(--spacing-xl);
  background-color: var(--background-color-light);
}

/* 结果区域样式 */
.results-section {
  margin-top: var(--spacing-xl);
  padding-top: var(--spacing-xl);
  border-top: 1px solid #e0e0e0;
  animation: fadeIn 0.5s ease;
}

.results-section h4 {
  margin: 0 0 var(--spacing-lg) 0;
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--text-color);
}

.result-field-container {
  position: relative;
}

.result-field {
  width: 100%;
  resize: vertical;
  min-height: 80px;
}

.copy-button {
  position: absolute;
  top: var(--spacing-sm);
  right: var(--spacing-sm);
  color: #667eea;
  transition: all 0.3s ease;
  padding: 4px 8px;
  border-radius: var(--border-radius-sm);
}

.copy-button:hover {
  color: #5a6fd8;
  background-color: rgba(102, 126, 234, 0.1);
}

/* 动作按钮容器 */
.action-buttons {
  display: flex;
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-lg);
  flex-wrap: wrap;
}

.action-button {
  min-width: 80px;
}

/* 加载状态 */
.el-button--loading {
  opacity: 0.8;
}

/* 动画 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 表单样式 */
.el-form-item__label {
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
}

.el-input {
  border-radius: var(--border-radius-md);
  transition: var(--transition);
}

.el-input:focus-within {
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
}

/* 表格样式 */
.el-table {
  border-radius: var(--border-radius-md);
  overflow: hidden;
}

.el-table th {
  background-color: var(--background-color-dark) !important;
  font-weight: var(--font-weight-semibold);
  color: var(--text-color);
}

/* 分页样式 */
.el-pagination {
  margin-top: var(--spacing-lg);
  display: flex;
  justify-content: center;
}

/* 标签样式 */
.el-tag {
  border-radius: var(--border-radius-sm);
}

/* 消息提示样式 */
.el-message {
  min-width: 300px;
  border-radius: var(--border-radius-md);
}

/* 对话框样式 */
.el-dialog {
  border-radius: var(--border-radius-lg);
  overflow: hidden;
}

.el-dialog__header {
  background-color: var(--background-color-dark);
  border-bottom: 1px solid var(--border-color);
}

.el-dialog__title {
  font-weight: var(--font-weight-semibold);
  color: var(--text-color);
}
</style>
