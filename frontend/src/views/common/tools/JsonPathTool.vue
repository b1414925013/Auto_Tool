<template>
  <div class="jsonpath-tool-container">
    <el-card class="jsonpath-tool-card">
      <template #header>
        <div class="card-header">
          <h3>JSONPath 验证工具</h3>
          <p class="card-description">使用 JSONPath 查询和验证 JSON 数据</p>
        </div>
      </template>

      <div class="tool-content">
        <!-- 输入区域 -->
        <el-form label-position="top">
          <el-form-item label="输入 JSON 数据">
            <el-input
              v-model="jsonInput"
              type="textarea"
              :rows="6"
              placeholder="请输入 JSON 数据"
              class="json-input"
            />
          </el-form-item>

          <el-form-item label="输入 JSONPath 表达式">
            <el-input
              v-model="jsonPathExpression"
              placeholder="请输入 JSONPath 表达式，例如：$.store.book[0].title"
              class="jsonpath-input"
            />
          </el-form-item>

          <div class="action-buttons">
            <el-button 
              type="primary" 
              @click="executeJsonPath"
              class="action-button"
              :loading="loading"
            >
              执行查询
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
          <h4>查询结果</h4>
          <div class="result-field-container">
            <el-input
              v-model="jsonPathResult"
              type="textarea"
              :rows="4"
              readonly
              placeholder="查询结果将显示在这里"
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

        <!-- 示例区域 -->
        <div class="examples-section">
          <div class="examples-header">
            <h4>示例 JSONPath 表达式</h4>
          </div>
          <div class="examples-list">
            <el-tag 
              v-for="(example, index) in jsonPathExamples" 
              :key="index"
              @click="useExample(example)"
              class="example-tag"
            >
              {{ example }}
            </el-tag>
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

// JSON输入
const jsonInput = ref('')
// JSONPath表达式
const jsonPathExpression = ref('')
// 查询结果
const jsonPathResult = ref('')

// 加载状态
const loading = ref(false)

// JSONPath示例表达式
const jsonPathExamples = [
  '$.store.book[0].title',
  '$.store.book[*].author',
  '$.store.book[?(@.price < 10)]',
  '$.store.book[?(@.category == "fiction")]',
  '$.store..price'
]

/**
 * 执行JSONPath查询
 */
const executeJsonPath = async () => {
  if (!jsonInput.value) {
    ElMessage.warning('请输入 JSON 数据')
    return
  }

  if (!jsonPathExpression.value) {
    ElMessage.warning('请输入 JSONPath 表达式')
    return
  }

  loading.value = true
  
  try {
    // 调用后端接口进行JSONPath查询
    const response = await api.common.jsonPathTool({
      json_data: jsonInput.value,
      expression: jsonPathExpression.value
    })
    
    if (response && response.success) {
      const result = {
        matches: response.matches || [],
        match_count: response.match_count || 0,
        expression: response.expression || ''
      }
      jsonPathResult.value = JSON.stringify(result, null, 2)
      ElMessage.success('查询成功')
    } else if (response && !response.success) {
      ElMessage.error(response.error)
    } else {
      ElMessage.error('查询失败')
    }
  } catch (error) {
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('查询错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * 清空输入
 */
const clearInput = () => {
  jsonInput.value = ''
  jsonPathExpression.value = ''
  jsonPathResult.value = ''
}

/**
 * 复制结果到剪贴板
 */
const copyResult = () => {
  if (!jsonPathResult.value) {
    ElMessage.warning('没有可复制的结果')
    return
  }

  navigator.clipboard.writeText(jsonPathResult.value)
    .then(() => {
      ElMessage.success('结果已复制到剪贴板')
    })
    .catch(err => {
      ElMessage.error('复制失败')
      console.error('复制错误:', err)
    })
}

/**
 * 使用示例表达式
 */
const useExample = (example) => {
  jsonPathExpression.value = example
}
</script>

<style scoped>
.jsonpath-tool-container {
  padding: var(--spacing-lg) 0;
}

.jsonpath-tool-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.jsonpath-tool-card:hover {
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
  min-height: 120px;
}

.jsonpath-input {
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
  margin-bottom: var(--spacing-xl);
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

/* 示例区域 */
.examples-section {
  border-top: 1px solid #e0e0e0;
  padding-top: var(--spacing-xl);
}

.examples-header {
  margin-bottom: var(--spacing-md);
}

.examples-header h4 {
  margin: 0;
  font-size: var(--font-size-base);
  font-weight: var(--font-weight-semibold);
  color: var(--text-color);
}

.examples-list {
  display: flex;
  flex-wrap: wrap;
  gap: var(--spacing-sm);
}

.example-tag {
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: var(--border-radius-md);
  padding: 4px 12px;
  background-color: #f8f9fa;
  border: 1px solid #e0e0e0;
  color: var(--text-color);
}

.example-tag:hover {
  background-color: #667eea;
  color: white;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
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
  
  .examples-list {
    flex-direction: column;
  }
  
  .example-tag {
    width: 100%;
    text-align: center;
  }
}
</style>