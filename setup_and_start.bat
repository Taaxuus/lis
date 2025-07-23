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

REM Sprawdź Python - różne możliwe lokalizacje
set PYTHON_CMD=
python --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=python
    goto python_found
)

py --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=py
    goto python_found
)

python3 --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=python3
    goto python_found
)

"C:\Python\python.exe" --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD="C:\Python\python.exe"
    goto python_found
)

"C:\Python3\python.exe" --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD="C:\Python3\python.exe"
    goto python_found
)

echo BŁĄD: Python nie został znaleziony!
echo Sprawdź czy Python jest zainstalowany i dodany do PATH
echo Możliwe lokalizacje:
echo - python (w PATH)
echo - py (Python Launcher)
echo - python3 (w PATH)
echo - C:\Python\python.exe
echo - C:\Python3\python.exe
echo.
echo Pobierz Python z: https://python.org/
echo WAŻNE: Podczas instalacji zaznacz "Add Python to PATH"
pause
exit /b 1

:python_found
echo ✅ Python znaleziony: %PYTHON_CMD%

REM Sprawdź R - różne możliwe lokalizacje  
set R_CMD=
"C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe" --version >nul 2>&1
if not errorlevel 1 (
    set R_CMD="C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe"
    goto r_found
)

"C:\Program Files\R\R-4.4.1\bin\x64\Rscript.exe" --version >nul 2>&1
if not errorlevel 1 (
    set R_CMD="C:\Program Files\R\R-4.4.1\bin\x64\Rscript.exe"
    goto r_found
)

"C:\Program Files\R\R-4.3.1\bin\x64\Rscript.exe" --version >nul 2>&1
if not errorlevel 1 (
    set R_CMD="C:\Program Files\R\R-4.3.1\bin\x64\Rscript.exe"
    goto r_found
)

REM Próba automatycznego znajdowania R
for /d %%i in ("C:\Program Files\R\R-*") do (
    if exist "%%i\bin\x64\Rscript.exe" (
        set R_CMD="%%i\bin\x64\Rscript.exe"
        goto r_found
    )
)

REM Sprawdź R w PATH
Rscript --version >nul 2>&1
if not errorlevel 1 (
    set R_CMD=Rscript
    goto r_found
)

echo BŁĄD: R nie został znaleziony!
echo Sprawdź czy R jest zainstalowany w jednej z lokalizacji:
echo - C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe
echo - C:\Program Files\R\R-4.4.1\bin\x64\Rscript.exe  
echo - C:\Program Files\R\R-4.3.1\bin\x64\Rscript.exe
echo - Rscript w PATH
echo.
echo Pobierz R z: https://r-project.org/
pause
exit /b 1

:r_found
echo ✅ R znaleziony: %R_CMD%

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
    %PYTHON_CMD% -m venv .venv
    call .venv\Scripts\activate.bat
    pip install fastapi uvicorn requests pydantic
    cd ..
)

REM Sprawdź pakiety R
echo Sprawdzanie pakietów R...
%R_CMD% -e "if(!require('plumber', quietly=TRUE)) install.packages('plumber', repos='https://cran.r-project.org')" >nul 2>&1
%R_CMD% -e "if(!require('dplyr', quietly=TRUE)) install.packages('dplyr', repos='https://cran.r-project.org')" >nul 2>&1
%R_CMD% -e "if(!require('httr', quietly=TRUE)) install.packages('httr', repos='https://cran.r-project.org')" >nul 2>&1
%R_CMD% -e "if(!require('jsonlite', quietly=TRUE)) install.packages('jsonlite', repos='https://cran.r-project.org')" >nul 2>&1

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
