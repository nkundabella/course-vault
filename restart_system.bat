@echo off
set "PORT=8081"
echo [Course-Vault] Starting a clean restart...

echo [Course-Vault] Ensuring port %PORT% is free...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :%PORT% ^| findstr LISTENING') do (
    echo [Course-Vault] Stopping previous process (PID: %%a)...
    taskkill /f /pid %%a >nul 2>&1
)

echo [Course-Vault] Compiling project...
call mvn compile

if %ERRORLEVEL% NEQ 0 (
    echo [Course-Vault] Error: Compilation failed. Please check your code.
    pause
    exit /b %ERRORLEVEL%
)

echo [Course-Vault] Launching system...
echo.
echo -------------------------------------------------------------------
echo YOUR BROWSER WILL OPEN AUTOMATICALLY TO http://localhost:%PORT%/
echo -------------------------------------------------------------------

call mvn exec:java -Dexec.mainClass="com.coursevault.Main"
