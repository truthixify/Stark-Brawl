import GameCanvas from "@/components/Map/GameCanvas";
import MapRenderer from "@/components/Map/MapRenderer";
import EnemyRenderer from "@/components/Enemy/EnemyRenderer";
import { GameProvider } from "@/components/contexts/GameContext";
import arena from "@/assets/td-tileset3/PNG/game_background_1/game_background_1.png"

export default function MainGameScene() {
  return (
    <GameProvider>
      <GameCanvas>
        <MapRenderer src={arena}/>
        <EnemyRenderer enemyId={1} initialX={5} initialY={5} />
      </GameCanvas>
    </GameProvider>
  )
}