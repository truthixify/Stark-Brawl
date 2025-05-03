import React from "react";
import { Filter, ChevronDown } from "lucide-react";

type ModeFilterDropdownProps = {
  value: string;
  onChange: (mode: string) => void;
};

const modes = ["all", "Gem Grab", "Showdown", "Brawl Ball", "Heist"];

const ModeFilterDropdown: React.FC<ModeFilterDropdownProps> = ({ value, onChange }) => (
  <div className="relative">
    <select
      className="appearance-none bg-blue-800 text-white font-semibold px-8 py-2 rounded-full pr-10 text-sm focus:outline-none focus:ring-2 focus:ring-blue-400 border border-blue-400"
      value={value}
      onChange={e => onChange(e.target.value)}
      style={{ minWidth: 120 }}
    >
      {modes.map(mode => (
        <option
          key={mode}
          value={mode}
          className={`bg-blue-800 text-white hover:bg-blue-600 ${value === mode ? 'bg-blue-600 text-white' : ''}`}
        >
          {mode === "all" ? "All Modes" : mode}
        </option>
      ))}
    </select>
    <Filter className="absolute left-2 top-1/2 -translate-y-1/2 w-4 h-4 text-white pointer-events-none" />
    <ChevronDown className="absolute right-2 top-1/2 -translate-y-1/2 w-4 h-4 text-white pointer-events-none" />
  </div>
);

export default ModeFilterDropdown; 