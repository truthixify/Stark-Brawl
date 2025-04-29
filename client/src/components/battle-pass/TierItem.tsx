import type React from "react";
import type { Tier } from "@/types/types";
import { ActiveIcon, CheckCircle, LockIcon } from "./Icons";
import RewardItem from "./RewardItem";
import { Star } from "lucide-react";

interface TierItemProps {
  tier: Tier;
}

const TierItem: React.FC<TierItemProps> = ({ tier }) => {
  const tierStatusIcon = () => {
    if (tier.completed) {
      return <CheckCircle />;
    }
    if (!tier.unlocked) {
      return <LockIcon />;
    }
    if (tier.active) {
      return <ActiveIcon />;
    }
    return null;
  };

  return (
    <div
      className={`flex-1 min-w-[85px] max-w-[150px] sm:min-w-[100px] md:min-w-[175px] flex flex-col items-center p-1 sm:p-2 rounded-lg transition-transform duration-200 
        ${tier.active ? "" : ""} 
        ${!tier.unlocked ? "opacity-70" : ""}`}
    >
      <div>
        <div className="relative w-[40px] h-[40px] sm:w-[50px] sm:h-[50px] md:w-[60px] md:h-[60px] mb-1 sm:mb-2">
          <div className="absolute inset-0 flex items-center justify-center">
            {tierStatusIcon()}
            {tier.active && (
              <div className="h-4 w-4 sm:h-5 sm:w-5 text-black flex items-center justify-center bg-yellow-500 rounded-full absolute top-0 right-0">
                <Star className="h-3 w-3 sm:h-4 sm:w-4" />
              </div>
            )}
          </div>
          <div
            className={`absolute inset-0 flex items-center justify-center z-10 text-base sm:text-lg md:text-xl font-bold text-white`}
          >
            {tier.completed ? "" : tier.number}
          </div>
        </div>
        <p
          className={`text-[10px] sm:text-xs text-center mb-3 sm:mb-4 md:mb-5 ${
            tier.active ? "text-yellow-500" : "text-gray-200"
          }`}
        >
          Tier {tier.number}
        </p>
      </div>
      <div className="w-full flex flex-col gap-3 sm:gap-4 md:gap-5 bg-[#2B369C] rounded-lg px-1 sm:px-2 py-2 sm:py-3 md:py-4">
        <RewardItem
          type="free"
          reward={tier.freeReward}
          unlocked={tier.unlocked}
        />
        <RewardItem
          type="premium"
          reward={tier.premiumReward}
          unlocked={tier.unlocked}
        />
      </div>
    </div>
  );
};

export default TierItem;
