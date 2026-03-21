<template>
  <div class="machine-account-container">
    <el-card class="machine-account-card">
      <template #header>
        <div class="card-header">
          <h3>机机账号管理</h3>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            新增
          </el-button>
        </div>
      </template>

      <!-- 搜索框 -->
      <div class="search-box">
        <el-input
          v-model="searchKeyword"
          placeholder="搜索环境编号或IP地址"
          class="search-input"
          @keyup.enter="handleSearch"
        >
          <template #append>
            <el-button @click="handleSearch">
              <el-icon><Search /></el-icon>
            </el-button>
          </template>
        </el-input>
      </div>

      <!-- 数据表格 -->
      <el-table :data="machineAccountList" style="width: 100%" stripe>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="environment_id" label="环境编号" width="150" />
        <el-table-column prop="ip" label="IP地址" width="150" />
        <el-table-column prop="port" label="端口" width="100" />
        <el-table-column prop="account" label="账号" width="150" />
        <el-table-column prop="type" label="类型" width="100" />
        <el-table-column prop="machine_account" label="机机账号" />
        <el-table-column prop="machine_password" label="机机密码" />
        <el-table-column label="创建时间" width="180">
          <template #default="scope">
            {{ formatDateTime(scope.row.created_at) }}
          </template>
        </el-table-column>
        <el-table-column label="更新时间" width="180">
          <template #default="scope">
            {{ formatDateTime(scope.row.updated_at) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="scope">
            <div class="operation-buttons">
              <el-button type="primary" size="small" @click="handleEdit(scope.row)">
                <el-icon><Edit /></el-icon>
                编辑
              </el-button>
              <el-button type="danger" size="small" @click="handleDelete(scope.row.id)">
                <el-icon><Delete /></el-icon>
                删除
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      @close="handleDialogClose"
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="120px"
      >
        <el-form-item label="环境编号" prop="environment_id">
          <el-input v-model="formData.environment_id" placeholder="请输入环境编号" />
        </el-form-item>
        <el-form-item label="IP地址" prop="ip">
          <el-input v-model="formData.ip" placeholder="请输入IP地址" />
        </el-form-item>
        <el-form-item label="端口" prop="port">
          <el-input-number v-model="formData.port" :min="1" :max="65535" :step="1" />
        </el-form-item>
        <el-form-item label="账号" prop="account">
          <el-input v-model="formData.account" placeholder="请输入账号" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="formData.password" type="password" placeholder="请输入密码" />
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-input v-model="formData.type" placeholder="请输入类型" />
        </el-form-item>
        <el-form-item label="机机账号" prop="machine_account">
          <el-input v-model="formData.machine_account" placeholder="请输入机机账号" />
        </el-form-item>
        <el-form-item label="机机密码" prop="machine_password">
          <el-input v-model="formData.machine_password" type="password" placeholder="请输入机机密码" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSave" :loading="loading">
            保存
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search, Edit, Delete } from '@element-plus/icons-vue'
import api from '../../api'

// 时间格式化函数
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

// 数据列表
const machineAccountList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const searchKeyword = ref('')
const loading = ref(false)

// 对话框状态
const dialogVisible = ref(false)
const dialogTitle = ref('新增机机账号')
const formRef = ref(null)

// 表单数据
const formData = reactive({
  environment_id: '',
  ip: '',
  port: 45339,
  account: '',
  password: '',
  type: '',
  machine_account: '',
  machine_password: ''
})

// 表单验证规则
const formRules = {
  environment_id: [
    { required: true, message: '请输入环境编号', trigger: 'blur' }
  ],
  ip: [
    { required: true, message: '请输入IP地址', trigger: 'blur' }
  ],
  port: [
    { required: true, message: '请输入端口', trigger: 'blur' }
  ],
  account: [
    { required: true, message: '请输入账号', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' }
  ]
}

// 加载数据
const loadData = async () => {
  try {
    loading.value = true
    const params = {
      skip: (currentPage.value - 1) * pageSize.value,
      limit: pageSize.value
    }
    if (searchKeyword.value) {
      // 这里可以根据后端 API 支持的参数进行调整
    }
    const response = await api.machineAccount.getList(params)
    machineAccountList.value = response.items || []
    total.value = response.total || 0
  } catch (error) {
    ElMessage.error('加载数据失败')
    console.error('Load data error:', error)
  } finally {
    loading.value = false
  }
}

// 对话框关闭事件
const handleDialogClose = () => {
  // 重置表单验证状态
  if (formRef.value) {
    formRef.value.resetFields()
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  loadData()
}

// 分页大小变化
const handleSizeChange = (size) => {
  pageSize.value = size
  loadData()
}

// 页码变化
const handleCurrentChange = (current) => {
  currentPage.value = current
  loadData()
}

// 新增
const handleAdd = () => {
  dialogTitle.value = '新增机机账号'
  // 重置表单
  Object.keys(formData).forEach(key => {
    if (key === 'port') {
      formData[key] = 45339
    } else {
      formData[key] = ''
    }
  })
  // 重置表单验证状态
  if (formRef.value) {
    formRef.value.resetFields()
  }
  dialogVisible.value = true
}

// 编辑
const handleEdit = (row) => {
  dialogTitle.value = '编辑机机账号'
  // 重置表单验证状态
  if (formRef.value) {
    formRef.value.resetFields()
  }
  // 复制数据到表单
  Object.assign(formData, row)
  dialogVisible.value = true
}

// 保存
const handleSave = async () => {
  try {
    // 验证表单
    await formRef.value.validate()
    loading.value = true
    
    if (formData.id) {
      // 更新
      await api.machineAccount.update(formData.id, formData)
      ElMessage.success('更新成功')
    } else {
      // 新增
      await api.machineAccount.create(formData)
      ElMessage.success('创建成功')
    }
    
    dialogVisible.value = false
    loadData()
  } catch (error) {
    if (error.name === 'Error') {
      ElMessage.error(error.message)
    } else {
      ElMessage.error('操作失败')
    }
    console.error('Save error:', error)
  } finally {
    loading.value = false
  }
}

// 删除
const handleDelete = async (id) => {
  try {
    await ElMessageBox.confirm(
      '确定要删除这条记录吗？',
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    await api.machineAccount.delete(id)
    ElMessage.success('删除成功')
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
      console.error('Delete error:', error)
    }
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.machine-account-container {
  padding: 20px 0;
}

.machine-account-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-box {
  margin: 20px;
}

.search-input {
  width: 400px;
}

.pagination-container {
  margin: 20px;
  display: flex;
  justify-content: flex-end;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}

/* 操作按钮样式 */
.operation-buttons {
  display: flex;
  gap: 8px;
  align-items: center;
}

/* 表格样式 */
:deep(.el-table) {
  margin: 20px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

:deep(.el-table__header-wrapper) {
  background-color: #fafafa;
  border-bottom: 1px solid #e0e0e0;
}

:deep(.el-table th) {
  font-weight: 600;
  color: #333;
  font-size: 14px;
}

:deep(.el-table tr:hover) {
  background-color: #f5f7fa !important;
}

:deep(.el-table__row:nth-child(even)) {
  background-color: #fafafa;
}
</style>
