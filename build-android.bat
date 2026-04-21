@echo off
chcp 65001 >nul
title 家账本 App - 一键打包 Android APK
color 0A

echo.
echo ╔══════════════════════════════════════════╗
echo ║       家账本 App - Android 一键打包        ║
echo ╚══════════════════════════════════════════╝
echo.

:: 检查 Node.js
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 未检测到 Node.js，请先安装：https://nodejs.org
    echo 请手动安装后重试，或使用 [方案B] GitHub云端打包（无需安装Android Studio）
    pause
    exit /b 1
)
echo [✓] Node.js 已安装
node --version

:: 检查 Java
where java >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [错误] 未检测到 Java，请安装 JDK 17
    pause
    exit /b 1
)
echo [✓] Java 已安装
java -version 2>&1 | findstr "17\|version"
echo.

echo [1/5] 准备 www 目录...
if not exist "www" mkdir www
if exist "..\family-budget-app.html" (
    copy "..\family-budget-app.html" ".\www\index.html" >nul
    echo [✓] 家账本 HTML 已复制到 www\index.html
) else (
    echo [警告] 未找到 family-budget-app.html，请确认文件路径
)

echo.
echo [2/5] 安装 npm 依赖...
call npm install --registry https://registry.npmmirror.com
if %ERRORLEVEL% NEQ 0 (
    echo [错误] npm install 失败，请检查网络
    pause
    exit /b 1
)
echo [✓] 依赖安装完成

:: 检查 Android SDK 是否存在
echo.
echo [3/5] 检查 Android SDK...
where adb >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [警告] 未检测到 Android SDK！
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo  方案A: 手动安装 Android Studio（需要约6GB磁盘空间）
    echo    → 下载地址：https://developer.android.com/studio
    echo    → 安装后重新运行本脚本
    echo.
    echo  方案B: 使用 GitHub 云端打包（推荐，无需安装任何工具）
    echo    → 1. 在 GitHub 新建一个仓库
    echo    → 2. 把 family-app-package 文件夹上传到仓库
    echo    → 3. 打开仓库 Actions 页面，APK自动构建
    echo ═══════════════════════════════════════════════════════════
    echo.
    echo 继续使用方案B？按任意键打开GitHub说明页面...
    pause >nul
    start https://github.com
    exit /b 1
)

echo [✓] Android SDK 已找到

echo.
echo [4/5] 添加 Android 平台...
if not exist "android" (
    call npx cap add android
    echo [✓] Android 平台已添加
) else (
    echo [跳过] Android 平台已存在
)

echo.
echo [5/5] 同步文件到 Android 项目...
call npx cap sync android
if %ERRORLEVEL% NEQ 0 (
    echo [错误] sync 失败
    pause
    exit /b 1
)
echo [✓] 文件同步完成

:: 复制 AndroidManifest.xml（如果存在）
if exist "android-manifest-template\AndroidManifest.xml" (
    copy "android-manifest-template\AndroidManifest.xml" "android\app\src\main\AndroidManifest.xml" >nul
    echo [✓] AndroidManifest.xml 已更新（含语音权限）
)

echo.
echo [6/6] 构建 Debug APK...
echo     （首次构建约需 10-20 分钟，请耐心等待...）
echo.
cd android
call gradlew.bat assembleDebug
if %ERRORLEVEL% NEQ 0 (
    cd ..
    echo.
    echo [错误] APK 构建失败！
    echo 常见原因：
    echo   1. JAVA_HOME 环境变量未设置
    echo   2. Android SDK 缺失或未配置
    echo   3. 网络问题导致 Gradle 依赖下载失败
    echo.
    echo 请将错误截图发给 AI 助手排查。
    pause
    exit /b 1
)
cd ..

echo.
echo ╔══════════════════════════════════════════╗
echo ║           打包成功！                      ║
echo ╚══════════════════════════════════════════╝
echo.
echo APK 文件位置：
echo   android\app\build\outputs\apk\debug\app-debug.apk
echo.
echo 下一步：
echo   1. 用微信把 APK 发给家人
echo   2. 家人点击安装，允许未知来源即可
echo   3. 桌面出现"家账本"图标，全家开用！
echo.

:: 自动打开 APK 所在目录
explorer "android\app\build\outputs\apk\debug"

pause
