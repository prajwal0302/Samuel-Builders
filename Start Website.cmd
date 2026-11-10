@echo off
setlocal
cd /d "%~dp0"
set "SAMUEL_NODE=node"
where node >nul 2>nul
if errorlevel 1 set "SAMUEL_NODE=C:\Program Files\WindowsApps\OpenAI.CodexPrimaryRuntime.v26-1105-1297-0_26.1105.1297.0_x64__3k8sg7r9htsxt\dependencies\node\bin\node.exe"
"%SAMUEL_NODE%" "%~dp0scripts\preview.mjs"
if errorlevel 1 (
  echo.
  echo Could not start the website. Check the message above.
  echo If Node.js is unavailable, install Node.js 24 and try again.
  pause
  exit /b 1
)
start "" "http://127.0.0.1:3000/"
