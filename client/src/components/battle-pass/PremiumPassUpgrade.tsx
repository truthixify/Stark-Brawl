import type React from "react";
import { Sparkles } from "lucide-react";

interface PremiumPassUpgradeProps {
  cost: number;
}

const PremiumPassUpgrade: React.FC<PremiumPassUpgradeProps> = ({ cost }) => {
  return (
    <div className="bg-gradient-to-r from-[#864E0C] to-[#C38503] p-3 sm:p-4 md:p-5">
      <div className="max-w-7xl mx-auto relative flex justify-between items-center">
        <div className="flex items-center gap-1 sm:gap-2">
          <div className="w-5 h-5 sm:w-6 sm:h-6 md:w-8 md:h-8">
            <Sparkles className="text-yellow-500 h-full w-full" />
          </div>
          <div>
            <h3 className="text-sm sm:text-base md:text-lg font-bold m-0">
              Upgrade to Premium Pass
            </h3>
            <p className="text-[10px] sm:text-xs md:text-sm text-white/70 m-0">
              Unlock exclusive rewards and bonuses!
            </p>
          </div>
        </div>
        <button className="bg-yellow-500 text-white font-bold rounded-lg px-3 sm:px-4 md:px-5 py-1.5 sm:py-2 text-xs sm:text-sm md:text-base transition-colors hover:bg-yellow-400">
          {cost} Gems
        </button>
      </div>
    </div>
  );
};

export default PremiumPassUpgrade;
