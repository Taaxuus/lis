# Backend R - Plumber dla webLIS
# Specjalistyczne obliczenia dendrometryczne i statystyczne

library(plumber)
library(jsonlite)
library(dplyr)

# Przykładowe dane testowe dla obliczeń dendrometrycznych
sample_forest_data <- data.frame(
  tree_id = 1:20,
  dbh = c(25.5, 32.1, 28.7, 22.3, 30.8, 26.4, 35.2, 24.1, 29.6, 27.3,
          33.7, 25.9, 31.4, 23.8, 28.2, 34.6, 26.7, 30.1, 27.8, 32.9),
  height = c(18.2, 22.5, 20.1, 16.8, 21.7, 19.3, 24.1, 17.5, 20.8, 19.6,
             23.2, 18.7, 22.0, 17.1, 19.9, 24.8, 19.2, 21.3, 20.4, 22.7),
  species = rep(c("Pinus sylvestris", "Picea abies", "Quercus robur", "Betula pendula"), 5),
  age = c(45, 52, 65, 35, 48, 42, 58, 38, 50, 44, 55, 40, 53, 37, 47, 60, 43, 51, 46, 54),
  x_coord = runif(20, 100, 200),
  y_coord = runif(20, 200, 300),
  stringsAsFactors = FALSE
)

# Funkcje pomocnicze dla obliczeń leśnych

#' Obliczanie miąższości metodą Hubera
calculate_volume_huber <- function(dbh, height, form_factor = 0.5) {
  diameter_m <- dbh / 100
  volume <- pi * (diameter_m / 2)^2 * height * form_factor
  return(volume)
}

#' Obliczanie miąższości metodą Smaliana
calculate_volume_smalian <- function(dbh, height, taper_factor = 0.8) {
  d_base <- dbh / 100
  d_top <- d_base * taper_factor
  volume <- (pi * height / 3) * ((d_base/2)^2 + (d_top/2)^2 + (d_base/2 * d_top/2))
  return(volume)
}

#' Obliczanie wysokości na podstawie modelu regresyjnego
height_diameter_model <- function(dbh, species = "Pinus sylvestris") {
  # Przykładowe modele wysokość-pierśnica dla różnych gatunków
  coefficients <- list(
    "Pinus sylvestris" = list(a = 1.3, b = 0.65),
    "Picea abies" = list(a = 1.2, b = 0.68),
    "Quercus robur" = list(a = 1.1, b = 0.72),
    "Betula pendula" = list(a = 1.4, b = 0.62)
  )
  
  coef <- coefficients[[species]]
  if (is.null(coef)) coef <- coefficients[["Pinus sylvestris"]]
  
  height <- coef$a + coef$b * dbh
  return(height)
}

#' Analiza struktury pionowej drzewostanu
analyze_vertical_structure <- function(heights) {
  layers <- list(
    upper = sum(heights > quantile(heights, 0.7)),
    middle = sum(heights >= quantile(heights, 0.3) & heights <= quantile(heights, 0.7)),
    lower = sum(heights < quantile(heights, 0.3))
  )
  
  total_trees <- length(heights)
  structure <- list(
    upper_layer_pct = round((layers$upper / total_trees) * 100, 1),
    middle_layer_pct = round((layers$middle / total_trees) * 100, 1),
    lower_layer_pct = round((layers$lower / total_trees) * 100, 1),
    height_diversity_index = round(sd(heights) / mean(heights), 3)
  )
  
  return(structure)
}

#* @apiTitle webLIS Backend R - Plumber
#* @apiDescription API do specjalistycznych obliczeń dendrometrycznych i statystycznych
#* @apiVersion 1.0.0

#* Status backendu R
#* @get /status
function() {
  list(
    message = "webLIS Backend R - Plumber",
    version = "1.0.0",
    description = "API do obliczeń dendrometrycznych i statystycznych",
    status = "active",
    timestamp = Sys.time()
  )
}

#* Sprawdzenie zdrowia systemu
#* @get /health
function() {
  list(
    status = "healthy",
    r_version = R.version.string,
    packages = c("plumber", "dplyr", "jsonlite"),
    memory_usage = round(as.numeric(object.size(ls(envir = .GlobalEnv))) / 1024^2, 2),
    timestamp = Sys.time()
  )
}

#* Pobierz przykładowe dane leśne
#* @get /forest-data
function() {
  sample_forest_data
}

#* Obliczenia miąższości dla pojedynczego drzewa
#* @post /calculate/volume
#* @param dbh:numeric Pierśnica w cm
#* @param height:numeric Wysokość w metrach
#* @param method:character Metoda obliczania (huber/smalian)
function(dbh, height, method = "huber") {
  dbh <- as.numeric(dbh)
  height <- as.numeric(height)
  
  if (is.na(dbh) || is.na(height)) {
    return(list(error = "Nieprawidłowe parametry wejściowe"))
  }
  
  volume <- switch(method,
    "huber" = calculate_volume_huber(dbh, height),
    "smalian" = calculate_volume_smalian(dbh, height),
    calculate_volume_huber(dbh, height)
  )
  
  list(
    dbh_cm = dbh,
    height_m = height,
    volume_m3 = round(volume, 4),
    method = method,
    calculated_at = Sys.time()
  )
}

#* Analiza parametrów drzewostanu
#* @post /analyze/forest-stand
#* @param data Data frame z danymi drzew (json)
function(req) {
  # Parsowanie danych JSON z body
  body <- jsonlite::fromJSON(rawToChar(req$postBody))
  
  if (is.null(body$trees)) {
    return(list(error = "Brak danych o drzewach"))
  }
  
  trees <- body$trees
  
  # Podstawowe statystyki
  total_trees <- nrow(trees)
  total_volume <- sum(sapply(1:total_trees, function(i) {
    calculate_volume_huber(trees$diameter_breast_height[i], trees$height[i])
  }))
  
  # Analiza struktury pionowej
  vertical_structure <- analyze_vertical_structure(trees$height)
  
  # Statystyki gatunkowe
  species_stats <- trees %>%
    group_by(species) %>%
    summarise(
      count = n(),
      avg_dbh = round(mean(diameter_breast_height, na.rm = TRUE), 1),
      avg_height = round(mean(height, na.rm = TRUE), 1),
      .groups = 'drop'
    )
  
  list(
    summary = list(
      total_trees = total_trees,
      total_volume_m3 = round(total_volume, 2),
      average_dbh_cm = round(mean(trees$diameter_breast_height, na.rm = TRUE), 1),
      average_height_m = round(mean(trees$height, na.rm = TRUE), 1),
      dbh_std_dev = round(sd(trees$diameter_breast_height, na.rm = TRUE), 1),
      height_std_dev = round(sd(trees$height, na.rm = TRUE), 1)
    ),
    vertical_structure = vertical_structure,
    species_composition = species_stats,
    calculated_at = Sys.time()
  )
}

#* Predykcja wysokości na podstawie pierśnicy
#* @post /predict/height
#* @param dbh:numeric Pierśnica w cm
#* @param species:character Gatunek drzewa
function(dbh, species = "Pinus sylvestris") {
  dbh <- as.numeric(dbh)
  
  if (is.na(dbh)) {
    return(list(error = "Nieprawidłowa wartość pierśnicy"))
  }
  
  predicted_height <- height_diameter_model(dbh, species)
  
  list(
    dbh_cm = dbh,
    species = species,
    predicted_height_m = round(predicted_height, 1),
    model_type = "power_function",
    confidence_interval = list(
      lower = round(predicted_height * 0.9, 1),
      upper = round(predicted_height * 1.1, 1)
    ),
    calculated_at = Sys.time()
  )
}

#* Analiza rozkładu przestrzennego drzew
#* @post /analyze/spatial-distribution
#* @param data Data frame z współrzędnymi drzew
function(req) {
  body <- jsonlite::fromJSON(rawToChar(req$postBody))
  
  if (is.null(body$trees)) {
    return(list(error = "Brak danych przestrzennych"))
  }
  
  trees <- body$trees
  
  # Podstawowe statystyki przestrzenne
  x_coords <- trees$location_x
  y_coords <- trees$location_y
  
  # Obliczenie średnich odległości między drzewami
  distances <- c()
  n <- length(x_coords)
  
  if (n > 1) {
    for (i in 1:(n-1)) {
      for (j in (i+1):n) {
        dist <- sqrt((x_coords[i] - x_coords[j])^2 + (y_coords[i] - y_coords[j])^2)
        distances <- c(distances, dist)
      }
    }
  }
  
  list(
    spatial_stats = list(
      total_trees = n,
      area_extent = list(
        x_range = round(max(x_coords) - min(x_coords), 1),
        y_range = round(max(y_coords) - min(y_coords), 1)
      ),
      center_point = list(
        x = round(mean(x_coords), 1),
        y = round(mean(y_coords), 1)
      ),
      average_distance_m = if(length(distances) > 0) round(mean(distances), 1) else 0,
      distance_std_dev = if(length(distances) > 0) round(sd(distances), 1) else 0,
      distribution_pattern = if(length(distances) > 0) {
        cv <- sd(distances) / mean(distances)
        if (cv < 0.5) "regular" else if (cv > 1.0) "clustered" else "random"
      } else "unknown"
    ),
    calculated_at = Sys.time()
  )
}

#* Modelowanie wzrostu drzewostanu
#* @post /model/growth
#* @param data Dane drzew z wiekiem
#* @param years_ahead:numeric Liczba lat prognozy
function(req, years_ahead = 10) {
  body <- jsonlite::fromJSON(rawToChar(req$postBody))
  years_ahead <- as.numeric(years_ahead)
  
  if (is.null(body$trees)) {
    return(list(error = "Brak danych o drzewach"))
  }
  
  trees <- body$trees
  
  # Proste modele wzrostu dla różnych gatunków
  growth_rates <- list(
    "Pinus sylvestris" = list(dbh_increment = 0.3, height_increment = 0.25),
    "Picea abies" = list(dbh_increment = 0.35, height_increment = 0.28),
    "Quercus robur" = list(dbh_increment = 0.25, height_increment = 0.20),
    "Betula pendula" = list(dbh_increment = 0.4, height_increment = 0.30)
  )
  
  projections <- lapply(1:nrow(trees), function(i) {
    tree <- trees[i, ]
    species <- tree$species
    
    # Użyj domyślnych wartości jeśli gatunek nie znaleziony
    rates <- growth_rates[[species]]
    if (is.null(rates)) rates <- growth_rates[["Pinus sylvestris"]]
    
    # Oblicz przyszłe parametry
    future_dbh <- tree$diameter_breast_height + (rates$dbh_increment * years_ahead)
    future_height <- tree$height + (rates$height_increment * years_ahead)
    future_volume <- calculate_volume_huber(future_dbh, future_height)
    
    list(
      tree_id = tree$id,
      current = list(
        dbh_cm = tree$diameter_breast_height,
        height_m = tree$height,
        volume_m3 = round(calculate_volume_huber(tree$diameter_breast_height, tree$height), 4)
      ),
      projected = list(
        dbh_cm = round(future_dbh, 1),
        height_m = round(future_height, 1),
        volume_m3 = round(future_volume, 4)
      ),
      growth = list(
        dbh_increment_cm = round(rates$dbh_increment * years_ahead, 1),
        height_increment_m = round(rates$height_increment * years_ahead, 1),
        volume_increment_m3 = round(future_volume - calculate_volume_huber(tree$diameter_breast_height, tree$height), 4)
      )
    )
  })
  
  list(
    projection_years = years_ahead,
    total_trees = nrow(trees),
    tree_projections = projections,
    calculated_at = Sys.time()
  )
}

#* Komunikacja z backendem Python
#* @get /python-backend/status
function() {
  tryCatch({
    response <- httr::GET("http://localhost:8000/health")
    if (httr::status_code(response) == 200) {
      list(
        python_backend = "connected",
        status = jsonlite::fromJSON(httr::content(response, "text"))
      )
    } else {
      list(python_backend = "error", status = "HTTP error")
    }
  }, error = function(e) {
    list(python_backend = "disconnected", status = "Backend Python niedostępny")
  })
}
