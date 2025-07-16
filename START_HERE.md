# 🚀 webLIS - Szybki Start

## Automatyczne uruchomienie (Windows)

### 1️⃣ Pierwsza instalacja:

```bash
setup_and_start.bat
```

- Sprawdza wymagania (Node.js, Python, R)
- Instaluje wszystkie zależności automatycznie
- Uruchamia wszystkie komponenty

### 2️⃣ Kolejne uruchomienia:

```bash
start_weblis.bat
```

- Szybkie uruchomienie bez sprawdzania zależności

### 3️⃣ Zatrzymanie:

```bash
stop_weblis.bat
```

- Zamyka wszystkie procesy webLIS

## Dostępne opcje uruchomienia:

| Plik                  | System    | Opis                  |
| --------------------- | --------- | --------------------- |
| `setup_and_start.bat` | Windows   | 🔧 Auto-setup + start |
| `start_weblis.bat`    | Windows   | ⚡ Szybki start       |
| `start_weblis.ps1`    | Windows   | 💻 PowerShell         |
| `start_weblis.sh`     | Linux/Mac | 🐧 Bash               |
| `stop_weblis.bat`     | Windows   | ⏹️ Stop wszystkich    |

## Po uruchomieniu:

✅ **Frontend**: http://localhost:3001  
✅ **Python API**: http://localhost:8000/docs  
✅ **R API**: http://localhost:8002/**docs**/

### Sprawdź status:

1. Otwórz http://localhost:3001
2. Sprawdź zielone statusy obu backendów
3. Kliknij "Załaduj dane testowe"
4. Kliknij "Analizuj drzewostan"

## Problemy?

```bash
# Sprawdź co działa:
netstat -ano | findstr ":3001 :8000 :8002"

# Zabij wszystko i zacznij od nowa:
stop_weblis.bat
setup_and_start.bat
```

---

**webLIS** - Leśny system analityczny
