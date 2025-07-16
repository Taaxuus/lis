#!/bin/bash

# webLIS - Bash Startup Script (Mac/Linux)

echo "================================="
echo "webLIS - Uruchamianie backendow"
echo "================================="
echo ""

# Sprawdź czy jesteśmy w odpowiednim katalogu
if [ ! -f "package.json" ]; then
    echo "BŁĄD: Uruchom skrypt z głównego katalogu projektu lis!"
    exit 1
fi

# Funkcja do sprawdzenia czy port jest zajęty
check_port() {
    lsof -ti:$1 > /dev/null 2>&1
}

# Zabij procesy na portach jeśli są zajęte
echo "Sprawdzanie i czyszczenie portów..."
if check_port 3001; then
    echo "Zamykanie procesów na porcie 3001..."
    lsof -ti:3001 | xargs kill -9 2>/dev/null
fi
if check_port 8000; then
    echo "Zamykanie procesów na porcie 8000..."
    lsof -ti:8000 | xargs kill -9 2>/dev/null
fi
if check_port 8002; then
    echo "Zamykanie procesów na porcie 8002..."
    lsof -ti:8002 | xargs kill -9 2>/dev/null
fi

echo ""
echo "[1/4] Sprawdzanie środowiska wirtualnego Python..."
if [ ! -d "backend-python/.venv" ]; then
    echo "Tworzenie środowiska wirtualnego Python..."
    cd backend-python
    python3 -m venv .venv
    source .venv/bin/activate
    pip install fastapi uvicorn requests pydantic
    cd ..
fi

echo ""
echo "[2/4] Uruchamianie Backend Python (FastAPI)..."
cd backend-python
gnome-terminal -- bash -c "source .venv/bin/activate && uvicorn main:app --host 0.0.0.0 --port 8000 --reload; exec bash" 2>/dev/null || \
osascript -e 'tell app "Terminal" to do script "cd \"'$(pwd)'\" && source .venv/bin/activate && uvicorn main:app --host 0.0.0.0 --port 8000 --reload"' 2>/dev/null || \
xterm -e "source .venv/bin/activate && uvicorn main:app --host 0.0.0.0 --port 8000 --reload" &
cd ..

echo ""
echo "[3/4] Uruchamianie Backend R (Plumber)..."
cd backend-r
gnome-terminal -- bash -c "Rscript server.R; exec bash" 2>/dev/null || \
osascript -e 'tell app "Terminal" to do script "cd \"'$(pwd)'\" && Rscript server.R"' 2>/dev/null || \
xterm -e "Rscript server.R" &
cd ..

echo ""
echo "[4/4] Uruchamianie Frontend (Next.js)..."
gnome-terminal -- bash -c "npm run dev; exec bash" 2>/dev/null || \
osascript -e 'tell app "Terminal" to do script "cd \"'$(pwd)'\" && npm run dev"' 2>/dev/null || \
xterm -e "npm run dev" &

echo ""
echo "================================="
echo "Wszystkie komponenty uruchomione!"
echo "================================="
echo ""
echo "Frontend: http://localhost:3001"
echo "Python API: http://localhost:8000/docs"
echo "R API: http://localhost:8002/__docs__/"
echo ""
echo "Sprawdź statusy w przeglądarce:"
echo "http://localhost:3001"
echo ""
echo "Naciśnij Enter aby zakończyć wszystkie procesy..."
read

# Zamknij procesy
echo "Zamykanie procesów webLIS..."
if check_port 3001; then lsof -ti:3001 | xargs kill -9 2>/dev/null; fi
if check_port 8000; then lsof -ti:8000 | xargs kill -9 2>/dev/null; fi  
if check_port 8002; then lsof -ti:8002 | xargs kill -9 2>/dev/null; fi
echo "Procesy zakończone."
