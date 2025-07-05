import GameCanvas from "@/components/Map/GameCanvas"
import MapRenderer from "@/components/Map/MapRenderer"
import EnemyRenderer from "@/components/Enemy/EnemyRenderer"
import { GameProvider } from "@/components/contexts/GameContext"
import { mapsConfig } from "@/components/Map/mapsConfig"

export default function MainGameScene() {
  const currentMap = mapsConfig.jungleRuins

  return (
    <GameProvider>
      <GameCanvas>
        <MapRenderer mapConfig={currentMap} showPath={false} />
        <EnemyRenderer enemyId={1} mapConfig={currentMap} autoStart={true} />
      </GameCanvas>
      <div className="absolute top-4 left-4 bg-black bg-opacity-50 text-white p-2 rounded text-sm z-20">
        <p>
          <strong>Path Controls:</strong>
        </p>
        <p>Space: Start/Stop automatic path following</p>
        <p>P: Pause movement</p>
        <p>R: Reset to spawn point</p>
        <p>
          <strong>Manual Controls:</strong>
        </p>
        <p>Arrow Keys: Move enemy manually</p>
        <p>
          <strong>Animations:</strong>
        </p>
        <p>A: Attack | S: Die | W: Jump | H: Hurt | I: Idle</p>
      </div>
    </GameProvider>
  )
}
