<template>
  <div class="machine-account-container">
    <el-card class="tool-card">
      <template #header>
        <div class="card-header">
          <div>
            <h3>机机账号管理</h3>
            <p class="card-description">管理和配置机机账号信息</p>
          </div>
          <el-button type="primary" @click="handleAdd" class="add-button">
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
            <el-button @click="handleSearch" class="search-button">
              <el-icon><Search /></el-icon>
            </el-button>
          </template>
        </el-input>
      </div>

      <!-- 数据表格 -->
      <el-table :data="machineAccountList" style="width: 100%" class="machine-account-table">
        <el-table-column prop="id" label="ID" min-width="80" />
        <el-table-column prop="environment_id" label="环境编号" min-width="120" />
        <el-table-column prop="ip" label="IP地址" min-width="120" />
        <el-table-column prop="type" label="类型" min-width="80" />
        <el-table-column prop="machine_account" label="机机账号" min-width="150" />
        <el-table-column prop="machine_password" label="机机密码" min-width="150" />
        <el-table-column label="创建时间" min-width="180">
          <template #default="scope">
            {{ formatDateTime(scope.row.created_at) }}
          </template>
        </el-table-column>
        <el-table-column label="更新时间" min-width="180">
          <template #default="scope">
            {{ formatDateTime(scope.row.updated_at) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" min-width="120">
          <template #default="scope">
            <div class="operation-buttons">
              <el-button type="primary" size="small" @click="handleEdit(scope.row)" class="action-button">
                <el-icon><Edit /></el-icon>
                编辑
              </el-button>
              <el-button type="danger" size="small" @click="handleDelete(scope.row.id)" class="action-button">
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
          class="pagination"
        />
      </div>
    </el-card>

    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      @close="handleDialogClose"
      class="custom-dialog"
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="120px"
      >
        <el-form-item label="环境编号" prop="environment_id">
          <el-input v-model="formData.environment_id" placeholder="请输入环境编号" class="form-input" />
        </el-form-item>
        <el-form-item label="IP地址" prop="ip">
          <el-input v-model="formData.ip" placeholder="请输入IP地址" class="form-input" />
        </el-form-item>
        <el-form-item label="端口" prop="port">
          <el-input-number v-model="formData.port" :min="1" :max="65535" :step="1" class="form-input-number" />
        </el-form-item>
        <el-form-item label="账号" prop="account">
          <el-input v-model="formData.account" placeholder="请输入账号" class="form-input" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="formData.password" type="password" placeholder="请输入密码" class="form-input" />
        </el-form-item>
        <el-form-item label="类型" prop="type">
          <el-input v-model="formData.type" placeholder="请输入类型" class="form-input" />
        </el-form-item>
        <el-form-item label="机机账号" prop="machine_account">
          <el-input v-model="formData.machine_account" placeholder="请输入机机账号" class="form-input" />
        </el-form-item>
        <el-form-item label="机机密码" prop="machine_password">
          <el-input v-model="formData.machine_password" type="password" placeholder="请输入机机密码" class="form-input" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false" class="cancel-button">取消</el-button>
          <el-button type="primary" @click="handleSave" :loading="loading" class="save-button">
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
  padding: var(--spacing-lg) 0;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: var(--spacing-lg);
}

.card-header > div {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-xs);
}

.card-description {
  font-size: var(--font-size-sm);
  color: rgba(255, 255, 255, 0.8);
  margin: 0;
  font-weight: var(--font-weight-normal);
}

.search-box {
  margin: var(--spacing-lg) var(--spacing-lg) 0;
}

.search-input {
  width: 400px;
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  border: 1px solid #e0e0e0;
}

.search-input:focus-within {
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
  border-color: #667eea;
}

.search-button {
  border-radius: var(--border-radius-sm);
  transition: all 0.3s ease;
}

.search-button:hover {
  border-color: #667eea;
  color: #667eea;
}

.add-button {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  background-color: #667eea !important;
  border: 1px solid #667eea !important;
}

.add-button:hover {
  background-color: #5a6fd8 !important;
  border-color: #5a6fd8 !important;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

.machine-account-table {
  margin: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.machine-account-table:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.machine-account-table :deep(.el-table__header-wrapper) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.machine-account-table :deep(.el-table th) {
  background: transparent !important;
  color: white !important;
  font-weight: var(--font-weight-semibold);
  border-bottom: none;
  text-align: center;
}

.machine-account-table :deep(.el-table__body-wrapper) {
  background: var(--background-color-light);
}

.machine-account-table :deep(.el-table tr) {
  transition: all 0.3s ease;
}

.machine-account-table :deep(.el-table tr:hover) {
  background-color: rgba(102, 126, 234, 0.05) !important;
}

.machine-account-table :deep(.el-table td) {
  border-bottom: 1px solid #f0f0f0;
}

.pagination-container {
  margin: var(--spacing-lg);
  display: flex;
  justify-content: flex-end;
}

.pagination {
  border-radius: var(--border-radius-md);
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.pagination :deep(.el-pagination__sizes),
.pagination :deep(.el-pagination__jump) {
  margin: 0 var(--spacing-md);
}

/* 操作按钮样式 */
.operation-buttons {
  display: flex;
  gap: var(--spacing-sm);
  align-items: center;
}

.action-button {
  transition: all 0.3s ease;
  border-radius: var(--border-radius-sm);
}

.action-button:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

/* 对话框样式 */
.custom-dialog :deep(.el-dialog__header) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: var(--border-radius-lg) var(--border-radius-lg) 0 0;
}

.custom-dialog :deep(.el-dialog__title) {
  color: white !important;
  font-weight: var(--font-weight-semibold);
  font-size: var(--font-size-lg);
}

.custom-dialog :deep(.el-dialog__headerbtn .el-icon-close) {
  color: white !important;
}

/* 表单样式 */
.form-input {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  border: 1px solid #e0e0e0;
  width: 100%;
}

.form-input:focus-within {
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
  border-color: #667eea;
}

.form-input-number {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  border: 1px solid #e0e0e0;
  width: 100%;
}

.form-input-number:focus-within {
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
  border-color: #667eea;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: var(--spacing-md);
  padding-top: var(--spacing-lg);
  border-top: 1px solid #f0f0f0;
  margin-top: var(--spacing-lg);
}

.cancel-button {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
}

.cancel-button:hover {
  border-color: #667eea;
  color: #667eea;
}

.save-button {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  background-color: #667eea !important;
  border: 1px solid #667eea !important;
}

.save-button:hover {
  background-color: #5a6fd8 !important;
  border-color: #5a6fd8 !important;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .card-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--spacing-md);
  }
  
  .search-input {
    width: 100%;
  }
  
  .machine-account-table {
    margin: var(--spacing-md);
  }
  
  .machine-account-table :deep(.el-table th),
  .machine-account-table :deep(.el-table td) {
    font-size: var(--font-size-sm);
  }
  
  .operation-buttons {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--spacing-xs);
  }
  
  .action-button {
    font-size: var(--font-size-xs);
    padding: 4px 8px;
  }
  
  .pagination-container {
    margin: var(--spacing-md);
  }
  
  .custom-dialog {
    width: 90% !important;
  }
  
  .form-input,
  .form-input-number {
    width: 100%;
  }
}
</style>
