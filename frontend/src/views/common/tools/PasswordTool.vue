<template>
  <div class="password-tool-container">
    <el-card class="password-tool-card">
      <template #header>
        <div class="card-header">
          <h3>密码生成器</h3>
          <p class="card-description">一次默认生成10条密码，可选择已生成的条数</p>
        </div>
      </template>

      <div class="tool-content">
        <el-form label-position="top">
          <div class="form-row">
            <el-form-item label="密码长度">
              <el-input-number 
                v-model="passwordToolForm.length" 
                :min="6" 
                :max="32" 
                :step="1" 
                class="w-32"
                :controls-position="'right'"
              />
              <div class="form-hint">建议长度：12-16位</div>
            </el-form-item>
            <el-form-item label="生成数量">
              <el-input-number 
                v-model="passwordToolForm.count" 
                :min="1" 
                :max="50" 
                :step="1" 
                class="w-32"
                :controls-position="'right'"
              />
              <div class="form-hint">最多生成50条</div>
            </el-form-item>
          </div>
          
          <el-form-item label="包含字符">
            <div class="checkbox-group">
              <el-checkbox 
                v-for="option in checkboxOptions" 
                :key="option.value" 
                :value="option.value"
                v-model="passwordToolForm.options"
                class="checkbox-item"
              >
                {{ option.label }}
              </el-checkbox>
            </div>
          </el-form-item>

          <!-- 密码强度预览 -->
          <div class="password-strength-preview" v-if="passwordToolForm.options.length > 0">
            <div class="strength-label">密码强度：</div>
            <div class="strength-bar">
              <div 
                class="strength-indicator" 
                :class="getStrengthClass()"
                :style="{ width: getStrengthWidth() }"
              ></div>
            </div>
            <div class="strength-text">{{ getStrengthText() }}</div>
          </div>

          <div class="action-buttons">
            <el-button 
              type="primary" 
              @click="generatePassword"
              class="generate-button"
              :loading="loading"
            >
              生成密码
            </el-button>
            <el-button 
              @click="clearInput"
              class="clear-button"
            >
              清空
            </el-button>
          </div>

          <!-- 结果区域 -->
          <div class="results-section" v-if="generatedPasswords.length > 0">
            <div class="results-header">
              <h4>生成结果</h4>
              <span class="result-count">{{ generatedPasswords.length }} 条密码</span>
            </div>
            <el-table 
              :data="generatedPasswords" 
              style="width: 100%"
              class="results-table"
              :row-class-name="(row, index) => index % 2 === 0 ? 'even-row' : 'odd-row'"
            >
              <el-table-column prop="index" label="序号" width="80" />
              <el-table-column prop="password" label="密码">
                <template #default="{ row }">
                  <div class="password-cell">
                    <span class="password-text">{{ row.password }}</span>
                    <el-button 
                      type="text" 
                      size="small" 
                      @click="copyPassword(row.password)"
                      class="copy-button"
                      :icon="'el-icon-document-copy'"
                    >
                      复制
                    </el-button>
                  </div>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-form>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { ElMessage } from 'element-plus'
import api from '../../../api'

// 密码生成器
const passwordToolForm = reactive({
  length: 16,
  count: 10, // 默认生成10条
  options: ['uppercase', 'lowercase', 'numbers', 'symbols']
})

// 生成的密码列表
const generatedPasswords = ref([])

// 加载状态
const loading = ref(false)

// 复选框选项
const checkboxOptions = [
  { value: 'uppercase', label: '大写字母 (A-Z)' },
  { value: 'lowercase', label: '小写字母 (a-z)' },
  { value: 'numbers', label: '数字 (0-9)' },
  { value: 'symbols', label: '特殊字符 (!@#$%^&*)' }
]

/**
 * 生成密码
 */
const generatePassword = async () => {
  if (passwordToolForm.options.length === 0) {
    ElMessage.warning('请至少选择一种字符类型')
    return
  }
  
  loading.value = true
  
  try {
    // 调用后端接口获取随机密码
    const response = await api.common.getPassword({
      length: passwordToolForm.length,
      include_uppercase: passwordToolForm.options.includes('uppercase'),
      include_lowercase: passwordToolForm.options.includes('lowercase'),
      include_numbers: passwordToolForm.options.includes('numbers'),
      include_symbols: passwordToolForm.options.includes('symbols'),
      count: passwordToolForm.count
    })
    
    // 处理返回的数据
    if (response && response.success && response.passwords) {
      // 后端返回的是密码数组，我们直接使用
      const passwords = response.passwords.map((password, index) => ({
        index: index + 1,
        password: password
      }))
      generatedPasswords.value = passwords
      ElMessage.success(`成功生成 ${passwordToolForm.count} 条密码`)
    } else if (response && !response.success) {
      ElMessage.error(response.error)
    } else {
      ElMessage.error('接口返回数据格式错误')
    }
  } catch (error) {
    ElMessage.error('获取密码失败，请稍后重试')
    console.error('获取密码错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * 清空输入和结果
 */
const clearInput = () => {
  generatedPasswords.value = []
}

/**
 * 复制密码到剪贴板
 */
const copyPassword = (password) => {
  navigator.clipboard.writeText(password)
    .then(() => {
      ElMessage.success('密码已复制到剪贴板')
    })
    .catch(err => {
      ElMessage.error('复制失败')
      console.error('复制错误:', err)
    })
}

/**
 * 获取密码强度等级
 */
const getStrengthLevel = () => {
  let level = 0
  
  // 根据密码长度计算强度
  if (passwordToolForm.length >= 12) {
    level += 2
  } else if (passwordToolForm.length >= 8) {
    level += 1
  }
  
  // 根据包含的字符类型计算强度
  level += passwordToolForm.options.length
  
  return Math.min(level, 5)
}

/**
 * 获取密码强度的CSS类
 */
const getStrengthClass = () => {
  const level = getStrengthLevel()
  
  switch (level) {
    case 0:
    case 1:
      return 'strength-weak'
    case 2:
    case 3:
      return 'strength-medium'
    case 4:
    case 5:
      return 'strength-strong'
    default:
      return 'strength-weak'
  }
}

/**
 * 获取密码强度条的宽度
 */
const getStrengthWidth = () => {
  const level = getStrengthLevel()
  return `${(level / 5) * 100}%`
}

/**
 * 获取密码强度的文本描述
 */
const getStrengthText = () => {
  const level = getStrengthLevel()
  
  switch (level) {
    case 0:
    case 1:
      return '弱'
    case 2:
    case 3:
      return '中'
    case 4:
    case 5:
      return '强'
    default:
      return '弱'
  }
}
</script>

<style scoped>
.password-tool-container {
  padding: var(--spacing-lg) 0;
}

.password-tool-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.password-tool-card:hover {
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
  margin-bottom: var(--spacing-sm);
  font-size: var(--font-size-base);
}

:deep(.el-input) {
  border-radius: var(--border-radius-md);
  transition: var(--transition);
  border: 1px solid #e0e0e0;
}

:deep(.el-input:focus-within) {
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
  border-color: var(--primary-color);
}

:deep(.el-input-number) {
  border-radius: var(--border-radius-md);
  overflow: hidden;
  border: 1px solid #e0e0e0;
}

:deep(.el-input-number__decrease),
:deep(.el-input-number__increase) {
  background-color: #f5f7fa;
  border-color: #e0e0e0;
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

.form-row {
  display: flex;
  gap: var(--spacing-xl);
  margin-bottom: var(--spacing-lg);
}

.form-row .el-form-item {
  flex: 1;
  margin-bottom: 0;
}

.form-hint {
  font-size: var(--font-size-xs);
  color: var(--text-color-secondary);
  margin-top: var(--spacing-xs);
}

.checkbox-group {
  display: flex;
  flex-wrap: wrap;
  gap: var(--spacing-lg);
  margin-top: var(--spacing-sm);
}

.checkbox-item {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  padding: 8px 12px;
  border-radius: var(--border-radius-md);
  transition: all 0.3s ease;
  background-color: #f9f9f9;
}

.checkbox-item:hover {
  background-color: #f0f0f0;
}

:deep(.el-checkbox__input.is-checked .el-checkbox__inner) {
  background-color: #667eea;
  border-color: #667eea;
}

:deep(.el-checkbox__input.is-checked + .el-checkbox__label) {
  color: #667eea;
  font-weight: var(--font-weight-medium);
}

/* 密码强度预览 */
.password-strength-preview {
  margin: var(--spacing-lg) 0;
  padding: var(--spacing-md);
  background-color: #f8f9fa;
  border-radius: var(--border-radius-md);
  border-left: 4px solid #667eea;
}

.strength-label {
  font-weight: var(--font-weight-medium);
  margin-bottom: var(--spacing-sm);
  color: var(--text-color);
}

.strength-bar {
  width: 100%;
  height: 8px;
  background-color: #e0e0e0;
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: var(--spacing-sm);
}

.strength-indicator {
  height: 100%;
  transition: width 0.3s ease;
  border-radius: 4px;
}

.strength-weak {
  background-color: #ff4d4f;
}

.strength-medium {
  background-color: #faad14;
}

.strength-strong {
  background-color: #52c41a;
}

.strength-text {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
}

.strength-weak + .strength-text {
  color: #ff4d4f;
}

.strength-medium + .strength-text {
  color: #faad14;
}

.strength-strong + .strength-text {
  color: #52c41a;
}

.action-buttons {
  display: flex;
  gap: var(--spacing-md);
  margin-bottom: var(--spacing-lg);
  flex-wrap: wrap;
}

.generate-button {
  flex: 1;
  min-width: 120px;
}

.clear-button {
  min-width: 80px;
}

/* 结果区域 */
.results-section {
  margin-top: var(--spacing-xl);
  padding-top: var(--spacing-xl);
  border-top: 1px solid #e0e0e0;
  animation: fadeIn 0.5s ease;
}

.results-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: var(--spacing-lg);
}

.results-header h4 {
  margin: 0;
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--text-color);
}

.result-count {
  font-size: var(--font-size-sm);
  color: var(--text-color-secondary);
  background-color: #f0f0f0;
  padding: 4px 12px;
  border-radius: 12px;
}

.results-table {
  border-radius: var(--border-radius-md);
  overflow: hidden;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

:deep(.el-table th) {
  background-color: #f8f9fa;
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
  border-bottom: 1px solid #e0e0e0;
}

:deep(.el-table tr:hover > td) {
  background-color: #f8f9fa;
}

.even-row {
  background-color: #fafafa;
}

.odd-row {
  background-color: white;
}

.password-cell {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
}

.password-text {
  font-family: 'Courier New', Courier, monospace;
  font-size: var(--font-size-base);
  color: var(--text-color);
  word-break: break-all;
}

.copy-button {
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
  
  .form-row {
    flex-direction: column;
    gap: var(--spacing-md);
  }
  
  .checkbox-group {
    flex-direction: column;
    gap: var(--spacing-sm);
  }
  
  .checkbox-item {
    width: 100%;
  }
  
  .action-buttons {
    flex-direction: column;
  }
  
  .action-buttons .el-button {
    width: 100%;
  }
  
  .results-header {
    flex-direction: column;
    align-items: flex-start;
    gap: var(--spacing-sm);
  }
}
</style>
