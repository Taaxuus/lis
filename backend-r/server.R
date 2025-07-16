# Serwer Plumber dla webLIS
# Uruchamia API na porcie 8001

library(plumber)

# Załaduj API
api <- plumb("plumber_api.R")

# Dodaj CORS middleware
api$filter("cors", function(req, res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  res$setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
  res$setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization")
  
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$status <- 200
    return(list())
  } else {
    plumber::forward()
  }
})

# Uruchom serwer
api$run(
  host = "0.0.0.0",
  port = 8002,
  docs = TRUE
)
