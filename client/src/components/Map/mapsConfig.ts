import arenaMap from "../../assets/td-tileset3/PNG/game_background_1/game_background_1.png";
import jungleRuins from "../../assets/td-tileset3/PNG/game_background_4/game_background_4.png";
export interface MapConfig {
  id: string
  name: string
  src: string
  waypoints: Array<{ x: number; y: number }>
  spawnPoint: { x: number; y: number }
  endPoint: { x: number; y: number }
}

export const mapsConfig: Record<string, MapConfig> = {
  arena: {
    id: "arena",
    name: "Arena",
    src: arenaMap,
    waypoints: [
      { x: 100, y: 300 },
      { x: 300, y: 300 },
      { x: 500, y: 300 },
      { x: 700, y: 300 },
    ],
    spawnPoint: { x: 50, y: 300 },
    endPoint: { x: 750, y: 300 },
  },
  jungleRuins: {
    id: "jungleRuins",
    name: "Jungle Ruins",
    src: jungleRuins,
    waypoints: [
      { x: 80, y: 800 }, // Start from left side, even closer to bottom
      { x: 180, y: 470 }, // Curve up slightly
      { x: 280, y: 430 }, // Continue curving up
      { x: 380, y: 470 }, // Start curving down
      { x: 480, y: 530 }, // Bottom of first curve
      { x: 580, y: 490 }, // Start second curve up
      { x: 680, y: 450 }, // Top of second curve
      { x: 780, y: 490 }, // Curve down toward exit
      { x: 880, y: 550 }, // Final approach, closer to bottom
    ],
    spawnPoint: { x: 20, y: 800 }, // Moved even closer to bottom
    endPoint: { x: 940, y: 570 }, // Exit point closer to bottom
  },
}
