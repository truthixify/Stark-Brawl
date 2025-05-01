import React, { useState } from "react";
import { ChevronLeft, Settings } from "lucide-react";
import ClubHeader from "@/components/club/ClubHeader";
import TabNavigation from "@/components/club/TabNavigation";
import MembersTab from "@/components/club/MembersTab";
import ClubLeagueTab from "@/components/club/ClubLeagueTab";
import ClubChatTab from "@/components/club/ClubChatTab";

function ClubPage() {
  const [activeTab, setActiveTab] = useState("members");

  return (
    <div className="min-h-screen md:h-auto h-screen md:overflow-y-hidden overflow-y-scroll bg-gradient-to-b from-blue-900 to-purple-900 text-white">
      <header className="flex items-center justify-between p-4">
        <button className="p-2 rounded-full bg-blue-800 hover:bg-blue-700 transition-colors">
          <ChevronLeft size={24} />
        </button>
        <h1 className="text-xl font-bold">Club</h1>
        <button className="p-2 rounded-full bg-blue-800 hover:bg-blue-700 transition-colors">
          <Settings size={24} />
        </button>
      </header>

      <main className="max-w-4xl mx-auto pb-8 px-4">
        <ClubHeader />

        <div className="mt-6">
          <TabNavigation activeTab={activeTab} onTabChange={setActiveTab} />

          {activeTab === "members" && <MembersTab />}
          {activeTab === "clubLeague" && <ClubLeagueTab />}
          {activeTab === "clubChat" && <ClubChatTab />}
        </div>
      </main>
    </div>
  );
}

export default ClubPage;
