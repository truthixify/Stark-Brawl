import React from "react";
import { UserPlus2 } from "lucide-react";
import { previousSeasons } from "@/data/clubLeague";

const ClubLeagueTab: React.FC = () => {
  return (
    <div className="bg-blue-800/90 rounded-xl p-4 mt-2 shadow-lg">
      <div className="md:h-[55vh] overflow-auto scrollbar">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-bold">Club League History</h2>
          <button className="flex items-center gap-2 bg-green-500 hover:bg-green-600 text-white py-2 px-4 rounded-md transition-colors text-sm">
            <UserPlus2 size={16} />
            <span>Create Team</span>
          </button>
        </div>

        <div className="bg-blue-700/60 p-4 rounded-lg mb-6">
          <h3 className="text-lg font-semibold mb-3">Current Season</h3>

          <div className="grid grid-cols-2 gap-y-3">
            <div>
              <p className="text-blue-300 text-sm">Status:</p>
            </div>
            <div className="text-right">
              <span className="bg-green-500 text-white text-xs px-2 py-0.5 rounded">
                Active
              </span>
            </div>

            <div>
              <p className="text-blue-300 text-sm">Time Remaining:</p>
            </div>
            <div className="text-right">
              <p>2 days, 14 hours</p>
            </div>

            <div>
              <p className="text-blue-300 text-sm">Current Rank:</p>
            </div>
            <div className="text-right">
              <p>2nd</p>
            </div>

            <div>
              <p className="text-blue-300 text-sm">Trophies:</p>
            </div>
            <div className="text-right">
              <p>8,450</p>
            </div>

            <div>
              <p className="text-blue-300 text-sm">Matches Played:</p>
            </div>
            <div className="text-right">
              <p>18/30</p>
            </div>
          </div>
        </div>

        <div>
          <h3 className="text-lg font-semibold mb-3">Previous Seasons</h3>

          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="text-left text-blue-300 border-b border-blue-700">
                  <th className="pb-2 font-medium">Season</th>
                  <th className="pb-2 font-medium">Rank</th>
                  <th className="pb-2 font-medium">Trophies</th>
                  <th className="pb-2 font-medium">Rewards</th>
                </tr>
              </thead>
              <tbody>
                {previousSeasons.map((season) => (
                  <tr key={season.id} className="border-b border-blue-700/50">
                    <td className="py-3">Season {season.number}</td>
                    <td className="py-3 flex items-center">
                      {season.rank <= 3 ? (
                        <span className="inline-flex items-center">
                          <span className="text-yellow-400 mr-1">★</span>{" "}
                          {season.rank}
                        </span>
                      ) : (
                        season.rank
                      )}
                    </td>
                    <td className="py-3">{season.trophies.toLocaleString()}</td>
                    <td className="py-3">{season.rewards}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ClubLeagueTab;
