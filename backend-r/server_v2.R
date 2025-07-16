# webLIS R Backend - Nowoczesny Plumber API
# Port: 8001

cat("=== webLIS R Backend v2 ===\n")
cat("Sprawdzanie środowiska...\n")

# Sprawdź working directory
cat("Working directory:", getwd(), "\n")

# Sprawdź wymagane pakiety
required_packages <- c("plumber", "jsonlite")

for(pkg in required_packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat(paste("Instalowanie pakietu:", pkg, "\n"))
    install.packages(pkg, repos = "https://cran.r-project.org")
    library(pkg, character.only = TRUE)
  }
  cat(paste("✅", pkg, "OK\n"))
}

# Nowy API z annotation-based approach
#* @apiTitle webLIS Backend R
#* @apiDescription API do obliczeń dendrometrycznych
#* @apiVersion 1.0.0

#* Status API
#* @get /status
function() {
  list(
    message = "webLIS Backend R - Plumber v2",
    version = "1.0.0",
    status = "active",
    port = 8001,
    timestamp = Sys.time()
  )
}

#* Health check
#* @get /health
function() {
  list(
    status = "healthy",
    r_version = R.version.string,
    timestamp = Sys.time()
  )
}

#* Test endpoint
#* @get /test
function() {
  list(
    message = "Backend R v2 działa poprawnie!",
    test = "OK"
  )
}

#* Analiza drzewostanu
#* @post /analyze/forest-stand
#* @param trees:object Lista drzew do analizy
function(trees) {
  cat("🔄 Otrzymano request do /analyze/forest-stand (v2)\n")
  
  # Sprawdź dane
  if (is.null(trees) || length(trees) == 0) {
    cat("❌ Brak danych o drzewach\n")
    return(list(error = "Brak danych o drzewach"))
  }
  
  # Konwertuj do data.frame jeśli potrzeba
  if (is.list(trees) && !is.data.frame(trees)) {
    trees <- do.call(rbind.data.frame, trees)
  }
  
  cat("✅ Otrzymano", nrow(trees), "drzew\n")
  
  # Podstawowe statystyki
  total_trees <- nrow(trees)
  cat("Liczba drzew:", total_trees, "\n")
  
  # Oblicz miąższości
  volumes <- sapply(1:total_trees, function(i) {
    dbh <- as.numeric(trees$diameter_breast_height[i])
    height <- as.numeric(trees$height[i])
    diameter_m <- dbh / 100
    volume <- pi * (diameter_m / 2)^2 * height * 0.5
    return(volume)
  })
  
  total_volume <- sum(volumes, na.rm = TRUE)
  
  # Statystyki
  avg_dbh <- mean(as.numeric(trees$diameter_breast_height), na.rm = TRUE)
  avg_height <- mean(as.numeric(trees$height), na.rm = TRUE)
  
  result <- list(
    summary = list(
      total_trees = total_trees,
      total_volume_m3 = round(total_volume, 2),
      average_dbh_cm = round(avg_dbh, 1),
      average_height_m = round(avg_height, 1)
    ),
    calculated_at = Sys.time()
  )
  
  cat("✅ Analiza zakończona pomyślnie\n")
  return(result)
}

# Utworzenie i uruchomienie API
cat("Tworzenie API v2...\n")

# CORS filter
#* @filter cors
cors <- function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization")
  
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$status <- 200
    return(list())
  } else {
    plumber::forward()
  }
}

cat("✅ API v2 skonfigurowane\n")
cat("🚀 Uruchamianie serwera na http://localhost:8001\n")
cat("📋 Dostępne endpointy:\n")
cat("   GET  /status - Status serwera\n") 
cat("   GET  /health - Health check\n")
cat("   GET  /test   - Test połączenia\n")
cat("   POST /analyze/forest-stand - Analiza drzewostanu\n")
cat("-------------------------------------\n")

# Uruchomienie serwera
pr <- plumb("server_v2.R")
pr$run(
  host = "0.0.0.0",
  port = 8001
)
