# webLIS - Quick Start Guide

## ⚡ Najszybsza opcja (Windows)

### Setup + Start (pierwszy raz)

```bash
git clone https://github.com/Taaxuus/lis.git
cd lis
.\setup_and_start.bat
```

### Start (kolejne uruchomienia)

```bash
.\start.bat
```

### Stop

```bash
.\stop_weblis.bat
```

## 🌐 Dostęp do aplikacji

| Komponent         | Adres                           |
| ----------------- | ------------------------------- |
| 🖥️ **Frontend**   | http://localhost:3000           |
| 🐍 **Python API** | http://localhost:8000/docs      |
| 📊 **R API**      | http://localhost:8001/**docs**/ |

## ✅ Test działania

```bash
# Test Python backend
curl http://localhost:8000/health

# Test R backend
curl http://localhost:8001/status
```

## 🛠️ Ręczne uruchomienie (jeśli potrzebujesz)

```bash
# Terminal 1 - Frontend
npm run dev

# Terminal 2 - Python Backend
cd backend-python && .venv\Scripts\activate && uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# Terminal 3 - R Backend
cd backend-r && .\start_r_backend.bat
```

## � Rozwiązywanie problemów

### Backend R nie startuje

1. Sprawdź czy R jest w: `C:\Program Files\R\R-4.5.1\`
2. Uruchom z katalogu backend-r: `.\start_r_backend.bat`

### Porty zajęte

```bash
netstat -an | findstr ":8000"
netstat -an | findstr ":8001"
netstat -an | findstr ":3000"
```

### Zatrzymanie

- Zamknij okna terminali lub użyj `.\stop_weblis.bat`

```bash
# Najpierw w R:
# install.packages(c("plumber", "dplyr", "httr", "jsonlite"))

cd backend-r
Rscript server.R  # lub pełna ścieżka do Rscript
```

➡️ http://localhost:8002

### ✅ Test

1. Otwórz http://localhost:3001
2. Sprawdź zielone statusy backendów
3. "Załaduj dane testowe" → "Analizuj drzewostan"

## Częste problemy

**Port zajęty?**

```bash
netstat -ano | findstr ":8000"
taskkill /PID [ID] /F
```

**R nie działa?**

```bash
# Sprawdź ścieżkę
where R
# Użyj pełnej ścieżki:
& 'C:\Program Files\R\R-4.5.1\bin\Rscript.exe' server.R
```

**Python venv problem?**

```bash
python -m pip install --upgrade pip
python -m venv .venv --clear
```
