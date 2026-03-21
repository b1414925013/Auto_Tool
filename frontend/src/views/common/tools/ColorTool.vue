<template>
  <div class="color-tool-container">
    <el-card class="color-tool-card">
      <template #header>
        <div class="card-header">
          <h3>颜色转换工具</h3>
          <p class="card-description">在 HEX、RGB 和 HSL 颜色格式之间转换</p>
        </div>
      </template>

      <div class="tool-content">
        <!-- 输入区域 -->
        <el-form label-position="top">
          <el-form-item label="输入颜色">
            <div class="color-input-group">
              <el-input
                v-model="colorInput"
                placeholder="请输入颜色值（如 #FF5733、rgb(255,87,51) 或 hsl(15,76%,60%)）"
                class="color-input"
              />
              <el-color-picker
                v-model="colorValue"
                @change="onColorChange"
                class="color-picker"
              />
            </div>
          </el-form-item>

          <div class="action-buttons">
            <el-button 
              type="primary" 
              @click="convertColor"
              class="action-button"
              :loading="loading"
            >
              转换颜色
            </el-button>
            <el-button 
              @click="clearInput"
              class="action-button"
            >
              清空
            </el-button>
          </div>
        </el-form>

        <!-- 颜色预览 -->
        <div class="color-preview">
          <div class="preview-label">颜色预览</div>
          <div class="preview-box" :style="{ backgroundColor: colorValue }"></div>
        </div>

        <!-- 结果区域 -->
        <div class="results-section">
          <h4>转换结果</h4>
          <div class="result-grid">
            <div class="result-item">
              <div class="result-label">HEX 格式</div>
              <div class="result-field-container">
                <el-input
                  v-model="hexResult"
                  readonly
                  placeholder="HEX 格式将显示在这里"
                  class="result-field"
                />
                <el-button 
                  type="text" 
                  size="small" 
                  @click="copyHex"
                  class="copy-button"
                  :icon="'el-icon-document-copy'"
                >
                  复制
                </el-button>
              </div>
            </div>

            <div class="result-item">
              <div class="result-label">RGB 格式</div>
              <div class="result-field-container">
                <el-input
                  v-model="rgbResult"
                  readonly
                  placeholder="RGB 格式将显示在这里"
                  class="result-field"
                />
                <el-button 
                  type="text" 
                  size="small" 
                  @click="copyRgb"
                  class="copy-button"
                  :icon="'el-icon-document-copy'"
                >
                  复制
                </el-button>
              </div>
            </div>

            <div class="result-item">
              <div class="result-label">HSL 格式</div>
              <div class="result-field-container">
                <el-input
                  v-model="hslResult"
                  readonly
                  placeholder="HSL 格式将显示在这里"
                  class="result-field"
                />
                <el-button 
                  type="text" 
                  size="small" 
                  @click="copyHsl"
                  class="copy-button"
                  :icon="'el-icon-document-copy'"
                >
                  复制
                </el-button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
import { ElMessage } from 'element-plus'
import api from '../../../api'

// 颜色输入
const colorInput = ref('')
// 颜色值（HEX格式）
const colorValue = ref('#FF5733')
// 转换结果
const hexResult = ref('#FF5733')
const rgbResult = ref('rgb(255, 87, 51)')
const hslResult = ref('hsl(15, 76%, 60%)')

// 加载状态
const loading = ref(false)

/**
 * 当颜色选择器变化时更新输入框
 */
const onColorChange = (value) => {
  colorInput.value = value
  convertColor()
}

/**
 * 转换颜色格式
 */
const convertColor = async () => {
  if (!colorInput.value) {
    ElMessage.warning('请输入颜色值')
    return
  }

  loading.value = true
  
  try {
    // 确定输入格式
    let inputFormat = 'hex'
    if (colorInput.value.startsWith('rgb(')) {
      inputFormat = 'rgb'
    } else if (colorInput.value.startsWith('hsl(')) {
      inputFormat = 'hsl'
    }

    // 调用后端接口进行颜色转换
    const response = await api.common.colorTool({
      input_format: inputFormat,
      input: colorInput.value
    })
    
    if (response && response.success && response.result) {
      const result = response.result
      hexResult.value = result.hex
      rgbResult.value = result.rgb
      hslResult.value = result.hsl
      colorValue.value = result.hex
      ElMessage.success('颜色转换完成')
    } else if (response && !response.success) {
      ElMessage.error(response.error)
    } else {
      ElMessage.error('颜色转换失败')
    }
  } catch (error) {
    ElMessage.error('获取数据失败，请稍后重试')
    console.error('颜色转换错误:', error)
  } finally {
    loading.value = false
  }
}

/**
 * 清空输入
 */
const clearInput = () => {
  colorInput.value = ''
  colorValue.value = '#FF5733'
  hexResult.value = '#FF5733'
  rgbResult.value = 'rgb(255, 87, 51)'
  hslResult.value = 'hsl(15, 76%, 60%)'
}

/**
 * 复制HEX结果
 */
const copyHex = () => {
  copyToClipboard(hexResult.value, 'HEX 格式')
}

/**
 * 复制RGB结果
 */
const copyRgb = () => {
  copyToClipboard(rgbResult.value, 'RGB 格式')
}

/**
 * 复制HSL结果
 */
const copyHsl = () => {
  copyToClipboard(hslResult.value, 'HSL 格式')
}

/**
 * 复制到剪贴板
 */
const copyToClipboard = (value, format) => {
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
.color-tool-container {
  padding: var(--spacing-lg) 0;
}

.color-tool-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-lg);
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.color-tool-card:hover {
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

.color-input-group {
  display: flex;
  gap: var(--spacing-md);
  align-items: center;
}

.color-input {
  flex: 1;
}

.color-picker {
  width: 50px;
  height: 40px;
}

.color-preview {
  margin: var(--spacing-lg) 0;
  padding: var(--spacing-md);
  border: 1px solid #e0e0e0;
  border-radius: var(--border-radius-md);
  background-color: #f8f9fa;
}

.preview-label {
  margin-bottom: var(--spacing-sm);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--text-color-secondary);
}

.preview-box {
  width: 100%;
  height: 120px;
  border-radius: var(--border-radius-md);
  border: 1px solid #e0e0e0;
  transition: all 0.3s ease;
}

.preview-box:hover {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
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
  
  .color-input-group {
    flex-direction: column;
    align-items: stretch;
  }
  
  .color-picker {
    width: 100%;
    height: 40px;
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
}
</style>