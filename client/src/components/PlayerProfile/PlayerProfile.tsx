import { useState } from "react";
import {
  Trophy,
  X,
  BarChart2,
  Target,
  Award,
  Users,
  Clock,
  Diamond,
} from "lucide-react";

export default function PlayerProfile() {
  const [activeTab, setActiveTab] = useState("Statistics");

  const playerData = {
    name: "BrawlMaster99",
    club: "StarForce Elite",
    level: 43,
    xp: 87500,
    maxXp: 90000,
    trophies: 24680,
    victories: 3245,
    winRate: 68,
    soloVictories: 1230,
    duoVictories: 987,
    teamVictories: 1028,
    highestTrophies: 26500,
    globalRank: 812543,
    accountCreated: "March 2021",
  };

  const achievements = [
    {
      name: "Sharpshooter",
      description: "Hit 50 enemies without missing",
      progress: 100,
      icon: <Target className="w-6 h-6 text-yellow-400" />,
    },
    {
      name: "Brawl Master",
      description: "Win 1000 matches",
      progress: 100,
      icon: <Trophy className="w-6 h-6 text-yellow-400" />,
    },
    {
      name: "Collector",
      description: "Unlock 10 brawlers",
      progress: 60,
      icon: <Award className="w-6 h-6 text-yellow-400" />,
    },
    {
      name: "Survivor",
      description: "Survive for 2 minutes in Showdown",
      progress: 100,
      icon: <Clock className="w-6 h-6 text-yellow-400" />,
    },
    {
      name: "Team Player",
      description: "Win 500 team matches",
      progress: 80,
      icon: <Users className="w-6 h-6 text-yellow-400" />,
    },
    {
      name: "Gem Collector",
      description: "Collect 1000 gems in Gem Grab",
      progress: 75,
      icon: <Diamond className="w-6 h-6 text-yellow-400" />,
    },
  ];

  const seasonHistory = [
    {
      season: "Season 15",
      trophies: 24680,
      rank: "#12,543",
      brawlersUsed: 28,
    },
    {
      season: "Season 14",
      trophies: 23450,
      rank: "#13,210",
      brawlersUsed: 26,
    },
    {
      season: "Season 13",
      trophies: 21780,
      rank: "#15,432",
      brawlersUsed: 25,
    },
    {
      season: "Season 12",
      trophies: 19340,
      rank: "#18,765",
      brawlersUsed: 23,
    },
    {
      season: "Season 11",
      trophies: 17650,
      rank: "#22,134",
      brawlersUsed: 21,
    },
  ];

  return (
    <div className="bg-blue-900 min-h-screen p-4 font-sans text-white flex justify-center">
      <div className="w-full max-w-2xl">
        <h1 className="text-center text-xl font-bold mb-4">Player Profile</h1>

        {/* Profile Card */}
        <div className="bg-purple-700 rounded-lg p-4 shadow-lg mb-4">
          <div className="flex items-center mb-4">
            {/* Avatar with level */}
            <div className="relative mr-3">
              <div className="w-16 h-16 rounded-full bg-white border-2 border-yellow-400"></div>
              <div className="absolute -bottom-1 -right-1 bg-yellow-400 rounded-full w-6 h-6 flex items-center justify-center text-xs font-bold text-black">
                {playerData.level}
              </div>
            </div>

            {/* Player Info */}
            <div>
              <h2 className="text-lg font-bold">{playerData.name}</h2>
              <p className="text-sm text-blue-200">Club: {playerData.club}</p>
            </div>
          </div>

          {/* Stats Row */}
          <div className="flex justify-between text-center mb-4">
            {/* Trophies */}
            <div className="flex-1">
              <div className="flex justify-center mb-1">
                <Trophy className="w-5 h-5 text-yellow-400" />
              </div>
              <p className="text-xs">Trophies</p>
              <p className="font-bold">
                {playerData.trophies.toLocaleString()}
              </p>
            </div>

            {/* Victories */}
            <div className="flex-1">
              <div className="flex justify-center mb-1">
                <X className="w-5 h-5 text-red-400" />
              </div>
              <p className="text-xs">Victories</p>
              <p className="font-bold">
                {playerData.victories.toLocaleString()}
              </p>
            </div>

            {/* Win Rate */}
            <div className="flex-1">
              <div className="flex justify-center mb-1">
                <BarChart2 className="w-5 h-5 text-green-400" />
              </div>
              <p className="text-xs">Win Rate</p>
              <p className="font-bold">{playerData.winRate}%</p>
            </div>
          </div>

          {/* XP Bar */}
          <div className="mb-2">
            <div className="bg-purple-900 rounded-full h-3 overflow-hidden">
              <div
                className="bg-gradient-to-r from-blue-400 to-purple-500 h-full rounded-full"
                style={{
                  width: `${(playerData.xp / playerData.maxXp) * 100}%`,
                }}
              ></div>
            </div>
            <p className="text-xs text-right mt-1">
              {playerData.xp.toLocaleString()} /{" "}
              {playerData.maxXp.toLocaleString()} XP to Level{" "}
              {playerData.level + 1}
            </p>
          </div>
        </div>

        {/* Tabs - Updated with blue background */}
        <div className="mb-4">
          <div className="flex bg-blue-600 rounded-lg overflow-hidden">
            <button
              className={`flex-1 py-2 text-center text-sm font-medium transition-colors ${
                activeTab === "Statistics"
                  ? "bg-white text-blue-600"
                  : "bg-blue-600 text-white hover:bg-blue-500"
              }`}
              onClick={() => setActiveTab("Statistics")}
            >
              Statistics
            </button>
            <button
              className={`flex-1 py-2 text-center text-sm font-medium transition-colors ${
                activeTab === "Achievements"
                  ? "bg-white text-blue-600"
                  : "bg-blue-600 text-white hover:bg-blue-500"
              }`}
              onClick={() => setActiveTab("Achievements")}
            >
              Achievements
            </button>
            <button
              className={`flex-1 py-2 text-center text-sm font-medium transition-colors ${
                activeTab === "Session History"
                  ? "bg-white text-blue-600"
                  : "bg-blue-600 text-white hover:bg-blue-500"
              }`}
              onClick={() => setActiveTab("Session History")}
            >
              Session History
            </button>
          </div>
        </div>

        {/* Statistics Content */}
        {activeTab === "Statistics" && (
          <div className="bg-blue-800 p-4 rounded-lg">
            <h2 className="text-lg font-bold mb-4">Player Statistics</h2>

            <div className="flex flex-col md:flex-row gap-4">
              {/* Battle Stats */}
              <div className="bg-blue-700 rounded-lg p-3 flex-1">
                <h3 className="text-blue-300 font-medium mb-2">Battle Stats</h3>
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <span>Total Victories:</span>
                    <span className="font-bold">
                      {playerData.victories.toLocaleString()}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span>Solo Victories:</span>
                    <span className="font-bold">
                      {playerData.soloVictories.toLocaleString()}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span>Duo Victories:</span>
                    <span className="font-bold">
                      {playerData.duoVictories.toLocaleString()}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span>3v3 Victories:</span>
                    <span className="font-bold">
                      {playerData.teamVictories.toLocaleString()}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span>Win Rate:</span>
                    <span className="font-bold">{playerData.winRate}%</span>
                  </div>
                </div>
              </div>

              {/* Trophy Stats */}
              <div className="bg-blue-700 rounded-lg p-3 flex-1">
                <h3 className="text-blue-300 font-medium mb-2">Trophy Stats</h3>
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <span>Current Trophies:</span>
                    <span className="font-bold">
                      {playerData.trophies.toLocaleString()}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span>Highest Trophies:</span>
                    <span className="font-bold">
                      {playerData.highestTrophies.toLocaleString()}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span>Global Rank:</span>
                    <span className="font-bold">
                      {playerData.globalRank.toLocaleString()}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span>Account Created:</span>
                    <span className="font-bold">
                      {playerData.accountCreated}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Achievements Tab Content */}
        {activeTab === "Achievements" && (
          <div className="bg-blue-800 p-4 rounded-lg">
            <h2 className="text-lg font-bold mb-4">Achievements</h2>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {achievements.map((achievement, index) => (
                <div key={index} className="bg-blue-700 rounded-lg p-3 flex">
                  <div className="mr-3 mt-1">{achievement.icon}</div>
                  <div className="flex-1">
                    <h3 className="font-medium">{achievement.name}</h3>
                    <p className="text-xs text-blue-200 mb-1">
                      {achievement.description}
                    </p>
                    <div className="bg-blue-900 rounded-full h-2 overflow-hidden">
                      <div
                        className="bg-yellow-400 h-full rounded-full"
                        style={{ width: `${achievement.progress}%` }}
                      ></div>
                    </div>
                    <div className="flex justify-end">
                      <span className="text-xs mt-1">
                        {achievement.progress}%
                      </span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Session History Tab Content */}
        {activeTab === "Session History" && (
          <div className="bg-blue-800 p-4 rounded-lg">
            <h2 className="text-lg font-bold mb-4">Season History</h2>

            <div className="overflow-x-auto max-h-[400px] overflow-y-auto">
              <table className="w-full text-left">
                <thead>
                  <tr className="text-blue-200">
                    <th className="pb-2 pr-4">Season</th>
                    <th className="pb-2 pr-4">Trophies</th>
                    <th className="pb-2 pr-4">Rank</th>
                    <th className="pb-2">Brawlers Used</th>
                  </tr>
                </thead>
                <tbody>
                  {seasonHistory.map((season, index) => (
                    <tr key={index} className="border-t border-blue-700">
                      <td className="py-3 pr-4">{season.season}</td>
                      <td className="py-3 pr-4">
                        {season.trophies.toLocaleString()}
                      </td>
                      <td className="py-3 pr-4">{season.rank}</td>
                      <td className="py-3">{season.brawlersUsed}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
