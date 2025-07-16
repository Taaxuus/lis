# 🔧 Notatki developerskie - webLIS

## Konfiguracja środowiska

### Aktualne porty:

- **Frontend**: 3001 (zmieniono z 3000 przez konflikt)
- **Python Backend**: 8000
- **R Backend**: 8002 (zmieniono z 8001 przez konflikt)

### CORS konfiguracja:

**Python** (`backend-python/main.py`):

```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000", "http://localhost:3001"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**R** (`backend-r/server.R`):

```r
#* @filter cors
function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "*")
  res$setHeader("Access-Control-Allow-Headers", "*")
  plumber::forward()
}
```

## Struktura API

### Python FastAPI endpoints:

- `GET /health` - status backendu
- `GET /trees` - dane testowe drzew
- `POST /forest-stands/analysis` - analiza drzewostanu

### R Plumber endpoints:

- `GET /status` - status backendu
- `POST /analyze/forest-stand` - analiza statystyczna
- `POST /calculate/volume` - obliczenia miąższości
- `POST /model/growth` - modelowanie wzrostu

## Pakiety i zależności

### Node.js:

```json
{
	"next": "15.4.1",
	"react": "19.0.0",
	"typescript": "^5",
	"tailwindcss": "^3.4.1"
}
```

### Python:

```txt
fastapi
uvicorn
requests
pydantic
```

### R:

```r
plumber
dplyr
httr
jsonlite
```

## Debugowanie

### Sprawdź procesy:

```bash
# Windows
netstat -ano | findstr ":3001 :8000 :8002"

# Mac/Linux
netstat -an | grep ":3001\|:8000\|:8002"
```

### Logi backendów:

- **Python**: Logi w terminalu uvicorn
- **R**: Logi w terminalu Rscript
- **Frontend**: Konsola przeglądarki (F12)

### Restart all:

```bash
# Kill all processes on ports
taskkill /F /IM node.exe /IM python.exe /IM Rscript.exe

# Restart
npm run dev  # Terminal 1
cd backend-python && uvicorn main:app --port 8000 --reload  # Terminal 2
cd backend-r && Rscript server.R  # Terminal 3
```

## VS Code rozszerzenia (zalecane):

- Python
- R
- TypeScript and JavaScript Language Features
- Tailwind CSS IntelliSense
- REST Client (testowanie API)

## Workflow developmentu:

1. **Nowa funkcja**: Dodaj endpoint w backend-python/main.py lub backend-r/plumber_api.R
2. **Frontend**: Zaktualizuj app/page.tsx
3. **Test**: Sprawdź w przeglądarce na localhost:3001
4. **API docs**:
   - Python: http://localhost:8000/docs
   - R: http://localhost:8002/**docs**/

## Git workflow:

```bash
git add .
git commit -m "feat: opis zmiany"
git push origin main
```

Zespół powinien:

1. Fork repository
2. Clone swojego forka
3. Pracować na branch feature/nazwa-funkcji
4. Pull request do main
