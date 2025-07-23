@echo off
chcp 65001 > nul
echo ========================================
echo        TEST ŚRODOWISKA PYTHON
echo ========================================
echo.

REM Sprawdź Python - różne możliwe lokalizacje
set PYTHON_CMD=
echo [1/6] Szukanie interpretera Python...

python --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=python
    echo ✅ Znaleziono: python
    goto python_found
)

py --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=py
    echo ✅ Znaleziono: py (Python Launcher)
    goto python_found
)

python3 --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD=python3
    echo ✅ Znaleziono: python3
    goto python_found
)

"C:\Python\python.exe" --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD="C:\Python\python.exe"
    echo ✅ Znaleziono: C:\Python\python.exe
    goto python_found
)

"C:\Python3\python.exe" --version >nul 2>&1
if not errorlevel 1 (
    set PYTHON_CMD="C:\Python3\python.exe"
    echo ✅ Znaleziono: C:\Python3\python.exe
    goto python_found
)

echo ❌ Python nie został znaleziony!
echo.
echo ROZWIĄZANIA:
echo 1. Zainstaluj Python z: https://python.org/
echo 2. Podczas instalacji zaznacz "Add Python to PATH"
echo 3. Sprawdź czy Python jest w PATH: echo %PATH%
echo.
pause
exit /b 1

:python_found
echo [2/6] Sprawdzanie wersji Python...
%PYTHON_CMD% --version
echo.

echo [3/6] Sprawdzanie modułu venv...
%PYTHON_CMD% -m venv --help >nul 2>&1
if errorlevel 1 (
    echo ❌ Moduł venv nie jest dostępny!
    echo.
    echo ROZWIĄZANIA:
    echo 1. Zainstaluj python-venv: apt install python3-venv (Linux)
    echo 2. Reinstaluj Python z pełną instalacją
    echo 3. Sprawdź czy Python jest kompletny
    echo.
    pause
    exit /b 1
) else (
    echo ✅ Moduł venv dostępny
)

echo [4/6] Sprawdzanie istniejącego środowiska...
if exist "backend-python\.venv" (
    echo ✅ Folder .venv istnieje
    if exist "backend-python\.venv\Scripts\activate.bat" (
        echo ✅ Plik activate.bat istnieje
    ) else (
        echo ❌ Brak pliku activate.bat - środowisko niepełne!
    )
    if exist "backend-python\.venv\Scripts\python.exe" (
        echo ✅ Python w środowisku istnieje
    ) else (
        echo ❌ Brak python.exe - środowisko niepełne!
    )
) else (
    echo ⚠️ Środowisko wirtualne nie istnieje
)

echo.
echo [5/6] Test tworzenia środowiska wirtualnego...
if exist "backend-python\.venv" (
    echo Usuwanie starego środowiska dla testu...
    rmdir /s /q "backend-python\.venv" 2>nul
)

cd backend-python
echo Tworzenie testowego środowiska...
%PYTHON_CMD% -m venv .venv_test
if errorlevel 1 (
    echo ❌ BŁĄD: Nie można utworzyć środowiska wirtualnego!
    echo.
    echo MOŻLIWE PRZYCZYNY:
    echo - Brak uprawnień do zapisu
    echo - Niekompatybilna wersja Python
    echo - Antywirusowe blokowanie
    echo - Błędna ścieżka Python
    echo.
    cd ..
    pause
    exit /b 1
) else (
    echo ✅ Środowisko utworzone pomyślnie
)

echo Test aktywacji środowiska...
call .venv_test\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ BŁĄD: Nie można aktywować środowiska!
    cd ..
    pause
    exit /b 1
) else (
    echo ✅ Środowisko aktywowane
)

echo Test pip...
pip --version >nul 2>&1
if errorlevel 1 (
    echo ❌ BŁĄD: Pip nie działa w środowisku!
    echo Próba naprawy...
    %PYTHON_CMD% -m ensurepip --upgrade
) else (
    echo ✅ Pip działa poprawnie
)

echo Czyszczenie testowego środowiska...
rmdir /s /q ".venv_test" 2>nul
cd ..

echo.
echo [6/6] PODSUMOWANIE
echo ========================================
echo ✅ Python: %PYTHON_CMD%
echo ✅ Venv: działa
echo ✅ Tworzenie środowiska: działa
echo ✅ System gotowy do uruchomienia setup_and_start.bat
echo.
echo Jeśli nadal masz problemy:
echo 1. Uruchom jako administrator
echo 2. Sprawdź antywirusowe
echo 3. Sprawdź miejsce na dysku
echo 4. Sprawdź długość ścieżki (Windows ma limit)
echo.
pause
