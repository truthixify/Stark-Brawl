import { useState } from "react";
import ClanCard from "./utils/clanCard";
import ClanDetailsModal from "./utils/ClanDetailsModal";
import { clansData } from "./utils/mockData";
import { Clan } from "./utils/mockData";

const Clans = ({ searchQuery }: { searchQuery: string }) => {
	const [selectedClan, setSelectedClan] = useState<Clan | null>(null);

	const handleViewClick = (clan: Clan) => {
		setSelectedClan(clan);
	};

	const handleRequestJoin = () => {
		setSelectedClan(null);
	};

	const filteredClans = clansData.filter(
		(clan) =>
			clan.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
			clan.tag.toLowerCase().includes(searchQuery.toLowerCase())
	);

	return (
		<div>
			<div className="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
				{filteredClans.map((clan) => (
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
