# 家账本 App - Android 打包指南

> 把家庭共享记账本 App 打包成 Android APK，在家人手机上安装使用。

---

## 🚀 最快方式：双击打包

### 前提条件（只需安装一次）

| 工具 | 下载地址 | 安装后操作 |
|------|---------|-----------|
| Node.js LTS | https://nodejs.org/zh-cn/download | 重启电脑 |
| JDK 17 | https://adoptium.net/zh-CN/temurin/releases/?version=17 | 重启电脑 |
| Android Studio | https://developer.android.google.cn/studio | 首次打开等待 SDK 下载完成 |

### 一键打包

```powershell
# 1. 打开 PowerShell，进入 family-app-package 目录
cd "C:\Users\81540\WorkBuddy\20260421104842\family-app-package"

# 2. 双击（或粘贴运行）打包脚本
.\build-android.bat
```

脚本会自动完成：
- ✅ 复制 HTML 到 www 目录
- ✅ 安装 npm 依赖
- ✅ 添加 Android 平台
- ✅ 同步文件
- ✅ 构建 APK
- ✅ 打开 APK 所在文件夹

---

## 📋 分步手动操作（不依赖 .bat 脚本）

如果你的环境稍有不同，可以手动分步执行：

```powershell
# Step 1: 复制 HTML 文件
mkdir www -ErrorAction SilentlyContinue
copy "..\family-budget-app.html" ".\www\index.html"

# Step 2: 安装依赖
npm install --registry https://registry.npmmirror.com

# Step 3: 添加 Android 平台
npx cap add android

# Step 4: 同步文件
npx cap sync android

# Step 5: 配置语音权限
copy "android-manifest-template\AndroidManifest.xml" "android\app\src\main\AndroidManifest.xml"

# Step 6: 构建 APK
cd android
.\gradlew.bat assembleDebug
cd ..

# Step 7: 打开 APK 目录
explorer "android\app\build\outputs\apk\debug"
```

---

## 🔧 环境配置常见问题

### 1. `node 不是内部或外部命令`
- 原因：Node.js 安装后没有刷新 PATH
- 解决：关闭 PowerShell 重新打开，或重启电脑

### 2. `JAVA_HOME is not set`
- 原因：Java 未安装或未配置环境变量
- 解决：安装 JDK 17 后，确保 JAVA_HOME 指向 JDK 目录
  ```
  [System.Environment]::SetEnvironmentVariable(
      "JAVA_HOME",
      "C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot",
      "Machine"
  )
  ```

### 3. `Gradle Sync Failed`
- 原因：首次构建，Gradle 依赖下载失败（网络问题）
- 解决：挂代理重试，或多等待几分钟

### 4. `npm install 速度慢`
- 解决：切换国内镜像
  ```powershell
  npm config set registry https://registry.npmmirror.com
  npm install
  ```

---

## 📱 APK 分发方式

| 方式 | 操作步骤 | 推荐程度 |
|------|---------|---------|
| **微信发送** | 直接把 APK 发微信给家人 | ⭐⭐⭐⭐⭐ 最快 |
| **蒲公英平台** | 上传 APK，生成二维码扫码安装 | ⭐⭐⭐⭐ 适合长期维护 |
| **百度网盘** | 上传 APK，分享链接给家人 | ⭐⭐⭐ |

---

## 📦 打包产物

```
android\app\build\outputs\apk\debug\
└── app-debug.apk    ← 安装包，给家人安装这个文件
```

---

## 🎯 后续优化建议

当前版本数据保存在手机本地（LocalStorage）。

如需**家庭成员数据实时共享**，可选升级：

1. **微信云开发**（推荐，免费额度充足）
   - 接入 CloudBase 数据库
   - 家庭成员绑定同一 appId
   - 支持离线缓存 + 实时同步

2. **Supabase**（免费开源）
   - PostgreSQL 数据库
   - 实时订阅功能
   - 适合有技术背景的用户

3. **LeanCloud**
   - 国内访问速度快
   - 有免费个人版

---

*打包有问题？把 PowerShell 里的错误信息截图发给我，我来帮你排查！*
