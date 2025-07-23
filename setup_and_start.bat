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
    echo ❌ BŁĄD: Node.js nie jest zainstalowany!
    echo.
    echo ROZWIĄZANIE:
    echo - Zainstaluj Node.js z: https://nodejs.org/
    echo - WAŻNE: Podczas instalacji zaznacz "Add to PATH"
    echo - Sprawdź środowisko: diagnoza_srodowiska.bat
    echo.
    pause
    exit /b 1
)

echo ✅ Node.js znaleziony

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

echo ❌ BŁĄD: Python nie został znaleziony!
echo.
echo ROZWIĄZANIE:
echo - Zainstaluj Python z: https://python.org/
echo - WAŻNE: Podczas instalacji zaznacz "Add Python to PATH"
echo - Sprawdź środowisko: diagnoza_srodowiska.bat
echo.
echo Możliwe lokalizacje:
echo - python (w PATH)
echo - py (Python Launcher)
echo - python3 (w PATH)
echo - C:\Python\python.exe
echo - C:\Python3\python.exe
echo.
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

echo ❌ BŁĄD: R nie został znaleziony!
echo.
echo ROZWIĄZANIE:
echo - Zainstaluj R z: https://r-project.org/
echo - Sprawdź środowisko: diagnoza_srodowiska.bat
echo.
echo Sprawdzane lokalizacje:
echo - C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe
echo - C:\Program Files\R\R-4.4.1\bin\x64\Rscript.exe  
echo - C:\Program Files\R\R-4.3.1\bin\x64\Rscript.exe
echo - Automatyczne: C:\Program Files\R\R-*\bin\x64\Rscript.exe
echo - Rscript w PATH
echo.
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
    
    echo - Tworzenie .venv za pomocą: %PYTHON_CMD%
    %PYTHON_CMD% -m venv .venv
    if errorlevel 1 (
        echo ❌ BŁĄD: Nie można utworzyć środowiska wirtualnego Python!
        echo.
        echo ROZWIĄZANIA:
        echo 1. Sprawdź czy Python ma moduł venv: %PYTHON_CMD% -m venv --help
        echo 2. Spróbuj: %PYTHON_CMD% -m pip install --upgrade pip
        echo 3. Sprawdź uprawnienia do folderu backend-python
        echo 4. Uruchom jako administrator
        echo 5. Sprawdź środowisko: diagnoza_srodowiska.bat
        echo.
        cd ..
        pause
        exit /b 1
    )
    
    echo - Aktywacja środowiska wirtualnego...
    if not exist ".venv\Scripts\activate.bat" (
        echo ❌ BŁĄD: Plik activate.bat nie został utworzony!
        echo - Folder .venv może być niepełny
        echo - Usuń folder .venv i spróbuj ponownie
        cd ..
        pause
        exit /b 1
    )
    
    call .venv\Scripts\activate.bat
    if errorlevel 1 (
        echo ❌ BŁĄD: Nie można aktywować środowiska wirtualnego!
        cd ..
        pause
        exit /b 1
    )
    
    echo - Sprawdzanie pip...
    pip --version >nul 2>&1
    if errorlevel 1 (
        echo ❌ BŁĄD: Pip nie jest dostępny w środowisku wirtualnym!
        echo - Próba naprawy...
        %PYTHON_CMD% -m ensurepip --upgrade
        if errorlevel 1 (
            echo ❌ Nie można naprawić pip
            cd ..
            pause
            exit /b 1
        )
    )
    
    echo - Instalacja pakietów Python...
    pip install fastapi uvicorn requests pydantic
    if errorlevel 1 (
        echo ❌ BŁĄD: Nie można zainstalować pakietów Python!
        echo.
        echo ROZWIĄZANIA:
        echo 1. Sprawdź połączenie internetowe
        echo 2. Spróbuj: pip install --upgrade pip
        echo 3. Spróbuj: pip install --user fastapi uvicorn requests pydantic
        echo 4. Sprawdź proxy/firewall
        echo.
        cd ..
        pause
        exit /b 1
    )
    
    echo ✅ Środowisko Python skonfigurowane pomyślnie!
    cd ..
) else (
    echo ✅ Środowisko Python już istnieje
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
echo    - Lub użyj: stop_weblis.bat
echo.
echo 💡 Kolejne uruchomienia (bez setupu):
echo    - Użyj: start.bat
echo.
echo 🔍 Jeśli problemy:
echo    - Diagnostyka: diagnoza_srodowiska.bat
echo    - Instrukcje: INSTRUKCJA_INSTALACJI.md
echo.
echo Naciśnij dowolny klawisz aby zamknąć to okno...
pause >nul
