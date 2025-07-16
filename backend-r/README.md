# webLIS R Backend - Instrukcja

## 📊 Backend R (Plumber) - Port 8001

### Szybkie uruchomienie

```bash
cd backend-r
.\start_r_backend.bat
```

### Ręczne uruchomienie

```bash
cd backend-r
"C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe" simple_server.R
```

## 🔧 Struktura plików

```
backend-r/
├── simple_server.R       # Główny serwer (UŻYWANY)
├── server.R             # Wrapper dla simple_server.R
├── start_r_backend.bat  # Skrypt uruchamiający (UŻYWANY)
├── test_simple.bat      # Test uruchomienia
├── plumber_api.R        # Stary plik API (zachowany dla referencji)
└── install_packages.R   # Instalacja pakietów R
```

## 🌐 Dostępne endpointy

| Endpoint            | Metoda | Opis                         |
| ------------------- | ------ | ---------------------------- |
| `/status`           | GET    | Status serwera               |
| `/health`           | GET    | Health check                 |
| `/test`             | GET    | Test połączenia              |
| `/calculate/volume` | POST   | Obliczanie miąższości drzewa |

### Przykłady użycia

```bash
# Status serwera
curl http://localhost:8001/status

# Health check
curl http://localhost:8001/health

# Test połączenia
curl http://localhost:8001/test

# Dokumentacja API
# http://localhost:8001/__docs__/
```

## 🔍 Rozwiązywanie problemów

### 1. Błąd: "R nie jest zainstalowany"

- Sprawdź ścieżkę: `C:\Program Files\R\R-4.5.1\bin\x64\Rscript.exe`
- Zainstaluj R z: https://r-project.org/

### 2. Błąd: "Pakiet plumber nie jest dostępny"

```r
install.packages("plumber", repos="https://cran.r-project.org")
```

### 3. Port 8001 zajęty

```bash
netstat -an | findstr ":8001"
# Zakończ proces używający portu lub zmień port w simple_server.R
```

### 4. Serwer się nie uruchamia

1. Uruchom `.\start_r_backend.bat` z katalogu `backend-r`
2. Sprawdź logi w konsoli
3. Upewnij się, że wszystkie pakiety są zainstalowane

## 📝 Konfiguracja

### Zmiana portu

W pliku `simple_server.R` zmień linię:

```r
pr$run(
  host = "0.0.0.0",
  port = 8001  # <- zmień tutaj
)
```

### Dodanie nowych endpointów

W pliku `simple_server.R` dodaj:

```r
pr$handle("GET", "/nowy-endpoint", function() {
  list(message = "Nowy endpoint")
})
```

## 🧪 Testowanie

```bash
# Test podstawowy
cd backend-r
.\test_simple.bat

# Test API
curl http://localhost:8001/status
curl http://localhost:8001/health
curl http://localhost:8001/test
```

## 📚 Dokumentacja API

Po uruchomieniu serwera, dokumentacja Swagger dostępna jest pod adresem:
**http://localhost:8001/**docs**/**

## 🔄 Integracja z Frontendem

Frontend łączy się z R backend przez:

- Status check: `http://localhost:8001/status`
- Analiza danych: `http://localhost:8001/calculate/volume`

Konfiguracja w `app/page.tsx`:

```typescript
const rResponse = await fetch("http://localhost:8001/status");
```
