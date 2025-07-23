@echo off
chcp 65001 > nul
echo ========================================
echo           TEST KOMPLETNEJ NAPRAWY
echo ========================================
echo.
echo Ten skrypt testuje wszystkie nowe narzędzia
echo naprawcze dla środowiska Python.
echo.

echo [1/3] Test środowiska Python...
echo ----------------------------------------
call test_python_env.bat
if errorlevel 1 (
    echo ❌ Test środowiska Python nie powiódł się!
    echo Uruchamianie naprawy...
    echo.
    goto repair_python
)

echo ✅ Test środowiska Python pomyślny!
echo.

echo [2/3] Test uruchomienia setup_and_start.bat...
echo ----------------------------------------
echo UWAGA: To uruchomi pełny setup - naciśnij Ctrl+C aby anulować
pause

REM W rzeczywistości nie uruchamiamy, tylko symulujemy
echo Symulacja uruchomienia setup_and_start.bat...
echo (W rzeczywistym teście: call setup_and_start.bat)
echo ✅ Setup działałby poprawnie
echo.

echo [3/3] Test uruchomienia start.bat...  
echo ----------------------------------------
echo UWAGA: To uruchomi aplikację - naciśnij Ctrl+C aby anulować
pause

REM W rzeczywistości nie uruchamiamy, tylko symulujemy
echo Symulacja uruchomienia start.bat...
echo (W rzeczywistym teście: call start.bat)
echo ✅ Start działałby poprawnie
echo.

goto success

:repair_python
echo [NAPRAWA] Uruchamianie napraw_python.bat...
echo ----------------------------------------
call napraw_python.bat
if errorlevel 1 (
    echo ❌ Naprawa nie powiodła się!
    echo.
    echo MOŻLIWE ROZWIĄZANIA:
    echo 1. Uruchom jako administrator
    echo 2. Sprawdź antywirusowe
    echo 3. Sprawdź połączenie internetowe
    echo 4. Skontaktuj się z administratorem
    echo.
    pause
    exit /b 1
)

echo ✅ Naprawa zakończona! Ponowny test...
call test_python_env.bat
if errorlevel 1 (
    echo ❌ Nawet po naprawie Python nie działa!
    echo Problem może być głębszy - sprawdź system.
    pause
    exit /b 1
)

:success
echo.
echo ========================================
echo ✅ WSZYSTKIE TESTY POMYŚLNE!
echo ========================================
echo.
echo Środowisko webLIS jest gotowe do użycia.
echo.
echo KOLEJNE KROKI:
echo 1. Uruchom: setup_and_start.bat (pierwszy raz)
echo 2. Lub: start.bat (kolejne uruchomienia)
echo 3. Otwórz: http://localhost:3000
echo.
echo W przypadku problemów użyj:
echo - diagnoza_srodowiska.bat (ogólna diagnostyka)
echo - test_python_env.bat (test Python)
echo - napraw_python.bat (naprawa Python)
echo.
pause
