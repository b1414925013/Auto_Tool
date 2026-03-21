<template>
  <div class="common-tools-container">
    <el-card class="tool-card">
      <template #header>
        <div class="card-header">
          <h3>公共工具</h3>
          <p class="card-description">选择以下工具进行操作</p>
        </div>
      </template>

      <div class="tools-grid">
        <!-- IP 地址工具 -->
        <el-card class="tool-item" @click="navigateToTool('ip')">
          <div class="tool-icon">
            <el-icon><Setting /></el-icon>
          </div>
          <div class="tool-name">IP 地址工具</div>
          <div class="tool-description">检查 IP 地址的有效性和详细信息</div>
        </el-card>

        <!-- 密码生成器 -->
        <el-card class="tool-item" @click="navigateToTool('password')">
          <div class="tool-icon">
            <el-icon><Lock /></el-icon>
          </div>
          <div class="tool-name">密码生成器</div>
          <div class="tool-description">生成强密码，支持自定义长度和字符类型</div>
        </el-card>

        <!-- JSON 格式化 -->
        <el-card class="tool-item" @click="navigateToTool('json')">
          <div class="tool-icon">
            <el-icon><DataAnalysis /></el-icon>
          </div>
          <div class="tool-name">JSON 格式化</div>
          <div class="tool-description">格式化和验证 JSON 数据</div>
        </el-card>

        <!-- 时间戳转换 -->
        <el-card class="tool-item" @click="navigateToTool('timestamp')">
          <div class="tool-icon">
            <el-icon><Clock /></el-icon>
          </div>
          <div class="tool-name">时间戳转换</div>
          <div class="tool-description">在时间和时间戳之间相互转换</div>
        </el-card>

        <!-- 变量命名转换 -->
        <el-card class="tool-item" @click="navigateToTool('naming')">
          <div class="tool-icon">
            <el-icon><RefreshLeft /></el-icon>
          </div>
          <div class="tool-name">变量命名转换</div>
          <div class="tool-description">在不同命名风格之间转换变量名</div>
        </el-card>

        <!-- Base64 加密解密 -->
        <el-card class="tool-item" @click="navigateToTool('base64')">
          <div class="tool-icon">
            <el-icon><Key /></el-icon>
          </div>
          <div class="tool-name">Base64 加密解密</div>
          <div class="tool-description">对文本进行 Base64 加密和解密</div>
        </el-card>

        <!-- URL 编码解码 -->
        <el-card class="tool-item" @click="navigateToTool('url')">
          <div class="tool-icon">
            <el-icon><Link /></el-icon>
          </div>
          <div class="tool-name">URL 编码解码</div>
          <div class="tool-description">对 URL 进行编码或解码操作</div>
        </el-card>

        <!-- 文本哈希工具 -->
        <el-card class="tool-item" @click="navigateToTool('hash')">
          <div class="tool-icon">
            <el-icon><Document /></el-icon>
          </div>
          <div class="tool-name">文本哈希工具</div>
          <div class="tool-description">计算文本的哈希值，支持多种算法</div>
        </el-card>

        <!-- 颜色转换工具 -->
        <el-card class="tool-item" @click="navigateToTool('color')">
          <div class="tool-icon">
            <el-icon><MagicStick /></el-icon>
          </div>
          <div class="tool-name">颜色转换工具</div>
          <div class="tool-description">在 HEX、RGB 和 HSL 颜色格式之间转换</div>
        </el-card>

        <!-- Python 字典转 JSON -->
        <el-card class="tool-item" @click="navigateToTool('python')">
          <div class="tool-icon">
            <el-icon><Document /></el-icon>
          </div>
          <div class="tool-name">Python 字典转 JSON</div>
          <div class="tool-description">将 Python 字典转换为 JSON 格式</div>
        </el-card>

        <!-- JSONPath 验证工具 -->
        <el-card class="tool-item" @click="navigateToTool('jsonpath')">
          <div class="tool-icon">
            <el-icon><Search /></el-icon>
          </div>
          <div class="tool-name">JSONPath 验证工具</div>
          <div class="tool-description">使用 JSONPath 查询和验证 JSON 数据</div>
        </el-card>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'

const router = useRouter()

// 导航到工具页面
const navigateToTool = (toolType) => {
  // 根据工具类型导航到对应的页面
  let routePath = ''
  
  switch (toolType) {
    case 'ip':
      routePath = '/tools/ip'
      break
    case 'password':
      routePath = '/tools/password'
      break
    case 'json':
      routePath = '/tools/json'
      break
    case 'timestamp':
      routePath = '/tools/timestamp'
      break
    case 'naming':
      routePath = '/tools/naming'
      break
    case 'base64':
      routePath = '/tools/base64'
      break
    case 'url':
      routePath = '/tools/url'
      break
    case 'hash':
      routePath = '/tools/hash'
      break
    case 'color':
      routePath = '/tools/color'
      break
    case 'python':
      routePath = '/tools/python'
      break
    case 'jsonpath':
      routePath = '/tools/jsonpath'
      break
    default:
      ElMessage.warning('未知工具类型')
      return
  }
  
  router.push(routePath)
}


</script>

<style scoped>
.common-tools-container {
  padding: var(--spacing-lg) 0;
}

.tools-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: var(--spacing-lg);
  margin-top: var(--spacing-xl);
}

.tool-item {
  border: 1px solid #e0e0e0;
  border-radius: var(--border-radius-lg);
  transition: all 0.3s ease;
  overflow: hidden;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--spacing-xl);
  text-align: center;
  min-height: 220px;
  background: var(--background-color-light);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  position: relative;
}

.tool-item:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
  transform: translateY(-4px);
  border-color: #667eea;
}

.tool-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #667eea, #764ba2);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 0.3s ease;
}

.tool-item:hover::before {
  transform: scaleX(1);
}

.tool-icon {
  width: 80px;
  height: 80px;
  margin: 0 auto var(--spacing-md);
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
  border-radius: 50%;
  transition: all 0.3s ease;
}

.tool-item:hover .tool-icon {
  transform: scale(1.1);
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.2), rgba(118, 75, 162, 0.2));
}

.tool-icon :deep(.el-icon) {
  font-size: 36px;
  color: #667eea;
  transition: all 0.3s ease;
}

.tool-item:hover .tool-icon :deep(.el-icon) {
  transform: scale(1.2);
}

.tool-name {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--text-color);
  margin-bottom: var(--spacing-sm);
  transition: all 0.3s ease;
}

.tool-item:hover .tool-name {
  color: #667eea;
  transform: translateY(-2px);
}

.tool-description {
  font-size: var(--font-size-sm);
  color: var(--text-color-secondary);
  line-height: 1.5;
  transition: all 0.3s ease;
}

.tool-item:hover .tool-description {
  color: var(--text-color);
}

.card-description {
  font-size: var(--font-size-sm);
  color: rgba(255, 255, 255, 0.8);
  margin: var(--spacing-xs) 0 0 0;
  font-weight: var(--font-weight-normal);
}

@media (max-width: 768px) {
  .tools-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: var(--spacing-md);
  }
  
  .tool-item {
    padding: var(--spacing-lg);
    min-height: 200px;
  }
  
  .tool-icon {
    width: 60px;
    height: 60px;
  }
  
  .tool-icon :deep(.el-icon) {
    font-size: 28px;
  }
  
  .tool-name {
    font-size: var(--font-size-base);
  }
}

@media (max-width: 480px) {
  .tools-grid {
    grid-template-columns: 1fr;
    gap: var(--spacing-sm);
  }
  
  .tool-item {
    padding: var(--spacing-md);
    min-height: 180px;
  }
  
  .tool-icon {
    width: 50px;
    height: 50px;
  }
  
  .tool-icon :deep(.el-icon) {
    font-size: 24px;
  }
  
  .tool-name {
    font-size: var(--font-size-base);
  }
  
  .tool-description {
    font-size: var(--font-size-xs);
  }
}
</style>
