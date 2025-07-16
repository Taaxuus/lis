# webLIS R Backend - Naprawiona wersja
library(plumber)
library(jsonlite)

# Status API
#* @get /status
function() {
  list(
    message = "webLIS Backend R - Fixed",
    version = "1.0.0",
    status = "active",
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

#* Analiza drzewostanu
#* @post /analyze/forest-stand
function(req) {
  cat("🔄 Otrzymano request do /analyze/forest-stand\n")
  
  # Parsowanie danych JSON z body
  body <- tryCatch({
    jsonlite::fromJSON(rawToChar(req$postBody))
  }, error = function(e) {
    cat("❌ Błąd parsowania JSON:", e$message, "\n")
    return(list(error = paste("Błąd parsowania JSON:", e$message)))
  })
  
  if (is.null(body$trees)) {
    cat("❌ Brak danych o drzewach\n")
    return(list(error = "Brak danych o drzewach"))
  }
  
  trees <- body$trees
  cat("✅ Otrzymano", nrow(trees), "drzew\n")
  
  # Podstawowe statystyki
  total_trees <- nrow(trees)
  
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
