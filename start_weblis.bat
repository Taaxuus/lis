@echo off
echo =================================
echo webLIS - Uruchamianie backendow
echo =================================

echo.
echo [1/3] Uruchamianie Backend Python (FastAPI)...
cd /d "%~dp0backend-python"
start "webLIS Python Backend" cmd /k ".\.venv\Scripts\activate && uvicorn main:app --host 0.0.0.0 --port 8000 --reload"

echo.
echo [2/3] Uruchamianie Backend R (Plumber)...
cd /d "%~dp0backend-r"
start "webLIS R Backend" cmd /k "\"C:\Program Files\R\R-4.5.1\bin\Rscript.exe\" server.R"

echo.
echo [3/3] Uruchamianie Frontend (Next.js)...
cd /d "%~dp0"
start "webLIS Frontend" cmd /k "npm run dev"

echo.
echo =================================
echo Wszystkie komponenty uruchomione!
echo =================================
echo.
echo Frontend: http://localhost:3000
echo Python API: http://localhost:8000/docs
echo R API: http://localhost:8002/__docs__/
echo.
echo Nacisnij dowolny klawisz aby zakonczyc...
pause >nul
