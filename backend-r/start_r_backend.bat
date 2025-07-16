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

REM Znajdź R w systemie
set "RSCRIPT_PATH="
if exist "C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe" (
    set "RSCRIPT_PATH=C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe"
) else if exist "C:\Program Files\R\R-4.5.1\bin\Rscript.exe" (
    set "RSCRIPT_PATH=C:\Program Files\R\R-4.5.1\bin\Rscript.exe"
) else (
    echo BŁĄD: Nie znaleziono R!
    pause
    exit /b 1
)

echo ✅ Znaleziono R: !RSCRIPT_PATH!

REM Test pakietów R
echo Sprawdzanie pakietów R...
"!RSCRIPT_PATH!" -e "cat('Sprawdzanie pakietów...\n'); if(!require('plumber', quietly=TRUE)) { cat('Instalowanie plumber...\n'); install.packages('plumber', repos='https://cran.r-project.org'); }"

echo 🚀 Uruchamianie serwera R na porcie 8001...
"!RSCRIPT_PATH!" server.R

pause
