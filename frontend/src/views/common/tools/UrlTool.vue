<template>
  <div class="url-tool-container">
    <el-card class="url-tool-card">
      <template #header>
        <div class="card-header">
          <h3>URL 编码解码</h3>
          <p class="card-description">对 URL 进行编码和解码操作</p>
        </div>
      </template>

      <div class="tool-content">
        <el-form label-position="top">
          <el-form-item label="输入文本">
            <el-input 
              v-model="urlToolInput" 
              type="textarea" 
              :rows="3" 
              placeholder="请输入要编码或解码的 URL" 
              class="url-input"
            />
          </el-form-item>

          <div class="action-buttons">
            <el-button 
              type="primary" 
              @click="encodeURL"
              class="action-button"
              :loading="loading"
            >
              编码
            </el-button>
            <el-button 
              type="primary" 
              @click="decodeURL"
              class="action-button"
              :loading="loading"
            >
              解码
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
            <h4>结果</h4>
            <div class="result-field-container">
              <el-input
                v-model="urlToolResult"
                type="textarea"
                :rows="3"
                readonly
                placeholder="结果将显示在这里"
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

// URL 编码解码
const urlToolInput = ref('')
const urlToolResult = ref('')

// 加载状态
const loading = ref(false)

/**
 * URL 编码
 */
const encodeURL = async () => {
  if (!urlToolInput.value) {
    ElMessage.warning('请输入要编码的 URL')
    return
  }
  
  loading.value = true
  
  try {
    // 调用后端接口进行URL编码
    const response = await api.common.urlTool({
      operation: 'encode',
      input: urlToolInput.value
    })
    
    if (response && response.success && response.result) {
      urlToolResult.value = response.result
      ElMessage.success('URL 编码成功')
    } else {
      urlToolResult.value = '编码失败'
      ElMessage.error('URL 编码失败')
    }
  } catch (error) {
    urlToolResult.value = '编码失败'
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('URL编码错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * URL 解码
 */
const decodeURL = async () => {
  if (!urlToolInput.value) {
    ElMessage.warning('请输入要解码的 URL')
    return
  }
  
  loading.value = true
  
  try {
    // 调用后端接口进行URL解码
    const response = await api.common.urlTool({
      operation: 'decode',
      input: urlToolInput.value
    })
    
    if (response && response.success && response.result) {
      urlToolResult.value = response.result
      ElMessage.success('URL 解码成功')
    } else {
      urlToolResult.value = '解码失败'
      ElMessage.error('URL 解码失败')
    }
  } catch (error) {
    urlToolResult.value = '解码失败'
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('URL解码错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * 清空输入
 */
const clearInput = () => {
  urlToolInput.value = ''
  urlToolResult.value = ''
}

/**
 * 复制结果到剪贴板
 */
const copyResult = () => {
  if (!urlToolResult.value) {
    ElMessage.warning('没有可复制的结果')
    return
  }

  navigator.clipboard.writeText(urlToolResult.value)
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
.url-tool-container {
  padding: var(--spacing-lg) 0;
}

.url-tool-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.url-tool-card:hover {
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

.url-input {
  resize: vertical;
  min-height: 80px;
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
  min-height: 80px;
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
