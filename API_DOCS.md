# webLIS - Dokumentacja API

## Architektura systemu

webLIS składa się z trzech głównych komponentów:

1. **Frontend (Next.js)** - port 3000
2. **Backend Python (FastAPI)** - port 8000
3. **Backend R (Plumber)** - port 8001

## Backend Python (FastAPI) - Port 8000

### Podstawowe endpointy

#### `GET /`

Status aplikacji

```json
{
	"message": "webLIS Backend Python - FastAPI",
	"version": "1.0.0",
	"description": "API do obliczeń parametrów drzew i drzewostanów"
}
```

#### `GET /health`

Sprawdzenie zdrowia systemu

```json
{
	"status": "healthy",
	"timestamp": "2024-01-01T12:00:00"
}
```

### Zarządzanie drzewami

#### `GET /trees`

Pobierz wszystkie dane drzew

```json
[
	{
		"id": 1,
		"diameter_breast_height": 25.5,
		"height": 18.2,
		"species": "Sosna zwyczajna",
		"age": 45,
		"location_x": 100.5,
		"location_y": 200.3
	}
]
```

#### `GET /trees/{tree_id}`

Pobierz dane konkretnego drzewa

#### `POST /trees/volume`

Oblicz miąższość drzewa

```json
{
	"tree_id": 1,
	"volume_m3": 0.0924,
	"diameter_cm": 25.5,
	"height_m": 18.2,
	"species": "Sosna zwyczajna"
}
```

### Analiza drzewostanów

#### `GET /forest-stands/{stand_id}`

Pobierz dane drzewostanu

#### `POST /forest-stands/analysis`

Analiza parametrów drzewostanu

```json
{
	"stand_id": 1,
	"area_ha": 2.5,
	"total_trees": 4,
	"trees_per_ha": 1.6,
	"total_volume_m3": 0.35,
	"volume_per_ha": 0.14,
	"average_height_m": 19.4,
	"average_diameter_cm": 27.15,
	"species_composition": {
		"Sosna zwyczajna": 1,
		"Świerk pospolity": 1,
		"Dąb szypułkowy": 1,
		"Brzoza brodawkowata": 1
	}
}
```

### Dane teledetekcyjne

#### `GET /telemetry`

Pobierz wszystkie dane teledetekcyjne

#### `GET /telemetry/lidar`

Pobierz dane z skanowania laserowego

#### `GET /telemetry/spectral`

Pobierz dane ze zobrazowań spektralnych

#### `POST /telemetry/process`

Symulacja przetwarzania danych teledetekcyjnych

```json
{
	"data_type": "lidar",
	"processed_area_km2": 15.5,
	"processing_time_s": 7.75,
	"detected_trees": 3875,
	"accuracy": 0.89,
	"status": "completed"
}
```

## Backend R (Plumber) - Port 8001

### Podstawowe endpointy

#### `GET /status`

Status aplikacji R

```json
{
	"message": "webLIS Backend R - Plumber",
	"version": "1.0.0",
	"description": "API do obliczeń dendrometrycznych i statystycznych",
	"status": "active",
	"timestamp": "2024-01-01T12:00:00"
}
```

#### `GET /health`

Sprawdzenie zdrowia systemu R

```json
{
	"status": "healthy",
	"r_version": "R version 4.3.0",
	"packages": ["plumber", "dplyr", "jsonlite"],
	"memory_usage": 45.2,
	"timestamp": "2024-01-01T12:00:00"
}
```

### Obliczenia dendrometryczne

#### `POST /calculate/volume`

Obliczenia miąższości dla pojedynczego drzewa

```
Parametry:
- dbh: numeric (pierśnica w cm)
- height: numeric (wysokość w metrach)
- method: character (huber/smalian)
```

```json
{
	"dbh_cm": 25.5,
	"height_m": 18.2,
	"volume_m3": 0.0924,
	"method": "huber",
	"calculated_at": "2024-01-01T12:00:00"
}
```

#### `POST /predict/height`

Predykcja wysokości na podstawie pierśnicy

```
Parametry:
- dbh: numeric (pierśnica w cm)
- species: character (gatunek drzewa)
```

```json
{
	"dbh_cm": 25.5,
	"species": "Pinus sylvestris",
	"predicted_height_m": 17.8,
	"model_type": "power_function",
	"confidence_interval": {
		"lower": 16.0,
		"upper": 19.6
	},
	"calculated_at": "2024-01-01T12:00:00"
}
```

### Analiza drzewostanów

#### `POST /analyze/forest-stand`

Kompleksowa analiza parametrów drzewostanu

```json
{
	"summary": {
		"total_trees": 4,
		"total_volume_m3": 0.35,
		"average_dbh_cm": 27.2,
		"average_height_m": 19.4,
		"dbh_std_dev": 4.1,
		"height_std_dev": 2.4
	},
	"vertical_structure": {
		"upper_layer_pct": 25.0,
		"middle_layer_pct": 50.0,
		"lower_layer_pct": 25.0,
		"height_diversity_index": 0.124
	},
	"species_composition": [
		{
			"species": "Sosna zwyczajna",
			"count": 1,
			"avg_dbh": 25.5,
			"avg_height": 18.2
		}
	],
	"calculated_at": "2024-01-01T12:00:00"
}
```

#### `POST /analyze/spatial-distribution`

Analiza rozkładu przestrzennego drzew

```json
{
	"spatial_stats": {
		"total_trees": 4,
		"area_extent": {
			"x_range": 7.4,
			"y_range": 6.8
		},
		"center_point": {
			"x": 101.7,
			"y": 202.2
		},
		"average_distance_m": 4.8,
		"distance_std_dev": 2.1,
		"distribution_pattern": "random"
	},
	"calculated_at": "2024-01-01T12:00:00"
}
```

### Modelowanie wzrostu

#### `POST /model/growth`

Modelowanie wzrostu drzewostanu

```
Parametry:
- data: Data frame z danymi drzew
- years_ahead: numeric (liczba lat prognozy, domyślnie 10)
```

```json
{
	"projection_years": 10,
	"total_trees": 4,
	"tree_projections": [
		{
			"tree_id": 1,
			"current": {
				"dbh_cm": 25.5,
				"height_m": 18.2,
				"volume_m3": 0.0924
			},
			"projected": {
				"dbh_cm": 28.5,
				"height_m": 20.7,
				"volume_m3": 0.1295
			},
			"growth": {
				"dbh_increment_cm": 3.0,
				"height_increment_m": 2.5,
				"volume_increment_m3": 0.0371
			}
		}
	],
	"calculated_at": "2024-01-01T12:00:00"
}
```

## Frontend (Next.js) - Port 3000

### Funkcjonalności

1. **Dashboard główny**

   - Status backendów w czasie rzeczywistym
   - Monitoring połączeń API

2. **Panel testowy**

   - Ładowanie danych testowych
   - Uruchamianie analiz
   - Wyświetlanie wyników

3. **Interfejs użytkownika**
   - Responsywny design
   - Tabele danych
   - Wizualizacja wyników

### Komunikacja z backendami

Frontend komunikuje się z oboma backendami:

- **Python API**: podstawowe operacje, zarządzanie danymi
- **R API**: zaawansowane obliczenia, analizy statystyczne

### Obsługa błędów

- Graceful handling połączeń sieciowych
- Wyświetlanie statusu backendów
- Informacje o błędach w interfejsie

## Przykłady użycia

### 1. Podstawowa analiza drzewa

```javascript
// Frontend -> Python Backend
const response = await fetch("http://localhost:8000/trees/volume", {
	method: "POST",
	headers: { "Content-Type": "application/json" },
	body: JSON.stringify({
		id: 1,
		diameter_breast_height: 25.5,
		height: 18.2,
		species: "Sosna zwyczajna",
	}),
});
```

### 2. Zaawansowana analiza R

```javascript
// Frontend -> R Backend
const response = await fetch("http://localhost:8001/analyze/forest-stand", {
	method: "POST",
	headers: { "Content-Type": "application/json" },
	body: JSON.stringify({ trees: treeData }),
});
```

### 3. Kombinowane analizy

Frontend może łączyć wyniki z obu backendów dla kompleksowych analiz wykorzystujących mocne strony każdego środowiska.
