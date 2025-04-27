"use client";

import type React from "react";
import { ChevronLeft, ChevronRight, ArrowLeft } from "./Icons";

interface NavigationButtonProps {
  direction: "left" | "right" | "back";
  onClick: () => void;
}

const NavigationButton: React.FC<NavigationButtonProps> = ({
  direction,
  onClick,
}) => {
  const getIcon = () => {
    switch (direction) {
      case "left":
        return <ChevronLeft className="h-4 w-4 sm:h-5 sm:w-5" />;
      case "right":
        return <ChevronRight className="h-4 w-4 sm:h-5 sm:w-5" />;
      case "back":
        return <ArrowLeft className="h-4 w-4 sm:h-5 sm:w-5" />;
      default:
        return null;
    }
  };

  return (
    <button
      className={`flex items-center justify-center w-8 h-8 sm:w-10 sm:h-10 rounded-full bg-white/10 text-white 
        transition-colors hover:bg-white/20 ${
          direction === "back" ? "bg-white/20" : ""
        }`}
      onClick={onClick}
      aria-label={`Navigate ${direction}`}
    >
      {getIcon()}
    </button>
  );
};

export default NavigationButton;
