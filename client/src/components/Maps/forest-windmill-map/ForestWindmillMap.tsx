import React, { useState } from "react";
import mapImage from "@/assets/td-tilesets1-2/tower-defense-game-tilesets/PNG/game_background_1/game_background_1.png";
import archerTower from "@/assets/archer-tower-game-assets/PNG/1.png";
import stoneTower from "@/assets/stone-tower-game-assets/PNG/1.png";
import supportTower from "@/assets/support-tower-game-assets/PNG/1.png";

const GRID_COLS = 10;
const GRID_ROWS = 8;
const CELL_WIDTH = 80;
const CELL_HEIGHT = 75;
const MAP_WIDTH = GRID_COLS * CELL_WIDTH;
const MAP_HEIGHT = GRID_ROWS * CELL_HEIGHT;

const VALID_CELLS = [
  [1, 2], [1, 3], [1, 4],
  [2, 2], [2, 3], [2, 4],
  [3, 2], [3, 3], [3, 4],
  [4, 2], [4, 3], [4, 4],
  [5, 2], [5, 3], [5, 4],
  [6, 2], [6, 3], [6, 4],
  [7, 2], [7, 3], [7, 4],
  [8, 2], [8, 3], [8, 4],
  [2, 6], [3, 6], [4, 6], [5, 6], [6, 6], [7, 6],
];

const TOWER_TYPES = [
  { name: "archer", img: archerTower },
  { name: "stone", img: stoneTower },
  { name: "support", img: supportTower },
];

interface Tower {
  col: number;
  row: number;
  type: string;
}

export const ForestWindmillMap: React.FC = () => {
  const [towers, setTowers] = useState<Tower[]>([]);
  const [selectedTower, setSelectedTower] = useState(TOWER_TYPES[0]);
  const [hoverCell, setHoverCell] = useState<{col: number, row: number} | null>(null);

  const isValidCell = (col: number, row: number) =>
    VALID_CELLS.some(([c, r]) => c === col && r === row) &&
    !towers.some(t => t.col === col && t.row === row);

  const handleMapClick = (e: React.MouseEvent<HTMLDivElement, MouseEvent>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    const col = Math.floor(x / CELL_WIDTH);
    const row = Math.floor(y / CELL_HEIGHT);
    if (isValidCell(col, row)) {
      setTowers([...towers, { col, row, type: selectedTower.name }]);
    }
  };

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement, MouseEvent>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    const col = Math.floor(x / CELL_WIDTH);
    const row = Math.floor(y / CELL_HEIGHT);
    setHoverCell({ col, row });
  };

  return (
    <div>
      <div style={{ display: "flex", gap: 16, marginBottom: 12 }}>
        {TOWER_TYPES.map(tower => (
          <button
            key={tower.name}
            onClick={() => setSelectedTower(tower)}
            style={{
              border: selectedTower.name === tower.name ? "2px solid #4ade80" : "1px solid #ccc",
              background: "#222",
              borderRadius: 8,
              padding: 4,
              cursor: "pointer"
            }}
          >
            <img src={tower.img} alt={tower.name} width={40} height={40} />
          </button>
        ))}
      </div>
      <div
        style={{
          position: "relative",
          width: MAP_WIDTH,
          height: MAP_HEIGHT,
          backgroundImage: `url(${mapImage})`,
          backgroundSize: "cover",
          border: "2px solid #333",
          cursor: "crosshair",
        }}
        onClick={handleMapClick}
        onMouseMove={handleMouseMove}
        onMouseLeave={() => setHoverCell(null)}
      >
        {[...Array(GRID_COLS)].map((_, col) =>
          [...Array(GRID_ROWS)].map((_, row) => {
            const isValid = isValidCell(col, row);
            const isHover = hoverCell && hoverCell.col === col && hoverCell.row === row;
            const isOccupied = towers.some(t => t.col === col && t.row === row);
            return (
              <div
                key={`${col}-${row}`}
                style={{
                  position: "absolute",
                  left: col * CELL_WIDTH,
                  top: row * CELL_HEIGHT,
                  width: CELL_WIDTH,
                  height: CELL_HEIGHT,
                  boxSizing: "border-box",
                  border: "1px solid rgba(255,255,255,0.08)",
                  background:
                    isHover && isValid
                      ? "rgba(16, 185, 129, 0.25)"
                      : isHover && !isValid
                      ? "rgba(239, 68, 68, 0.25)"
                      : VALID_CELLS.some(([c, r]) => c === col && r === row)
                      ? "rgba(34,197,94,0.10)"
                      : "none",
                  pointerEvents: "none",
                  zIndex: 2,
                }}
              />
            );
          })
        )}
        {towers.map((tower, idx) => {
          const towerImg = TOWER_TYPES.find(t => t.name === tower.type)?.img;
          return (
            <img
              key={idx}
              src={towerImg}
              alt={tower.type}
              style={{
                position: "absolute",
                left: tower.col * CELL_WIDTH + CELL_WIDTH / 2 - 24,
                top: tower.row * CELL_HEIGHT + CELL_HEIGHT / 2 - 24,
                width: 48,
                height: 48,
                zIndex: 3,
                pointerEvents: "none",
              }}
            />
          );
        })}
      </div>
      <div style={{ marginTop: 8, color: "#888", fontSize: 14 }}>
        <p>You can only place towers on green (grass) areas. Select the tower type and click on the map.</p>
      </div>
    </div>
  );
}; 