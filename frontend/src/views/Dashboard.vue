<template>
  <div class="dashboard-container">
    <el-card class="tool-card">
      <template #header>
        <div class="card-header">
          <h3>系统概览</h3>
          <p class="card-description">查看系统的关键指标和最近操作</p>
        </div>
      </template>
      <div class="dashboard-stats">
        <el-row :gutter="20">
          <el-col :xs="12" :sm="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-icon">
                  <el-icon><Key /></el-icon>
                </div>
                <div class="stat-number">{{ stats.graphDbCount || 0 }}</div>
                <div class="stat-label">图数据库密码</div>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-icon">
                  <el-icon><Monitor /></el-icon>
                </div>
                <div class="stat-number">{{ stats.machineAccountCount || 0 }}</div>
                <div class="stat-label">机机账号</div>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-icon">
                  <el-icon><DataAnalysis /></el-icon>
                </div>
                <div class="stat-number">{{ stats.dimDbCount || 0 }}</div>
                <div class="stat-label">DIM数据库</div>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-icon">
                  <el-icon><User /></el-icon>
                </div>
                <div class="stat-number">{{ stats.userCount || 0 }}</div>
                <div class="stat-label">系统用户</div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>

      <div class="recent-activities">
        <h4>最近操作</h4>
        <el-table :data="recentActivities" style="width: 100%" class="activity-table">
          <el-table-column prop="created_at" label="时间" min-width="180">
            <template #default="scope">
              {{ formatDateTime(scope.row.created_at) }}
            </template>
          </el-table-column>
          <el-table-column prop="username" label="用户" min-width="100" />
          <el-table-column prop="operation_type" label="操作类型" min-width="120" />
          <el-table-column prop="operation_desc" label="操作" min-width="200" />
          <el-table-column prop="ip_address" label="IP地址" min-width="120" />
          <el-table-column prop="request_method" label="方法" min-width="80">
            <template #default="scope">
              <el-tag :type="scope.row.request_method === 'POST' ? 'primary' : 'info'" size="small">
                {{ scope.row.request_method || '-' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" min-width="80">
            <template #default="scope">
              <el-tag :type="scope.row.status === 'success' ? 'success' : 'danger'" effect="dark">
                {{ scope.row.status === 'success' ? '成功' : '失败' }}
              </el-tag>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import api from '../api'

// 统计数据
const stats = ref({
  graphDbCount: 0,
  machineAccountCount: 0,
  dimDbCount: 0,
  userCount: 0
})

// 最近操作数据
const recentActivities = ref([])

/**
 * 格式化日期时间
 */
const formatDateTime = (dateTime) => {
  if (!dateTime) return ''
  const date = new Date(dateTime)
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  })
}

/**
 * 获取仪表盘统计数据
 */
const getDashboardStats = async () => {
  try {
    const response = await api.common.getDashboardStats()
    if (response.success) {
      const data = response.data
      stats.value = {
        graphDbCount: data.graph_db_count || 0,
        machineAccountCount: data.machine_account_count || 0,
        dimDbCount: data.dim_db_count || 0,
        userCount: data.user_count || 0
      }
    } else {
      ElMessage.error('获取统计数据失败')
    }
  } catch (error) {
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('Get dashboard stats error:', error)
  }
}

/**
 * 获取最近操作日志
 */
const getRecentActivities = async () => {
  try {
    const response = await api.common.getOperationLogs({ limit: 5 })
    if (response) {
      recentActivities.value = response
    } else {
      ElMessage.error('获取操作日志失败')
    }
  } catch (error) {
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('Get recent activities error:', error)
  }
}

onMounted(() => {
  // 获取真实数据
  getDashboardStats()
  getRecentActivities()
  console.log('Dashboard mounted')
})
</script>

<style scoped>
.dashboard-container {
  padding: var(--spacing-lg) 0;
  max-width: 1800px;
  margin: 0 auto;
  width: 100%;
}

.dashboard-stats {
  margin-bottom: var(--spacing-xl);
}

.stat-card {
  border-radius: var(--border-radius-lg);
  border: 1px solid #e0e0e0;
  transition: all 0.3s ease;
  overflow: hidden;
  background: var(--background-color-light);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  height: 100%;
}

.stat-card:hover {
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
  transform: translateY(-6px);
  border-color: #667eea;
}

.stat-content {
  text-align: center;
  padding: var(--spacing-xl) var(--spacing-lg);
  position: relative;
  overflow: hidden;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.stat-content::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #667eea, #764ba2);
}

.stat-icon {
  width: 60px;
  height: 60px;
  margin: 0 auto var(--spacing-md);
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
  border-radius: 50%;
  transition: all 0.3s ease;
}

.stat-card:hover .stat-icon {
  transform: scale(1.1);
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.2), rgba(118, 75, 162, 0.2));
}

.stat-icon :deep(.el-icon) {
  font-size: 24px;
  color: #667eea;
  transition: all 0.3s ease;
}

.stat-card:hover .stat-icon :deep(.el-icon) {
  transform: scale(1.2);
}

.stat-number {
  font-size: 32px;
  font-weight: var(--font-weight-bold);
  color: #667eea;
  margin-bottom: var(--spacing-sm);
  transition: all 0.3s ease;
}

.stat-card:hover .stat-number {
  transform: scale(1.05);
}

.stat-label {
  font-size: var(--font-size-sm);
  color: var(--text-color-secondary);
  font-weight: var(--font-weight-medium);
}

.recent-activities {
  margin-top: var(--spacing-xl);
  padding-top: var(--spacing-xl);
  border-top: 1px solid #e0e0e0;
}

.recent-activities h4 {
  margin: 0 0 var(--spacing-lg) 0;
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--text-color);
}

.activity-table {
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
  width: 100%;
}

.activity-table:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
}

.activity-table :deep(.el-table__header-wrapper) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.activity-table :deep(.el-table th) {
  background: transparent !important;
  color: white !important;
  font-weight: var(--font-weight-semibold);
  border-bottom: none;
  text-align: center;
}

.activity-table :deep(.el-table__body-wrapper) {
  background: var(--background-color-light);
}

.activity-table :deep(.el-table tr) {
  transition: all 0.3s ease;
}

.activity-table :deep(.el-table tr:hover) {
  background-color: rgba(102, 126, 234, 0.05) !important;
}

.activity-table :deep(.el-table td) {
  border-bottom: 1px solid #f0f0f0;
}

.activity-table :deep(.el-tag) {
  border-radius: var(--border-radius-sm);
  font-size: var(--font-size-xs);
  padding: 2px 8px;
}

@media (max-width: 768px) {
  .stat-content {
    padding: var(--spacing-lg) var(--spacing-md);
  }
  
  .stat-icon {
    width: 50px;
    height: 50px;
  }
  
  .stat-icon :deep(.el-icon) {
    font-size: 20px;
  }
  
  .stat-number {
    font-size: 24px;
  }
  
  .recent-activities {
    margin-top: var(--spacing-lg);
    padding-top: var(--spacing-lg);
  }
  
  .activity-table :deep(.el-table th),
  .activity-table :deep(.el-table td) {
    font-size: var(--font-size-sm);
  }
}
</style>
