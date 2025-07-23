# webLIS - Kompletny przewodnik

System a**📖 Szczegółowa instrukcja**: Zobacz `INSTRUKCJA_INSTALACJI.md`

## 🏗️ ARCHITEKTURAkorzystaniem danych teledetekcyjnych dla leśnictwa.

## 🚀 SZYBKIE URUCHOMIENIE (Windows)

### 🆕 Pierwszy raz na nowym komputerze

```bash
# 1. Sprawdź czy masz wszystko zainstalowane
.\diagnoza_srodowiska.bat

# 2. Jeśli wszystko OK, uruchom setup
.\setup_and_start.bat
```

### 🔄 Kolejne uruchomienia

```bash
.\start.bat
```

### ⏹️ Zatrzymanie

```bash
.\stop_weblis.bat
```

## 📋 WYMAGANIA

**⚠️ UWAGA**: Przed pierwszym uruchomieniem musisz zainstalować:

### Oprogramowanie:

- **Node.js** >= 18.0.0 ➜ https://nodejs.org/ (zaznacz "Add to PATH")
- **Python** >= 3.8 ➜ https://python.org/ (zaznacz "Add Python to PATH")
- **R** >= 4.0 ➜ https://r-project.org/ (standardowa instalacja)

### 🔍 Sprawdź instalację:

```bash
node --version
python --version  # lub: py --version
# R zostanie znaleziony automatycznie
```

**📖 Szczegółowa instrukcja**: Zobacz `INSTRUKCJA_INSTALACJI.md`

- **Node.js** >= 18.0.0
- **Python** >= 3.11
- **R** >= 4.5.0

### Sprawdź wersje:

```bash
node --version
python --version
R --version
```

## �️ ARCHITEKTURA

| Komponent          | Technologia             | Port | Funkcje                                   |
| ------------------ | ----------------------- | ---- | ----------------------------------------- |
| **Frontend**       | Next.js 15 + TypeScript | 3000 | Interfejs użytkownika, wizualizacja       |
| **Backend Python** | FastAPI                 | 8000 | Zarządzanie danymi, podstawowe obliczenia |
| **Backend R**      | Plumber                 | 8001 | Obliczenia dendrometryczne, modelowanie   |

## 🌐 DOSTĘP DO APLIKACJI

| Komponent               | Adres                           | Opis                 |
| ----------------------- | ------------------------------- | -------------------- |
| 🖥️ **Aplikacja główna** | http://localhost:3000           | Interfejs webLIS     |
| 🐍 **Python API**       | http://localhost:8000/docs      | Dokumentacja FastAPI |
| 📊 **R API**            | http://localhost:8001/**docs**/ | Dokumentacja Plumber |

## ✅ TEST DZIAŁANIA

### Szybki test:

```bash
# Test Python backend
curl http://localhost:8000/health

# Test R backend
curl http://localhost:8001/status
```

### Test w aplikacji:

1. Otwórz http://localhost:3000
2. Sprawdź zielone statusy backendów
3. Kliknij "Załaduj dane testowe"
4. Kliknij "Analizuj drzewostan"

## 🛠️ RĘCZNE URUCHOMIENIE (jeśli potrzebujesz)

Otwórz 3 terminale i uruchom po kolei:

```bash
# Terminal 1 - Frontend
npm run dev

# Terminal 2 - Python Backend
cd backend-python
.venv\Scripts\activate
uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# Terminal 3 - R Backend
cd backend-r
.\start_r_backend.bat
```

## 📁 STRUKTURA PROJEKTU

```
lis/
├── setup_and_start.bat    # Setup + Start (pierwszy raz)
├── start.bat              # Start (kolejne razy)
├── stop_weblis.bat        # Stop wszystkich serwisów
├── diagnoza_srodowiska.bat # Diagnostyka kompletnego środowiska
├── test_python_env.bat    # Test środowiska Python
├── napraw_python.bat      # Naprawa środowiska Python
├── app/                   # Frontend Next.js
│   ├── layout.tsx         # Layout główny
│   ├── page.tsx          # Strona główna
│   ├── mapa/             # Podstrona z mapą
│   │   └── page.tsx      # Interaktywna mapa OpenLayers
│   └── globals.css       # Style globalne + OpenLayers CSS
├── backend-python/        # Backend FastAPI
│   ├── main.py           # Główny serwer Python
│   ├── requirements.txt  # Zależności Python
│   └── .venv/            # Środowisko wirtualne (auto-generowane)
└── backend-r/             # Backend Plumber R
    ├── server.R          # Główny serwer R (port 8001)
    └── start_r_backend.bat # Skrypt uruchamiający R
```

## 🎯 FUNKCJONALNOŚCI

### Backend Python (FastAPI):

- ✅ Zarządzanie danymi drzew
- ✅ Podstawowe obliczenia miąższości
- ✅ Analiza parametrów drzewostanów
- ✅ Symulacja przetwarzania danych teledetekcyjnych
- ✅ CORS dla komunikacji z frontendem

### Backend R (Plumber):

- ✅ Zaawansowane obliczenia dendrometryczne (Huber, Smalian)
- ✅ Analiza struktury pionowej drzewostanu
- ✅ Predykcja wysokości na podstawie pierśnicy
- ✅ Analiza rozkładu przestrzennego drzew
- ✅ Modelowanie wzrostu drzewostanu

### Frontend (Next.js):

- ✅ Responsywny interfejs użytkownika
- ✅ Monitoring statusu backendów
- ✅ Interaktywne panele testowe
- ✅ Wizualizacja danych i wyników analiz
- ✅ Komunikacja z obiema API

## 🔧 ROZWIĄZYWANIE PROBLEMÓW

### 🐍 Problemy z Python?

**NAJCZĘSTSZE ROZWIĄZANIA:**

1. **Test środowiska:** `test_python_env.bat` - sprawdza wszystkie komponenty Python
2. **Automatyczna naprawa:** `napraw_python.bat` - usuwa i odtwarza środowisko Python
3. **Diagnostyka:** `diagnoza_srodowiska.bat` - sprawdza całe środowisko

**RĘCZNE ROZWIĄZANIA:**

```bash
# Problem: środowisko nie tworzy się
cd backend-python
rmdir /s /q .venv
python -m venv .venv
call .venv\Scripts\activate.bat
pip install fastapi uvicorn requests pydantic

# Problem: pip nie działa
python -m ensurepip --upgrade
python -m pip install --upgrade pip

# Problem: pakiety nie instalują się
pip install --user fastapi uvicorn requests pydantic
```

### Port zajęty?

```bash
# Sprawdź zajęte porty
netstat -ano | findstr ":3000"
netstat -ano | findstr ":8000"
netstat -ano | findstr ":8001"

# Zabij proces (zamień [PID] na numer procesu)
taskkill /PID [PID] /F
```

### Backend R nie startuje?

```bash
# Sprawdź ścieżkę do R
where R

# Uruchom z pełną ścieżką
& 'C:\Program Files\R\R-4.5.1\bin\Rscript.exe' server.R
```

### Frontend nie startuje?

```bash
# Wyczyść cache i reinstall
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

## 📊 API ENDPOINTS

### Python FastAPI:

- `GET /health` - status backendu
- `GET /trees` - dane testowe drzew
- `POST /forest-stands/analysis` - analiza drzewostanu

### R Plumber:

- `GET /status` - status backendu
- `POST /analyze/forest-stand` - analiza statystyczna
- `POST /calculate/volume` - obliczenia miąższości
- `POST /model/growth` - modelowanie wzrostu

## 📈 STATUS PROJEKTU

- ✅ **Backend R (Plumber)** - działa na porcie 8001
- ✅ **Backend Python (FastAPI)** - działa na porcie 8000
- ✅ **Frontend (Next.js)** - działa na porcie 3000
- ✅ **Ujednolicone porty i skrypty startowe**
- ✅ **Kompletna dokumentacja w jednym pliku**

---

**webLIS v2.0** - System analityczny dla leśnictwa  
**Data aktualizacji**: 2025-07-23
