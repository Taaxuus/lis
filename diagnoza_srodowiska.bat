@echo off
REM webLIS - Diagnostyka środowiska
echo ========================================
echo webLIS - Diagnostyka środowiska
echo ========================================
echo.

echo [1/3] SPRAWDZANIE NODE.JS...
where node >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js: NIE ZNALEZIONO
    echo    Pobierz z: https://nodejs.org/
    echo    WAŻNE: Podczas instalacji zaznacz "Add to PATH"
) else (
    echo ✅ Node.js: ZNALEZIONY
    node --version
    echo    Lokalizacja: 
    where node
)
echo.

echo [2/3] SPRAWDZANIE PYTHON...
set PYTHON_FOUND=false

python --version >nul 2>&1
if not errorlevel 1 (
    echo ✅ Python: ZNALEZIONY (python)
    python --version
    echo    Lokalizacja:
    where python
    set PYTHON_FOUND=true
    goto python_check_done
)

py --version >nul 2>&1
if not errorlevel 1 (
    echo ✅ Python: ZNALEZIONY (py launcher)
    py --version
    echo    Lokalizacja:
    where py
    set PYTHON_FOUND=true
    goto python_check_done
)

python3 --version >nul 2>&1
if not errorlevel 1 (
    echo ✅ Python: ZNALEZIONY (python3)
    python3 --version
    echo    Lokalizacja:
    where python3
    set PYTHON_FOUND=true
    goto python_check_done
)

if exist "C:\Python\python.exe" (
    echo ✅ Python: ZNALEZIONY (C:\Python\)
    "C:\Python\python.exe" --version
    set PYTHON_FOUND=true
    goto python_check_done
)

if exist "C:\Python3\python.exe" (
    echo ✅ Python: ZNALEZIONY (C:\Python3\)
    "C:\Python3\python.exe" --version
    set PYTHON_FOUND=true
    goto python_check_done
)

echo ❌ Python: NIE ZNALEZIONY
echo    Pobierz z: https://python.org/
echo    WAŻNE: Podczas instalacji zaznacz "Add Python to PATH"

:python_check_done
echo.

echo [3/3] SPRAWDZANIE R...
set R_FOUND=false

REM Sprawdź różne wersje R
for /d %%i in ("C:\Program Files\R\R-*") do (
    if exist "%%i\bin\x64\Rscript.exe" (
        echo ✅ R: ZNALEZIONY (%%i)
        "%%i\bin\x64\Rscript.exe" --version 2>nul
        set R_FOUND=true
        goto r_check_done
    )
    if exist "%%i\bin\Rscript.exe" (
        echo ✅ R: ZNALEZIONY (%%i)
        "%%i\bin\Rscript.exe" --version 2>nul
        set R_FOUND=true
        goto r_check_done
    )
)

Rscript --version >nul 2>&1
if not errorlevel 1 (
    echo ✅ R: ZNALEZIONY (w PATH)
    Rscript --version
    echo    Lokalizacja:
    where Rscript
    set R_FOUND=true
    goto r_check_done
)

echo ❌ R: NIE ZNALEZIONY
echo    Pobierz z: https://r-project.org/
echo    Standardowa lokalizacja: C:\Program Files\R\

:r_check_done
echo.

echo ========================================
echo PODSUMOWANIE
echo ========================================

if exist "node_modules" (
    echo ✅ Node.js dependencies: ZAINSTALOWANE
) else (
    echo ❌ Node.js dependencies: BRAK (uruchom: npm install)
)

if exist "backend-python\.venv" (
    echo ✅ Python venv: UTWORZONY
) else (
    echo ❌ Python venv: BRAK (zostanie utworzony automatycznie)
)

echo.
echo INSTRUKCJE DLA KOLEGI:
echo.
echo 1. Zainstaluj Node.js z https://nodejs.org/
echo    - Podczas instalacji zaznacz "Add to PATH"
echo.
echo 2. Zainstaluj Python z https://python.org/
echo    - Podczas instalacji zaznacz "Add Python to PATH"
echo.
echo 3. Zainstaluj R z https://r-project.org/
echo    - Standardowa instalacja wystarczy
echo.
echo 4. Po instalacji uruchom: setup_and_start.bat
echo.
echo Naciśnij dowolny klawisz aby zamknąć...
pause >nul
