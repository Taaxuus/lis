# 🚀 Instrukcja instalacji webLIS dla nowego użytkownika

## 📋 Wymagania systemowe

Przed uruchomieniem webLIS musisz zainstalować:

### 1. Node.js ⚡

- **Pobierz**: https://nodejs.org/
- **Wersja**: Zalecana LTS (obecnie 18.x lub 20.x)
- **⚠️ WAŻNE**: Podczas instalacji zaznacz opcję **"Add to PATH"**
- **Test**: Otwórz PowerShell i wpisz `node --version`

### 2. Python 🐍

- **Pobierz**: https://python.org/downloads/
- **Wersja**: Python 3.8 lub nowszy
- **⚠️ WAŻNE**: Podczas instalacji zaznacz opcję **"Add Python to PATH"**
- **Test**: Otwórz PowerShell i wpisz `python --version`

### 3. R 📊

- **Pobierz**: https://r-project.org/
- **Wersja**: R 4.0 lub nowszy
- **Instalacja**: Standardowa instalacja w `C:\Program Files\R\`
- **Test**: Sprawdź czy folder `C:\Program Files\R\R-[wersja]\` istnieje

## 🔧 Instalacja webLIS

### Krok 1: Pobierz projekt

```bash
git clone https://github.com/Taaxuus/lis.git
cd lis
```

### Krok 2: Sprawdź środowisko

```bash
.\diagnoza_srodowiska.bat
```

Ten skrypt sprawdzi czy wszystko jest poprawnie zainstalowane.

### Krok 3: Automatyczna instalacja i uruchomienie

```bash
.\setup_and_start.bat
```

## 🐛 Rozwiązywanie problemów

### ❌ "Python nie został znaleziony"

**Przyczyna**: Python nie jest w PATH lub nie zainstalowany
**Rozwiązanie**:

1. Sprawdź czy Python jest zainstalowany: `python --version` lub `py --version`
2. Jeśli nie ma w PATH, dodaj ręcznie lub przeinstaluj z opcją "Add to PATH"
3. Alternatywnie użyj: `py` zamiast `python`

### ❌ "R nie został znaleziony"

**Przyczyna**: R nie jest zainstalowany lub w nietypowej lokalizacji
**Rozwiązanie**:

1. Zainstaluj R z https://r-project.org/
2. Sprawdź czy istnieje: `C:\Program Files\R\R-[wersja]\bin\x64\Rscript.exe`
3. Skrypt automatycznie znajdzie R w standardowych lokalizacjach

### ❌ "Node.js nie jest zainstalowany"

**Przyczyna**: Node.js nie jest zainstalowany lub nie w PATH
**Rozwiązanie**:

1. Pobierz i zainstaluj z https://nodejs.org/
2. Podczas instalacji zaznacz "Add to PATH"
3. Restart PowerShell i spróbuj ponownie

### ❌ Porty zajęte (8000, 8001, 3000)

**Rozwiązanie**:

1. Zatrzymaj inne aplikacje używające tych portów
2. Lub użyj `.\stop_weblis.bat` żeby zatrzymać poprzednie instancje

## 📞 Pomoc

1. **Pierwsza pomoc**: Uruchom `.\diagnoza_srodowiska.bat`
2. **Logi błędów**: Sprawdź okna terminali które się otworzą
3. **Reset**: Usuń folder `.venv` w `backend-python` i uruchom ponownie

## ✅ Test działania

Po pomyślnym uruchomieniu powinieneś zobaczyć:

- 🌐 Frontend: http://localhost:3000
- 🐍 Python API: http://localhost:8000/docs
- 📊 R API: http://localhost:8001/**docs**/

Wszystkie 3 komponenty powinny pokazywać zielone statusy na stronie głównej.
