import type React from "react";
import type { Reward } from "@/types/types";
import { getRewardIcon } from "./RewardIcons";
import { Check, LockKeyhole, Star } from "lucide-react";

interface RewardItemProps {
  type: "free" | "premium";
  reward: Reward;
  unlocked: boolean;
}

const RewardItem: React.FC<RewardItemProps> = ({ type, reward, unlocked }) => {
  const getStatusLabel = () => {
    if (!unlocked) {
      return (
        <span className="bg-black/50 text-white/30 text-[8px] sm:text-[10px] font-bold px-1 py-0.5 rounded flex items-center gap-1">
          <span>
            <LockKeyhole className="w-2 h-2 sm:w-3 sm:h-3" />
          </span>
          LOCKED
        </span>
      );
    }

    if (type === "free" && reward.claimed) {
      return (
        <span className="bg-green-500 text-white text-[8px] sm:text-[10px] font-bold px-1 py-0.5 rounded flex items-center gap-1">
          <Check className="h-2 w-2 sm:h-3 sm:w-3" /> <span>CLAIMED</span>
        </span>
      );
    }

    if (type === "free" && !reward.claimed) {
      return (
        <span className="bg-blue-500 text-white text-[8px] sm:text-[10px] font-bold px-1 py-0.5 rounded">
          CLAIM
        </span>
      );
    }

    if (type === "premium") {
      return (
        <span className="bg-yellow-500 text-black text-[8px] sm:text-[10px] font-bold px-1 py-0.5 rounded flex items-center gap-1">
          <span>
            <Star className="h-2 w-2 sm:h-3 sm:w-3" />
          </span>
          PREMIUM
        </span>
      );
    }

    return null;
  };

  return (
    <div
      className={`relative rounded-lg p-1.5 sm:p-2 flex justify-center h-16 sm:h-18 md:h-20
      ${type === "free" ? "bg-[#253793]" : "bg-[#433772]"}`}
    >
      <div className="flex flex-col w-full">
        <div
          className={`text-[10px] sm:text-xs text-white/70 mb-0.5 sm:mb-1 flex items-center justify-between gap-1 ${
            type === "free" ? "" : "text-yellow-500"
          }`}
        >
          <span>{type === "free" ? "Free" : "Premium"}</span>
          <div className="">{getStatusLabel()}</div>
        </div>
        <div className="flex items-center gap-1 sm:gap-2">
          <div
            className={`w-4 h-4 sm:w-5 sm:h-5 md:w-6 md:h-6 p-0.5 sm:p-1 rounded ${
              type === "premium" ? "bg-[#854D0F]" : "bg-[#1E41AF]"
            }`}
          >
            {getRewardIcon(reward.type)}
          </div>
          <span className="text-xs sm:text-sm font-bold truncate">
            {reward.type}
          </span>
        </div>
      </div>
    </div>
  );
};

export default RewardItem;
