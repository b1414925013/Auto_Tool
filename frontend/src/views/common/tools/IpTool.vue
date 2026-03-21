<template>
  <div class="ip-tool-container">
    <el-card class="ip-tool-card">
      <template #header>
        <div class="card-header">
          <h3>IP 地址工具</h3>
          <p class="card-description">检查 IP 地址的有效性和详细信息</p>
        </div>
      </template>

      <div class="tool-content">
        <el-form label-position="top">
          <el-form-item label="IP 地址">
            <el-input 
              v-model="ipToolForm.ip" 
              placeholder="请输入 IP 地址" 
              class="ip-input"
            />
          </el-form-item>

          <div class="action-buttons">
            <el-button 
              type="primary" 
              @click="checkIP"
              class="action-button"
              :loading="loading"
            >
              检查 IP
            </el-button>
            <el-button 
              @click="clearInput"
              class="action-button"
            >
              清空
            </el-button>
          </div>

          <!-- 结果区域 -->
          <div class="results-section">
            <h4>检查结果</h4>
            <div class="result-field-container">
              <el-input
                v-model="ipToolResult"
                type="textarea"
                :rows="6"
                readonly
                placeholder="检查结果将显示在这里"
                class="result-field"
              />
              <el-button 
                type="text" 
                size="small" 
                @click="copyResult"
                class="copy-button"
                :icon="'el-icon-document-copy'"
              >
                复制
              </el-button>
            </div>
          </div>
        </el-form>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import api from '../../../api'

// IP 工具
const ipToolForm = reactive({
  ip: ''
})
const ipToolResult = ref('')

// 加载状态
const loading = ref(false)

/**
 * 检查 IP 地址
 */
const checkIP = async () => {
  if (!ipToolForm.ip) {
    ElMessage.warning('请输入 IP 地址')
    return
  }
  
  loading.value = true
  
  try {
    // 调用后端接口进行IP地址验证
    const response = await api.common.ipTool({
      ip: ipToolForm.ip
    })
    
    if (response && response.success && response.result) {
      const result = response.result
      let resultText = `IP 地址: ${result.ip}\n`
      resultText += `格式: ${result.format}\n`
      resultText += `有效: ${result.valid ? '是' : '否'}\n`
      resultText += `私有地址: ${result.private ? '是' : '否'}\n`
      resultText += `回环地址: ${result.loopback ? '是' : '否'}\n`
      resultText += `保留地址: ${result.reserved ? '是' : '否'}\n`
      ipToolResult.value = resultText
      ElMessage.success('IP 地址检查完成')
    } else if (response && !response.success) {
      ipToolResult.value = response.error
      ElMessage.error('IP 地址检查失败')
    } else {
      ipToolResult.value = '检查失败'
      ElMessage.error('IP 地址检查失败')
    }
  } catch (error) {
    ipToolResult.value = '检查失败'
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('IP地址检查错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * 清空输入
 */
const clearInput = () => {
  ipToolForm.ip = ''
  ipToolResult.value = ''
}

/**
 * 复制结果到剪贴板
 */
const copyResult = () => {
  if (!ipToolResult.value) {
    ElMessage.warning('没有可复制的结果')
    return
  }

  navigator.clipboard.writeText(ipToolResult.value)
    .then(() => {
      ElMessage.success('结果已复制到剪贴板')
    })
    .catch(err => {
      ElMessage.error('复制失败')
      console.error('复制错误:', err)
    })
}
</script>

<style scoped>
.ip-tool-container {
  padding: var(--spacing-lg) 0;
}

.ip-tool-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.ip-tool-card:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
}

.card-header {
  padding: var(--spacing-lg);
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-bottom: none;
}

.card-header h3 {
  margin: 0 0 var(--spacing-xs) 0;
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: white;
}

.card-description {
  margin: 0;
  font-size: var(--font-size-sm);
  color: rgba(255, 255, 255, 0.8);
}

.tool-content {
  padding: var(--spacing-xl);
  background-color: var(--background-color-light);
}

/* 表单样式 */
:deep(.el-form-item) {
  margin-bottom: var(--spacing-lg);
}

:deep(.el-form-item__label) {
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
  font-size: var(--font-size-base);
  margin-bottom: var(--spacing-sm);
}

:deep(.el-input) {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  border: 1px solid #e0e0e0;
}

:deep(.el-input:focus-within) {
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
  border-color: var(--primary-color);
}

:deep(.el-button) {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  font-weight: var(--font-weight-medium);
  padding: 8px 16px;
}

:deep(.el-button--primary) {
  background-color: #667eea !important;
  border-color: #667eea !important;
}

:deep(.el-button--primary:hover) {
  background-color: #5a6fd8 !important;
  border-color: #5a6fd8 !important;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

:deep(.el-button--default:hover) {
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.ip-input {
  width: 100%;
}

.action-buttons {
  display: flex;
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-lg);
  flex-wrap: wrap;
}

.action-button {
  min-width: 80px;
}

/* 结果区域 */
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
  min-height: 120px;
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

/* 加载状态 */
:deep(.el-button--loading) {
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

@media (max-width: 768px) {
  .tool-content {
    padding: var(--spacing-lg);
  }
  
  .card-header {
    padding: var(--spacing-md);
  }
  
  .card-header h3 {
    font-size: var(--font-size-base);
  }
  
  .action-buttons {
    flex-direction: column;
  }
  
  .action-buttons .el-button {
    width: 100%;
  }
}
</style>
