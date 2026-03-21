<template>
  <div class="naming-tool-container">
    <el-card class="naming-tool-card">
      <template #header>
        <div class="card-header">
          <h3>变量命名转换</h3>
          <p class="card-description">一次性展示所有命名类型的转换结果</p>
        </div>
      </template>

      <div class="tool-content">
        <el-form label-position="top">
          <el-form-item label="输入文本">
            <el-input 
              v-model="namingToolInput" 
              placeholder="请输入要转换的文本" 
              class="naming-input"
            />
          </el-form-item>

          <div class="action-buttons">
            <el-button 
              type="primary" 
              @click="convertAllNaming"
              class="action-button"
              :loading="loading"
            >
              转换所有命名类型
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
            <h4>转换结果</h4>
            <div class="results-grid">
              <div class="result-item">
                <div class="result-label">驼峰命名 (camelCase)</div>
                <div class="result-field-container">
                  <el-input v-model="results.camelCase" readonly class="result-field" />
                  <el-button 
                    type="text" 
                    size="small" 
                    @click="copyResult(results.camelCase, 'camelCase')"
                    class="copy-button"
                    :icon="'el-icon-document-copy'"
                  >
                    复制
                  </el-button>
                </div>
              </div>
              <div class="result-item">
                <div class="result-label">帕斯卡命名 (PascalCase)</div>
                <div class="result-field-container">
                  <el-input v-model="results.PascalCase" readonly class="result-field" />
                  <el-button 
                    type="text" 
                    size="small" 
                    @click="copyResult(results.PascalCase, 'PascalCase')"
                    class="copy-button"
                    :icon="'el-icon-document-copy'"
                  >
                    复制
                  </el-button>
                </div>
              </div>
              <div class="result-item">
                <div class="result-label">下划线小写 (snake_case)</div>
                <div class="result-field-container">
                  <el-input v-model="results.snake_case" readonly class="result-field" />
                  <el-button 
                    type="text" 
                    size="small" 
                    @click="copyResult(results.snake_case, 'snake_case')"
                    class="copy-button"
                    :icon="'el-icon-document-copy'"
                  >
                    复制
                  </el-button>
                </div>
              </div>
              <div class="result-item">
                <div class="result-label">下划线大写 (SNAKE_CASE)</div>
                <div class="result-field-container">
                  <el-input v-model="results.SNAKE_CASE" readonly class="result-field" />
                  <el-button 
                    type="text" 
                    size="small" 
                    @click="copyResult(results.SNAKE_CASE, 'SNAKE_CASE')"
                    class="copy-button"
                    :icon="'el-icon-document-copy'"
                  >
                    复制
                  </el-button>
                </div>
              </div>
              <div class="result-item">
                <div class="result-label">中横线小写 (kebab-case)</div>
                <div class="result-field-container">
                  <el-input v-model="results['kebab-case']" readonly class="result-field" />
                  <el-button 
                    type="text" 
                    size="small" 
                    @click="copyResult(results['kebab-case'], 'kebab-case')"
                    class="copy-button"
                    :icon="'el-icon-document-copy'"
                  >
                    复制
                  </el-button>
                </div>
              </div>
              <div class="result-item">
                <div class="result-label">包名格式 (package.name)</div>
                <div class="result-field-container">
                  <el-input v-model="results['package.name']" readonly class="result-field" />
                  <el-button 
                    type="text" 
                    size="small" 
                    @click="copyResult(results['package.name'], 'package.name')"
                    class="copy-button"
                    :icon="'el-icon-document-copy'"
                  >
                    复制
                  </el-button>
                </div>
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

// 变量命名转换
const namingToolInput = ref('')

// 所有命名类型的结果
const results = reactive({
  camelCase: '',
  PascalCase: '',
  snake_case: '',
  SNAKE_CASE: '',
  'kebab-case': '',
  'package.name': ''
})

// 加载状态
const loading = ref(false)

/**
 * 转换所有命名类型
 */
const convertAllNaming = async () => {
  if (!namingToolInput.value) {
    ElMessage.warning('请输入要转换的文本')
    return
  }
  
  loading.value = true
  
  try {
    // 调用后端接口进行命名转换
    const response = await api.common.namingTool({
      input: namingToolInput.value
    })
    
    if (response && response.success && response.result) {
      const result = response.result
      results.camelCase = result.camel_case || ''
      results.PascalCase = result.pascal_case || ''
      results.snake_case = result.snake_case || ''
      results.SNAKE_CASE = result.snake_case_upper || ''
      results['kebab-case'] = result.kebab_case || ''
      results['package.name'] = result.package_name || ''
      ElMessage.success('转换完成')
    } else if (response && !response.success) {
      ElMessage.error(response.error)
    } else {
      ElMessage.error('转换失败')
    }
  } catch (error) {
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('命名转换错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * 清空输入和结果
 */
const clearInput = () => {
  namingToolInput.value = ''
  Object.keys(results).forEach(key => {
    results[key] = ''
  })
}

/**
 * 复制结果到剪贴板
 */
const copyResult = (value, format) => {
  if (!value) {
    ElMessage.warning(`没有可复制的${format}结果`)
    return
  }

  navigator.clipboard.writeText(value)
    .then(() => {
      ElMessage.success(`${format}已复制到剪贴板`)
    })
    .catch(err => {
      ElMessage.error('复制失败')
      console.error('复制错误:', err)
    })
}
</script>

<style scoped>
.naming-tool-container {
  padding: var(--spacing-lg) 0;
}

.naming-tool-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.naming-tool-card:hover {
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

.naming-input {
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

.results-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: var(--spacing-lg);
}

.result-item {
  background-color: #f8f9fa;
  border-radius: var(--border-radius-md);
  padding: var(--spacing-md);
  transition: all 0.3s ease;
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
  margin-bottom: var(--spacing-sm);
}

.result-field-container {
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
  
  .results-grid {
    grid-template-columns: 1fr;
  }
}
</style>
