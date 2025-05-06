import React from "react";
import { Trophy, Users, Shield, Globe } from "lucide-react";

const ClubHeader: React.FC = () => {
  return (
    <div className="bg-gradient-to-r from-blue-800 to-purple-800 rounded-xl p-4 mt-2 shadow-lg">
      <div className="flex items-start gap-4">
        <div className="w-16 h-16 bg-white rounded-md border-2 border-yellow-400 flex-shrink-0"></div>
        <div className="flex md:flex-row flex-col items-start gap-4">
          <div className="flex-1">
            <h2 className="text-2xl font-bold">StarForce Elite</h2>
            <p className="text-blue-300 text-sm">#SF2023E • Invite Only</p>
            <p className="text-sm mt-1">
              Active competitive club looking for trophy pushers. English
              speaking. Join us for club league and team play!
            </p>
          </div>
          <div>
            <button className="bg-green-500 hover:bg-green-600 text-white py-2 px-4 rounded-md transition-colors text-sm whitespace-nowrap">
              Join Club League
            </button>
          </div>
        </div>
      </div>
      <div className="grid md:grid-cols-4 grid-cols-2 gap-2 mt-4 md:pl-20">
        <div className="bg-blue-700 rounded-lg p-3 flex flex-col items-center">
          <div className="flex items-center justify-center mb-1">
            <Trophy size={20} className="text-yellow-400" />
          </div>
          <span className="text-xs text-blue-300">Trophies</span>
          <span className="font-bold">1,250,000</span>
        </div>

        <div className="bg-blue-700 rounded-lg p-3 flex flex-col items-center">
          <div className="flex items-center justify-center mb-1">
            <Users size={20} className="text-blue-300" />
          </div>
          <span className="text-xs text-blue-300">Members</span>
          <span className="font-bold">28/30</span>
        </div>

        <div className="bg-blue-700 rounded-lg p-3 flex flex-col items-center">
          <div className="flex items-center justify-center mb-1">
            <Shield size={20} className="text-purple-300" />
          </div>
          <span className="text-xs text-blue-300">Required</span>
          <span className="font-bold">15,000</span>
        </div>

        <div className="bg-blue-700 rounded-lg p-3 flex flex-col items-center">
          <div className="flex items-center justify-center mb-1">
            <Globe size={20} className="text-green-300" />
          </div>
          <span className="text-xs text-blue-300">Region</span>
          <span className="font-bold">Global</span>
        </div>
      </div>
    </div>
  );
};

export default ClubHeader;
