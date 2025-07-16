@echo off
echo =================================
echo webLIS - Zatrzymywanie serwisów
echo =================================
echo.

echo Zamykanie procesów webLIS...

REM Zabij procesy Node.js (Frontend)
taskkill /F /IM node.exe >nul 2>&1
if not errorlevel 1 echo ✅ Frontend Next.js zatrzymany

REM Zabij procesy Python (Backend)  
taskkill /F /IM python.exe >nul 2>&1
if not errorlevel 1 echo ✅ Backend Python zatrzymany

REM Zabij procesy R (Backend)
taskkill /F /IM Rscript.exe >nul 2>&1
if not errorlevel 1 echo ✅ Backend R zatrzymany

REM Dodatkowe czyszczenie portów
for %%p in (3001 8000 8002) do (
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%%p "') do (
        taskkill /F /PID %%a >nul 2>&1
    )
)

echo.
echo =================================
echo ✅ Wszystkie serwisy zatrzymane!
echo =================================
echo.
pause
