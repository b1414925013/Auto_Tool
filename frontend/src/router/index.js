import { createRouter, createWebHistory } from 'vue-router'

// 路由配置
const routes = [
  {
    path: '/',
    redirect: '/dashboard'
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue')
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: () => import('../views/Dashboard.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/dtn',
    name: 'DTN',
    meta: { requiresAuth: true },
    children: [
      {
        path: 'graph-db',
        name: 'GraphDB',
        component: () => import('../views/dtn/GraphDBPassword.vue')
      },
      {
        path: 'machine-account',
        name: 'MachineAccount',
        component: () => import('../views/dtn/MachineAccount.vue')
      }
    ]
  },
  {
    path: '/dim',
    name: 'DIM',
    meta: { requiresAuth: true },
    children: [
      {
        path: 'database',
        name: 'DimDatabase',
        component: () => import('../views/dim/DimDatabase.vue')
      }
    ]
  },
  {
    path: '/system',
    name: 'System',
    meta: { requiresAuth: true },
    children: [
      {
        path: 'users',
        name: 'UserManagement',
        component: () => import('../views/system/UserManagement.vue')
      },
      {
        path: 'roles',
        name: 'RoleManagement',
        component: () => import('../views/system/RoleManagement.vue')
      }
    ]
  },
  {
    path: '/common',
    name: 'Common',
    meta: { requiresAuth: true },
    children: [
      {
        path: 'tools',
        name: 'CommonTools',
        component: () => import('../views/common/CommonTools.vue')
      },
      {
        path: 'custom',
        name: 'CustomTools',
        component: () => import('../views/common/CustomTools.vue')
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('../views/NotFound.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from) => {
  // 检查是否需要认证
  if (to.matched.some(record => record.meta.requiresAuth)) {
    // 检查是否有token
    const token = localStorage.getItem('token')
    if (!token) {
      // 没有token，跳转到登录页
      return '/login'
    }
  }
  // 不需要认证的页面，直接访问
  return true
})

export default router
