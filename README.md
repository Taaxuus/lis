# webLIS - Aplikacja webowa do obliczeń parametrów drzew i drzewostanów

System analityczny z wykorzystaniem danych teledetekcyjnych dla leśnictwa.

## 🏗️ Architektura

- **Frontend**: Next.## 🚦 Uruchomienie wszystkich serwisów jednocześnie

### ⚡ NAJSZYBSZA OPCJA - Jeden klik (Windows):

```bash
# Auto-setup i uruchomienie (Windows)
setup_and_start.bat

# Alternatywnie - tylko uruchomienie
start_weblis.bat

# Zatrzymanie wszystkich serwisów
stop_weblis.bat
```

### 🐧 Linux/Mac:

```bash
# Nadaj uprawnienia (jednorazowo)
chmod +x start_weblis.sh

# Uruchom
./start_weblis.sh
```

### 💻 Ręcznie w 3 terminalach:

#### Windows PowerShell:

```bash
# Terminal 1 - Frontend
npm run dev

# Terminal 2 - Python Backend
cd backend-python && .\.venv\Scripts\Activate.ps1 && uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# Terminal 3 - R Backend
cd backend-r && & 'C:\Program Files\R\R-4.5.1\bin\Rscript.exe' server.R
```

#### Mac/Linux:

````bash
# Terminal 1 - Frontend
npm run dev

# Terminal 2 - Python Backend
cd backend-python && source .venv/bin/activate && uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# Terminal 3 - R Backend
cd backend-r && Rscript server.R
```eScript + Tailwind CSS)
- **Backend Python**: FastAPI (zarządzanie danymi, podstawowe obliczenia)
- **Backend R**: Plumber (zaawansowane obliczenia dendrometryczne)
- **Porty**: Frontend 3001, Python 8000, R 8002

## 📋 Wymagania systemowe

### Obowiązkowe:

- **Node.js** >= 18.0.0
- **Python** >= 3.11 (zalecane 3.13)
- **R** >= 4.5.0
- **Git**
- **PowerShell** (Windows) lub Terminal (Mac/Linux)

### Sprawdź wersje:

```bash
node --version
python --version
R --version
git --version
````

## 🚀 Instalacja krok po kroku

### 1. Sklonuj repozytorium

```bash
git clone https://github.com/Taaxuus/lis.git
cd lis
```

### 2. Frontend (Next.js)

```bash
# Zainstaluj zależności
npm install

# Uruchom w trybie rozwoju
npm run dev
```

✅ Frontend dostępny na: http://localhost:3001

### 3. Backend Python (FastAPI)

```bash
# Przejdź do katalogu
cd backend-python

# Stwórz środowisko wirtualne
python -m venv .venv

# Aktywuj środowisko wirtualne
# Windows PowerShell:
.\.venv\Scripts\Activate.ps1
# Windows CMD:
.\.venv\Scripts\activate.bat
# Mac/Linux:
source .venv/bin/activate

# Zainstaluj zależności
pip install fastapi uvicorn requests pydantic

# Uruchom serwer
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

✅ Backend Python dostępny na: http://localhost:8000

### 4. Backend R (Plumber)

```bash
# Przejdź do katalogu
cd backend-r

# Uruchom R i zainstaluj pakiety (jednorazowo)
R
```

W konsoli R wykonaj:

```r
install.packages(c("plumber", "dplyr", "httr", "jsonlite"))
quit()
```

Następnie uruchom serwer:

```bash
# Windows:
& 'C:\Program Files\R\R-4.5.1\bin\Rscript.exe' server.R

# Mac/Linux:
Rscript server.R
```

✅ Backend R dostępny na: http://localhost:8002

## 🔧 Weryfikacja instalacji

### Sprawdź status wszystkich serwisów:

```bash
# Windows:
netstat -ano | findstr ":3001 :8000 :8002"

# Mac/Linux:
netstat -an | grep ":3001\|:8000\|:8002"
```

Powinieneś zobaczyć 3 porty w stanie `LISTENING`:

- `3001` - Frontend Next.js
- `8000` - Backend Python FastAPI
- `8002` - Backend R Plumber

### Test przez przeglądarkę:

1. Otwórz http://localhost:3001
2. Sprawdź status backendów (powinny pokazać "connected")
3. Kliknij "Załaduj dane testowe"
4. Kliknij "Analizuj drzewostan"

## 🛠️ Rozwiązywanie problemów

### Port jest zajęty

```bash
# Znajdź proces na porcie (Windows)
netstat -ano | findstr ":8000"
taskkill /PID [NUMER_PID] /F

# Mac/Linux
lsof -ti:8000 | xargs kill -9
```

### Backend R nie startuje

1. Sprawdź czy R jest zainstalowany: `R --version`
2. Sprawdź ścieżkę do R: `where R` (Windows) lub `which R` (Mac/Linux)
3. Zainstaluj brakujące pakiety:

```r
install.packages(c("plumber", "dplyr", "httr", "jsonlite"))
```

### Python środowisko wirtualne

```bash
# Dezaktywuj
deactivate

# Usuń i stwórz ponownie
rm -rf .venv  # Mac/Linux
Remove-Item -Recurse -Force .venv  # Windows PowerShell

python -m venv .venv
```

### CORS błędy

- Upewnij się, że wszystkie backendy używają poprawnych portów
- Frontend musi być uruchomiony na porcie 3001
- Sprawdź konfigurację CORS w `backend-python/main.py` i `backend-r/server.R`

## 📁 Struktura projektu

```
lis/
├── app/                    # Frontend Next.js
│   ├── page.tsx           # Główna strona
│   ├── globals.css        # Style CSS
│   └── layout.tsx         # Layout aplikacji
├── backend-python/         # Backend FastAPI
│   ├── main.py            # Główny plik API
│   └── .venv/             # Środowisko wirtualne Python
├── backend-r/              # Backend Plumber R
│   ├── server.R           # Konfiguracja serwera
│   └── plumber_api.R      # Endpointy API
├── package.json           # Zależności Node.js
└── README.md              # Ta instrukcja
```

## 🚦 Uruchomienie wszystkich serwisów jednocześnie

### Windows PowerShell (3 terminale):

```bash
# Terminal 1 - Frontend
npm run dev

# Terminal 2 - Python Backend
cd backend-python && .\.venv\Scripts\Activate.ps1 && uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# Terminal 3 - R Backend
cd backend-r && & 'C:\Program Files\R\R-4.5.1\bin\Rscript.exe' server.R
```

## 🤝 Rozwój

### Dodawanie nowych funkcji:

1. **Frontend**: Edytuj `app/page.tsx`
2. **Python API**: Dodaj endpointy w `backend-python/main.py`
3. **R API**: Dodaj funkcje w `backend-r/plumber_api.R`

### Testy:

- Frontend: http://localhost:3001
- Python API docs: http://localhost:8000/docs
- R API docs: http://localhost:8002/**docs**/

## 📞 Wsparcie

W przypadku problemów:

1. Sprawdź logi w terminalach
2. Upewnij się, że wszystkie porty są wolne
3. Zweryfikuj wersje oprogramowania
4. Sprawdź czy wszystkie pakiety są zainstalowane

## 🎯 Funkcjonalności

### Backend Python (FastAPI):

- Zarządzanie danymi drzew
- Podstawowe obliczenia miąższości
- Analiza drzewostanów
- Przetwarzanie danych teledetekcyjnych

### Backend R (Plumber):

- Zaawansowane obliczenia dendrometryczne
- Analiza struktury pionowej
- Modelowanie wzrostu
- Analiza rozkładu przestrzennego

---

**webLIS** - System analityczny dla leśnictwa  
_Technologie: Next.js + FastAPI + Plumber R_
