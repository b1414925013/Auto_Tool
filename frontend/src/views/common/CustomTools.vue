<template>
  <div class="custom-tools-container">
    <el-card class="tool-card">
      <template #header>
        <div class="card-header">
          <div>
            <h3>自定义工具</h3>
            <p class="card-description">管理和配置自定义工具</p>
          </div>
          <el-button type="primary" @click="handleAddTool" icon="Plus">
            新增工具
          </el-button>
        </div>
      </template>

      <!-- 工具列表 -->
      <el-table :data="toolList" style="width: 100%" class="custom-tools-table">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="工具名称" width="180" />
        <el-table-column prop="description" label="工具描述" />
        <el-table-column prop="type" label="工具类型" width="120">
          <template #default="scope">
            <el-tag :type="scope.row.type === 'api' ? 'primary' : 'warning'" effect="dark">
              {{ scope.row.type === 'api' ? 'API 工具' : '本地工具' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="创建时间" width="180" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="scope">
            <el-button type="primary" size="small" @click="handleEditTool(scope.row)" icon="Edit" class="action-button">
              编辑
            </el-button>
            <el-button type="danger" size="small" @click="handleDeleteTool(scope.row.id)" icon="Delete" class="action-button">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 新增/编辑工具对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      class="custom-dialog"
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="120px"
      >
        <el-form-item label="工具名称" prop="name">
          <el-input v-model="formData.name" placeholder="请输入工具名称" class="form-input" />
        </el-form-item>
        <el-form-item label="工具描述" prop="description">
          <el-input v-model="formData.description" type="textarea" placeholder="请输入工具描述" class="form-input" />
        </el-form-item>
        <el-form-item label="工具类型" prop="type">
          <el-select v-model="formData.type" placeholder="请选择工具类型" class="form-select">
            <el-option label="API 工具" value="api" />
            <el-option label="本地工具" value="local" />
          </el-select>
        </el-form-item>
        <el-form-item label="工具配置" prop="config" v-if="formData.type === 'api'">
          <el-input v-model="formData.config" type="textarea" placeholder="请输入 API 配置（JSON 格式）" class="form-input" />
        </el-form-item>
        <el-form-item label="工具脚本" prop="script" v-if="formData.type === 'local'">
          <el-input v-model="formData.script" type="textarea" placeholder="请输入本地脚本" class="form-input" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false" class="cancel-button">取消</el-button>
          <el-button type="primary" @click="handleSaveTool" :loading="loading" class="save-button">
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
import { Plus, Edit, Delete } from '@element-plus/icons-vue'

// 工具列表
const toolList = ref([
  {
    id: 1,
    name: 'API 测试工具',
    description: '用于测试 API 接口的工具',
    type: 'api',
    config: '{"baseURL": "https://api.example.com"}',
    created_at: '2026-03-19 10:00:00'
  },
  {
    id: 2,
    name: '文件处理工具',
    description: '用于处理本地文件的工具',
    type: 'local',
    script: 'console.log("Hello, World!")',
    created_at: '2026-03-19 11:00:00'
  }
])

const loading = ref(false)

// 对话框状态
const dialogVisible = ref(false)
const dialogTitle = ref('新增工具')
const formRef = ref(null)

// 表单数据
const formData = reactive({
  name: '',
  description: '',
  type: 'api',
  config: '',
  script: ''
})

// 表单验证规则
const formRules = {
  name: [
    { required: true, message: '请输入工具名称', trigger: 'blur' }
  ],
  description: [
    { required: true, message: '请输入工具描述', trigger: 'blur' }
  ],
  type: [
    { required: true, message: '请选择工具类型', trigger: 'change' }
  ],
  config: [
    { required: true, message: '请输入 API 配置', trigger: 'blur' }
  ],
  script: [
    { required: true, message: '请输入本地脚本', trigger: 'blur' }
  ]
}

// 新增工具
const handleAddTool = () => {
  dialogTitle.value = '新增工具'
  // 重置表单
  Object.assign(formData, {
    name: '',
    description: '',
    type: 'api',
    config: '',
    script: ''
  })
  dialogVisible.value = true
}

// 编辑工具
const handleEditTool = (row) => {
  dialogTitle.value = '编辑工具'
  // 复制数据到表单
  Object.assign(formData, row)
  dialogVisible.value = true
}

// 保存工具
const handleSaveTool = async () => {
  try {
    // 验证表单
    await formRef.value.validate()
    loading.value = true
    
    if (formData.id) {
      // 更新
      const index = toolList.value.findIndex(item => item.id === formData.id)
      if (index !== -1) {
        toolList.value[index] = { ...formData }
      }
      ElMessage.success('更新成功')
    } else {
      // 新增
      const newTool = {
        ...formData,
        id: toolList.value.length + 1,
        created_at: new Date().toLocaleString()
      }
      toolList.value.push(newTool)
      ElMessage.success('创建成功')
    }
    
    dialogVisible.value = false
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

// 删除工具
const handleDeleteTool = async (id) => {
  try {
    await ElMessageBox.confirm(
      '确定要删除这个工具吗？',
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    toolList.value = toolList.value.filter(item => item.id !== id)
    ElMessage.success('删除成功')
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
      console.error('Delete error:', error)
    }
  }
}

onMounted(() => {
  // 这里可以添加获取真实数据的逻辑
  console.log('Custom tools mounted')
})
</script>

<style scoped>
.custom-tools-container {
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

.custom-tools-table {
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
  margin-top: var(--spacing-lg);
}

.custom-tools-table:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.custom-tools-table :deep(.el-table__header-wrapper) {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.custom-tools-table :deep(.el-table th) {
  background: transparent !important;
  color: white !important;
  font-weight: var(--font-weight-semibold);
  border-bottom: none;
}

.custom-tools-table :deep(.el-table__body-wrapper) {
  background: var(--background-color-light);
}

.custom-tools-table :deep(.el-table tr) {
  transition: all 0.3s ease;
}

.custom-tools-table :deep(.el-table tr:hover) {
  background-color: rgba(102, 126, 234, 0.05) !important;
}

.custom-tools-table :deep(.el-table td) {
  border-bottom: 1px solid #f0f0f0;
}

.action-button {
  margin-right: var(--spacing-sm);
  transition: all 0.3s ease;
  border-radius: var(--border-radius-sm);
}

.action-button:hover {
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

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

.form-input {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  border: 1px solid #e0e0e0;
}

.form-input:focus-within {
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
  border-color: #667eea;
}

.form-select {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  border: 1px solid #e0e0e0;
}

.form-select:focus-within {
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
  
  .custom-tools-table :deep(.el-table th),
  .custom-tools-table :deep(.el-table td) {
    font-size: var(--font-size-sm);
  }
  
  .action-button {
    font-size: var(--font-size-xs);
    padding: 4px 8px;
  }
  
  .custom-dialog {
    width: 90% !important;
  }
  
  .form-input,
  .form-select {
    width: 100%;
  }
}
</style>
