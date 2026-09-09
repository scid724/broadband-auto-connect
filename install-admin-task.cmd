@echo off
cd /d "%~dp0"
set "CONNECTION_NAME=%~1"
if "%CONNECTION_NAME%"=="" set "CONNECTION_NAME=宽带连接"

net session >nul 2>&1
if not "%errorlevel%"=="0" (
  echo Requesting administrator permission...
  powershell.exe -NoProfile -Command "Start-Process -FilePath '%~f0' -ArgumentList '%CONNECTION_NAME%' -Verb RunAs"
  exit /b
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\install-admin-task.ps1" -ConnectionName "%CONNECTION_NAME%"
pause
