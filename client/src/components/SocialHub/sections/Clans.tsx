import { useState } from "react";
import ClanCard from "./utils/clanCard";
import ClanDetailsModal from "./utils/ClanDetailsModal";
import { clansData } from "./utils/mockData";
import { Clan } from "./utils/mockData";

const Clans = () => {
  const [selectedClan, setSelectedClan] = useState<Clan | null>(null);

  const handleViewClick = (clan: Clan) => {
    setSelectedClan(clan);
  };

  const handleRequestJoin = (clan: Clan) => {
    console.log(`Request to join ${clan.name} sent!`);
    setSelectedClan(null);
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
