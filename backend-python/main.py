# Backend Python - FastAPI dla webLIS
# Aplikacja do obliczeń parametrów drzew i drzewostanów

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import math
import random
from datetime import datetime

app = FastAPI(
    title="webLIS - Backend Python",
    description="API do obliczeń parametrów drzew i drzewostanów",
    version="1.0.0"
)

# CORS dla komunikacji z frontendem
app.add_middleware(
    CORSMiddleware,
    # Next.js frontend na różnych portach
    allow_origins=["http://localhost:3000", "http://localhost:3001"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Modele danych


class TreeData(BaseModel):
    id: int
    diameter_breast_height: float  # Pierśnica (cm)
    height: float  # Wysokość (m)
    species: str  # Gatunek
    age: Optional[int] = None  # Wiek (lata)
    location_x: float  # Współrzędne X
    location_y: float  # Współrzędne Y


class ForestStandData(BaseModel):
    stand_id: int
    area: float  # Powierzchnia (ha)
    trees: List[TreeData]
    site_index: Optional[float] = None  # Bonitacja


class TelemetryData(BaseModel):
    data_type: str  # "lidar" lub "spectral"
    timestamp: datetime
    coverage_area: float  # km2
    resolution: float  # m/pixel lub points/m2
    file_path: str


# Przykładowe dane testowe
test_trees = [
    TreeData(id=1, diameter_breast_height=25.5, height=18.2,
             species="Sosna zwyczajna", age=45, location_x=100.5, location_y=200.3),
    TreeData(id=2, diameter_breast_height=32.1, height=22.5,
             species="Świerk pospolity", age=52, location_x=105.2, location_y=198.7),
    TreeData(id=3, diameter_breast_height=28.7, height=20.1,
             species="Dąb szypułkowy", age=65, location_x=98.3, location_y=205.1),
    TreeData(id=4, diameter_breast_height=22.3, height=16.8,
             species="Brzoza brodawkowata", age=35, location_x=102.7, location_y=202.5),
]

test_forest_stand = ForestStandData(
    stand_id=1,
    area=2.5,
    trees=test_trees,
    site_index=3.2
)

test_telemetry = [
    TelemetryData(
        data_type="lidar",
        timestamp=datetime.now(),
        coverage_area=15.5,
        resolution=4.0,  # points/m2
        file_path="/data/lidar/scan_2024_01.las"
    ),
    TelemetryData(
        data_type="spectral",
        timestamp=datetime.now(),
        coverage_area=25.0,
        resolution=0.5,  # m/pixel
        file_path="/data/spectral/image_2024_01.tif"
    )
]


@app.get("/")
async def root():
    return {
        "message": "webLIS Backend Python - FastAPI",
        "version": "1.0.0",
        "description": "API do obliczeń parametrów drzew i drzewostanów"
    }


@app.get("/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.now()}

# Endpointy dla danych drzew


@app.get("/trees", response_model=List[TreeData])
async def get_trees():
    """Pobierz wszystkie dane drzew"""
    return test_trees


@app.get("/trees/{tree_id}", response_model=TreeData)
async def get_tree(tree_id: int):
    """Pobierz dane konkretnego drzewa"""
    tree = next((t for t in test_trees if t.id == tree_id), None)
    if not tree:
        raise HTTPException(status_code=404, detail="Drzewo nie znalezione")
    return tree


@app.post("/trees/volume")
async def calculate_tree_volume(tree: TreeData):
    """Oblicz miąższość drzewa na podstawie pierśnicy i wysokości"""
    # Wzór Hubera: V = π * (d/200)² * h * f
    # gdzie f to współczynnik kształtu (przyjęty 0.5)
    diameter_m = tree.diameter_breast_height / 100
    volume = math.pi * (diameter_m / 2) ** 2 * tree.height * 0.5

    return {
        "tree_id": tree.id,
        "volume_m3": round(volume, 4),
        "diameter_cm": tree.diameter_breast_height,
        "height_m": tree.height,
        "species": tree.species
    }

# Endpointy dla drzewostanów


@app.get("/forest-stands/{stand_id}")
async def get_forest_stand(stand_id: int):
    """Pobierz dane drzewostanu"""
    if stand_id != 1:
        raise HTTPException(
            status_code=404, detail="Drzewostan nie znaleziony")
    return test_forest_stand


@app.post("/forest-stands/analysis")
async def analyze_forest_stand(stand: ForestStandData):
    """Analiza parametrów drzewostanu"""
    total_trees = len(stand.trees)
    total_volume = 0
    species_count = {}
    heights = []
    diameters = []

    for tree in stand.trees:
        # Oblicz miąższość każdego drzewa
        diameter_m = tree.diameter_breast_height / 100
        volume = math.pi * (diameter_m / 2) ** 2 * tree.height * 0.5
        total_volume += volume

        # Zlicz gatunki
        species_count[tree.species] = species_count.get(tree.species, 0) + 1

        heights.append(tree.height)
        diameters.append(tree.diameter_breast_height)

    avg_height = sum(heights) / len(heights) if heights else 0
    avg_diameter = sum(diameters) / len(diameters) if diameters else 0

    return {
        "stand_id": stand.stand_id,
        "area_ha": stand.area,
        "total_trees": total_trees,
        "trees_per_ha": round(total_trees / stand.area, 1),
        "total_volume_m3": round(total_volume, 2),
        "volume_per_ha": round(total_volume / stand.area, 2),
        "average_height_m": round(avg_height, 1),
        "average_diameter_cm": round(avg_diameter, 1),
        "species_composition": species_count,
        "site_index": stand.site_index
    }

# Endpointy dla danych teledetekcyjnych


@app.get("/telemetry")
async def get_telemetry_data():
    """Pobierz dane teledetekcyjne"""
    return test_telemetry


@app.get("/telemetry/lidar")
async def get_lidar_data():
    """Pobierz dane z skanowania laserowego"""
    lidar_data = [t for t in test_telemetry if t.data_type == "lidar"]
    return lidar_data


@app.get("/telemetry/spectral")
async def get_spectral_data():
    """Pobierz dane ze zobrazowań spektralnych"""
    spectral_data = [t for t in test_telemetry if t.data_type == "spectral"]
    return spectral_data


@app.post("/telemetry/process")
async def process_telemetry_data(data_type: str, area: float):
    """Symulacja przetwarzania danych teledetekcyjnych"""
    if data_type not in ["lidar", "spectral"]:
        raise HTTPException(status_code=400, detail="Nieprawidłowy typ danych")

    # Symulacja obliczeń
    processing_time = area * 0.5  # sekundy
    detected_trees = int(area * random.uniform(150, 300))  # drzewa/ha

    return {
        "data_type": data_type,
        "processed_area_km2": area,
        "processing_time_s": processing_time,
        "detected_trees": detected_trees,
        "accuracy": random.uniform(0.85, 0.95),
        "status": "completed"
    }

# Endpoint do komunikacji z backendem R


@app.get("/r-backend/status")
async def check_r_backend():
    """Sprawdź status backendu R"""
    try:
        import requests
        response = requests.get("http://localhost:8001/status", timeout=5)
        return {"r_backend": "connected", "status": response.json()}
    except:
        return {"r_backend": "disconnected", "status": "Backend R niedostępny"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
