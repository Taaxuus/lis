@echo off
REM webLIS - Start Script (tylko uruchomienie)

echo =======================================
echo webLIS - Start
echo Porty: Frontend 3000, Python 8000, R 8001
echo =======================================

REM Sprawdź katalog
if not exist "package.json" (
    echo BŁĄD: Uruchom z głównego katalogu projektu!
    pause
    exit /b 1
)

echo [1/3] Backend Python (FastAPI) - port 8000...
cd backend-python
start "webLIS Python" cmd /k ".venv\Scripts\activate && uvicorn main:app --host 0.0.0.0 --port 8000 --reload"
cd ..

timeout /t 3 /nobreak >nul

echo [2/3] Backend R (Plumber) - port 8001...
cd backend-r
start "webLIS R Backend" cmd /k "start_r_backend.bat"
cd ..

timeout /t 3 /nobreak >nul

echo [3/3] Frontend (Next.js) - port 3000...
start "webLIS Frontend" cmd /k "npm run dev"

timeout /t 5 /nobreak >nul

echo.
echo =======================================
echo ✅ webLIS uruchomiony!
echo =======================================
echo.
echo 🌐 Frontend: http://localhost:3000
echo 🐍 Python API: http://localhost:8000/docs
echo 📊 R API: http://localhost:8001/__docs__/
echo.

pause
