<template>
  <div class="json-tool-container">
    <el-card class="json-tool-card">
      <template #header>
        <div class="card-header">
          <h3>JSON 格式化</h3>
          <p class="card-description">格式化和美化 JSON 数据</p>
        </div>
      </template>

      <div class="tool-content">
        <el-form label-position="top">
          <el-form-item label="JSON 输入">
            <el-input 
              v-model="jsonToolInput" 
              type="textarea" 
              :rows="4" 
              placeholder="请输入 JSON 字符串" 
              class="json-input"
            />
          </el-form-item>

          <div class="action-buttons">
            <el-button 
              type="primary" 
              @click="formatJSON"
              class="action-button"
              :loading="loading"
            >
              格式化
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
            <h4>格式化结果</h4>
            <div class="result-field-container">
              <el-input
                v-model="jsonToolResult"
                type="textarea"
                :rows="4"
                readonly
                placeholder="格式化结果将显示在这里"
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
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import api from '../../../api'

// JSON 格式化
const jsonToolInput = ref('')
const jsonToolResult = ref('')

// 加载状态
const loading = ref(false)

/**
 * 格式化 JSON
 */
const formatJSON = async () => {
  if (!jsonToolInput.value) {
    ElMessage.warning('请输入 JSON 字符串')
    return
  }
  
  loading.value = true
  
  try {
    // 调用后端接口进行JSON格式化
    const response = await api.common.jsonTool({
      operation: 'beautify',
      input: jsonToolInput.value
    })
    
    if (response && response.success && response.result) {
      jsonToolResult.value = response.result
      ElMessage.success('JSON 格式化成功')
    } else {
      jsonToolResult.value = 'JSON 格式错误'
      ElMessage.error('JSON 格式化失败')
    }
  } catch (error) {
    jsonToolResult.value = 'JSON 格式错误'
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('JSON格式化错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * 清空输入
 */
const clearInput = () => {
  jsonToolInput.value = ''
  jsonToolResult.value = ''
}

/**
 * 复制结果到剪贴板
 */
const copyResult = () => {
  if (!jsonToolResult.value) {
    ElMessage.warning('没有可复制的结果')
    return
  }

  navigator.clipboard.writeText(jsonToolResult.value)
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
.json-tool-container {
  padding: var(--spacing-lg) 0;
}

.json-tool-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.json-tool-card:hover {
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

.json-input {
  resize: vertical;
  min-height: 100px;
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
  min-height: 100px;
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
