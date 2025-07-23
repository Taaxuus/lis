@echo off
REM Test skryptu start.bat - czy działa na każdym komputerze

echo =======================================
echo TEST start.bat - Symulacja nowego komputera
echo =======================================
echo.

echo [TEST 1] Sprawdzanie start.bat bez środowiska wirtualnego...
echo.

REM Tymczasowo ukryj .venv żeby zasymulować nowy komputer
if exist "backend-python\.venv" (
    echo Ukrywam .venv żeby zasymulować nowy komputer...
    ren "backend-python\.venv" ".venv_backup"
)

echo.
echo Uruchamiam start.bat...
echo (To powinno pokazać błąd i instrukcje)
echo.
call start.bat

REM Przywróć .venv
if exist "backend-python\.venv_backup" (
    echo.
    echo Przywracam środowisko...
    ren "backend-python\.venv_backup" ".venv"
)

echo.
echo =======================================
echo TEST ZAKOŃCZONY
echo =======================================
echo.
echo WNIOSEK: 
echo - Jeśli zobaczyłeś jasne komunikaty błędów z instrukcjami
echo - To start.bat będzie działać poprawnie na każdym komputerze
echo.
pause
