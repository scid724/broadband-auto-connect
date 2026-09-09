@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\install-admin-task.ps1" %*
if errorlevel 1 (
  echo Installation failed. Keep this window open and send the error text.
) else (
  echo Installation succeeded. Restart Windows to test.
)
pause