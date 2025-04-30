import type React from "react";
import type { Progress } from "@/types/types";
import { Trophy } from "lucide-react";

interface ProgressBarProps {
  progress: Progress;
}

const ProgressBar: React.FC<ProgressBarProps> = ({ progress }) => {
  return (
    <div className="w-full">
      <div className="flex justify-between items-center mb-1.5 sm:mb-2">
        <span className="text-sm sm:text-base md:text-lg font-bold">
          Current Progress
        </span>
        <div className="flex items-center gap-1 text-white text-xs sm:text-sm">
          <Trophy className="w-3.5 h-3.5 sm:w-4 sm:h-4 text-yellow-500" />
          <span>Tier {progress.currentTier}</span>
        </div>
      </div>
      <div className="h-2 sm:h-3 bg-yellow-500 rounded-md overflow-hidden mb-1.5 sm:mb-2">
        <div
          className="h-full bg-gradient-to-r from-green-500 to-lime-500 rounded-md"
          style={{ width: `${progress.percentToNextTier}%` }}
        ></div>
      </div>
      <div className="flex justify-between text-[10px] sm:text-xs text-white">
        <span>
          {progress.currentTokens}/{progress.totalTokens} Tokens
        </span>
        <span>
          {progress.percentToNextTier}% to Tier {progress.nextTier}
        </span>
      </div>
    </div>
  );
};

export default ProgressBar;
