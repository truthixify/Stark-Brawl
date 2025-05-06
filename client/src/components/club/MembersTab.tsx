import React, { useState } from "react";
import { Search, Trophy, ChevronRight, UserPlus } from "lucide-react";
import { MemberRole, members } from "@/data/members";

const MembersTab: React.FC = () => {
  const [searchQuery, setSearchQuery] = useState("");

  const filteredMembers = members.filter((member) =>
    member.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const getRoleBadge = (role: MemberRole) => {
    switch (role) {
      case "President":
        return (
          <span className="bg-orange-500 text-white text-xs px-2 py-0.5 rounded">
            President
          </span>
        );
      case "Vice President":
        return (
          <span className="bg-blue-500 text-white text-xs px-2 py-0.5 rounded">
            Vice President
          </span>
        );
      case "Senior":
        return (
          <span className="bg-teal-500 text-white text-xs px-2 py-0.5 rounded">
            Senior
          </span>
        );
      default:
        return null;
    }
  };

  return (
    <div className="bg-blue-800/90 rounded-xl p-4 mt-2 shadow-lg">
      <div className="md:h-[55vh] overflow-auto scrollbar">
        <div className="flex justify-between items-center mb-4">
          <h2 className="text-xl font-bold">Club Members</h2>
          <div className="relative">
            <input
              type="text"
              placeholder="Search members..."
              className="pl-9 pr-4 py-2 bg-blue-700/70 rounded-lg bg-white text-black text-sm placeholder:text-sm w-full max-w-xs"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
            <Search
              size={18}
              className="absolute left-3 top-1/2 transform -translate-y-1/2 text-blue-300"
            />
          </div>
        </div>

        <div className="space-y-2">
          {filteredMembers.map((member) => (
            <div
              key={member.id}
              className="flex items-center justify-between bg-blue-700/60 hover:bg-blue-700/80 p-3 rounded-lg transition-colors"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 bg-gray-300 rounded-full"></div>
                <div>
                  <div className="flex items-center gap-2">
                    <span className="font-medium">{member.name}</span>
                    {getRoleBadge(member.role)}
                  </div>
                  <p className="text-xs text-blue-300">
                    Last active: {member.lastActive}
                  </p>
                </div>
              </div>

              <div className="flex items-center gap-2">
                <div className="flex items-center">
                  <Trophy size={16} className="text-yellow-400 mr-1" />
                  <span className="font-medium">
                    {member.trophies.toLocaleString()}
                  </span>
                </div>
                <ChevronRight size={20} className="text-blue-300" />
              </div>
            </div>
          ))}
        </div>

        <div className="mt-6 flex justify-center">
          <button className="flex items-center gap-2 bg-green-500 hover:bg-green-600 text-white py-2 px-6 rounded-md transition-colors">
            <UserPlus size={18} />
            <span>Invite Players</span>
          </button>
        </div>
      </div>
    </div>
  );
};

export default MembersTab;
