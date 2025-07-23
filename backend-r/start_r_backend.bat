@echo off
setlocal enabledelayedexpansion

REM webLIS R Backend - Start Script
echo =======================================
echo webLIS R Backend - Uruchamianie...
echo =======================================

REM Sprawdź czy jesteśmy w katalogu backend-r
if not exist "server.R" (
    echo BŁĄD: Uruchom z katalogu backend-r!
    pause
    exit /b 1
)

REM Znajdź R w systemie - różne możliwe lokalizacje
set "RSCRIPT_PATH="

REM Sprawdź różne wersje R
if exist "C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe" (
    set "RSCRIPT_PATH=C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe"
    goto r_found
)
if exist "C:\Program Files\R\R-4.4.1\bin\x64\Rscript.exe" (
    set "RSCRIPT_PATH=C:\Program Files\R\R-4.4.1\bin\x64\Rscript.exe"
    goto r_found
)
if exist "C:\Program Files\R\R-4.3.1\bin\x64\Rscript.exe" (
    set "RSCRIPT_PATH=C:\Program Files\R\R-4.3.1\bin\x64\Rscript.exe"
    goto r_found
)

REM Sprawdź 32-bit wersje
if exist "C:\Program Files\R\R-4.5.1\bin\Rscript.exe" (
    set "RSCRIPT_PATH=C:\Program Files\R\R-4.5.1\bin\Rscript.exe"
    goto r_found
)
if exist "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" (
    set "RSCRIPT_PATH=C:\Program Files\R\R-4.4.1\bin\Rscript.exe"
    goto r_found
)

REM Próba automatycznego znajdowania
for /d %%i in ("C:\Program Files\R\R-*") do (
    if exist "%%i\bin\x64\Rscript.exe" (
        set "RSCRIPT_PATH=%%i\bin\x64\Rscript.exe"
        goto r_found
    )
    if exist "%%i\bin\Rscript.exe" (
        set "RSCRIPT_PATH=%%i\bin\Rscript.exe"
        goto r_found
    )
)

REM Sprawdź czy R jest w PATH
Rscript --version >nul 2>&1
if not errorlevel 1 (
    set "RSCRIPT_PATH=Rscript"
    goto r_found
)

echo BŁĄD: Nie znaleziono R!
echo Sprawdź czy R jest zainstalowany w:
echo - C:\Program Files\R\R-[wersja]\bin\x64\Rscript.exe
echo - C:\Program Files\R\R-[wersja]\bin\Rscript.exe
echo - Rscript w PATH
echo.
echo Pobierz R z: https://r-project.org/
pause
exit /b 1

:r_found

echo ✅ Znaleziono R: !RSCRIPT_PATH!

REM Test pakietów R
echo Sprawdzanie pakietów R...
"!RSCRIPT_PATH!" -e "cat('Sprawdzanie pakietów...\n'); if(!require('plumber', quietly=TRUE)) { cat('Instalowanie plumber...\n'); install.packages('plumber', repos='https://cran.r-project.org'); }"

echo 🚀 Uruchamianie serwera R na porcie 8001...
"!RSCRIPT_PATH!" server.R

pause
