@echo off
REM webLIS - Start Script (z automatycznym znajdowaniem Python/R)

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

echo [SPRAWDZANIE] Znajdowanie Python...

REM Znajdź Python - różne możliwe lokalizacje
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

echo ❌ BŁĄD: Python nie został znaleziony!
echo.
echo ROZWIĄZANIE:
echo 1. Uruchom najpierw: setup_and_start.bat
echo 2. Lub zainstaluj Python z: https://python.org/ (zaznacz "Add to PATH")
echo 3. Lub sprawdź środowisko: diagnoza_srodowiska.bat
echo.
pause
exit /b 1

:python_found
echo ✅ Python znaleziony: %PYTHON_CMD%

echo [SPRAWDZANIE] Znajdowanie R...

REM Znajdź R - różne możliwe lokalizacje (kopiuje logikę z setup_and_start.bat)
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

echo ❌ BŁĄD: R nie został znaleziony!
echo.
echo ROZWIĄZANIE:
echo 1. Uruchom najpierw: setup_and_start.bat
echo 2. Lub zainstaluj R z: https://r-project.org/
echo 3. Lub sprawdź środowisko: diagnoza_srodowiska.bat
echo.
pause
exit /b 1

:r_found
echo ✅ R znaleziony: %R_CMD%

echo [SPRAWDZANIE] Środowisko Python...

REM Sprawdź czy środowisko Python istnieje
if not exist "backend-python\.venv" (
    echo ❌ BŁĄD: Środowisko Python nie istnieje!
    echo.
    echo ROZWIĄZANIE:
    echo 1. Uruchom: setup_and_start.bat (automatycznie utworzy środowisko)
    echo 2. Lub ręcznie: cd backend-python && %PYTHON_CMD% -m venv .venv
    echo.
    pause
    exit /b 1
)

echo [SPRAWDZANIE] Node.js...

node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ BŁĄD: Node.js nie został znaleziony!
    echo.
    echo ROZWIĄZANIE:
    echo 1. Zainstaluj Node.js z: https://nodejs.org/ (zaznacz "Add to PATH")
    echo 2. Sprawdź środowisko: diagnoza_srodowiska.bat
    echo.
    pause
    exit /b 1
)

echo ✅ Node.js znaleziony

echo [SPRAWDZANIE] Środowisko Python...
if not exist "backend-python\.venv\Scripts\activate.bat" (
    echo ❌ BŁĄD: Środowisko Python niepełne - brak activate.bat!
    echo.
    echo ROZWIĄZANIE:
    echo 1. Uruchom: setup_and_start.bat (automatycznie naprawi środowisko)
    echo 2. Lub usuń folder backend-python\.venv i uruchom setup_and_start.bat
    echo.
    pause
    exit /b 1
)

if not exist "backend-python\.venv\Scripts\python.exe" (
    echo ❌ BŁĄD: Środowisko Python niepełne - brak python.exe!
    echo.
    echo ROZWIĄZANIE:
    echo 1. Uruchom: setup_and_start.bat (automatycznie naprawi środowisko)
    echo 2. Lub usuń folder backend-python\.venv i uruchom setup_and_start.bat
    echo.
    pause
    exit /b 1
)

echo ✅ Środowisko Python sprawdzone
echo ✅ Wszystko gotowe!
echo.

echo [1/3] Backend Python (FastAPI) - port 8000...
cd backend-python
start "webLIS Python Backend" cmd /k ".venv\Scripts\activate && echo Aktywacja środowiska... && python -c "import fastapi, uvicorn; print('✅ Pakiety Python OK')" && uvicorn main:app --host 0.0.0.0 --port 8000 --reload"
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
echo ✅ webLIS uruchomiony pomyślnie!
echo =======================================
echo.
echo 🌐 Frontend: http://localhost:3000
echo 🐍 Python API: http://localhost:8000/docs
echo 📊 R API: http://localhost:8001/__docs__/
echo.
echo ⚠️ Aby zatrzymać wszystkie serwisy:
echo    - Zamknij wszystkie okna terminali
echo    - Lub użyj: stop_weblis.bat
echo.
echo 💡 Jeśli coś nie działa:
echo    - Sprawdź: diagnoza_srodowiska.bat
echo    - Setup: setup_and_start.bat
echo.
pause
