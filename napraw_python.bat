@echo off
chcp 65001 > nul
echo ========================================
echo        NAPRAWA ŚRODOWISKA PYTHON
echo ========================================
echo.
echo Ten skrypt usuwa i ponownie tworzy środowisko Python
echo dla backend-python jeśli wystąpiły problemy.
echo.

set /p choice="Czy chcesz kontynuować? (t/n): "
if /i not "%choice%"=="t" (
    echo Operacja anulowana.
    pause
    exit /b 0
)

echo.
echo [1/5] Sprawdzanie Python...

REM Znajdź Python - kopiuje logikę z głównych skryptów
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
echo Musisz najpierw zainstalować Python.
pause
exit /b 1

:python_found
echo ✅ Python znaleziony: %PYTHON_CMD%

echo [2/5] Usuwanie starego środowiska...
if exist "backend-python\.venv" (
    echo Usuwanie folderu .venv...
    rmdir /s /q "backend-python\.venv" 2>nul
    if exist "backend-python\.venv" (
        echo ⚠️ Nie można usunąć niektórych plików - możliwe problemy z uprawnieniami
        echo Spróbuj uruchomić jako administrator lub ręcznie usuń folder
    ) else (
        echo ✅ Stare środowisko usunięte
    )
) else (
    echo ✅ Brak starego środowiska do usunięcia
)

echo [3/5] Tworzenie nowego środowiska...
cd backend-python

echo Uruchamianie: %PYTHON_CMD% -m venv .venv
%PYTHON_CMD% -m venv .venv
if errorlevel 1 (
    echo ❌ BŁĄD: Nie można utworzyć środowiska wirtualnego!
    echo.
    echo ROZWIĄZANIA:
    echo 1. Uruchom jako administrator
    echo 2. Sprawdź czy dysk ma miejsce
    echo 3. Sprawdź antywirusowe
    echo 4. Sprawdź uprawnienia do folderu
    echo.
    cd ..
    pause
    exit /b 1
)

echo ✅ Środowisko utworzone

echo [4/5] Aktywacja i konfiguracja...
if not exist ".venv\Scripts\activate.bat" (
    echo ❌ BŁĄD: Plik activate.bat nie został utworzony!
    cd ..
    pause
    exit /b 1
)

call .venv\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ BŁĄD: Nie można aktywować środowiska!
    cd ..
    pause
    exit /b 1
)

echo ✅ Środowisko aktywowane

echo Sprawdzanie pip...
pip --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Pip nie działa - próba naprawy...
    %PYTHON_CMD% -m ensurepip --upgrade
    if errorlevel 1 (
        echo ❌ Nie można naprawić pip
        cd ..
        pause
        exit /b 1
    )
)

echo ✅ Pip sprawny

echo [5/5] Instalacja pakietów...
echo Instalowanie: fastapi uvicorn requests pydantic
pip install fastapi uvicorn requests pydantic
if errorlevel 1 (
    echo ❌ BŁĄD: Nie można zainstalować pakietów!
    echo.
    echo ROZWIĄZANIA:
    echo 1. Sprawdź połączenie internetowe
    echo 2. Spróbuj: pip install --upgrade pip
    echo 3. Sprawdź proxy/firewall
    echo.
    cd ..
    pause
    exit /b 1
)

echo ✅ Pakiety zainstalowane

cd ..

echo.
echo ========================================
echo ✅ NAPRAWA ZAKOŃCZONA POMYŚLNIE!
echo ========================================
echo.
echo Środowisko Python zostało odtworzone.
echo Możesz teraz uruchomić:
echo - start.bat (szybkie uruchomienie)
echo - setup_and_start.bat (pełna konfiguracja)
echo.
echo Sprawdź też: test_python_env.bat
echo.
pause
