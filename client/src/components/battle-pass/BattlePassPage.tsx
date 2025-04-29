"use client";

import { useState } from "react";
import BattlePassHeader from "@/components/battle-pass/BattlePassHeader";
import ProgressBar from "@/components/battle-pass/ProgressBar";
import TierList from "@/components/battle-pass/TierList";
import PremiumPassUpgrade from "@/components/battle-pass/PremiumPassUpgrade";
import NavigationButton from "@/components/battle-pass/NavigationButton";
import type { Tier } from "@/types/types";

const battlePassData = {
  season: {
    number: 15,
    name: "Cyber Revolution",
    daysRemaining: 24,
  },
  progress: {
    currentTokens: 65,
    totalTokens: 100,
    currentTier: 12,
    nextTier: 13,
    percentToNextTier: 65,
  },
  premiumPassCost: 950,
  tiers: [
    {
      id: 7,
      number: 7,
      unlocked: true,
      active: false,
      completed: true,
      freeReward: {
        type: "Small Box",
        claimed: true,
      },
      premiumReward: {
        type: "400 Coins",
        claimed: false,
      },
    },
    {
      id: 8,
      number: 8,
      unlocked: true,
      active: false,
      completed: true,
      freeReward: {
        type: "150 Power Points",
        claimed: true,
      },
      premiumReward: {
        type: "50 Gems",
        claimed: false,
      },
    },
    {
      id: 9,
      number: 9,
      unlocked: true,
      active: false,
      completed: true,
      freeReward: {
        type: "250 Coins",
        claimed: true,
      },
      premiumReward: {
        type: "Big Box",
        claimed: false,
      },
    },
    {
      id: 10,
      number: 10,
      unlocked: true,
      active: false,
      completed: true,
      freeReward: {
        type: "Big Box",
        claimed: true,
      },
      premiumReward: {
        type: "New Epic Brawler",
        claimed: false,
      },
    },
    {
      id: 11,
      number: 11,
      unlocked: true,
      active: false,
      completed: true,
      freeReward: {
        type: "200 Power Points",
        claimed: true,
      },
      premiumReward: {
        type: "500 Coins",
        claimed: false,
      },
    },
    {
      id: 12,
      number: 12,
      unlocked: true,
      active: true,
      completed: false,
      freeReward: {
        type: "300 Coins",
        claimed: false,
      },
      premiumReward: {
        type: "300 Power Points",
        claimed: false,
      },
    },
    {
      id: 13,
      number: 13,
      unlocked: false,
      active: false,
      completed: false,
      freeReward: {
        type: "Small Box",
        claimed: false,
      },
      premiumReward: {
        type: "50 Gems",
        claimed: false,
      },
    },
    {
      id: 14,
      number: 14,
      unlocked: false,
      active: false,
      completed: false,
      freeReward: {
        type: "250 Power Points",
        claimed: false,
      },
      premiumReward: {
        type: "Mega Box",
        claimed: false,
      },
    },
    {
      id: 15,
      number: 15,
      unlocked: false,
      active: false,
      completed: false,
      freeReward: {
        type: "350 Coins",
        claimed: false,
      },
      premiumReward: {
        type: "Exclusive Weapon Skin",
        claimed: false,
      },
    },
    // Additional tiers
    {
      id: 25,
      number: 25,
      unlocked: false,
      active: false,
      completed: false,
      freeReward: {
        type: "Big Box",
        claimed: false,
      },
      premiumReward: {
        type: "Animated Emote",
        claimed: false,
      },
    },
    {
      id: 26,
      number: 26,
      unlocked: false,
      active: false,
      completed: false,
      freeReward: {
        type: "450 Power Points",
        claimed: false,
      },
      premiumReward: {
        type: "1000 Coins",
        claimed: false,
      },
    },
    {
      id: 27,
      number: 27,
      unlocked: false,
      active: false,
      completed: false,
      freeReward: {
        type: "550 Coins",
        claimed: false,
      },
      premiumReward: {
        type: "500 Power Points",
        claimed: false,
      },
    },
    {
      id: 28,
      number: 28,
      unlocked: false,
      active: false,
      completed: false,
      freeReward: {
        type: "Big Box",
        claimed: false,
      },
      premiumReward: {
        type: "150 Gems",
        claimed: false,
      },
    },
    {
      id: 29,
      number: 29,
      unlocked: false,
      active: false,
      completed: false,
      freeReward: {
        type: "500 Power Points",
        claimed: false,
      },
      premiumReward: {
        type: "Mega Box",
        claimed: false,
      },
    },
    {
      id: 30,
      number: 30,
      unlocked: false,
      active: false,
      completed: false,
      freeReward: {
        type: "Mega Box",
        claimed: false,
      },
      premiumReward: {
        type: "Ultimate Cyber Warrior",
        claimed: false,
      },
    },
  ],
};

function BattlePassPage() {
  const [visibleTiers, setVisibleTiers] = useState<Tier[]>(
    battlePassData.tiers.slice(0, 6)
  );
  const [startIndex, setStartIndex] = useState(0);

  const handlePrevious = () => {
    if (startIndex > 0) {
      const newStartIndex = Math.max(0, startIndex - 6);
      setStartIndex(newStartIndex);
      setVisibleTiers(
        battlePassData.tiers.slice(newStartIndex, newStartIndex + 6)
      );
    }
  };

  const handleNext = () => {
    if (startIndex + 6 < battlePassData.tiers.length) {
      const newStartIndex = startIndex + 6;
      setStartIndex(newStartIndex);
      setVisibleTiers(
        battlePassData.tiers.slice(newStartIndex, newStartIndex + 6)
      );
    }
  };

  return (
    <div className="bg-gradient-to-b from-blue-900 to-purple-900 min-h-screen text-white flex flex-col justify-between">
      <div>
        <div className="py-4 sm:py-6 md:py-8">
          <div className="absolute top-3 sm:top-4 md:top-5 left-3 sm:left-4 md:left-5">
            <NavigationButton
              direction="back"
              onClick={() => console.log("Back button clicked")}
            />
          </div>

          <h1 className="text-center text-xl sm:text-2xl md:text-3xl font-bold">
            Battle Pass
          </h1>
        </div>
        <div className="max-w-7xl mx-auto px-2 sm:px-4 md:px-5 relative">
          <div className="bg-gradient-to-r from-indigo-800 to-purple-800 rounded-xl overflow-hidden shadow-xl mb-4 sm:mb-6">
            <BattlePassHeader
              season={battlePassData.season}
              premiumPassCost={battlePassData.premiumPassCost}
            />
          </div>
          <div className="px-3 sm:px-6 md:px-10 mb-6 sm:mb-8 md:mb-10">
            <div className="rounded-xl overflow-hidden shadow-xl">
              <div className="p-3 sm:p-4 md:p-5">
                <ProgressBar progress={battlePassData.progress} />
              </div>
            </div>
          </div>

          {/* Mobile View - Full scrollable tier list */}
          <div className="sm:hidden mb-4">
            <div className="overflow-x-auto pb-2">
              <TierList tiers={battlePassData.tiers} />
            </div>
          </div>

          {/* Desktop View - Paginated tier list with navigation buttons */}
          <div className="hidden sm:block">
            <div className="flex items-center px-1 sm:px-2 mb-4 sm:mb-5">
              <NavigationButton direction="left" onClick={handlePrevious} />
              <div className="flex-1 overflow-x-hidden">
                <TierList tiers={visibleTiers} />
              </div>
              <NavigationButton direction="right" onClick={handleNext} />
            </div>
          </div>
        </div>
      </div>
      <PremiumPassUpgrade cost={battlePassData.premiumPassCost} />
    </div>
  );
}

export default BattlePassPage;
