import type React from "react";
import TierItem from "./TierItem";
import type { Tier } from "@/types/types";

interface TierListProps {
  tiers: Tier[];
}

const TierList: React.FC<TierListProps> = ({ tiers }) => {
  return (
    <div className="flex gap-1 sm:gap-2 md:gap-3 p-1 sm:p-2 overflow-x-auto scrollbar-thin scrollbar-thumb-gray-500 scrollbar-track-transparent snap-x snap-mandatory">
      {tiers.map((tier) => (
        <div key={tier.id} className="snap-center snap-always">
          <TierItem tier={tier} />
        </div>
      ))}
    </div>
  );
};

export default TierList;
