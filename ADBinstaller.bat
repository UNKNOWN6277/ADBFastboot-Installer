@echo off
setlocal EnableDelayedExpansion

:: ������ԱȨ��
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo �������ԱȨ��...
    powershell -Command "Start-Process cmd -ArgumentList '/c %0' -Verb RunAs"
    exit /b
)

title ADB Fastboot ��װ���� v2.0
TITLE ADB Installer
COLOR 70
ECHO ############################################################################################################
ECHO #    �����������[ �������������[ �������������[     �����[�������[   �����[���������������[�����������������[ �����������[ �����[     �����[     ���������������[�������������[      #
ECHO #   �����X�T�T�����[�����X�T�T�����[�����X�T�T�����[    �����U���������[  �����U�����X�T�T�T�T�a�^�T�T�����X�T�T�a�����X�T�T�����[�����U     �����U     �����X�T�T�T�T�a�����X�T�T�����[     #
ECHO #   ���������������U�����U  �����U�������������X�a    �����U�����X�����[ �����U���������������[   �����U   ���������������U�����U     �����U     �����������[  �������������X�a     #
ECHO #   �����X�T�T�����U�����U  �����U�����X�T�T�����[    �����U�����U�^�����[�����U�^�T�T�T�T�����U   �����U   �����X�T�T�����U�����U     �����U     �����X�T�T�a  �����X�T�T�����[     #
ECHO #   �����U  �����U�������������X�a�������������X�a    �����U�����U �^���������U���������������U   �����U   �����U  �����U���������������[���������������[���������������[�����U  �����U     #
ECHO #   �^�T�a  �^�T�a�^�T�T�T�T�T�a �^�T�T�T�T�T�a     �^�T�a�^�T�a  �^�T�T�T�a�^�T�T�T�T�T�T�a   �^�T�a   �^�T�a  �^�T�a�^�T�T�T�T�T�T�a�^�T�T�T�T�T�T�a�^�T�T�T�T�T�T�a�^�T�a  �^�T�a     #
ECHO #                                                                                                          #
ECHO #   VER 0.1.0                                                                                              #
ECHO #   �����[   �����[�������[   �����[�����[  �����[�������[   �����[ �������������[ �����[    �����[�������[   �����[ �������������[ �������������[ ���������������[���������������[    #
ECHO #   �����U   �����U���������[  �����U�����U �����X�a���������[  �����U�����X�T�T�T�����[�����U    �����U���������[  �����U�����X�T�T�T�T�a �^�T�T�T�T�����[�^�T�T�T�T�����U�^�T�T�T�T�����U    #
ECHO #   �����U   �����U�����X�����[ �����U�����������X�a �����X�����[ �����U�����U   �����U�����U ���[ �����U�����X�����[ �����U���������������[  �����������X�a    �����X�a    �����X�a    #
ECHO #   �����U   �����U�����U�^�����[�����U�����X�T�����[ �����U�^�����[�����U�����U   �����U�����U�������[�����U�����U�^�����[�����U�����X�T�T�T�����[�����X�T�T�T�a    �����X�a    �����X�a     #
ECHO #   �^�������������X�a�����U �^���������U�����U  �����[�����U �^���������U�^�������������X�a�^�������X�������X�a�����U �^���������U�^�������������X�a���������������[   �����U     �����U      #
ECHO #    �^�T�T�T�T�T�a �^�T�a  �^�T�T�T�a�^�T�a  �^�T�a�^�T�a  �^�T�T�T�a �^�T�T�T�T�T�a  �^�T�T�a�^�T�T�a �^�T�a  �^�T�T�T�a �^�T�T�T�T�T�a �^�T�T�T�T�T�T�a   �^�T�a     �^�T�a      #
ECHO #                                                                                                          #
ECHO #                                                                                                          #
ECHO ############################################################################################################

PAUSE 

:: ���ñ���
set "ADB_DIR=%ProgramFiles%\Android\Platform-Tools"
set "TEMP_DIR=%TEMP%\adb_temp"
set "DOWNLOAD_URL=https://dl.google.com/android/repository/platform-tools-latest-windows.zip"

:: ������ʱĿ¼
if exist "%TEMP_DIR%" rd /s /q "%TEMP_DIR%"
mkdir "%TEMP_DIR%"

:: ���˵�
:MAIN_MENU
CLS
ECHO ############################################################################################################
ECHO #                                                                                                          #
ECHO #    �����������[ �������������[ �������������[     �����[�������[   �����[���������������[�����������������[ �����������[ �����[     �����[     ���������������[�������������[      #
ECHO #   �����X�T�T�����[�����X�T�T�����[�����X�T�T�����[    �����U���������[  �����U�����X�T�T�T�T�a�^�T�T�����X�T�T�a�����X�T�T�����[�����U     �����U     �����X�T�T�T�T�a�����X�T�T�����[     #
ECHO #   ���������������U�����U  �����U�������������X�a    �����U�����X�����[ �����U���������������[   �����U   ���������������U�����U     �����U     �����������[  �������������X�a     #
ECHO #   �����X�T�T�����U�����U  �����U�����X�T�T�����[    �����U�����U�^�����[�����U�^�T�T�T�T�����U   �����U   �����X�T�T�����U�����U     �����U     �����X�T�T�a  �����X�T�T�����[     #
ECHO #   �����U  �����U�������������X�a�������������X�a    �����U�����U �^���������U���������������U   �����U   �����U  �����U���������������[���������������[���������������[�����U  �����U     #
ECHO #   �^�T�a  �^�T�a�^�T�T�T�T�T�a �^�T�T�T�T�T�a     �^�T�a�^�T�a  �^�T�T�T�a�^�T�T�T�T�T�T�a   �^�T�a   �^�T�a  �^�T�a�^�T�T�T�T�T�T�a�^�T�T�T�T�T�T�a�^�T�T�T�T�T�T�a�^�T�a  �^�T�a     #
ECHO #                                                                                                          #
ECHO #   VER 0.1.0                                                                                              #
ECHO #                                                                                                          #
ECHO #   �����[   �����[�������[   �����[�����[  �����[�������[   �����[ �������������[ �����[    �����[�������[   �����[ �������������[ �������������[ ���������������[���������������[    #
ECHO #   �����U   �����U���������[  �����U�����U �����X�a���������[  �����U�����X�T�T�T�����[�����U    �����U���������[  �����U�����X�T�T�T�T�a �^�T�T�T�T�����[�^�T�T�T�T�����U�^�T�T�T�T�����U    #
ECHO #   �����U   �����U�����X�����[ �����U�����������X�a �����X�����[ �����U�����U   �����U�����U ���[ �����U�����X�����[ �����U���������������[  �����������X�a    �����X�a    �����X�a    #
ECHO #   �����U   �����U�����U�^�����[�����U�����X�T�����[ �����U�^�����[�����U�����U   �����U�����U�������[�����U�����U�^�����[�����U�����X�T�T�T�����[�����X�T�T�T�a    �����X�a    �����X�a     #
ECHO #   �^�������������X�a�����U �^���������U�����U  �����[�����U �^���������U�^�������������X�a�^�������X�������X�a�����U �^���������U�^�������������X�a���������������[   �����U     �����U      #
ECHO #    �^�T�T�T�T�T�a �^�T�a  �^�T�T�T�a�^�T�a  �^�T�a�^�T�a  �^�T�T�T�a �^�T�T�T�T�T�a  �^�T�T�a�^�T�T�a �^�T�a  �^�T�T�T�a �^�T�T�T�T�T�a �^�T�T�T�T�T�T�a   �^�T�a     �^�T�a      #
ECHO #                                                                                                          #
ECHO ############################################################################################################
echo .
echo ��ѡ�������
echo 1. ��װ ADB �� Fastboot
echo 2. ж�� ADB �� Fastboot
echo 3. ��鵱ǰ��װ״̬
echo 4. ��� ADB ��ϵͳ PATH
echo 5. �˳�
echo.
set /p CHOICE=������ѡ�� (1-5): 

if "%CHOICE%"=="1" goto INSTALL
if "%CHOICE%"=="2" goto UNINSTALL
if "%CHOICE%"=="3" goto CHECK_STATUS
if "%CHOICE%"=="4" goto ADD_TO_PATH
if "%CHOICE%"=="5" goto EXIT
goto MAIN_MENU

PAUSE 


:INSTALL
echo.
echo ���ڰ�װ ADB �� Fastboot...
echo.

PAUSE 


:: ����Ƿ��Ѱ�װ
if exist "%ADB_DIR%" (
    echo ��⵽�Ѱ�װ�� ADB������ж�ؾɰ汾...
    rd /s /q "%ADB_DIR%" 2>nul
)

PAUSE 


:: ����ƽ̨����
echo ��������ƽ̨����...
powershell -Command "& {Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%TEMP_DIR%\platform-tools.zip'}" >nul 2>&1

if not exist "%TEMP_DIR%\platform-tools.zip" (
    echo ��������ʧ�ܣ�
    pause
    goto MAIN_MENU
)

echo ������ɣ�

PAUSE 


:: ��ѹ�ļ�
echo ���ڽ�ѹ�ļ�...
powershell -Command "& {Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%TEMP_DIR%\platform-tools.zip', '%TEMP_DIR%')}" >nul 2>&1

:: ���Ƶ�����Ŀ¼
echo ���ڰ�װ��ϵͳĿ¼...
mkdir "%ADB_DIR%"
xcopy "%TEMP_DIR%\platform-tools\*" "%ADB_DIR%\" /E /Y /Q >nul


:: ��ӵ�ϵͳPATH
:ADD_TO_PATH
echo ��������ϵͳ��������...

setx PATH "%ADB_DIR%;%PATH%" /M >nul 2>&1


:: ���������ݷ�ʽ����ѡ��
echo �Ƿ񴴽������ݷ�ʽ�� (y/n)
set /p CREATE_SHORTCUT=
if /i "%CREATE_SHORTCUT%"=="y" (
    echo ���������ݷ�ʽ...
    powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\ADB Command Prompt.lnk'); $Shortcut.TargetPath = 'cmd.exe'; $Shortcut.WorkingDirectory = '%ADB_DIR%'; $Shortcut.Save()}"
)

echo.
echo ? ADB �� Fastboot ��װ��ɣ�
echo ? ��װĿ¼: %ADB_DIR%
echo ? ����ӵ�ϵͳ PATH
echo.
echo ��֤��װ:
"%ADB_DIR%\adb.exe" version
echo.
pause
goto MAIN_MENU

PAUSE 


:UNINSTALL
echo.
echo ����ж�� ADB �� Fastboot...

:: ��PATH���Ƴ�
echo ���ڴ�ϵͳPATH���Ƴ�...
set "NEW_PATH=%PATH:%ADB_DIR%;=%"
setx PATH "%NEW_PATH%" /M >nul 2>&1


:: ɾ����װĿ¼
if exist "%ADB_DIR%" (
    rd /s /q "%ADB_DIR%"
    echo ? ��ɾ����װĿ¼
)

:: ɾ�������ݷ�ʽ
if exist "%USERPROFILE%\Desktop\ADB Command Prompt.lnk" (
    del "%USERPROFILE%\Desktop\ADB Command Prompt.lnk"
    echo ? ��ɾ�������ݷ�ʽ
)

echo.
echo ? ж����ɣ�
pause
goto MAIN_MENU

PAUSE 

:CHECK_STATUS
echo.
echo ��� ADB ��װ״̬...
echo.

PAUSE 


:: ��鰲װĿ¼
if exist "%ADB_DIR%" (
    echo ? ADB Ŀ¼����: %ADB_DIR%
    dir "%ADB_DIR%\adb.exe" >nul 2>&1 && echo ? adb.exe �ļ�����
    dir "%ADB_DIR%\fastboot.exe" >nul 2>&1 && echo ? fastboot.exe �ļ�����
) else (
    echo ? ADB Ŀ¼������
)

PAUSE 


:: ���PATH
echo %PATH% | find "%ADB_DIR%" >nul 2>&1
if %errorLevel% equ 0 (
    echo ? ����ϵͳ PATH ��
) else (
    echo ? δ��ϵͳ PATH ��
)

PAUSE 


:: ����ADB����
adb version >nul 2>&1
if %errorLevel% equ 0 (
    echo ? ADB �������
) else (
    echo ? ADB �������
)

echo.
pause
goto MAIN_MENU

PAUSE 


:EXIT
:: ������ʱ�ļ�
if exist "%TEMP_DIR%" rd /s /q "%TEMP_DIR%"
echo.
echo ��лʹ�ã�
timeout /t 2 >nul

PAUSE 

exit