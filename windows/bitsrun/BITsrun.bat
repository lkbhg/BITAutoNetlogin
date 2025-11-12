@echo off
set TARGET=www.baidu.com  &rem 检测目标地址
set ACCOUNT="*******"
set PASSWORD="******"
set CLI_PATH="D:\bitsrun\bitsrun.exe"  &rem 替换为CLI程序实际路径
set Logout_PATH="D:\bitsrun\bitsrun.exe"  &rem 替换为CLI程序实际路径
set INTERVAL=300  &rem 检测间隔（秒）

:LOOP
echo [%date% %time%] 检测网络连接状态 >> network.log

ping -n 2 -w 1000 %TARGET% > nul
if %ERRORLEVEL% EQU 0 (
    echo [%date% %time%] 网络已连接 >> network.log
) else (
    echo [%date% %time%] 网络未连接，尝试登陆 >> network.log
   %Logout_PATH% logout -u %ACCOUNT% -p %PASSWORD%  &rem logout
	echo [%date% %time%] 尝试离线>> network.log
    %CLI_PATH% login -u %ACCOUNT% -p %PASSWORD%  &rem login
    if %ERRORLEVEL% NEQ 0 (
        echo [%date% %time%] 登录失败，查看凭据 >> network.log
    )
)

timeout /t %INTERVAL% > nul

goto LOOP