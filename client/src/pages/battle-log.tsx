import React, { useEffect, useState } from "react";
import { Battle } from "../types/battle-log-types";
import { fetchBattles } from "../data/battle-log-service";
import Tabs from "../components/BattleLog/Tabs";
import ModeFilterDropdown from "../components/BattleLog/ModeFilterDropdown";
import BattleCard from "../components/BattleLog/BattleCard";
import { ArrowLeft } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { AnimatePresence, motion } from "framer-motion";

const BattleLogPage: React.FC = () => {
  const [battles, setBattles] = useState<Battle[]>([]);
  const [loading, setLoading] = useState(true);
  const [tab, setTab] = useState<"all" | "victory" | "defeat">("all");
  const [mode, setMode] = useState("all");
  const navigate = useNavigate();

  useEffect(() => {
    fetchBattles().then(data => {
      setBattles(data);
      setLoading(false);
    });
  }, []);

  const filteredBattles = battles.filter(b =>
    (tab === "all" || b.result === tab) &&
    (mode === "all" || b.mode === mode)
  );

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-900 to-purple-900 p-6 relative">
      <button
        className="fixed top-6 left-6 z-50 w-9 h-9 rounded-full bg-blue-700 flex items-center justify-center text-white hover:bg-blue-800 shadow-lg"
        onClick={() => navigate(-1)}
        aria-label="Back"
      >
        <ArrowLeft className="w-5 h-5" />
      </button>
      <div className="max-w-3xl mx-auto">
        <h1 className="text-2xl font-bold text-white mb-4 text-center">Battle Log</h1>
        <div className="flex items-center justify-between mb-4">
          <Tabs value={tab} onChange={setTab} />
          <ModeFilterDropdown value={mode} onChange={setMode} />
        </div>
        {loading ? (
          <div className="text-white">Loading...</div>
        ) : (
          <div className="space-y-6">
            <AnimatePresence mode="wait">
              {filteredBattles.map(battle => (
                <motion.div
                  key={battle.id}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: -20 }}
                  transition={{ duration: 0.35, ease: "easeInOut" }}
                >
                  <BattleCard battle={battle} />
                </motion.div>
              ))}
            </AnimatePresence>
          </div>
        )}
      </div>
    </div>
  );
};

export default BattleLogPage; 