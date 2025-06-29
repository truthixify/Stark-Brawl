import React, { useState, useRef, useEffect } from "react";

interface Tower {
  id: string;
  x: number;
  y: number;
}

interface ToxicSwampMapProps {
  onTowerPlaced?: (tower: Tower) => void;
  initialTowers?: Tower[];
  disabled?: boolean;
  className?: string;
}

const ToxicSwampMap: React.FC<ToxicSwampMapProps> = ({
  onTowerPlaced,
  initialTowers = [],
  disabled = false,
  className = "",
}) => {
  const [towers, setTowers] = useState<Tower[]>(initialTowers);
  const [isPlacing, setIsPlacing] = useState(false);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const [mousePos, setMousePos] = useState({ x: 0, y: 0 });

  // Grid configuration
  const GRID_SIZE = 64;
  const MAP_WIDTH = 800;
  const MAP_HEIGHT = 600;

  // Define placement zones (dirt patches where towers can be placed)
  const dirtPatches = [
    { x: 1, y: 1, width: 2, height: 2 },
    { x: 5, y: 2, width: 2, height: 2 },
    { x: 9, y: 1, width: 2, height: 3 },
    { x: 2, y: 5, width: 2, height: 2 },
    { x: 6, y: 6, width: 3, height: 2 },
    { x: 10, y: 5, width: 2, height: 2 },
  ];

  // Toxic river path (where enemies walk - cannot place towers)
  const toxicRiver = [
    { x: 4, y: 0, width: 2, height: 9 },
    { x: 4, y: 8, width: 5, height: 1 },
  ];

  // Check if position is valid (on dirt and not on river/path)
  const isValidPlacement = (gridX: number, gridY: number): boolean => {
    if (disabled) return false;

    const isOnDirt = dirtPatches.some(
      (patch) =>
        gridX >= patch.x &&
        gridX < patch.x + patch.width &&
        gridY >= patch.y &&
        gridY < patch.y + patch.height
    );

    const isOnRiver = toxicRiver.some(
      (river) =>
        gridX >= river.x &&
        gridX < river.x + river.width &&
        gridY >= river.y &&
        gridY < river.y + river.height
    );

    const isOccupied = towers.some(
      (tower) =>
        Math.floor(tower.x / GRID_SIZE) === gridX &&
        Math.floor(tower.y / GRID_SIZE) === gridY
    );

    return isOnDirt && !isOnRiver && !isOccupied;
  };

  const handleCanvasClick = (e: React.MouseEvent<HTMLCanvasElement>) => {
    if (!isPlacing || disabled) return;

    const canvas = canvasRef.current;
    if (!canvas) return;

    const rect = canvas.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    const gridX = Math.floor(x / GRID_SIZE);
    const gridY = Math.floor(y / GRID_SIZE);

    if (isValidPlacement(gridX, gridY)) {
      const newTower: Tower = {
        id: `tower-${Date.now()}`,
        x: gridX * GRID_SIZE + GRID_SIZE / 2,
        y: gridY * GRID_SIZE + GRID_SIZE / 2,
      };

      setTowers((prev) => [...prev, newTower]);
      onTowerPlaced?.(newTower);
      setIsPlacing(false);
    }
  };

  const handleMouseMove = (e: React.MouseEvent<HTMLCanvasElement>) => {
    const canvas = canvasRef.current;
    if (!canvas) return;

    const rect = canvas.getBoundingClientRect();
    setMousePos({
      x: e.clientX - rect.left,
      y: e.clientY - rect.top,
    });
  };

  useEffect(() => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    if (!ctx) return;

    // Clear canvas
    ctx.clearRect(0, 0, MAP_WIDTH, MAP_HEIGHT);

    // Draw background (swamp)
    ctx.fillStyle = "#0F2A1E";
    ctx.fillRect(0, 0, MAP_WIDTH, MAP_HEIGHT);

    // Draw toxic river (enemy path)
    toxicRiver.forEach((river) => {
      ctx.fillStyle = "#2A7F62";
      ctx.fillRect(
        river.x * GRID_SIZE,
        river.y * GRID_SIZE,
        river.width * GRID_SIZE,
        river.height * GRID_SIZE
      );
    });

    // Draw dirt patches (tower placement areas)
    dirtPatches.forEach((patch) => {
      ctx.fillStyle = "#5C4033";
      ctx.fillRect(
        patch.x * GRID_SIZE,
        patch.y * GRID_SIZE,
        patch.width * GRID_SIZE,
        patch.height * GRID_SIZE
      );
    });

    // Draw existing towers
    towers.forEach((tower) => {
      ctx.fillStyle = "#B5E61D";
      ctx.beginPath();
      ctx.arc(tower.x, tower.y, 20, 0, Math.PI * 2);
      ctx.fill();
    });

    // Draw placement preview
    if (isPlacing && !disabled) {
      const gridX = Math.floor(mousePos.x / GRID_SIZE);
      const gridY = Math.floor(mousePos.y / GRID_SIZE);

      ctx.fillStyle = isValidPlacement(gridX, gridY)
        ? "rgba(0, 255, 0, 0.3)"
        : "rgba(255, 0, 0, 0.3)";
      ctx.fillRect(gridX * GRID_SIZE, gridY * GRID_SIZE, GRID_SIZE, GRID_SIZE);
    }
  }, [towers, isPlacing, mousePos, disabled]);

  return (
    <div className={`toxic-swamp-map ${className}`}>
      <button
        onClick={() => !disabled && setIsPlacing(true)}
        disabled={disabled}
        className={`px-3 py-2 mb-2 rounded ${
          disabled
            ? "bg-gray-600 cursor-not-allowed"
            : "bg-green-800 hover:bg-green-700"
        } text-white`}
      >
        {disabled
          ? "Placement Disabled"
          : isPlacing
          ? "Click on dirt to place tower"
          : "Place Tower"}
      </button>

      <canvas
        ref={canvasRef}
        width={MAP_WIDTH}
        height={MAP_HEIGHT}
        onClick={handleCanvasClick}
        onMouseMove={handleMouseMove}
        className={`border border-gray-700 rounded ${
          disabled ? "cursor-not-allowed" : "cursor-crosshair"
        } ${className}`}
      />

      <div className="mt-2 text-sm text-gray-300">
        <p>• Green areas: Valid tower placement (dirt patches)</p>
        <p>• Toxic river: Enemy path (no tower placement)</p>
      </div>
    </div>
  );
};

export default ToxicSwampMap;
