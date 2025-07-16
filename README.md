# webLIS - Aplikacja webowa do obliczeń parametrów drzew i drzewostanów

System analityczny z wykorzystaniem danych teledetekcyjnych dla leśnictwa.

## � Szybkie uruchomienie (Windows)

### Setup + Start (pierwszy raz)

```bash
.\setup_and_start.bat
```

### Tylko start (kolejne uruchomienia)

```bash
.\start.bat
```

### Stop

```bash
.\stop_weblis.bat
```

## 🏗️ Architektura

- **Frontend**: Next.js 15 (React 19, TypeScript + Tailwind CSS) - **port 3000**
- **Backend Python**: FastAPI (zarządzanie danymi) - **port 8000**
- **Backend R**: Plumber (obliczenia dendrometryczne) - **port 8001**

## 📋 Wymagania

- **Node.js** >= 18.0.0
- **Python** >= 3.11
- **R** >= 4.5.0

### Sprawdź wersje:

```bash
node --version
python --version
R --version
```

## 🌐 Dostęp

| Komponent         | Adres                           | Opis             |
| ----------------- | ------------------------------- | ---------------- |
| 🖥️ **Frontend**   | http://localhost:3000           | Główna aplikacja |
| 🐍 **Python API** | http://localhost:8000/docs      | FastAPI docs     |
| 📊 **R API**      | http://localhost:8001/**docs**/ | Plumber docs     |

## ✅ Test działania

```bash
# Test Python
curl http://localhost:8000/health

# Test R
curl http://localhost:8001/status
```

## 🛠️ Ręczne uruchomienie (3 terminale)

```bash
# Terminal 1 - Frontend
npm run dev

# Terminal 2 - Python Backend
cd backend-python && .venv\Scripts\activate && uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# Terminal 3 - R Backend
cd backend-r && .\start_r_backend.bat
```

## 📁 Struktura

```
lis/
├── setup_and_start.bat    # Setup + Start (pierwszy raz)
├── start.bat              # Start (kolejne razy)
├── stop_weblis.bat        # Stop wszystkich serwisów
├── app/                   # Frontend Next.js
├── backend-python/        # Backend FastAPI
└── backend-r/             # Backend Plumber R
    ├── server.R           # Główny serwer R
    └── start_r_backend.bat # Skrypt uruchamiający R
```

## 🎯 Funkcjonalności

- **Python**: Zarządzanie danymi, podstawowe obliczenia
- **R**: Zaawansowane obliczenia dendrometryczne, analiza struktury
- **Frontend**: Interfejs użytkownika, wizualizacja danych

---

**webLIS** - System analityczny dla leśnictwa
