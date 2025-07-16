"use client";

import { useState, useEffect } from "react";

interface BackendStatus {
	python: { status: string; message?: string };
	r: { status: string; message?: string };
}

interface TreeData {
	id: number;
	diameter_breast_height: number;
	height: number;
	species: string;
	age?: number;
	location_x: number;
	location_y: number;
}

interface ForestAnalysis {
	total_trees: number;
	average_height_m: number;
	average_diameter_cm: number;
	total_volume_m3: number;
	species_composition: Record<string, number>;
}

export default function Home() {
	const [backendStatus, setBackendStatus] = useState<BackendStatus>({
		python: { status: "checking..." },
		r: { status: "checking..." },
	});

	const [trees, setTrees] = useState<TreeData[]>([]);
	const [analysis, setAnalysis] = useState<ForestAnalysis | null>(null);
	const [loading, setLoading] = useState(false);

	// Sprawdź status backendów
	useEffect(() => {
		checkBackendStatus();
	}, []);

	const checkBackendStatus = async () => {
		// Sprawdź backend Python
		try {
			const pythonResponse = await fetch("http://localhost:8000/health");
			if (pythonResponse.ok) {
				setBackendStatus((prev) => ({
					...prev,
					python: { status: "connected", message: "FastAPI działa poprawnie" },
				}));
			}
		} catch (error) {
			setBackendStatus((prev) => ({
				...prev,
				python: { status: "disconnected", message: "FastAPI niedostępny" },
			}));
		}

		// Sprawdź backend R
		try {
			const rResponse = await fetch("http://localhost:8001/status");
			if (rResponse.ok) {
				setBackendStatus((prev) => ({
					...prev,
					r: { status: "connected", message: "Plumber R działa poprawnie" },
				}));
			}
		} catch (error) {
			setBackendStatus((prev) => ({
				...prev,
				r: { status: "disconnected", message: "Plumber R niedostępny" },
			}));
		}
	};

	const loadTestData = async () => {
		setLoading(true);
		console.log("🔄 Ładowanie danych testowych...");
		try {
			const response = await fetch("http://localhost:8000/trees");
			if (response.ok) {
				const data = await response.json();
				console.log("✅ Dane załadowane:", data);
				setTrees(data);
			} else {
				console.error("❌ Błąd response:", response.status);
			}
		} catch (error) {
			console.error("❌ Błąd ładowania danych:", error);
		}
		setLoading(false);
	};

	const analyzeForest = async () => {
		if (trees.length === 0) {
			alert("Najpierw załaduj dane testowe");
			return;
		}

		setLoading(true);
		console.log("🔬 Rozpoczynam analizę drzewostanu...");

		try {
			// Analiza z backendem Python
			console.log("📊 Wysyłam dane do Python backend...");
			const pythonPayload = {
				stand_id: 1,
				area: 2.5,
				trees: trees,
			};
			console.log("Python payload:", pythonPayload);

			const pythonResponse = await fetch(
				"http://localhost:8000/forest-stands/analysis",
				{
					method: "POST",
					headers: { "Content-Type": "application/json" },
					body: JSON.stringify(pythonPayload),
				}
			);

			console.log("Python response status:", pythonResponse.status);

			if (!pythonResponse.ok) {
				const errorText = await pythonResponse.text();
				console.error("❌ Python backend error:", errorText);
				alert(`Błąd Python backend: ${pythonResponse.status} - ${errorText}`);
				setLoading(false);
				return;
			}

			const pythonData = await pythonResponse.json();
			console.log("✅ Python data received:", pythonData);

			// Analiza z backendem R
			console.log("📈 Wysyłam dane do R backend...");
			const rPayload = { trees: trees };
			console.log("R payload:", rPayload);

			const rResponse = await fetch(
				"http://localhost:8001/analyze/forest-stand",
				{
					method: "POST",
					headers: { "Content-Type": "application/json" },
					body: JSON.stringify(rPayload),
				}
			);

			console.log("R response status:", rResponse.status);

			if (!rResponse.ok) {
				const errorText = await rResponse.text();
				console.error("❌ R backend error:", errorText);
				alert(`Błąd R backend: ${rResponse.status} - ${errorText}`);
				setLoading(false);
				return;
			}

			const rData = await rResponse.json();
			console.log("✅ R data received:", rData);

			// Kombinuj wyniki
			const analysisResult = {
				total_trees: pythonData.total_trees,
				average_height_m: rData.summary?.average_height_m || 0,
				average_diameter_cm: rData.summary?.average_dbh_cm || 0,
				total_volume_m3: rData.summary?.total_volume_m3 || 0,
				species_composition: pythonData.species_composition,
			};

			console.log("🎯 Final analysis result:", analysisResult);
			setAnalysis(analysisResult);
		} catch (error) {
			console.error("❌ Błąd analizy:", error);
			alert(
				`Wystąpił błąd podczas analizy: ${
					error instanceof Error ? error.message : "Nieznany błąd"
				}`
			);
		}
		setLoading(false);
	};

	return (
		<div className="min-h-screen bg-gradient-to-br from-green-50 to-green-100 p-8">
			<div className="max-w-7xl mx-auto">
				{/* Header */}
				<div className="text-center mb-12">
					<h1 className="text-5xl font-bold text-green-800 mb-4">webLIS</h1>
					<p className="text-xl text-green-600 mb-2">
						Aplikacja webowa do obliczeń parametrów drzew i drzewostanów
					</p>
					<p className="text-sm text-gray-600">
						System analityczny z wykorzystaniem danych teledetekcyjnych
					</p>
				</div>

				{/* Status backendów */}
				<div className="grid md:grid-cols-2 gap-6 mb-12">
					<div className="bg-white rounded-lg shadow-lg p-6">
						<h2 className="text-xl font-semibold mb-4 flex items-center">
							<span
								className="w-3 h-3 rounded-full mr-3"
								style={{
									backgroundColor:
										backendStatus.python.status === "connected"
											? "#10b981"
											: "#ef4444",
								}}></span>
							Backend Python (FastAPI)
						</h2>
						<p className="text-gray-600">
							Status:{" "}
							<span className="font-medium">{backendStatus.python.status}</span>
						</p>
						{backendStatus.python.message && (
							<p className="text-sm text-gray-500 mt-1">
								{backendStatus.python.message}
							</p>
						)}
						<div className="mt-4">
							<p className="text-sm text-gray-600">Funkcjonalności:</p>
							<ul className="text-xs text-gray-500 mt-1 list-disc list-inside">
								<li>Zarządzanie danymi drzew</li>
								<li>Podstawowe obliczenia miąższości</li>
								<li>Analiza drzewostanów</li>
								<li>Przetwarzanie danych teledetekcyjnych</li>
							</ul>
						</div>
					</div>

					<div className="bg-white rounded-lg shadow-lg p-6">
						<h2 className="text-xl font-semibold mb-4 flex items-center">
							<span
								className="w-3 h-3 rounded-full mr-3"
								style={{
									backgroundColor:
										backendStatus.r.status === "connected"
											? "#10b981"
											: "#ef4444",
								}}></span>
							Backend R (Plumber)
						</h2>
						<p className="text-gray-600">
							Status:{" "}
							<span className="font-medium">{backendStatus.r.status}</span>
						</p>
						{backendStatus.r.message && (
							<p className="text-sm text-gray-500 mt-1">
								{backendStatus.r.message}
							</p>
						)}
						<div className="mt-4">
							<p className="text-sm text-gray-600">Funkcjonalności:</p>
							<ul className="text-xs text-gray-500 mt-1 list-disc list-inside">
								<li>Zaawansowane obliczenia dendrometryczne</li>
								<li>Analiza struktury pionowej</li>
								<li>Modelowanie wzrostu</li>
								<li>Analiza rozkładu przestrzennego</li>
							</ul>
						</div>
					</div>
				</div>

				{/* Panel testowy */}
				<div className="bg-white rounded-lg shadow-lg p-8 mb-8">
					<h2 className="text-2xl font-semibold text-gray-800 mb-6">
						Panel testowy
					</h2>

					<div className="flex flex-wrap gap-4 mb-8">
						<button
							onClick={checkBackendStatus}
							className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors shadow-md font-medium border border-blue-700">
							🔍 Sprawdź status backendów
						</button>

						<button
							onClick={loadTestData}
							disabled={loading}
							className="px-6 py-3 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50 shadow-md font-medium border border-green-700">
							{loading ? "⏳ Ładowanie..." : "📊 Załaduj dane testowe"}
						</button>

						<button
							onClick={analyzeForest}
							disabled={loading || trees.length === 0}
							className="px-6 py-3 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors disabled:opacity-50 shadow-md font-medium border border-purple-700">
							{loading ? "⚙️ Analizowanie..." : "🔬 Analizuj drzewostan"}
						</button>
					</div>

					{/* Wyniki */}
					{trees.length > 0 && (
						<div className="mb-8">
							<h3 className="text-lg font-semibold mb-4 text-gray-800">
								Załadowane dane ({trees.length} drzew)
							</h3>
							<div className="overflow-x-auto bg-white rounded-lg border border-gray-200 shadow-sm">
								<table className="w-full text-sm">
									<thead className="bg-gray-100 border-b border-gray-200">
										<tr>
											<th className="p-4 text-left font-semibold text-gray-700">
												ID
											</th>
											<th className="p-4 text-left font-semibold text-gray-700">
												Gatunek
											</th>
											<th className="p-4 text-left font-semibold text-gray-700">
												Pierśnica (cm)
											</th>
											<th className="p-4 text-left font-semibold text-gray-700">
												Wysokość (m)
											</th>
											<th className="p-4 text-left font-semibold text-gray-700">
												Wiek
											</th>
										</tr>
									</thead>
									<tbody>
										{trees.slice(0, 5).map((tree, index) => (
											<tr
												key={tree.id}
												className={`border-b border-gray-100 ${
													index % 2 === 0 ? "bg-white" : "bg-gray-50"
												} hover:bg-blue-50 transition-colors`}>
												<td className="p-4 font-medium text-gray-900">
													{tree.id}
												</td>
												<td className="p-4 text-gray-800 font-medium">
													{tree.species}
												</td>
												<td className="p-4 text-gray-900 font-mono">
													{tree.diameter_breast_height}
												</td>
												<td className="p-4 text-gray-900 font-mono">
													{tree.height}
												</td>
												<td className="p-4 text-gray-700">
													{tree.age || "N/A"}
												</td>
											</tr>
										))}
									</tbody>
								</table>
								{trees.length > 5 && (
									<div className="p-4 bg-gray-50 border-t border-gray-200">
										<p className="text-sm text-gray-600 font-medium">
											... i {trees.length - 5} więcej drzew
										</p>
									</div>
								)}
							</div>
						</div>
					)}

					{analysis && (
						<div className="grid md:grid-cols-2 gap-6">
							<div className="bg-white p-6 rounded-lg border border-gray-200 shadow-sm">
								<h3 className="text-lg font-semibold mb-4 text-gray-800 border-b border-gray-200 pb-2">
									Wyniki analizy drzewostanu
								</h3>
								<div className="space-y-3 text-sm">
									<div className="flex justify-between items-center p-3 bg-gray-50 rounded">
										<span className="font-medium text-gray-700">
											Liczba drzew:
										</span>
										<span className="font-bold text-gray-900 text-lg">
											{analysis.total_trees}
										</span>
									</div>
									<div className="flex justify-between items-center p-3 bg-gray-50 rounded">
										<span className="font-medium text-gray-700">
											Średnia wysokość:
										</span>
										<span className="font-bold text-gray-900 text-lg">
											{analysis.average_height_m} m
										</span>
									</div>
									<div className="flex justify-between items-center p-3 bg-gray-50 rounded">
										<span className="font-medium text-gray-700">
											Średnia pierśnica:
										</span>
										<span className="font-bold text-gray-900 text-lg">
											{analysis.average_diameter_cm} cm
										</span>
									</div>
									<div className="flex justify-between items-center p-3 bg-gray-50 rounded">
										<span className="font-medium text-gray-700">
											Całkowita miąższość:
										</span>
										<span className="font-bold text-gray-900 text-lg">
											{analysis.total_volume_m3} m³
										</span>
									</div>
								</div>
							</div>

							<div className="bg-white p-6 rounded-lg border border-gray-200 shadow-sm">
								<h3 className="text-lg font-semibold mb-4 text-gray-800 border-b border-gray-200 pb-2">
									Skład gatunkowy
								</h3>
								<div className="space-y-2">
									{Object.entries(analysis.species_composition).map(
										([species, count]) => (
											<div
												key={species}
												className="flex justify-between items-center p-3 bg-gray-50 rounded hover:bg-gray-100 transition-colors">
												<span className="font-medium text-gray-700">
													{species}:
												</span>
												<span className="font-bold text-gray-900 text-lg">
													{count} szt.
												</span>
											</div>
										)
									)}
								</div>
							</div>
						</div>
					)}
				</div>

				{/* Footer */}
				<div className="text-center text-gray-500 text-sm">
					<p>webLIS - System analityczny dla leśnictwa</p>
					<p className="mt-1">
						Technologie: Next.js + FastAPI + Plumber R + PostgreSQL
					</p>
				</div>
			</div>
		</div>
	);
}
