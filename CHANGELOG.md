# webLIS - Changelog

## ✅ GOTOWE - Aplikacja działa!

### Co zostało naprawione

- ✅ Backend R (Plumber) działa na porcie 8001
- ✅ Ujednolicone porty: Frontend 3000, Python 8000, R 8001
- ✅ Poprawione skrypty startowe
- ✅ Uproszczona struktura plików

## 📂 Finalna struktura plików

```
lis/
├── setup_and_start.bat    # Setup + Start (pierwszy raz)
├── start.bat              # Start (kolejne razy)
├── stop_weblis.bat        # Stop wszystkich serwisów
├── app/                   # Frontend Next.js
├── backend-python/        # Backend FastAPI
└── backend-r/             # Backend Plumber R
    ├── server.R           # Główny serwer R (port 8001)
    └── start_r_backend.bat # Skrypt uruchamiający R
```

## 🚀 Jak uruchomić

### Pierwszy raz (z setupem)

```bash
.\setup_and_start.bat
```

### Kolejne razy (tylko start)

```bash
.\start.bat
```

### Zatrzymanie

```bash
.\stop_weblis.bat
```

## 🌐 Porty

| Komponent                | Port | Status |
| ------------------------ | ---- | ------ |
| Frontend (Next.js)       | 3000 | ✅     |
| Backend Python (FastAPI) | 8000 | ✅     |
| Backend R (Plumber)      | 8001 | ✅     |

## ✅ Test działania

```bash
# Python backend
curl http://localhost:8000/health

# R backend
curl http://localhost:8001/status

# Frontend
# http://localhost:3000
```

---

**Status**: ✅ GOTOWE  
**Wersja**: v2.0 (Final)  
**Data**: 2025-07-16
