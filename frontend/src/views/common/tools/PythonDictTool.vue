<template>
  <div class="python-dict-tool-container">
    <el-card class="python-dict-tool-card">
      <template #header>
        <div class="card-header">
          <h3>Python 字典转 JSON</h3>
          <p class="card-description">将 Python 字典转换为 JSON 格式</p>
        </div>
      </template>

      <div class="tool-content">
        <!-- 输入区域 -->
        <el-form label-position="top">
          <el-form-item label="输入 Python 字典">
            <el-input
              v-model="pythonDictInput"
              type="textarea"
              :rows="6"
              placeholder="请输入 Python 字典，例如：{'name': 'John', 'age': 30, 'city': 'New York'}"
              class="python-input"
            />
          </el-form-item>

          <el-form-item label="缩进空格数">
            <el-input-number
              v-model="indentSize"
              :min="0"
              :max="8"
              :step="1"
              class="indent-input"
            />
          </el-form-item>

          <div class="action-buttons">
            <el-button 
              type="primary" 
              @click="convertToJson"
              class="action-button"
              :loading="loading"
            >
              转换为 JSON
            </el-button>
            <el-button 
              @click="clearInput"
              class="action-button"
            >
              清空
            </el-button>
          </div>
        </el-form>

        <!-- 结果区域 -->
        <div class="results-section">
          <h4>JSON 结果</h4>
          <div class="result-field-container">
            <el-input
              v-model="jsonResult"
              type="textarea"
              :rows="6"
              readonly
              placeholder="转换结果将显示在这里"
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

          <div class="result-actions">
            <el-button 
              @click="downloadJson"
              class="action-button"
              :icon="'el-icon-download'"
            >
              下载 JSON 文件
            </el-button>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import api from '../../../api'

// Python字典输入
const pythonDictInput = ref('')
// 缩进空格数
const indentSize = ref(2)
// JSON结果
const jsonResult = ref('')

// 加载状态
const loading = ref(false)

/**
 * 将Python字典转换为JSON
 */
const convertToJson = async () => {
  if (!pythonDictInput.value) {
    ElMessage.warning('请输入 Python 字典')
    return
  }

  loading.value = true
  
  try {
    // 调用后端接口进行Python字典转JSON
    const response = await api.common.pythonDictToJson({
      input: pythonDictInput.value
    })
    
    if (response && response.success && response.result) {
      // 后端返回的是格式化后的JSON字符串，我们可以直接使用
      jsonResult.value = response.result
      ElMessage.success('转换成功')
    } else if (response && !response.success) {
      ElMessage.error(response.error)
    } else {
      ElMessage.error('转换失败')
    }
  } catch (error) {
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('转换错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * 清空输入
 */
const clearInput = () => {
  pythonDictInput.value = ''
  jsonResult.value = ''
}

/**
 * 复制结果到剪贴板
 */
const copyResult = () => {
  if (!jsonResult.value) {
    ElMessage.warning('没有可复制的结果')
    return
  }

  navigator.clipboard.writeText(jsonResult.value)
    .then(() => {
      ElMessage.success('结果已复制到剪贴板')
    })
    .catch(err => {
      ElMessage.error('复制失败')
      console.error('复制错误:', err)
    })
}

/**
 * 下载JSON文件
 */
const downloadJson = () => {
  if (!jsonResult.value) {
    ElMessage.warning('没有可下载的结果')
    return
  }

  try {
    const blob = new Blob([jsonResult.value], { type: 'application/json' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = 'result.json'
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)
    
    ElMessage.success('JSON 文件已下载')
  } catch (error) {
    ElMessage.error('下载失败')
    console.error('下载错误:', error)
  }
}
</script>

<style scoped>
.python-dict-tool-container {
  padding: var(--spacing-lg) 0;
}

.python-dict-tool-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.python-dict-tool-card:hover {
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

:deep(.el-input-number) {
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
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

.python-input {
  resize: vertical;
  min-height: 120px;
}

.indent-input {
  width: 120px;
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
  margin-bottom: var(--spacing-md);
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

.result-actions {
  display: flex;
  gap: var(--spacing-md);
  flex-wrap: wrap;
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
  
  .result-actions {
    flex-direction: column;
  }
  
  .result-actions .el-button {
    width: 100%;
  }
}
</style>