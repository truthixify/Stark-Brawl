import React, { useState } from "react";
import { Battle } from "../../types/battle-log-types";
import ReplayModal from "./ReplayModal";
import { Clock, Play, Download, Share2 } from "lucide-react";

const BattleCard: React.FC<{ battle: Battle }> = ({ battle }) => {
  const isVictory = battle.result === "victory";
  const isDefeat = battle.result === "defeat";
  const isRank = battle.result === "rank";
  // Degradado fiel al diseño
  const bgColor = isVictory
    ? "from-blue-800 via-blue-700 to-green-600"
    : isDefeat
    ? "from-blue-800 via-blue-700 to-red-600"
    : "from-blue-800 via-blue-700 to-green-600";

  // Para Showdown, mostrar "Other Players" en vez de "Opponents"
  const isShowdown = battle.mode.toLowerCase() === "showdown";
  const opponentsLabel = isShowdown ? "Other Players" : "Opponents";

  // Modal state
  const [replayOpen, setReplayOpen] = useState(false);
  const [shareOpen, setShareOpen] = useState(false);
  const [shareMsg, setShareMsg] = useState("");

  // Download JSON
  const handleDownload = () => {
    const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(battle, null, 2));
    const dlAnchor = document.createElement("a");
    dlAnchor.setAttribute("href", dataStr);
    dlAnchor.setAttribute("download", `battle-${battle.id}.json`);
    document.body.appendChild(dlAnchor);
    dlAnchor.click();
    dlAnchor.remove();
  };

  // Share (simulado: copia un link al portapapeles)
  const handleShare = () => {
    const fakeUrl = `${window.location.origin}/battle-log?battle=${battle.id}`;
    navigator.clipboard.writeText(fakeUrl).then(() => {
      setShareMsg("Link copied to clipboard!");
    }, () => {
      setShareMsg("Could not copy link.");
    });
    setShareOpen(true);
  };

  return (
    <div className={`rounded-2xl p-6 bg-gradient-to-r ${bgColor} shadow-lg mb-8`}>
      {/* Header: modo, mapa, tiempo, resultado */}
      <div className="flex flex-wrap justify-between items-center mb-3 gap-2">
        <div className="flex flex-wrap items-center gap-2">
          <span className="font-bold text-white text-xl">{battle.mode}</span>
          <span className="bg-blue-700 text-white text-xs px-2 py-1 rounded-full font-semibold">{battle.map}</span>
        </div>
        <span className={`px-4 py-1 rounded-full font-bold text-white text-base shadow ${
          isVictory ? "bg-green-500" : isDefeat ? "bg-red-500" : "bg-green-700"
        }`}>
          {battle.resultLabel} {battle.trophyChange > 0 ? `+${battle.trophyChange}` : battle.trophyChange}
        </span>
      </div>
      <div className="flex items-center gap-2 text-blue-100 text-sm mb-4">
        <Clock className="inline-block mr-1 w-4 h-4" />
        <span>{battle.timeAgo}</span>
        <span className="mx-1">•</span>
        <span>{battle.duration}</span>
      </div>
      {/* Equipos/Players */}
      <div className="flex flex-col md:flex-row md:justify-between gap-8 mt-2">
        {/* Your Team */}
        <div className="flex-1 min-w-[200px] bg-blue-900/40 rounded-xl p-3">
          <div className="text-white font-bold mb-2">Your Team</div>
          {battle.teams.your.map(player => (
            <div key={player.name} className="flex items-center gap-3 mb-2">
              <span className="w-6 h-6 rounded-full bg-blue-600 inline-block" />
              <div className="flex-1">
                <div className="text-white font-bold leading-tight">{player.name}</div>
                <div className="text-blue-200 text-xs leading-tight">{player.specialty} · Power {player.power}</div>
              </div>
              <span className="text-yellow-300 font-bold text-sm">🏆 {player.trophies}</span>
            </div>
          ))}
        </div>
        {/* Opponents/Other Players */}
        <div className="flex-1 min-w-[200px] bg-blue-900/40 rounded-xl p-3">
          <div className={`font-bold mb-2 ${isShowdown ? "text-purple-200" : "text-red-200"}`}>{opponentsLabel}</div>
          {battle.teams.opponents.slice(0, 3).map(player => (
            <div key={player.name} className="flex items-center gap-3 mb-2">
              <span className="w-6 h-6 rounded-full bg-red-600 inline-block" />
              <div className="flex-1">
                <div className="text-white font-bold leading-tight">{player.name}</div>
                <div className="text-blue-200 text-xs leading-tight">{player.specialty} · Power {player.power}</div>
              </div>
              <span className="text-yellow-300 font-bold text-sm">🏆 {player.trophies}</span>
            </div>
          ))}
          {isShowdown && battle.teams.opponents.length > 3 && (
            <div className="text-blue-200 text-xs mt-1">+{battle.teams.opponents.length - 3} more players</div>
          )}
        </div>
      </div>
      {/* Battle Stats barra inferior */}
      <div className="mt-6">
        <div className="text-white font-bold mb-2">Battle Stats</div>
        <div className="flex flex-wrap justify-between items-center gap-2 bg-blue-950/80 rounded-lg px-4 py-3">
          {Object.entries(battle.stats).map(([key, value]) => (
            <div key={key} className="flex-1 min-w-[120px] text-center">
              <div className="text-blue-100 text-xs font-semibold mb-1">{key}</div>
              <div className="text-white text-xl font-bold">{value}</div>
            </div>
          ))}
        </div>
      </div>
      {/* Botones de acción */}
      <div className="flex flex-wrap gap-2 mt-4 justify-center">
        <button
          className="bg-blue-600 hover:bg-blue-700 text-white px-3 py-2 rounded-lg font-bold text-xs flex items-center justify-center gap-2 transition"
          onClick={() => setReplayOpen(true)}
        >
          <Play className="w-4 h-4" /> Watch Replay
        </button>
        <button
          className="bg-gray-600 hover:bg-gray-700 text-white px-3 py-2 rounded-lg font-bold text-xs flex items-center justify-center gap-2 transition"
          onClick={handleDownload}
        >
          <Download className="w-4 h-4" /> Download
        </button>
        <button
          className="bg-purple-600 hover:bg-purple-700 text-white px-3 py-2 rounded-lg font-bold text-xs flex items-center justify-center gap-2 transition"
          onClick={handleShare}
        >
          <Share2 className="w-4 h-4" /> Share
        </button>
      </div>
      {/* Modales */}
      <ReplayModal open={replayOpen} onClose={() => setReplayOpen(false)} title="Watch Replay">
        <div className="text-center text-blue-900 font-semibold">Replay simulation for battle <span className="font-mono">{battle.id}</span>.<br/>[Here would go the video or animation]</div>
      </ReplayModal>
      <ReplayModal open={shareOpen} onClose={() => setShareOpen(false)} title="Share Battle">
        <div className="text-center text-blue-900 font-semibold mb-2">Share this battle with your friends!</div>
        <div className="text-center text-xs text-gray-700 mb-2">{window.location.origin}/battle-log?battle={battle.id}</div>
        <div className="text-center text-green-600 font-bold">{shareMsg}</div>
      </ReplayModal>
    </div>
  );
};

export default BattleCard; 