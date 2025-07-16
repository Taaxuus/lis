@echo off
REM webLIS - Enhanced Startup Script with Auto-Setup

echo =================================
echo webLIS - Auto Setup i Start
echo =================================
echo.

REM Sprawdź czy jesteśmy w odpowiednim katalogu
if not exist "package.json" (
    echo BŁĄD: Uruchom skrypt z głównego katalogu projektu lis!
    pause
    exit /b 1
)

echo [SETUP] Sprawdzanie wymagań...

REM Sprawdź Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo BŁĄD: Node.js nie jest zainstalowany!
    echo Pobierz z: https://nodejs.org/
    pause
    exit /b 1
)

REM Sprawdź Python
python --version >nul 2>&1
if errorlevel 1 (
    echo BŁĄD: Python nie jest zainstalowany!
    echo Pobierz z: https://python.org/
    pause
    exit /b 1
)

REM Sprawdź R
"C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe" --version >nul 2>&1
if errorlevel 1 (
    echo BŁĄD: R nie jest zainstalowany!
    echo Pobierz z: https://r-project.org/
    pause
    exit /b 1
)

echo ✅ Wszystkie wymagania spełnione!
echo.

echo [SETUP] Instalacja zależności...

REM Instalacja zależności Node.js
if not exist "node_modules" (
    echo Instalacja pakietów Node.js...
    npm install
)

REM Konfiguracja środowiska Python
if not exist "backend-python\.venv" (
    echo Tworzenie środowiska wirtualnego Python...
    cd backend-python
    python -m venv .venv
    call .venv\Scripts\activate.bat
    pip install fastapi uvicorn requests pydantic
    cd ..
)

REM Sprawdź pakiety R
echo Sprawdzanie pakietów R...
"C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe" -e "if(!require('plumber', quietly=TRUE)) install.packages('plumber', repos='https://cran.r-project.org')" >nul 2>&1
"C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe" -e "if(!require('dplyr', quietly=TRUE)) install.packages('dplyr', repos='https://cran.r-project.org')" >nul 2>&1
"C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe" -e "if(!require('httr', quietly=TRUE)) install.packages('httr', repos='https://cran.r-project.org')" >nul 2>&1
"C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe" -e "if(!require('jsonlite', quietly=TRUE)) install.packages('jsonlite', repos='https://cran.r-project.org')" >nul 2>&1

echo ✅ Setup zakończony!
echo.

echo [START] Uruchamianie komponentów...

echo [1/3] Backend Python (FastAPI)...
cd backend-python
start "webLIS Python Backend" cmd /k ".venv\Scripts\activate && uvicorn main:app --host 0.0.0.0 --port 8000 --reload"
cd ..

timeout /t 3 /nobreak >nul

echo [2/3] Backend R (Plumber)...
cd backend-r  
start "webLIS R Backend" cmd /k "start_r_backend.bat"
cd ..

timeout /t 3 /nobreak >nul

echo [3/3] Frontend (Next.js)...
start "webLIS Frontend" cmd /k "npm run dev"

timeout /t 5 /nobreak >nul

echo.
echo =================================
echo ✅ webLIS uruchomiony pomyślnie!
echo =================================
echo.
echo 🌐 Frontend: http://localhost:3000
echo 🐍 Python API: http://localhost:8000/docs  
echo 📊 R API: http://localhost:8001/__docs__/
echo.
echo Sprawdź status w przeglądarce:
echo http://localhost:3000
echo.
echo ⚠️  Aby zatrzymać wszystkie serwisy:
echo    - Zamknij wszystkie okna terminali
echo    - Lub użyj stop_weblis.bat
echo.
echo Naciśnij dowolny klawisz aby zamknąć to okno...
pause >nul
