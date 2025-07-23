@echo off
echo =======================================
echo webLIS - TEST WERSJI wszystkich skryptów
echo =======================================
echo.

echo [TEST 1] Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js: BRAK
) else (
    echo ✅ Node.js: OK
    node --version
)

echo.
echo [TEST 2] Python...
python --version >nul 2>&1
if errorlevel 1 (
    py --version >nul 2>&1
    if errorlevel 1 (
        echo ❌ Python: BRAK
    ) else (
        echo ✅ Python: OK (py launcher)
        py --version
    )
) else (
    echo ✅ Python: OK
    python --version
)

echo.
echo [TEST 3] R...
for /d %%i in ("C:\Program Files\R\R-*") do (
    if exist "%%i\bin\x64\Rscript.exe" (
        echo ✅ R: OK
        "%%i\bin\x64\Rscript.exe" --version 2>nul
        goto r_ok
    )
)
echo ❌ R: BRAK
:r_ok

echo.
echo [TEST 4] Środowiska...
if exist "backend-python\.venv" (
    echo ✅ Python venv: ISTNIEJE
) else (
    echo ❌ Python venv: BRAK
)

if exist "node_modules" (
    echo ✅ Node modules: ISTNIEJE
) else (
    echo ❌ Node modules: BRAK
)

echo.
echo =======================================
echo PODSUMOWANIE
echo =======================================
echo.
echo Jeśli wszystko pokazuje ✅ to aplikacja powinna działać.
echo Jeśli coś pokazuje ❌ to:
echo 1. Uruchom: diagnoza_srodowiska.bat
echo 2. Zainstaluj brakujące komponenty
echo 3. Uruchom: setup_and_start.bat
echo.
pause
