import React, { useState, useRef, useEffect } from "react";
import { Filter, ChevronDown, Check } from "lucide-react";

const modes = [
  { value: "all", label: "All Modes" },
  { value: "Gem Grab", label: "Gem Grab" },
  { value: "Showdown", label: "Showdown" },
  { value: "Brawl Ball", label: "Brawl Ball" },
  { value: "Heist", label: "Heist" },
];

type ModeFilterDropdownProps = {
  value: string;
  onChange: (mode: string) => void;
};

const ModeFilterDropdown: React.FC<ModeFilterDropdownProps> = ({ value, onChange }) => {
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (ref.current && !ref.current.contains(event.target as Node)) {
        setOpen(false);
      }
    };
    if (open) {
      document.addEventListener("mousedown", handleClickOutside);
    } else {
      document.removeEventListener("mousedown", handleClickOutside);
    }
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, [open]);

  const selected = modes.find(m => m.value === value) || modes[0];

  return (
    <div className="relative" ref={ref}>
      <button
        className="flex items-center gap-2 bg-blue-700 hover:bg-blue-800 text-white font-semibold px-3 py-2 rounded-sm text-base shadow focus:outline-none focus:ring-2 focus:ring-blue-400 transition"
        onClick={() => setOpen(o => !o)}
        type="button"
        aria-haspopup="listbox"
        aria-expanded={open}
      >
        <Filter className="w-5 h-5 text-white" />
        <span>{selected.label}</span>
        <ChevronDown className="w-4 h-4 text-white" />
      </button>
      {open && (
        <div className="absolute right-0 mt-2 w-48 bg-blue-800 rounded-xl shadow-lg z-50 py-2 border border-blue-600 animate-fade-in">
          {modes.map(mode => (
            <button
              key={mode.value}
              className={`w-full text-left px-4 py-2 text-white text-base hover:bg-blue-600 focus:bg-blue-600 transition flex items-center gap-2 ${value === mode.value ? "bg-blue-600 font-bold" : ""}`}
              onClick={() => {
                onChange(mode.value);
                setOpen(false);
              }}
              type="button"
              role="option"
              aria-selected={value === mode.value}
            >
              {value === mode.value && <Check className="w-4 h-4 text-white" />}<span>{mode.label}</span>
            </button>
          ))}
        </div>
      )}
    </div>
  );
};

export default ModeFilterDropdown; 