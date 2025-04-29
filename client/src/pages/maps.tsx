import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { mapsData, OfficialMap, CommunityMap, MyMap } from "@/data/maps-data";
import OfficialMaps from "@/components/maps-ui/OfficialMaps";
import MyMaps from "@/components/maps-ui/MyMaps";
import CommunityMaps from "@/components/maps-ui/CommunityMaps";
import { Map, PlusIcon, ArrowLeft } from "lucide-react";
const Maps = () => {
	const [activeTab, setActiveTab] = useState<"Official" | "Community" | "My Maps">("Official");
	const [searchQuery, setSearchQuery] = useState<string>("");
	const tabs: Array<"Official" | "Community" | "My Maps"> = ["Official", "Community", "My Maps"];

	const currentMaps: OfficialMap[] | CommunityMap[] | MyMap[] =
		activeTab === "Official"
			? mapsData.official
			: activeTab === "Community"
			? mapsData.community
			: mapsData.mine;

	const filteredMaps: (OfficialMap | CommunityMap | MyMap)[] = currentMaps.filter((map) =>
		map.name.toLowerCase().includes(searchQuery.toLowerCase())
	);

	const tabVariants = {
		hidden: { opacity: 0, y: 10 },
		visible: { opacity: 1, y: 0, transition: { duration: 0.3 } },
		exit: { opacity: 0, y: -10, transition: { duration: 0.2 } },
	};

	return (
		<main className="min-h-screen flex flex-col bg-gradient-to-b from-blue-900 to-purple-900 py-5 px-3 text-white">
			<div className=" flex items-center justify-between">
				<div className=" bg-blue-500 w-[30px] h-[30px] flex items-center justify-center rounded-full">
					<ArrowLeft width={18} height={18} />
				</div>
				<div className=" bg-green-500 w-[30px] h-[30px] flex items-center justify-center rounded-full">
					<PlusIcon width={18} height={18} />
				</div>
			</div>
			<div>
				<section className="container-xyz w-[100%]">
					<h1 className="text-center text-2xl font-bold mb-5">Maps</h1>

					<div className="mb-5 relative w-full">
						<Map
							className=" absolute top-[28%] left-[12px]"
							color="#ccc"
							width={20}
							height={20}
						/>
						<input
							type="text"
							placeholder="Search maps..."
							value={searchQuery}
							onChange={(e) => setSearchQuery(e.target.value)}
							className="w-full py-2 pl-[40px] rounded-lg border placeholder:text-[14px] text-[14px] bg-blue-600/20 border-gray-400 text-white placeholder-gray-400 focus:outline-none focus:border-gray-200"
						/>
					</div>

					<div className="flex flex-col sm:flex-row justify-center mb-5 w-full bg-blue-600/20">
						{tabs.map((tab) => (
							<motion.button
								key={tab}
								onClick={() => setActiveTab(tab)}
								className={`px-5 py-2 w-full font-bold text-[15px] transition-colors ${
									activeTab === tab
										? "bg-white text-blue-900 my-[2px] mx-[2px] rounded-sm"
										: "bg-transparent text-gray-400"
								}`}
							>
								{tab}
							</motion.button>
						))}
					</div>

					{activeTab === "My Maps" && (
						<div className=" flex justify-end">
							<motion.button
								whileHover={{ scale: 1.05 }}
								whileTap={{ scale: 0.95 }}
								className=" mb-5 px-5 py-[6px] bg-green-600 text-white rounded-lg font-medium"
							>
								+ Create New Map
							</motion.button>
						</div>
					)}

					<AnimatePresence mode="wait">
						<motion.div
							key={activeTab}
							variants={tabVariants}
							initial="hidden"
							animate="visible"
							exit="exit"
							className="flex flex-col gap-5"
						>
							{activeTab === "Official" && (
								<OfficialMaps maps={filteredMaps as OfficialMap[]} />
							)}
							{activeTab === "Community" && (
								<CommunityMaps maps={filteredMaps as CommunityMap[]} />
							)}
							{activeTab === "My Maps" && <MyMaps maps={filteredMaps as MyMap[]} />}
						</motion.div>
					</AnimatePresence>
				</section>
			</div>
		</main>
	);
};

export default Maps;
