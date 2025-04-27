import type React from "react";
import type { Season } from "@/types/types";
import { Clock } from "./Icons";
import { Star } from "lucide-react";

interface BattlePassHeaderProps {
  season: Season;
  premiumPassCost: number;
}

const BattlePassHeader: React.FC<BattlePassHeaderProps> = ({
  season,
  premiumPassCost,
}) => {
  return (
    <div className="p-3 sm:p-4 md:p-5 border-b border-white/10">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center">
        <div className="flex flex-col">
          <h2 className="text-xl sm:text-2xl font-bold m-0">
            Season {season.number}: {season.name}
          </h2>
        </div>
        <button className="flex items-center gap-1 sm:gap-2 bg-yellow-500 text-white font-bold rounded-xl px-3 sm:px-4 py-1.5 sm:py-2 mt-2 sm:mt-0 text-sm sm:text-base transition-colors hover:bg-yellow-400">
          <Star className="h-4 w-4 sm:h-5 sm:w-5" />
          <span>Premium Pass ({premiumPassCost} Gems)</span>
        </button>
      </div>
      <div className="flex items-center gap-1 text-white/70 mt-1 text-xs sm:text-sm">
        <Clock className="h-3.5 w-3.5 sm:h-4 sm:w-4" />
        <span>{season.daysRemaining} days remaining</span>
      </div>
    </div>
  );
};

export default BattlePassHeader;
