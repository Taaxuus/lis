"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import "ol/ol.css";
import Map from "ol/Map";
import View from "ol/View";
import TileLayer from "ol/layer/Tile";
import VectorLayer from "ol/layer/Vector";
import VectorSource from "ol/source/Vector";
import OSM from "ol/source/OSM";
import XYZ from "ol/source/XYZ";
import Feature from "ol/Feature";
import Point from "ol/geom/Point";
import Polygon from "ol/geom/Polygon";
import LineString from "ol/geom/LineString";
import Circle from "ol/geom/Circle";
import { Style, Fill, Stroke, Circle as CircleStyle, Text } from "ol/style";
import { fromLonLat, toLonLat } from "ol/proj";
import { Draw } from "ol/interaction";
import { Coordinate } from "ol/coordinate";

interface TreePoint {
	id: number;
	coordinates: Coordinate;
	species: string;
	diameter: number;
	height: number;
}

export default function MapaPage() {
	const mapRef = useRef<HTMLDivElement>(null);
	const mapInstanceRef = useRef<Map | null>(null);
	const vectorSourceRef = useRef<VectorSource>(new VectorSource());
	const [selectedLayer, setSelectedLayer] = useState<string>("osm");
	const [drawType, setDrawType] = useState<string>("Point");
	const [trees, setTrees] = useState<TreePoint[]>([]);
	const [selectedFeature, setSelectedFeature] = useState<Feature | null>(null);
	const [measurements, setMeasurements] = useState<string[]>([]);

	useEffect(() => {
		console.log("🗺️ Inicjalizacja mapy...");
		if (!mapRef.current || mapInstanceRef.current) {
			console.log("⚠️ Mapa już istnieje lub brak ref");
			return;
		}

		console.log("📦 Tworzenie warstw...");
		// Warstwy bazowe
		const osmLayer = new TileLayer({
			source: new OSM(),
		});

		const satelliteLayer = new TileLayer({
			source: new XYZ({
				url: "https://mt{0-3}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}",
				crossOrigin: "anonymous",
			}),
		});

		const topoLayer = new TileLayer({
			source: new XYZ({
				url: "https://{a-c}.tile.opentopomap.org/{z}/{x}/{y}.png",
				crossOrigin: "anonymous",
			}),
		});

		console.log("🎨 Tworzenie warstwy wektorowej...");
		// Warstwa wektorowa dla drzew i pomiarów
		const vectorLayer = new VectorLayer({
			source: vectorSourceRef.current,
			style: (feature) => {
				const type = feature.get("type");
				switch (type) {
					case "tree":
						return new Style({
							image: new CircleStyle({
								radius: 8,
								fill: new Fill({ color: "#22c55e" }),
								stroke: new Stroke({ color: "#16a34a", width: 2 }),
							}),
							text: new Text({
								text: feature.get("species") || "Drzewo",
								offsetY: -20,
								fill: new Fill({ color: "#000" }),
								stroke: new Stroke({ color: "#fff", width: 2 }),
								font: "12px Arial",
							}),
						});
					case "forest-area":
						return new Style({
							fill: new Fill({ color: "rgba(34, 197, 94, 0.2)" }),
							stroke: new Stroke({ color: "#16a34a", width: 2 }),
							text: new Text({
								text: "Obszar leśny",
								fill: new Fill({ color: "#16a34a" }),
								font: "bold 14px Arial",
							}),
						});
					case "measurement":
						return new Style({
							stroke: new Stroke({ color: "#dc2626", width: 3 }),
							fill: new Fill({ color: "rgba(239, 68, 68, 0.1)" }),
							text: new Text({
								text: feature.get("measurement") || "",
								fill: new Fill({ color: "#dc2626" }),
								stroke: new Stroke({ color: "#fff", width: 2 }),
								font: "12px Arial",
							}),
						});
					default:
						return new Style({
							image: new CircleStyle({
								radius: 6,
								fill: new Fill({ color: "#3b82f6" }),
								stroke: new Stroke({ color: "#1d4ed8", width: 2 }),
							}),
						});
				}
			},
		});

		// Inicjalizacja mapy
		console.log("🗺️ Tworzenie mapy...");
		const map = new Map({
			target: mapRef.current,
			layers: [osmLayer, vectorLayer],
			view: new View({
				center: fromLonLat([19.9449, 50.0647]), // Kraków
				zoom: 15,
			}),
		});

		console.log("✅ Mapa utworzona:", map);
		mapInstanceRef.current = map;

		// Dodaj przykładowe drzewa
		addSampleTrees();

		// Dodaj obszar leśny
		addForestArea();

		// Obsługa kliknięć
		map.on("click", (evt) => {
			const feature = map.forEachFeatureAtPixel(
				evt.pixel,
				(feature) => feature
			);
			if (feature && feature instanceof Feature) {
				setSelectedFeature(feature);
				console.log("Wybrano obiekt:", feature.getProperties());
			}
		});

		return () => {
			map.setTarget(undefined);
		};
	}, []);

	const addSampleTrees = () => {
		const sampleTrees = [
			{
				lon: 19.9449,
				lat: 50.0647,
				species: "Sosna",
				diameter: 35,
				height: 25,
			},
			{
				lon: 19.9459,
				lat: 50.0657,
				species: "Świerk",
				diameter: 42,
				height: 30,
			},
			{
				lon: 19.9439,
				lat: 50.0637,
				species: "Brzoza",
				diameter: 28,
				height: 20,
			},
			{ lon: 19.9469, lat: 50.0667, species: "Dąb", diameter: 55, height: 28 },
			{
				lon: 19.9429,
				lat: 50.0627,
				species: "Modrzew",
				diameter: 38,
				height: 26,
			},
		];

		sampleTrees.forEach((tree, index) => {
			const feature = new Feature({
				geometry: new Point(fromLonLat([tree.lon, tree.lat])),
				type: "tree",
				species: tree.species,
				diameter: tree.diameter,
				height: tree.height,
				id: index + 1,
			});
			vectorSourceRef.current?.addFeature(feature);
		});

		setTrees(
			sampleTrees.map((tree, index) => ({
				id: index + 1,
				coordinates: fromLonLat([tree.lon, tree.lat]),
				species: tree.species,
				diameter: tree.diameter,
				height: tree.height,
			}))
		);
	};

	const addForestArea = () => {
		const forestCoords = [
			[19.942, 50.062],
			[19.948, 50.062],
			[19.948, 50.068],
			[19.942, 50.068],
			[19.942, 50.062],
		].map((coord) => fromLonLat(coord));

		const forestFeature = new Feature({
			geometry: new Polygon([forestCoords]),
			type: "forest-area",
			name: "Przykładowy obszar leśny",
			area: "2.5 ha",
		});

		vectorSourceRef.current?.addFeature(forestFeature);
	};

	const changeBaseLayer = (layerType: string) => {
		if (!mapInstanceRef.current) return;

		const layers = mapInstanceRef.current.getLayers();
		layers.removeAt(0); // Usuń pierwszą warstwę (bazową)

		let newLayer;
		switch (layerType) {
			case "satellite":
				newLayer = new TileLayer({
					source: new XYZ({
						url: "https://mt{0-3}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}",
						crossOrigin: "anonymous",
					}),
				});
				break;
			case "topo":
				newLayer = new TileLayer({
					source: new XYZ({
						url: "https://{a-c}.tile.opentopomap.org/{z}/{x}/{y}.png",
						crossOrigin: "anonymous",
					}),
				});
				break;
			default:
				newLayer = new TileLayer({
					source: new OSM(),
				});
		}

		layers.insertAt(0, newLayer);
		setSelectedLayer(layerType);
	};

	const enableDrawing = (type: string) => {
		if (!mapInstanceRef.current) return;

		// Usuń poprzednie interakcje rysowania
		mapInstanceRef.current
			.getInteractions()
			.getArray()
			.forEach((interaction) => {
				if (interaction instanceof Draw) {
					mapInstanceRef.current?.removeInteraction(interaction);
				}
			});

		let geometryType: "Point" | "LineString" | "Polygon" | "Circle" = "Point";
		switch (type) {
			case "LineString":
				geometryType = "LineString";
				break;
			case "Polygon":
				geometryType = "Polygon";
				break;
			case "Circle":
				geometryType = "Circle";
				break;
			default:
				geometryType = "Point";
		}

		const draw = new Draw({
			source: vectorSourceRef.current!,
			type: geometryType,
		});

		draw.on("drawend", (event) => {
			const feature = event.feature;
			feature.set("type", "measurement");

			if (type === "LineString") {
				const geometry = feature.getGeometry() as LineString;
				const length = geometry.getLength();
				const lengthKm = (length / 1000).toFixed(2);
				feature.set("measurement", `${lengthKm} km`);
				setMeasurements((prev) => [...prev, `Linia: ${lengthKm} km`]);
			} else if (type === "Polygon") {
				const geometry = feature.getGeometry() as Polygon;
				const area = geometry.getArea();
				const areaHa = (area / 10000).toFixed(2);
				feature.set("measurement", `${areaHa} ha`);
				setMeasurements((prev) => [...prev, `Obszar: ${areaHa} ha`]);
			} else if (type === "Circle") {
				const geometry = feature.getGeometry() as Circle;
				const radius = geometry.getRadius();
				const radiusM = radius.toFixed(1);
				feature.set("measurement", `R: ${radiusM} m`);
				setMeasurements((prev) => [...prev, `Okrąg: promień ${radiusM} m`]);
			}
		});

		mapInstanceRef.current.addInteraction(draw);
		setDrawType(type);
	};

	const clearMeasurements = () => {
		vectorSourceRef.current
			?.getFeatures()
			.filter((feature) => feature.get("type") === "measurement")
			.forEach((feature) => vectorSourceRef.current?.removeFeature(feature));
		setMeasurements([]);
	};

	const exportData = () => {
		const data = {
			trees: trees,
			measurements: measurements,
			center: mapInstanceRef.current?.getView().getCenter(),
			zoom: mapInstanceRef.current?.getView().getZoom(),
		};

		const dataStr = JSON.stringify(data, null, 2);
		const dataBlob = new Blob([dataStr], { type: "application/json" });
		const url = URL.createObjectURL(dataBlob);
		const link = document.createElement("a");
		link.href = url;
		link.download = "mapa_danych_lesnych.json";
		link.click();
	};

	return (
		<div className="min-h-screen bg-gray-50">
			{/* Header */}
			<div className="bg-white shadow-sm border-b">
				<div className="max-w-7xl mx-auto px-4 py-4">
					<div className="flex items-center justify-between">
						<div className="flex items-center space-x-4">
							<Link
								href="/"
								className="flex items-center text-green-600 hover:text-green-700 transition-colors">
								<svg
									className="w-5 h-5 mr-2"
									fill="none"
									stroke="currentColor"
									viewBox="0 0 24 24">
									<path
										strokeLinecap="round"
										strokeLinejoin="round"
										strokeWidth={2}
										d="M10 19l-7-7m0 0l7-7m-7 7h18"
									/>
								</svg>
								Powrót do głównej
							</Link>
							<h1 className="text-2xl font-bold text-gray-800">
								Mapa Interaktywna
							</h1>
						</div>
						<div className="text-sm text-gray-600">webLIS - Moduł mapowy</div>
					</div>
				</div>
			</div>

			<div className="flex h-[calc(100vh-80px)]">
				{/* Panel boczny */}
				<div className="w-80 bg-white shadow-lg p-4 overflow-y-auto">
					<div className="space-y-6">
						{/* Warstwy bazowe */}
						<div>
							<h3 className="text-lg font-semibold mb-3 text-gray-800">
								Warstwy bazowe
							</h3>
							<div className="space-y-2">
								{[
									{ id: "osm", name: "OpenStreetMap", icon: "🗺️" },
									{ id: "satellite", name: "Zdjęcia satelitarne", icon: "🛰️" },
									{ id: "topo", name: "Mapa topograficzna", icon: "🏔️" },
								].map((layer) => (
									<button
										key={layer.id}
										onClick={() => changeBaseLayer(layer.id)}
										className={`w-full p-3 text-left rounded-lg border transition-all ${
											selectedLayer === layer.id
												? "border-green-500 bg-green-50 text-green-700"
												: "border-gray-200 hover:border-gray-300 text-gray-700"
										}`}>
										<span className="mr-2">{layer.icon}</span>
										{layer.name}
									</button>
								))}
							</div>
						</div>

						{/* Narzędzia rysowania */}
						<div>
							<h3 className="text-lg font-semibold mb-3 text-gray-800">
								Narzędzia pomiarowe
							</h3>
							<div className="space-y-2">
								{[
									{ id: "Point", name: "Punkt", icon: "📍" },
									{
										id: "LineString",
										name: "Linia (pomiar długości)",
										icon: "📏",
									},
									{
										id: "Polygon",
										name: "Obszar (pomiar powierzchni)",
										icon: "📐",
									},
									{ id: "Circle", name: "Okrąg", icon: "⭕" },
								].map((tool) => (
									<button
										key={tool.id}
										onClick={() => enableDrawing(tool.id)}
										className={`w-full p-3 text-left rounded-lg border transition-all ${
											drawType === tool.id
												? "border-blue-500 bg-blue-50 text-blue-700"
												: "border-gray-200 hover:border-gray-300 text-gray-700"
										}`}>
										<span className="mr-2">{tool.icon}</span>
										{tool.name}
									</button>
								))}
							</div>
							<button
								onClick={clearMeasurements}
								className="w-full mt-3 p-2 bg-red-100 text-red-700 rounded-lg hover:bg-red-200 transition-colors">
								🗑️ Wyczyść pomiary
							</button>
						</div>

						{/* Wyniki pomiarów */}
						{measurements.length > 0 && (
							<div>
								<h3 className="text-lg font-semibold mb-3 text-gray-800">
									Wyniki pomiarów
								</h3>
								<div className="space-y-2">
									{measurements.map((measurement, index) => (
										<div
											key={index}
											className="p-3 bg-gray-50 rounded-lg text-sm">
											{measurement}
										</div>
									))}
								</div>
							</div>
						)}

						{/* Lista drzew */}
						<div>
							<h3 className="text-lg font-semibold mb-3 text-gray-800">
								Drzewa na mapie ({trees.length})
							</h3>
							<div className="space-y-2 max-h-60 overflow-y-auto">
								{trees.map((tree) => (
									<div
										key={tree.id}
										className="p-3 bg-gray-50 rounded-lg text-sm border-l-4 border-green-500">
										<div className="font-medium text-gray-800">
											{tree.species} #{tree.id}
										</div>
										<div className="text-gray-600 mt-1">
											Pierśnica: {tree.diameter} cm
										</div>
										<div className="text-gray-600">
											Wysokość: {tree.height} m
										</div>
									</div>
								))}
							</div>
						</div>

						{/* Informacje o wybranym obiekcie */}
						{selectedFeature && (
							<div>
								<h3 className="text-lg font-semibold mb-3 text-gray-800">
									Wybrany obiekt
								</h3>
								<div className="p-4 bg-blue-50 rounded-lg border border-blue-200">
									<div className="space-y-2 text-sm">
										{Object.entries(selectedFeature.getProperties())
											.filter(([key]) => key !== "geometry")
											.map(([key, value]) => (
												<div key={key} className="flex justify-between">
													<span className="font-medium text-gray-700 capitalize">
														{key}:
													</span>
													<span className="text-gray-900">{String(value)}</span>
												</div>
											))}
									</div>
								</div>
							</div>
						)}

						{/* Eksport danych */}
						<div>
							<button
								onClick={exportData}
								className="w-full p-3 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors">
								💾 Eksportuj dane mapy
							</button>
						</div>
					</div>
				</div>

				{/* Mapa */}
				<div className="flex-1 relative">
					<div
						ref={mapRef}
						className="w-full h-full"
						style={{
							minHeight: "600px",
							position: "relative",
							background: "#f0f0f0",
						}}
					/>

					{/* Kontrolki na mapie */}
					<div className="absolute top-4 right-4 bg-white rounded-lg shadow-lg p-3">
						<div className="text-sm text-gray-600 mb-2">
							Współrzędne środka:
						</div>
						<div className="text-xs font-mono text-gray-800">
							{mapInstanceRef.current &&
								toLonLat(mapInstanceRef.current.getView().getCenter() || [0, 0])
									.map((coord) => coord.toFixed(6))
									.join(", ")}
						</div>
					</div>

					{/* Legenda */}
					<div className="absolute bottom-4 right-4 bg-white rounded-lg shadow-lg p-4">
						<h4 className="font-semibold text-gray-800 mb-2">Legenda</h4>
						<div className="space-y-1 text-sm">
							<div className="flex items-center">
								<div className="w-4 h-4 bg-green-500 rounded-full mr-2"></div>
								Drzewa
							</div>
							<div className="flex items-center">
								<div className="w-4 h-4 bg-green-200 border-2 border-green-600 mr-2"></div>
								Obszary leśne
							</div>
							<div className="flex items-center">
								<div className="w-4 h-1 bg-red-600 mr-2"></div>
								Pomiary
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	);
}
