<template>
  <div class="dashboard-container">
    <el-card class="dashboard-card">
      <template #header>
        <div class="card-header">
          <h3>系统概览</h3>
        </div>
      </template>
      <div class="dashboard-stats">
        <el-row :gutter="20">
          <el-col :xs="12" :sm="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-number">128</div>
                <div class="stat-label">图数据库密码</div>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-number">89</div>
                <div class="stat-label">机机账号</div>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-number">45</div>
                <div class="stat-label">DIM数据库</div>
              </div>
            </el-card>
          </el-col>
          <el-col :xs="12" :sm="6">
            <el-card class="stat-card">
              <div class="stat-content">
                <div class="stat-number">12</div>
                <div class="stat-label">系统用户</div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>

      <div class="recent-activities">
        <h4>最近操作</h4>
        <el-table :data="recentActivities" style="width: 100%">
          <el-table-column prop="time" label="时间" width="180" />
          <el-table-column prop="user" label="用户" width="120" />
          <el-table-column prop="action" label="操作" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="scope">
              <el-tag :type="scope.row.status === 'success' ? 'success' : 'danger'">
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

// 最近操作数据
const recentActivities = ref([
  {
    time: '2026-03-19 14:30:22',
    user: 'admin',
    action: '创建图数据库密码',
    status: 'success'
  },
  {
    time: '2026-03-19 13:45:10',
    user: 'user1',
    action: '更新机机账号',
    status: 'success'
  },
  {
    time: '2026-03-19 12:15:33',
    user: 'admin',
    action: '删除DIM数据库记录',
    status: 'success'
  },
  {
    time: '2026-03-19 11:20:45',
    user: 'user2',
    action: '创建图数据库密码',
    status: 'failed'
  },
  {
    time: '2026-03-19 10:05:18',
    user: 'admin',
    action: '更新用户角色',
    status: 'success'
  }
])

onMounted(() => {
  // 这里可以添加获取真实数据的逻辑
  console.log('Dashboard mounted')
})
</script>

<style scoped>
.dashboard-container {
  padding: 20px 0;
}

.dashboard-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dashboard-stats {
  margin-bottom: 30px;
}

.stat-card {
  border-radius: 8px;
  border: 1px solid #e4e7ed;
  transition: all 0.3s ease;
}

.stat-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.stat-content {
  text-align: center;
  padding: 20px 0;
}

.stat-number {
  font-size: 32px;
  font-weight: 600;
  color: #409eff;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 14px;
  color: #606266;
}

.recent-activities {
  margin-top: 30px;
}

.recent-activities h4 {
  margin-bottom: 16px;
  color: #303133;
}
</style>
