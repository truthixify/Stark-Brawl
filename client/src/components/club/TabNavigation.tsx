import React from "react";

interface TabNavigationProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
}

const TabNavigation: React.FC<TabNavigationProps> = ({
  activeTab,
  onTabChange,
}) => {
  return (
    <div className="grid grid-cols-3 gap-2 mb-4 bg-blue-700 p-1 rounded-lg">
      <button
        className={`py-3 px-4 rounded-md text-center transition-colors ${
          activeTab === "members"
            ? "bg-white text-black"
            : "bg-blue-800/50 text-blue-300 hover:bg-blue-700/70"
        }`}
        onClick={() => onTabChange("members")}
      >
        Members
      </button>
      <button
        className={`py-3 px-4 rounded-md text-center transition-colors ${
          activeTab === "clubLeague"
            ? "bg-white text-black"
            : "bg-blue-800/50 text-blue-300 hover:bg-blue-700/70"
        }`}
        onClick={() => onTabChange("clubLeague")}
      >
        Club League
      </button>
      <button
        className={`py-3 px-4 rounded-md text-center transition-colors ${
          activeTab === "clubChat"
            ? "bg-white text-black"
            : "bg-blue-800/50 text-blue-300 hover:bg-blue-700/70"
        }`}
        onClick={() => onTabChange("clubChat")}
      >
        Club Chat
      </button>
    </div>
  );
};

export default TabNavigation;
