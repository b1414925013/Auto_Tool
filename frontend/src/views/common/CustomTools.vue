<template>
  <div class="custom-tools-container">
    <el-card class="custom-tools-card">
      <template #header>
        <div class="card-header">
          <h3>自定义工具</h3>
          <el-button type="primary" @click="handleAddTool" icon="Plus">
            新增工具
          </el-button>
        </div>
      </template>

      <!-- 工具列表 -->
      <el-table :data="toolList" style="width: 100%" stripe>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="工具名称" width="180" />
        <el-table-column prop="description" label="工具描述" />
        <el-table-column prop="type" label="工具类型" width="120">
          <template #default="scope">
            <el-tag :type="scope.row.type === 'api' ? 'primary' : 'warning'">
              {{ scope.row.type === 'api' ? 'API 工具' : '本地工具' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="创建时间" width="180" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="scope">
            <el-button type="primary" size="small" @click="handleEditTool(scope.row)" icon="Edit">
              编辑
            </el-button>
            <el-button type="danger" size="small" @click="handleDeleteTool(scope.row.id)" icon="Delete">
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
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="120px"
      >
        <el-form-item label="工具名称" prop="name">
          <el-input v-model="formData.name" placeholder="请输入工具名称" />
        </el-form-item>
        <el-form-item label="工具描述" prop="description">
          <el-input v-model="formData.description" type="textarea" placeholder="请输入工具描述" />
        </el-form-item>
        <el-form-item label="工具类型" prop="type">
          <el-select v-model="formData.type" placeholder="请选择工具类型">
            <el-option label="API 工具" value="api" />
            <el-option label="本地工具" value="local" />
          </el-select>
        </el-form-item>
        <el-form-item label="工具配置" prop="config" v-if="formData.type === 'api'">
          <el-input v-model="formData.config" type="textarea" placeholder="请输入 API 配置（JSON 格式）" />
        </el-form-item>
        <el-form-item label="工具脚本" prop="script" v-if="formData.type === 'local'">
          <el-input v-model="formData.script" type="textarea" placeholder="请输入本地脚本" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSaveTool" :loading="loading">
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
  padding: 20px 0;
}

.custom-tools-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}
</style>
