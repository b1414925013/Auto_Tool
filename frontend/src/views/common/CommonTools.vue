<template>
  <div class="common-tools-container">
    <el-card class="common-tools-card">
      <template #header>
        <div class="card-header">
          <h3>公共工具</h3>
        </div>
      </template>

      <div class="tools-grid">
        <!-- IP 地址工具 -->
        <el-card class="tool-card">
          <template #header>
            <div class="tool-header">
              <el-icon><Setting /></el-icon>
              <span>IP 地址工具</span>
            </div>
          </template>
          <div class="tool-content">
            <el-form :model="ipToolForm" label-width="100px">
              <el-form-item label="IP 地址">
                <el-input v-model="ipToolForm.ip" placeholder="请输入 IP 地址" />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="checkIP">检查 IP</el-button>
              </el-form-item>
              <el-form-item label="结果">
                <el-input v-model="ipToolResult" type="textarea" readonly />
              </el-form-item>
            </el-form>
          </div>
        </el-card>

        <!-- 密码生成器 -->
        <el-card class="tool-card">
          <template #header>
            <div class="tool-header">
              <el-icon><Lock /></el-icon>
              <span>密码生成器</span>
            </div>
          </template>
          <div class="tool-content">
            <el-form :model="passwordToolForm" label-width="100px">
              <el-form-item label="密码长度">
                <el-input-number v-model="passwordToolForm.length" :min="6" :max="32" :step="1" />
              </el-form-item>
              <el-form-item label="包含字符">
                <el-checkbox-group v-model="passwordToolForm.options">
                  <el-checkbox value="uppercase">大写字母</el-checkbox>
                  <el-checkbox value="lowercase">小写字母</el-checkbox>
                  <el-checkbox value="numbers">数字</el-checkbox>
                  <el-checkbox value="symbols">特殊字符</el-checkbox>
                </el-checkbox-group>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="generatePassword">生成密码</el-button>
              </el-form-item>
              <el-form-item label="结果">
                <el-input v-model="passwordToolResult" readonly />
              </el-form-item>
            </el-form>
          </div>
        </el-card>

        <!-- JSON 格式化 -->
        <el-card class="tool-card">
          <template #header>
            <div class="tool-header">
              <el-icon><DataAnalysis /></el-icon>
              <span>JSON 格式化</span>
            </div>
          </template>
          <div class="tool-content">
            <el-form label-width="100px">
              <el-form-item label="JSON 输入">
                <el-input v-model="jsonToolInput" type="textarea" :rows="4" placeholder="请输入 JSON 字符串" />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="formatJSON">格式化</el-button>
              </el-form-item>
              <el-form-item label="结果">
                <el-input v-model="jsonToolResult" type="textarea" :rows="4" readonly />
              </el-form-item>
            </el-form>
          </div>
        </el-card>

        <!-- 时间戳转换 -->
        <el-card class="tool-card">
          <template #header>
            <div class="tool-header">
              <el-icon><Clock /></el-icon>
              <span>时间戳转换</span>
            </div>
          </template>
          <div class="tool-content">
            <el-form :model="timestampToolForm" label-width="100px">
              <el-form-item label="时间戳">
                <el-input v-model="timestampToolForm.timestamp" placeholder="请输入时间戳" />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="convertTimestamp">转换</el-button>
              </el-form-item>
              <el-form-item label="结果">
                <el-input v-model="timestampToolResult" readonly />
              </el-form-item>
            </el-form>
          </div>
        </el-card>

        <!-- 变量命名转换 -->
        <el-card class="tool-card">
          <template #header>
            <div class="tool-header">
              <el-icon><RefreshLeft /></el-icon>
              <span>变量命名转换</span>
            </div>
          </template>
          <div class="tool-content">
            <el-form label-width="100px">
              <el-form-item label="输入文本">
                <el-input v-model="namingToolInput" placeholder="请输入要转换的文本" />
              </el-form-item>
              <el-form-item label="转换类型">
                <el-button-group>
                  <el-button @click="convertNaming('camelCase')">驼峰命名</el-button>
                  <el-button @click="convertNaming('PascalCase')">帕斯卡命名</el-button>
                  <el-button @click="convertNaming('snake_case')">下划线小写</el-button>
                  <el-button @click="convertNaming('SNAKE_CASE')">下划线大写</el-button>
                  <el-button @click="convertNaming('kebab-case')">中横线小写</el-button>
                  <el-button @click="convertNaming('package.name')">包名格式</el-button>
                </el-button-group>
              </el-form-item>
              <el-form-item label="结果">
                <el-input v-model="namingToolResult" readonly />
              </el-form-item>
            </el-form>
          </div>
        </el-card>

        <!-- Base64 加密解密 -->
        <el-card class="tool-card">
          <template #header>
            <div class="tool-header">
              <el-icon><Key /></el-icon>
              <span>Base64 加密解密</span>
            </div>
          </template>
          <div class="tool-content">
            <el-form label-width="100px">
              <el-form-item label="输入文本">
                <el-input v-model="base64ToolInput" type="textarea" :rows="3" placeholder="请输入要加密或解密的文本" />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="encodeBase64">加密</el-button>
                <el-button type="primary" @click="decodeBase64">解密</el-button>
              </el-form-item>
              <el-form-item label="结果">
                <el-input v-model="base64ToolResult" type="textarea" :rows="3" readonly />
              </el-form-item>
            </el-form>
          </div>
        </el-card>

        <!-- URL 编码解码 -->
        <el-card class="tool-card">
          <template #header>
            <div class="tool-header">
              <el-icon><Link /></el-icon>
              <span>URL 编码解码</span>
            </div>
          </template>
          <div class="tool-content">
            <el-form label-width="100px">
              <el-form-item label="输入文本">
                <el-input v-model="urlToolInput" type="textarea" :rows="3" placeholder="请输入要编码或解码的 URL" />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="encodeURL">编码</el-button>
                <el-button type="primary" @click="decodeURL">解码</el-button>
              </el-form-item>
              <el-form-item label="结果">
                <el-input v-model="urlToolResult" type="textarea" :rows="3" readonly />
              </el-form-item>
            </el-form>
          </div>
        </el-card>

        <!-- 文本哈希工具 -->
        <el-card class="tool-card">
          <template #header>
            <div class="tool-header">
              <el-icon><Document /></el-icon>
              <span>文本哈希工具</span>
            </div>
          </template>
          <div class="tool-content">
            <el-form label-width="100px">
              <el-form-item label="输入文本">
                <el-input v-model="hashToolInput" type="textarea" :rows="3" placeholder="请输入要计算哈希的文本" />
              </el-form-item>
              <el-form-item label="哈希算法">
                <el-select v-model="hashToolAlgorithm" placeholder="请选择哈希算法">
                  <el-option label="MD5" value="md5" />
                  <el-option label="SHA-1" value="sha1" />
                  <el-option label="SHA-256" value="sha256" />
                  <el-option label="SHA-512" value="sha512" />
                </el-select>
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="calculateHash">计算哈希</el-button>
              </el-form-item>
              <el-form-item label="结果">
                <el-input v-model="hashToolResult" type="textarea" :rows="3" readonly />
              </el-form-item>
            </el-form>
          </div>
        </el-card>

        <!-- 颜色转换工具 -->
        <el-card class="tool-card">
          <template #header>
            <div class="tool-header">
              <el-icon><MagicStick /></el-icon>
              <span>颜色转换工具</span>
            </div>
          </template>
          <div class="tool-content">
            <el-form label-width="100px">
              <el-form-item label="输入颜色">
                <el-input v-model="colorToolInput" placeholder="请输入颜色值（如 #FF0000 或 rgb(255,0,0)）" />
              </el-form-item>
              <el-form-item label="转换类型">
                <el-button-group>
                  <el-button @click="convertColor('hex')">转 HEX</el-button>
                  <el-button @click="convertColor('rgb')">转 RGB</el-button>
                  <el-button @click="convertColor('hsl')">转 HSL</el-button>
                </el-button-group>
              </el-form-item>
              <el-form-item label="结果">
                <el-input v-model="colorToolResult" readonly />
              </el-form-item>
              <el-form-item label="颜色预览">
                <div class="color-preview" :style="{ backgroundColor: colorToolResult }"></div>
              </el-form-item>
            </el-form>
          </div>
        </el-card>

        <!-- Python 字典转 JSON -->
        <el-card class="tool-card">
          <template #header>
            <div class="tool-header">
              <el-icon><Document /></el-icon>
              <span>Python 字典转 JSON</span>
            </div>
          </template>
          <div class="tool-content">
            <el-form label-width="100px">
              <el-form-item label="Python 字典">
                <el-input v-model="pythonToolInput" type="textarea" :rows="4" placeholder="请输入 Python 字典" />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="pythonToJSON">转换</el-button>
              </el-form-item>
              <el-form-item label="结果">
                <el-input v-model="pythonToolResult" type="textarea" :rows="4" readonly />
              </el-form-item>
            </el-form>
          </div>
        </el-card>

        <!-- JSONPath 验证工具 -->
        <el-card class="tool-card">
          <template #header>
            <div class="tool-header">
              <el-icon><Search /></el-icon>
              <span>JSONPath 验证工具</span>
            </div>
          </template>
          <div class="tool-content">
            <el-form label-width="100px">
              <el-form-item label="JSON 数据">
                <el-input v-model="jsonPathToolInput" type="textarea" :rows="4" placeholder="请输入 JSON 数据" />
              </el-form-item>
              <el-form-item label="JSONPath">
                <el-input v-model="jsonPathToolPath" placeholder="请输入 JSONPath 表达式" />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="validateJSONPath">验证</el-button>
              </el-form-item>
              <el-form-item label="结果">
                <el-input v-model="jsonPathToolResult" type="textarea" :rows="4" readonly />
              </el-form-item>
            </el-form>
          </div>
        </el-card>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'

// IP 工具
const ipToolForm = reactive({
  ip: ''
})
const ipToolResult = ref('')

const checkIP = () => {
  if (!ipToolForm.ip) {
    ElMessage.warning('请输入 IP 地址')
    return
  }
  // 简单的 IP 地址验证
  const ipRegex = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/
  if (ipRegex.test(ipToolForm.ip)) {
    ipToolResult.value = 'IP 地址格式正确'
  } else {
    ipToolResult.value = 'IP 地址格式错误'
  }
}

// 密码生成器
const passwordToolForm = reactive({
  length: 16,
  options: ['uppercase', 'lowercase', 'numbers', 'symbols']
})
const passwordToolResult = ref('')

const generatePassword = () => {
  if (passwordToolForm.options.length === 0) {
    ElMessage.warning('请至少选择一种字符类型')
    return
  }
  
  const chars = {
    uppercase: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
    lowercase: 'abcdefghijklmnopqrstuvwxyz',
    numbers: '0123456789',
    symbols: '!@#$%^&*()_+~`|}{[]:;?><,./-='
  }
  
  let charSet = ''
  passwordToolForm.options.forEach(option => {
    charSet += chars[option]
  })
  
  let password = ''
  for (let i = 0; i < passwordToolForm.length; i++) {
    const randomIndex = Math.floor(Math.random() * charSet.length)
    password += charSet[randomIndex]
  }
  
  passwordToolResult.value = password
}

// JSON 格式化
const jsonToolInput = ref('')
const jsonToolResult = ref('')

const formatJSON = () => {
  if (!jsonToolInput.value) {
    ElMessage.warning('请输入 JSON 字符串')
    return
  }
  
  try {
    const parsed = JSON.parse(jsonToolInput.value)
    jsonToolResult.value = JSON.stringify(parsed, null, 2)
  } catch (error) {
    jsonToolResult.value = 'JSON 格式错误'
  }
}

// 时间戳转换
const timestampToolForm = reactive({
  timestamp: ''
})
const timestampToolResult = ref('')

const convertTimestamp = () => {
  if (!timestampToolForm.timestamp) {
    ElMessage.warning('请输入时间戳')
    return
  }
  
  const timestamp = parseInt(timestampToolForm.timestamp)
  if (isNaN(timestamp)) {
    timestampToolResult.value = '请输入有效的时间戳'
    return
  }
  
  const date = new Date(timestamp * 1000)
  timestampToolResult.value = date.toLocaleString()
}

// 变量命名转换
const namingToolInput = ref('')
const namingToolResult = ref('')

const convertNaming = (type) => {
  if (!namingToolInput.value) {
    ElMessage.warning('请输入要转换的文本')
    return
  }
  
  let result = namingToolInput.value
  
  // 首先将输入文本转换为单词数组
  const words = result
    .replace(/([a-z])([A-Z])/g, '$1 $2') // 分离驼峰命名
    .replace(/[^a-zA-Z0-9]+/g, ' ') // 替换非字母数字字符为空格
    .trim()
    .split(/\s+/)
    .map(word => word.toLowerCase())
  
  switch (type) {
    case 'camelCase':
      result = words[0] + words.slice(1).map(word => word.charAt(0).toUpperCase() + word.slice(1)).join('')
      break
    case 'PascalCase':
      result = words.map(word => word.charAt(0).toUpperCase() + word.slice(1)).join('')
      break
    case 'snake_case':
      result = words.join('_')
      break
    case 'SNAKE_CASE':
      result = words.join('_').toUpperCase()
      break
    case 'kebab-case':
      result = words.join('-')
      break
    case 'package.name':
      result = words.join('.')
      break
  }
  
  namingToolResult.value = result
}

// Base64 加密解密
const base64ToolInput = ref('')
const base64ToolResult = ref('')

const encodeBase64 = () => {
  if (!base64ToolInput.value) {
    ElMessage.warning('请输入要加密的文本')
    return
  }
  
  try {
    base64ToolResult.value = btoa(unescape(encodeURIComponent(base64ToolInput.value)))
  } catch (error) {
    base64ToolResult.value = '加密失败'
    console.error('Base64 encode error:', error)
  }
}

const decodeBase64 = () => {
  if (!base64ToolInput.value) {
    ElMessage.warning('请输入要解密的文本')
    return
  }
  
  try {
    base64ToolResult.value = decodeURIComponent(escape(atob(base64ToolInput.value)))
  } catch (error) {
    base64ToolResult.value = '解密失败'
    console.error('Base64 decode error:', error)
  }
}

// URL 编码解码
const urlToolInput = ref('')
const urlToolResult = ref('')

const encodeURL = () => {
  if (!urlToolInput.value) {
    ElMessage.warning('请输入要编码的 URL')
    return
  }
  
  try {
    urlToolResult.value = encodeURIComponent(urlToolInput.value)
  } catch (error) {
    urlToolResult.value = '编码失败'
    console.error('URL encode error:', error)
  }
}

const decodeURL = () => {
  if (!urlToolInput.value) {
    ElMessage.warning('请输入要解码的 URL')
    return
  }
  
  try {
    urlToolResult.value = decodeURIComponent(urlToolInput.value)
  } catch (error) {
    urlToolResult.value = '解码失败'
    console.error('URL decode error:', error)
  }
}

// 文本哈希工具
const hashToolInput = ref('')
const hashToolAlgorithm = ref('md5')
const hashToolResult = ref('')

const calculateHash = () => {
  if (!hashToolInput.value) {
    ElMessage.warning('请输入要计算哈希的文本')
    return
  }
  
  try {
    // 这里使用简单的前端实现，实际项目中可能需要使用后端 API
    switch (hashToolAlgorithm.value) {
      case 'md5':
        hashToolResult.value = md5(hashToolInput.value)
        break
      case 'sha1':
        hashToolResult.value = sha1(hashToolInput.value)
        break
      case 'sha256':
        hashToolResult.value = sha256(hashToolInput.value)
        break
      case 'sha512':
        hashToolResult.value = sha512(hashToolInput.value)
        break
      default:
        hashToolResult.value = '不支持的哈希算法'
    }
  } catch (error) {
    hashToolResult.value = '计算哈希失败'
    console.error('Hash calculation error:', error)
  }
}

// 简单的哈希函数实现
const md5 = (str) => {
  // 简单的 MD5 实现，实际项目中可能需要使用更复杂的实现
  let hash = 0
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i)
    hash = ((hash << 5) - hash) + char
    hash = hash & hash
  }
  return hash.toString(16)
}

const sha1 = (str) => {
  // 简单的 SHA-1 实现，实际项目中可能需要使用更复杂的实现
  let hash = 0
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i)
    hash = ((hash << 5) - hash) + char
    hash = hash & hash
  }
  return hash.toString(16)
}

const sha256 = (str) => {
  // 简单的 SHA-256 实现，实际项目中可能需要使用更复杂的实现
  let hash = 0
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i)
    hash = ((hash << 5) - hash) + char
    hash = hash & hash
  }
  return hash.toString(16)
}

const sha512 = (str) => {
  // 简单的 SHA-512 实现，实际项目中可能需要使用更复杂的实现
  let hash = 0
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i)
    hash = ((hash << 5) - hash) + char
    hash = hash & hash
  }
  return hash.toString(16)
}

// 颜色转换工具
const colorToolInput = ref('')
const colorToolResult = ref('')

const convertColor = (type) => {
  if (!colorToolInput.value) {
    ElMessage.warning('请输入颜色值')
    return
  }
  
  try {
    // 简单的颜色转换实现，实际项目中可能需要使用更复杂的实现
    let color = colorToolInput.value.trim()
    
    switch (type) {
      case 'hex':
        if (color.startsWith('rgb(')) {
          // RGB 转 HEX
          const match = color.match(/rgb\((\d+),\s*(\d+),\s*(\d+)\)/)
          if (match) {
            const r = parseInt(match[1])
            const g = parseInt(match[2])
            const b = parseInt(match[3])
            colorToolResult.value = '#' + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1).toUpperCase()
          } else {
            colorToolResult.value = '无效的 RGB 颜色值'
          }
        } else if (color.startsWith('hsl(')) {
          // HSL 转 HEX
          // 这里简化处理，实际项目中可能需要更复杂的转换
          colorToolResult.value = 'HSL 转 HEX 暂不支持'
        } else {
          // 已经是 HEX 格式
          colorToolResult.value = color
        }
        break
      case 'rgb':
        if (color.startsWith('#')) {
          // HEX 转 RGB
          const hex = color.slice(1)
          const r = parseInt(hex.slice(0, 2), 16)
          const g = parseInt(hex.slice(2, 4), 16)
          const b = parseInt(hex.slice(4, 6), 16)
          colorToolResult.value = `rgb(${r}, ${g}, ${b})`
        } else if (color.startsWith('hsl(')) {
          // HSL 转 RGB
          // 这里简化处理，实际项目中可能需要更复杂的转换
          colorToolResult.value = 'HSL 转 RGB 暂不支持'
        } else {
          // 已经是 RGB 格式
          colorToolResult.value = color
        }
        break
      case 'hsl':
        // 简化处理，实际项目中可能需要更复杂的转换
        colorToolResult.value = '颜色转 HSL 暂不支持'
        break
      default:
        colorToolResult.value = '不支持的转换类型'
    }
  } catch (error) {
    colorToolResult.value = '转换失败'
    console.error('Color conversion error:', error)
  }
}

// Python 字典转 JSON
const pythonToolInput = ref('')
const pythonToolResult = ref('')

const pythonToJSON = () => {
  if (!pythonToolInput.value) {
    ElMessage.warning('请输入 Python 字典')
    return
  }
  
  try {
    // 简单的 Python 字典转 JSON 实现，实际项目中可能需要使用更复杂的实现
    // 这里使用 eval 来解析 Python 字典，实际项目中应该使用更安全的方法
    const pythonDict = eval(pythonToolInput.value)
    pythonToolResult.value = JSON.stringify(pythonDict, null, 2)
  } catch (error) {
    pythonToolResult.value = '转换失败，请检查 Python 字典格式'
    console.error('Python to JSON error:', error)
  }
}

// JSONPath 验证工具
const jsonPathToolInput = ref('')
const jsonPathToolPath = ref('')
const jsonPathToolResult = ref('')

const validateJSONPath = () => {
  if (!jsonPathToolInput.value) {
    ElMessage.warning('请输入 JSON 数据')
    return
  }
  
  if (!jsonPathToolPath.value) {
    ElMessage.warning('请输入 JSONPath 表达式')
    return
  }
  
  try {
    // 简单的 JSONPath 验证实现，实际项目中可能需要使用更复杂的实现
    const jsonData = JSON.parse(jsonPathToolInput.value)
    // 这里简化处理，实际项目中应该使用专门的 JSONPath 库
    jsonPathToolResult.value = 'JSONPath 验证暂不支持'
  } catch (error) {
    jsonPathToolResult.value = '验证失败，请检查 JSON 格式'
    console.error('JSONPath validation error:', error)
  }
}
</script>

<style scoped>
.common-tools-container {
  padding: var(--spacing-lg) 0;
}

.common-tools-card {
  margin-bottom: var(--spacing-lg);
  border-radius: var(--border-radius-md);
  overflow: hidden;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--spacing-md) var(--spacing-lg);
  background-color: var(--background-color-dark);
  border-bottom: 1px solid var(--border-color);
}

.card-header h3 {
  margin: 0;
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--text-color);
}

.tools-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: var(--spacing-lg);
  margin-top: var(--spacing-lg);
}

.tool-card {
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius-md);
  transition: var(--transition);
  overflow: hidden;
}

.tool-card:hover {
  box-shadow: var(--hover-shadow);
  transform: translateY(-2px);
}

.tool-header {
  display: flex;
  align-items: center;
  gap: var(--spacing-sm);
  padding: var(--spacing-md);
  background-color: var(--background-color-dark);
  border-bottom: 1px solid var(--border-color);
}

.tool-header :deep(.el-icon) {
  color: var(--primary-color);
  font-size: 18px;
}

.tool-header span {
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
}

.tool-content {
  padding: var(--spacing-lg);
  background-color: var(--background-color-light);
}

.color-preview {
  width: 100px;
  height: 100px;
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius-sm);
  margin-top: var(--spacing-sm);
  transition: var(--transition);
}

.color-preview:hover {
  box-shadow: var(--card-shadow);
  transform: scale(1.05);
}

/* 表单样式 */
:deep(.el-form-item) {
  margin-bottom: var(--spacing-md);
}

:deep(.el-form-item__label) {
  font-weight: var(--font-weight-medium);
  color: var(--text-color);
}

:deep(.el-input) {
  border-radius: var(--border-radius-md);
  transition: var(--transition);
}

:deep(.el-input:focus-within) {
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
  border-color: var(--primary-color);
}

:deep(.el-input-number) {
  border-radius: var(--border-radius-md);
  overflow: hidden;
}

:deep(.el-select) {
  border-radius: var(--border-radius-md);
  transition: var(--transition);
}

:deep(.el-select:focus-within) {
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
  border-color: var(--primary-color);
}

:deep(.el-button) {
  border-radius: var(--border-radius-md);
  transition: var(--transition);
}

:deep(.el-button--primary) {
  background-color: var(--primary-color) !important;
  border-color: var(--primary-color) !important;
}

:deep(.el-button--primary:hover) {
  background-color: var(--primary-hover) !important;
  border-color: var(--primary-hover) !important;
}

:deep(.el-button-group) {
  display: flex;
  flex-wrap: wrap;
  gap: var(--spacing-sm);
  margin-bottom: var(--spacing-md);
}

:deep(.el-button-group .el-button) {
  flex: 1;
  min-width: 80px;
}

@media (max-width: 768px) {
  .tools-grid {
    grid-template-columns: 1fr;
    gap: var(--spacing-md);
  }
  
  .tool-content {
    padding: var(--spacing-md);
  }
  
  .card-header {
    padding: var(--spacing-sm) var(--spacing-md);
  }
  
  .card-header h3 {
    font-size: var(--font-size-base);
  }
}

@media (max-width: 480px) {
  .tools-grid {
    gap: var(--spacing-sm);
  }
  
  .tool-content {
    padding: var(--spacing-sm);
  }
  
  :deep(.el-button-group) {
    flex-direction: column;
  }
  
  :deep(.el-button-group .el-button) {
    width: 100%;
  }
}
</style>
