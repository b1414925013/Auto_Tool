<template>
  <div class="timestamp-tool-container">
    <el-card class="timestamp-tool-card">
      <template #header>
        <div class="card-header">
          <h3>时间戳转换</h3>
          <p class="card-description">支持时间戳和时间格式输入，自动转换为多种时间格式</p>
        </div>
      </template>

      <div class="tool-content">
        <el-form :model="timestampToolForm" label-width="120px">
          <el-form-item label="输入类型">
            <el-radio-group v-model="inputType" @change="resetForm">
              <el-radio label="timestamp">时间戳</el-radio>
              <el-radio label="datetime">时间格式</el-radio>
            </el-radio-group>
          </el-form-item>
          
          <el-form-item :label="inputType === 'timestamp' ? '时间戳' : '时间格式'">
            <el-input 
              v-model="timestampToolForm.input" 
              :placeholder="inputType === 'timestamp' ? '请输入时间戳（秒或毫秒）' : '请输入时间格式，如：2024-01-01 12:00:00'" 
              class="input-field"
            />
            <div class="form-hint" v-if="inputType === 'timestamp'">
              支持10位（秒）或13位（毫秒）时间戳
            </div>
            <div class="form-hint" v-else>
              支持多种时间格式，如：2024-01-01 12:00:00、2024/01/01等
            </div>
          </el-form-item>
          
          <div class="action-buttons">
            <el-button 
              type="primary" 
              @click="convertTimestamp"
              class="convert-button"
              :loading="loading"
            >
              转换
            </el-button>
            <el-button 
              @click="resetForm"
              class="reset-button"
            >
              重置
            </el-button>
            <el-button 
              type="info" 
              @click="getCurrentTime"
              class="current-time-button"
            >
              当前时间
            </el-button>
          </div>

          <!-- 结果区域 -->
          <div class="results-section" v-if="conversionResult">
            <h4>转换结果</h4>
            <div class="result-grid">
              <div class="result-item">
                <div class="result-label">日期时间</div>
                <div class="result-value">{{ conversionResult.datetime }}</div>
                <el-button 
                  type="text" 
                  size="small" 
                  @click="copyResult(conversionResult.datetime)"
                  class="copy-button"
                  :icon="'el-icon-document-copy'"
                >
                  复制
                </el-button>
              </div>
              <div class="result-item">
                <div class="result-label">时间戳（秒）</div>
                <div class="result-value">{{ conversionResult.timestamp }}</div>
                <el-button 
                  type="text" 
                  size="small" 
                  @click="copyResult(conversionResult.timestamp)"
                  class="copy-button"
                  :icon="'el-icon-document-copy'"
                >
                  复制
                </el-button>
              </div>
              <div class="result-item">
                <div class="result-label">时间戳（毫秒）</div>
                <div class="result-value">{{ conversionResult.milliseconds }}</div>
                <el-button 
                  type="text" 
                  size="small" 
                  @click="copyResult(conversionResult.milliseconds)"
                  class="copy-button"
                  :icon="'el-icon-document-copy'"
                >
                  复制
                </el-button>
              </div>
              <div class="result-item">
                <div class="result-label">ISO格式</div>
                <div class="result-value">{{ conversionResult.iso }}</div>
                <el-button 
                  type="text" 
                  size="small" 
                  @click="copyResult(conversionResult.iso)"
                  class="copy-button"
                  :icon="'el-icon-document-copy'"
                >
                  复制
                </el-button>
              </div>
              <div class="result-item">
                <div class="result-label">UTC时间</div>
                <div class="result-value">{{ conversionResult.utc }}</div>
                <el-button 
                  type="text" 
                  size="small" 
                  @click="copyResult(conversionResult.utc)"
                  class="copy-button"
                  :icon="'el-icon-document-copy'"
                >
                  复制
                </el-button>
              </div>
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

// 输入类型：timestamp 或 datetime
const inputType = ref('timestamp')

// 时间戳转换
const timestampToolForm = reactive({
  input: ''
})

// 转换结果
const conversionResult = ref(null)

// 加载状态
const loading = ref(false)

/**
 * 转换时间戳或时间格式
 */
const convertTimestamp = async () => {
  if (!timestampToolForm.input) {
    ElMessage.warning('请输入' + (inputType.value === 'timestamp' ? '时间戳' : '时间格式'))
    return
  }
  
  loading.value = true
  
  try {
    // 构建请求数据
    const requestData = inputType.value === 'timestamp' 
      ? { timestamp: timestampToolForm.input } 
      : { datetime: timestampToolForm.input }
    
    // 调用后端接口进行转换
    const response = await api.common.timestampTool(requestData)
    
    if (response && response.success && response.result) {
      conversionResult.value = response.result
      ElMessage.success('转换成功')
    } else {
      ElMessage.error('转换失败')
    }
  } catch (error) {
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('时间戳转换错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * 重置表单
 */
const resetForm = () => {
  timestampToolForm.input = ''
  conversionResult.value = null
}

/**
 * 获取当前时间
 */
const getCurrentTime = async () => {
  loading.value = true
  
  try {
    // 调用后端接口获取当前时间
    const response = await api.common.timestampTool({})
    
    if (response && response.success && response.result) {
      conversionResult.value = response.result
      // 根据当前输入类型设置输入值
      if (inputType.value === 'timestamp') {
        timestampToolForm.input = response.result.timestamp
      } else {
        timestampToolForm.input = response.result.datetime
      }
      ElMessage.success('获取当前时间成功')
    } else {
      ElMessage.error('获取当前时间失败')
    }
  } catch (error) {
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('获取当前时间错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * 复制结果到剪贴板
 */
const copyResult = (value) => {
  navigator.clipboard.writeText(value)
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
.timestamp-tool-container {
  padding: var(--spacing-lg) 0;
}

.timestamp-tool-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.timestamp-tool-card:hover {
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

:deep(.el-button--info) {
  background-color: #409eff !important;
  border-color: #409eff !important;
}

:deep(.el-button--info:hover) {
  background-color: #66b1ff !important;
  border-color: #66b1ff !important;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.3);
}

:deep(.el-button--default:hover) {
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

:deep(.el-radio-button__orig-radio:checked + .el-radio-button__inner) {
  background-color: #667eea;
  border-color: #667eea;
  box-shadow: -1px 0 0 0 #667eea;
}

:deep(.el-radio-button__inner:hover) {
  color: #667eea;
}

.input-field {
  width: 100%;
  max-width: 400px;
}

.form-hint {
  font-size: var(--font-size-xs);
  color: var(--text-color-secondary);
  margin-top: var(--spacing-xs);
}

.action-buttons {
  display: flex;
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-xl);
  flex-wrap: wrap;
}

.convert-button {
  min-width: 100px;
}

.reset-button,
.current-time-button {
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

.result-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: var(--spacing-lg);
}

.result-item {
  background-color: #f8f9fa;
  border-radius: var(--border-radius-md);
  padding: var(--spacing-md);
  transition: all 0.3s ease;
  position: relative;
  border: 1px solid #e0e0e0;
}

.result-item:hover {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transform: translateY(-2px);
}

.result-label {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--text-color-secondary);
  margin-bottom: var(--spacing-xs);
}

.result-value {
  font-size: var(--font-size-base);
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
  margin-bottom: var(--spacing-sm);
  word-break: break-all;
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
  
  .result-grid {
    grid-template-columns: 1fr;
  }
  
  .input-field {
    max-width: 100%;
  }
}
</style>
