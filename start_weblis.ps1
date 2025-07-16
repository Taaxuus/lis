# webLIS - PowerShell Startup Script

Write-Host "=================================" -ForegroundColor Green
Write-Host "webLIS - Uruchamianie backendow" -ForegroundColor Green  
Write-Host "=================================" -ForegroundColor Green

$rootPath = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "[1/3] Uruchamianie Backend Python (FastAPI)..." -ForegroundColor Yellow
$pythonPath = Join-Path $rootPath "backend-python"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$pythonPath'; .\.venv\Scripts\Activate.ps1; uvicorn main:app --host 0.0.0.0 --port 8000 --reload"

Write-Host ""
Write-Host "[2/3] Uruchamianie Backend R (Plumber)..." -ForegroundColor Yellow  
$rPath = Join-Path $rootPath "backend-r"
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$rPath'; Rscript server.R"

Write-Host ""
Write-Host "[3/3] Uruchamianie Frontend (Next.js)..." -ForegroundColor Yellow
$frontendPath = $rootPath
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$frontendPath'; npm run dev"

Write-Host ""
Write-Host "=================================" -ForegroundColor Green
Write-Host "Wszystkie komponenty uruchomione!" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""
Write-Host "Frontend: http://localhost:3001" -ForegroundColor Cyan
Write-Host "Python API: http://localhost:8000/docs" -ForegroundColor Cyan
Write-Host "R API: http://localhost:8002/__docs__/" -ForegroundColor Cyan
Write-Host ""
Write-Host "Nacisnij Enter aby zakonczyc..." -ForegroundColor Gray
Read-Host
