# 家账本 App - Android APK

通过 GitHub Actions 云端构建，生成 Android APK 安装包。

## 文件说明

- `www/index.html` - 家账本 App 完整网页代码
- `package.json` - npm 依赖配置
- `capacitor.config.json` - Capacitor 原生 App 配置
- `build-android.bat` - Windows 一键打包脚本（本地有 Android Studio 时使用）

## 如何获取 APK

### 方案 A：GitHub Actions 自动构建（推荐）

1. 打开仓库：https://github.com/YYmm1314/family-budget-app
2. 进入 **Actions** 标签页
3. 点击左侧 "Build Android APK"
4. 点击右侧 **"Run workflow"** 绿色按钮
5. 等待 10-15 分钟构建完成
6. 在构建页面下方 **Artifacts** 下载 APK

### 方案 B：本地构建

需要有 Node.js + JDK 17 + Android Studio，双击 `build-android.bat`

## App 功能

- 家庭记账本
- 收入/支出分类记录
- 月度预算管理
- 数据图表分析
- 语音输入（支持麦克风）
