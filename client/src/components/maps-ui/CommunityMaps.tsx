import { motion } from "framer-motion";
import { CommunityMap } from "@/data/maps-data";
import { ThumbsUp, ThumbsDown, Users, Clock } from "lucide-react";

interface CommunityMapsProps {
	maps: CommunityMap[];
}

const CommunityMaps: React.FC<CommunityMapsProps> = ({ maps }) => {
	const cardVariants = {
		hidden: { opacity: 0, x: -20 },
		visible: (i: number) => ({
			opacity: 1,
			x: 0,
			transition: { delay: i * 0.1, duration: 0.3 },
		}),
		exit: { opacity: 0, x: 20, transition: { duration: 0.2 } },
	};

	return (
		<>
			{maps.map((map, index) => (
				<motion.div
					key={map.name}
					custom={index}
					variants={cardVariants}
					initial="hidden"
					animate="visible"
					exit="exit"
					className="flex flex-col md:flex-row bg-blue-600/20 p-4 rounded-lg"
				>
					<div className="w-full h-[200px] md:w-[250px] md:h-[260px] flex-shrink-0 bg-gray-200 rounded-lg mb-4 md:mb-0 md:mr-4" />

					<div className=" flex flex-col justify-between w-full">
						<div className=" flex items-start justify-between">
							<div className="flex-1">
								<h3 className="text-lg text-white font-semibold">{map.name}</h3>
								<div>
									<p className="text-blue-300/90 font-semibold text-sm">
										{map.mode} . by {map.creator}
									</p>
									<div className=" flex items-center gap-[6px] mt-2">
										<Clock width={15} height={15} className=" " />
										<p className={` text-[13px] font-medium text-blue-300/90`}>
											Created {map.created}
										</p>
									</div>
								</div>
							</div>
							{map.featured && (
								<button className=" bg-yellow-500 text-white py-1 px-2 rounded-full capitalize text-xs font-bold">
									FEATURED
								</button>
							)}
						</div>
						<div className="flex flex-col sm:flex-row items-start sm:items-center justify-between mt-4 sm:mt-0">
							<div className="flex flex-col sm:flex-row gap-3 mb-4 sm:mb-0">
								{map.likes !== null && (
									<div className=" flex items-center gap-1">
										<ThumbsUp
											width={18}
											height={18}
											className=" text-green-500"
										/>{" "}
										<p className=" font-medium">{map.likes.toLocaleString()}</p>
									</div>
								)}
								{map.dislikes !== null && (
									<div className=" flex items-center gap-1">
										<ThumbsDown
											width={18}
											height={18}
											className=" text-red-400"
										/>{" "}
										<p className=" font-medium">
											{map.dislikes.toLocaleString()}
										</p>
									</div>
								)}

								{map.dislikes !== null && (
									<div className="flex items-center gap-1">
										<Users width={18} height={18} className=" text-blue-300" />{" "}
										<p className=" font-medium">
											{map.dislikes.toLocaleString()}
										</p>
									</div>
								)}
							</div>

							<div className=" flex items-center gap-2 self-end sm:self-auto">
								<div className="px-3 py-2 bg-green-600 text-white font-medium  rounded-lg cursor-pointer">
									<ThumbsUp width={20} height={20} />
								</div>
								<div className="px-3 py-2 bg-red-600 text-white font-medium  rounded-lg cursor-pointer">
									<ThumbsDown width={20} height={20} />
								</div>
								<motion.button
									whileHover={{ scale: 1.05 }}
									whileTap={{ scale: 0.95 }}
									className="px-3 py-2 bg-blue-600 text-white font-medium text-sm rounded-lg"
								>
									Play
								</motion.button>
							</div>
						</div>
					</div>
				</motion.div>
			))}
		</>
	);
};

export default CommunityMaps;
