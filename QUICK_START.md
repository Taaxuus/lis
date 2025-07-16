# 🚀 Szybki start - webLIS

## ⚡ NAJSZYBSZA OPCJA (Windows):

```bash
git clone https://github.com/Taaxuus/lis.git
cd lis
setup_and_start.bat
```

**Gotowe!** 🎉 Wszystko zostanie zainstalowane i uruchomione automatycznie.

## TL;DR - Uruchom w 5 minut (ręcznie)

### 1. Wymagania

✅ Node.js >= 18  
✅ Python >= 3.11  
✅ R >= 4.5

### 2. Sklonuj i uruchom

```bash
git clone https://github.com/Taaxuus/lis.git
cd lis
```

### 3. Frontend (Terminal 1)

```bash
npm install
npm run dev
```

➡️ http://localhost:3001

### 4. Python Backend (Terminal 2)

```bash
cd backend-python
python -m venv .venv
.\.venv\Scripts\Activate.ps1  # Windows
pip install fastapi uvicorn requests pydantic
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

➡️ http://localhost:8000

### 5. R Backend (Terminal 3)

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
