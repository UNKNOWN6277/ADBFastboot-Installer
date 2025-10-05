@echo off
setlocal EnableDelayedExpansion

:: 检查管理员权限
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo 请求管理员权限...
    powershell -Command "Start-Process cmd -ArgumentList '/c %0 %*' -Verb RunAs"
    exit /b
)

title ADB Fastboot 安装工具 v2.0
COLOR 70

:: 设置变量
set "ADB_DIR=%ProgramFiles%\Android\Platform-Tools"
set "TEMP_DIR=%TEMP%\adb_temp"
set "DOWNLOAD_URL=https://dl.google.com/android/repository/platform-tools-latest-windows.zip"

:: 解析命令行参数
if "%~1"=="" goto SHOW_HEADER
if "%~1"=="-1" goto INSTALL
if "%~1"=="-2" goto UNINSTALL
if "%~1"=="-3" goto CHECK_STATUS
if "%~1"=="-4" goto ADD_TO_PATH
if "%~1"=="-5" goto EXIT

echo 错误：无效参数 %~1
echo 可用参数：
echo   -1 安装 ADB 和 Fastboot
echo   -2 卸载 ADB 和 Fastboot
echo   -3 检查当前安装状态
echo   -4 添加 ADB 到系统 PATH
echo   -5 退出
pause
exit /b 1

:SHOW_HEADER
CLS
ECHO ############################################################################################################
ECHO #                                                                                                          #
ECHO #    █████╗ ██████╗ ██████╗     ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗      #
ECHO #   ██╔══██╗██╔══██╗██╔══██╗    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗     #
ECHO #   ███████║██║  ██║██████╔╝    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝     #
ECHO #   ██╔══██║██║  ██║██╔══██╗    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗     #
ECHO #   ██║  ██║██████╔╝██████╔╝    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║     #
ECHO #   ╚═╝  ╚═╝╚═════╝ ╚═════╝     ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝     #
ECHO #                                                                                                          #
ECHO #   VER 0.1.0                                                                                              #
ECHO #                                                                                                          #
ECHO #   ██╗   ██╗███╗   ██╗██╗  ██╗███╗   ██╗ ██████╗ ██╗    ██╗███╗   ██╗ ██████╗ ██████╗ ███████╗███████╗    #
ECHO #   ██║   ██║████╗  ██║██║ ██╔╝████╗  ██║██╔═══██╗██║    ██║████╗  ██║██╔════╝ ╚════██╗╚════██║╚════██║    #
ECHO #   ██║   ██║██╔██╗ ██║█████╔╝ ██╔██╗ ██║██║   ██║██║ █╗ ██║██╔██╗ ██║███████╗  █████╔╝    ██╔╝    ██╔╝    #
ECHO #   ██║   ██║██║╚██╗██║██╔═██╗ ██║╚██╗██║██║   ██║██║███╗██║██║╚██╗██║██╔═══██╗██╔═══╝    ██╔╝    ██╔╝     #
ECHO #   ╚██████╔╝██║ ╚████║██║  ██╗██║ ╚████║╚██████╔╝╚███╔███╔╝██║ ╚████║╚██████╔╝███████╗   ██║     ██║      #
ECHO #    ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝   ╚═╝     ╚═╝      #
ECHO #                                                                                                          #
ECHO ############################################################################################################
echo .
echo 请选择操作：
echo 1. 安装 ADB 和 Fastboot
echo 2. 卸载 ADB 和 Fastboot
echo 3. 检查当前安装状态
echo 4. 添加 ADB 到系统 PATH
echo 5. 退出
echo.
set /p CHOICE=请输入选择 (1-5): 

if "%CHOICE%"=="1" goto INSTALL
if "%CHOICE%"=="2" goto UNINSTALL
if "%CHOICE%"=="3" goto CHECK_STATUS
if "%CHOICE%"=="4" goto ADD_TO_PATH
if "%CHOICE%"=="5" goto EXIT
goto SHOW_HEADER

:INSTALL
echo.
echo 正在安装 ADB 和 Fastboot...
echo.

:: 创建临时目录
if exist "%TEMP_DIR%" rd /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%"

:: 检查是否已安装
if exist "%ADB_DIR%" (
    echo 检测到已安装的 ADB，正在卸载旧版本...
    rd /s /q "%ADB_DIR%" 2>nul
)

:: 下载平台工具
echo 正在下载平台工具...
powershell -Command "& {Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%TEMP_DIR%\platform-tools.zip'}" >nul 2>&1

if not exist "%TEMP_DIR%\platform-tools.zip" (
    echo 错误：下载失败！
    goto CLEANUP_AND_EXIT
)

echo 下载完成！

:: 解压文件
echo 正在解压文件...
powershell -Command "& {Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%TEMP_DIR%\platform-tools.zip', '%TEMP_DIR%')}" >nul 2>&1

:: 复制到程序目录
echo 正在安装到系统目录...
mkdir "%ADB_DIR%"
xcopy "%TEMP_DIR%\platform-tools\*" "%ADB_DIR%\" /E /Y /Q >nul

:: 添加到系统PATH
echo 正在配置系统环境变量...
setx PATH "%ADB_DIR%;%PATH%" /M >nul 2>&1

:: 检查是否有第二个参数用于自动创建快捷方式
if "%~2"=="-y" (
    echo 创建桌面快捷方式...
    powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\ADB Command Prompt.lnk'); $Shortcut.TargetPath = 'cmd.exe'; $Shortcut.WorkingDirectory = '%ADB_DIR%'; $Shortcut.Save()}"
) else if "%~2"=="" (
    echo 是否创建桌面快捷方式？ (y/n)
    set /p CREATE_SHORTCUT=
    if /i "!CREATE_SHORTCUT!"=="y" (
        echo 创建桌面快捷方式...
        powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\ADB Command Prompt.lnk'); $Shortcut.TargetPath = 'cmd.exe'; $Shortcut.WorkingDirectory = '%ADB_DIR%'; $Shortcut.Save()}"
    )
)

echo.
echo ? ADB 和 Fastboot 安装完成！
echo ? 安装目录: %ADB_DIR%
echo ? 已添加到系统 PATH
echo.
echo 验证安装:
"%ADB_DIR%\adb.exe" version
echo.
goto CLEANUP_AND_EXIT

:UNINSTALL
echo.
echo 正在卸载 ADB 和 Fastboot...

:: 从PATH中移除
echo 正在从系统PATH中移除...
set "NEW_PATH=%PATH:%ADB_DIR%;=%"
setx PATH "%NEW_PATH%" /M >nul 2>&1

:: 删除安装目录
if exist "%ADB_DIR%" (
    rd /s /q "%ADB_DIR%"
    echo ? 已删除安装目录
)

:: 删除桌面快捷方式
if exist "%USERPROFILE%\Desktop\ADB Command Prompt.lnk" (
    del "%USERPROFILE%\Desktop\ADB Command Prompt.lnk"
    echo ? 已删除桌面快捷方式
)

echo.
echo ? 卸载完成！
goto CLEANUP_AND_EXIT

:CHECK_STATUS
echo.
echo 检查 ADB 安装状态...
echo.

:: 检查安装目录
if exist "%ADB_DIR%" (
    echo ? ADB 目录存在: %ADB_DIR%
    dir "%ADB_DIR%\adb.exe" >nul 2>&1 && echo ? adb.exe 文件存在
    dir "%ADB_DIR%\fastboot.exe" >nul 2>&1 && echo ? fastboot.exe 文件存在
) else (
    echo ? ADB 目录不存在
)

:: 检查PATH
echo %PATH% | find "%ADB_DIR%" >nul 2>&1
if %errorLevel% equ 0 (
    echo ? 已在系统 PATH 中
) else (
    echo ? 未在系统 PATH 中
)

:: 测试ADB命令
adb version >nul 2>&1
if %errorLevel% equ 0 (
    echo ? ADB 命令可用
) else (
    echo ? ADB 命令不可用
)

echo.
goto CLEANUP_AND_EXIT

:ADD_TO_PATH
echo 正在配置系统环境变量...
setx PATH "%ADB_DIR%;%PATH%" /M >nul 2>&1
echo ? 已添加 ADB 到系统 PATH
goto CLEANUP_AND_EXIT

:CLEANUP_AND_EXIT
:: 清理临时文件
if exist "%TEMP_DIR%" rd /s /q "%TEMP_DIR%"

:: 如果没有参数则暂停，有参数则直接退出
if "%~1"=="" (
    pause
) else (
    timeout /t 2 >nul
)
exit /b 0

:EXIT
echo.
echo 感谢使用！
goto CLEANUP_AND_EXIT