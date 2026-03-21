<template>
  <div class="base64-tool-container">
    <el-card class="base64-tool-card">
      <template #header>
        <div class="card-header">
          <h3>Base64 加密解密</h3>
          <p class="card-description">将文本进行 Base64 编码或解码</p>
        </div>
      </template>

      <div class="tool-content">
        <el-form label-position="top">
          <el-form-item label="输入文本">
            <el-input 
              v-model="base64ToolInput" 
              type="textarea" 
              :rows="4" 
              placeholder="请输入要加密或解密的文本" 
              class="input-field"
            />
          </el-form-item>
          
          <div class="action-buttons">
            <el-button 
              type="primary" 
              @click="encodeBase64"
              class="action-button"
              :loading="loading"
            >
              加密
            </el-button>
            <el-button 
              type="primary" 
              @click="decodeBase64"
              class="action-button"
              :loading="loading"
            >
              解密
            </el-button>
            <el-button 
              @click="resetForm"
              class="action-button"
            >
              重置
            </el-button>
          </div>

          <!-- 结果区域 -->
          <div class="results-section" v-if="base64ToolResult">
            <h4>结果</h4>
            <div class="result-container">
              <el-input 
                v-model="base64ToolResult" 
                type="textarea" 
                :rows="4" 
                readonly 
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

// Base64 加密解密
const base64ToolInput = ref('')
const base64ToolResult = ref('')

// 加载状态
const loading = ref(false)

/**
 * Base64 加密
 */
const encodeBase64 = async () => {
  if (!base64ToolInput.value) {
    ElMessage.warning('请输入要加密的文本')
    return
  }
  
  loading.value = true
  
  try {
    // 调用后端接口进行Base64加密
    const response = await api.common.base64Tool({
      operation: 'encode',
      input: base64ToolInput.value
    })
    
    if (response && response.success && response.result) {
      base64ToolResult.value = response.result
      ElMessage.success('Base64 加密成功')
    } else {
      base64ToolResult.value = '加密失败'
      ElMessage.error('Base64 加密失败')
    }
  } catch (error) {
    base64ToolResult.value = '加密失败'
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('Base64加密错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * Base64 解密
 */
const decodeBase64 = async () => {
  if (!base64ToolInput.value) {
    ElMessage.warning('请输入要解密的文本')
    return
  }
  
  loading.value = true
  
  try {
    // 调用后端接口进行Base64解密
    const response = await api.common.base64Tool({
      operation: 'decode',
      input: base64ToolInput.value
    })
    
    if (response && response.success && response.result) {
      base64ToolResult.value = response.result
      ElMessage.success('Base64 解密成功')
    } else {
      base64ToolResult.value = '解密失败'
      ElMessage.error('Base64 解密失败')
    }
  } catch (error) {
    base64ToolResult.value = '解密失败'
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('Base64解密错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * 重置表单
 */
const resetForm = () => {
  base64ToolInput.value = ''
  base64ToolResult.value = ''
}

/**
 * 复制结果到剪贴板
 */
const copyResult = () => {
  if (!base64ToolResult.value) {
    return
  }
  
  navigator.clipboard.writeText(base64ToolResult.value)
    .then(() => {
      ElMessage.success('已复制到剪贴板')
    })
    .catch(err => {
      ElMessage.error('复制失败')
      console.error('复制错误:', err)
    })
}
</script>

<style scoped>
.base64-tool-container {
  padding: var(--spacing-lg) 0;
}

.base64-tool-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.base64-tool-card:hover {
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

.input-field {
  width: 100%;
}

.action-buttons {
  display: flex;
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-xl);
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

.result-container {
  position: relative;
}

.result-field {
  width: 100%;
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
