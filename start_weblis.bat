@echo off
echo =================================
echo webLIS - Uruchamianie backendow
echo =================================

echo.
echo [1/3] Uruchamianie Backend Python (FastAPI)...
cd /d "%~dp0backend-python"
start "webLIS Python Backend" cmd /k "python main.py"

echo.
echo [2/3] Uruchamianie Backend R (Plumber)...
cd /d "%~dp0backend-r"
start "webLIS R Backend" cmd /k "Rscript server.R"

echo.
echo [3/3] Uruchamianie Frontend (Next.js)...
cd /d "%~dp0lis"
start "webLIS Frontend" cmd /k "npm run dev"

echo.
echo =================================
echo Wszystkie komponenty uruchomione!
echo =================================
echo.
echo Frontend: http://localhost:3000
echo Python API: http://localhost:8000/docs
echo R API: http://localhost:8001/__docs__/
echo.
echo Nacisnij dowolny klawisz aby zakonczyc...
pause >nul
