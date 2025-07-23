# 🚀 webLIS - START TUTAJ!

## ✅ SZYBKA INSTALACJA (Windows)

### Krok 1: Sprawdź środowisko

```bash
.\diagnoza_srodowiska.bat
```

### Krok 2: Uruchom aplikację

```bash
.\setup_and_start.bat
```

### ⚠️ Jeśli coś nie działa:

**Problem z Python/R/Node.js?**

- Zainstaluj brakujące oprogramowanie zgodnie z instrukcjami w `INSTRUKCJA_INSTALACJI.md`
- Uruchom ponownie `.\diagnoza_srodowiska.bat`

**Wszystko zainstalowane ale nie działa?**

- Otwórz 3 okna terminali ręcznie i uruchom po kolei:

  ```bash
  # Terminal 1
  cd backend-python && .venv\Scripts\activate && uvicorn main:app --host 0.0.0.0 --port 8000 --reload

  # Terminal 2
  cd backend-r && .\start_r_backend.bat

  # Terminal 3
  npm run dev
  ```

## 🌐 Dostęp

- **Aplikacja**: http://localhost:3000
- **Python API**: http://localhost:8000/docs
- **R API**: http://localhost:8001/**docs**/

---

**Szczegółowa dokumentacja**: `README.md`
