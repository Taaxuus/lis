# Wymagane pakiety R dla backendu webLIS

# Instalacja pakietów (uruchom raz)
install.packages(c(
  "plumber",      # API framework
  "jsonlite",     # JSON parsing
  "dplyr",        # Data manipulation
  "httr",         # HTTP requests
  "magrittr"      # Pipe operator
))

# Dodatkowe pakiety dla analiz leśnych (opcjonalne)
install.packages(c(
  "sf",           # Spatial features
  "raster",       # Raster data
  "ggplot2",      # Plotting
  "tidyr",        # Data tidying
  "forestinventory" # Forest inventory calculations
))
