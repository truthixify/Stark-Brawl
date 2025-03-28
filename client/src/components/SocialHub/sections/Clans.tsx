// Clans.tsx
import { useState } from "react";
import ClanCard from "./utils/clanCard";
import ClanDetailsModal from "./utils/ClanDetailsModal";
import { clansData } from "./utils/mockData";
import { Clan } from "./utils/mockData";

const Clans = () => {
  // Fix: Change the type from Clan[] to Clan | null
  const [selectedClan, setSelectedClan] = useState<Clan | null>(null);

  const handleViewClick = (clan: Clan) => {
    setSelectedClan(clan); // Now this matches the type Clan | null
  };

  const handleRequestJoin = (clan: Clan) => {
    console.log(`Request to join ${clan.name} sent!`);
    setSelectedClan(null); // This is fine, as null is allowed by the type
  };

  return (
    <div>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
        {clansData.map((clan) => (
          <ClanCard key={clan.id} clan={clan} onViewClick={handleViewClick} />
        ))}
      </div>
      {selectedClan && (
        <ClanDetailsModal
          clan={selectedClan}
          onClose={() => setSelectedClan(null)}
          onRequestJoin={handleRequestJoin}
        />
      )}
    </div>
  );
};

export default Clans;