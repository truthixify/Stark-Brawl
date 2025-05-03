import React from "react";

type TabsProps = {
  value: "all" | "victory" | "defeat";
  onChange: (tab: "all" | "victory" | "defeat") => void;
};

const tabLabels = {
  all: "All",
  victory: "Victories",
  defeat: "Defeats"
};

const Tabs: React.FC<TabsProps> = ({ value, onChange }) => (
  <div className="flex bg-blue-800 rounded-md p-1 gap-1">
    {(["all", "victory", "defeat"] as const).map(tab => (
      <button
        key={tab}
        className={`px-5 py-2 rounded-md font-bold transition-colors text-sm
          ${value === tab ? "bg-white text-blue-900 shadow" : "bg-blue-800 text-blue-300 hover:bg-blue-700"}
        `}
        onClick={() => onChange(tab)}
      >
        {tabLabels[tab]}
      </button>
    ))}
  </div>
);

export default Tabs; 