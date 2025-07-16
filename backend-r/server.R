# Serwer Plumber dla webLIS
# Uruchamia API na porcie 8001

library(plumber)

# Załaduj API
api <- plumb("plumber_api.R")

# Uruchom serwer
api$run(
  host = "0.0.0.0",
  port = 8001,
  swagger = TRUE
)
