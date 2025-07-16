'use client';

import { useState, useEffect } from 'react';

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
    python: { status: 'checking...' },
    r: { status: 'checking...' }
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
      const pythonResponse = await fetch('http://localhost:8000/health');
      if (pythonResponse.ok) {
        setBackendStatus(prev => ({
          ...prev,
          python: { status: 'connected', message: 'FastAPI działa poprawnie' }
        }));
      }
    } catch (error) {
      setBackendStatus(prev => ({
        ...prev,
        python: { status: 'disconnected', message: 'FastAPI niedostępny' }
      }));
    }

    // Sprawdź backend R
    try {
      const rResponse = await fetch('http://localhost:8001/status');
      if (rResponse.ok) {
        setBackendStatus(prev => ({
          ...prev,
          r: { status: 'connected', message: 'Plumber R działa poprawnie' }
        }));
      }
    } catch (error) {
      setBackendStatus(prev => ({
        ...prev,
        r: { status: 'disconnected', message: 'Plumber R niedostępny' }
      }));
    }
  };

  const loadTestData = async () => {
    setLoading(true);
    try {
      const response = await fetch('http://localhost:8000/trees');
      if (response.ok) {
        const data = await response.json();
        setTrees(data);
      }
    } catch (error) {
      console.error('Błąd ładowania danych:', error);
    }
    setLoading(false);
  };

  const analyzeForest = async () => {
    if (trees.length === 0) {
      alert('Najpierw załaduj dane testowe');
      return;
    }

    setLoading(true);
    try {
      // Analiza z backendem Python
      const pythonResponse = await fetch('http://localhost:8000/forest-stands/analysis', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          stand_id: 1,
          area: 2.5,
          trees: trees
        })
      });

      if (pythonResponse.ok) {
        const pythonData = await pythonResponse.json();
        
        // Analiza z backendem R
        const rResponse = await fetch('http://localhost:8001/analyze/forest-stand', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ trees: trees })
        });

        if (rResponse.ok) {
          const rData = await rResponse.json();
          
          setAnalysis({
            total_trees: pythonData.total_trees,
            average_height_m: rData.summary.average_height_m,
            average_diameter_cm: rData.summary.average_dbh_cm,
            total_volume_m3: rData.summary.total_volume_m3,
            species_composition: pythonData.species_composition
          });
        }
      }
    } catch (error) {
      console.error('Błąd analizy:', error);
    }
    setLoading(false);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 to-green-100 p-8">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-5xl font-bold text-green-800 mb-4">
            webLIS
          </h1>
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
              <span className="w-3 h-3 rounded-full mr-3" 
                    style={{backgroundColor: backendStatus.python.status === 'connected' ? '#10b981' : '#ef4444'}}></span>
              Backend Python (FastAPI)
            </h2>
            <p className="text-gray-600">Status: <span className="font-medium">{backendStatus.python.status}</span></p>
            {backendStatus.python.message && (
              <p className="text-sm text-gray-500 mt-1">{backendStatus.python.message}</p>
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
              <span className="w-3 h-3 rounded-full mr-3"
                    style={{backgroundColor: backendStatus.r.status === 'connected' ? '#10b981' : '#ef4444'}}></span>
              Backend R (Plumber)
            </h2>
            <p className="text-gray-600">Status: <span className="font-medium">{backendStatus.r.status}</span></p>
            {backendStatus.r.message && (
              <p className="text-sm text-gray-500 mt-1">{backendStatus.r.message}</p>
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
          <h2 className="text-2xl font-semibold text-gray-800 mb-6">Panel testowy</h2>
          
          <div className="flex flex-wrap gap-4 mb-8">
            <button
              onClick={checkBackendStatus}
              className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
            >
              Sprawdź status backendów
            </button>
            
            <button
              onClick={loadTestData}
              disabled={loading}
              className="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition-colors disabled:opacity-50"
            >
              {loading ? 'Ładowanie...' : 'Załaduj dane testowe'}
            </button>
            
            <button
              onClick={analyzeForest}
              disabled={loading || trees.length === 0}
              className="px-6 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors disabled:opacity-50"
            >
              {loading ? 'Analizowanie...' : 'Analizuj drzewostan'}
            </button>
          </div>

          {/* Wyniki */}
          {trees.length > 0 && (
            <div className="mb-8">
              <h3 className="text-lg font-semibold mb-4">Załadowane dane ({trees.length} drzew)</h3>
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead className="bg-gray-50">
                    <tr>
                      <th className="p-2 text-left">ID</th>
                      <th className="p-2 text-left">Gatunek</th>
                      <th className="p-2 text-left">Pierśnica (cm)</th>
                      <th className="p-2 text-left">Wysokość (m)</th>
                      <th className="p-2 text-left">Wiek</th>
                    </tr>
                  </thead>
                  <tbody>
                    {trees.slice(0, 5).map(tree => (
                      <tr key={tree.id} className="border-t">
                        <td className="p-2">{tree.id}</td>
                        <td className="p-2">{tree.species}</td>
                        <td className="p-2">{tree.diameter_breast_height}</td>
                        <td className="p-2">{tree.height}</td>
                        <td className="p-2">{tree.age || 'N/A'}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
                {trees.length > 5 && (
                  <p className="text-sm text-gray-500 mt-2">... i {trees.length - 5} więcej</p>
                )}
              </div>
            </div>
          )}

          {analysis && (
            <div className="grid md:grid-cols-2 gap-6">
              <div>
                <h3 className="text-lg font-semibold mb-4">Wyniki analizy drzewostanu</h3>
                <div className="space-y-2 text-sm">
                  <p><span className="font-medium">Liczba drzew:</span> {analysis.total_trees}</p>
                  <p><span className="font-medium">Średnia wysokość:</span> {analysis.average_height_m} m</p>
                  <p><span className="font-medium">Średnia pierśnica:</span> {analysis.average_diameter_cm} cm</p>
                  <p><span className="font-medium">Całkowita miąższość:</span> {analysis.total_volume_m3} m³</p>
                </div>
              </div>
              
              <div>
                <h3 className="text-lg font-semibold mb-4">Skład gatunkowy</h3>
                <div className="space-y-1 text-sm">
                  {Object.entries(analysis.species_composition).map(([species, count]) => (
                    <p key={species}>
                      <span className="font-medium">{species}:</span> {count} szt.
                    </p>
                  ))}
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="text-center text-gray-500 text-sm">
          <p>webLIS - System analityczny dla leśnictwa</p>
          <p className="mt-1">Technologie: Next.js + FastAPI + Plumber R + PostgreSQL</p>
        </div>
      </div>
    </div>
          </a>
        </div>
      </main>
      <footer className="row-start-3 flex gap-[24px] flex-wrap items-center justify-center">
        <a
          className="flex items-center gap-2 hover:underline hover:underline-offset-4"
          href="https://nextjs.org/learn?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          <Image
            aria-hidden
            src="/file.svg"
            alt="File icon"
            width={16}
            height={16}
          />
          Learn
        </a>
        <a
          className="flex items-center gap-2 hover:underline hover:underline-offset-4"
          href="https://vercel.com/templates?framework=next.js&utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          <Image
            aria-hidden
            src="/window.svg"
            alt="Window icon"
            width={16}
            height={16}
          />
          Examples
        </a>
        <a
          className="flex items-center gap-2 hover:underline hover:underline-offset-4"
          href="https://nextjs.org?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
          target="_blank"
          rel="noopener noreferrer"
        >
          <Image
            aria-hidden
            src="/globe.svg"
            alt="Globe icon"
            width={16}
            height={16}
          />
          Go to nextjs.org →
        </a>
      </footer>
    </div>
  );
}
