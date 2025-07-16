# Wymagane pakiety R dla backendu webLIS

# Ustaw CRAN mirror
options(repos = c(CRAN = "https://cran.rstudio.com/"))

# Utwórz katalog bibliotek użytkownika jeśli nie istnieje
user_lib <- Sys.getenv("R_LIBS_USER")
if (!dir.exists(user_lib)) {
  dir.create(user_lib, recursive = TRUE)
}

# Instalacja pakietów do katalogu użytkownika
install.packages(c(
  "plumber",      # API framework
  "jsonlite",     # JSON parsing
  "dplyr",        # Data manipulation
  "httr",         # HTTP requests
  "magrittr"      # Pipe operator
), lib = user_lib)

cat("Pakiety zainstalowane pomyślnie!\n")
