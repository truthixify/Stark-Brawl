import type React from "react";

// Icons for different reward types
const CoinIcon: React.FC = () => (
  <svg
    className="w-full h-full"
    viewBox="0 0 24 24"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <circle cx="12" cy="12" r="10" fill="#FFD700" />
    <text
      x="12"
      y="16"
      textAnchor="middle"
      fill="#000"
      fontSize="12"
      fontWeight="bold"
    >
      $
    </text>
  </svg>
);

const GemIcon: React.FC = () => (
  <svg
    className="w-full h-full"
    viewBox="0 0 24 24"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <path d="M12 2L22 8.5L12 15L2 8.5L12 2Z" fill="#9C27B0" />
    <path d="M12 15V22L22 8.5L12 15Z" fill="#7B1FA2" />
    <path d="M12 15V22L2 8.5L12 15Z" fill="#7B1FA2" />
  </svg>
);

const SmallBoxIcon: React.FC = () => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 24 24"
    fill="none"
    stroke="#ffffff"
    className="w-full h-full"
  >
    <path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z" />
    <path d="m3.3 7 8.7 5 8.7-5" />
    <path d="M12 22V12" />
  </svg>
);

const BigBoxIcon: React.FC = () => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 24 24"
    fill="none"
    stroke="#FC933B"
    className="w-full h-full"
  >
    <path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z" />
    <path d="m3.3 7 8.7 5 8.7-5" />
    <path d="M12 22V12" />
  </svg>
);

const BoxIcon: React.FC = () => (
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 24 24"
    fill="none"
    stroke="#ffffff"
    className="w-full h-full"
  >
    <path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z" />
    <path d="m3.3 7 8.7 5 8.7-5" />
    <path d="M12 22V12" />
  </svg>
);

const PowerPointsIcon: React.FC = () => (
  <svg
    className="w-full h-full"
    viewBox="0 0 24 24"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <path
      d="M13 2L3 14H12L11 22L21 10H12L13 2Z"
      fill="#2196F3"
      stroke="#2196F3"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
);

const SkinIcon: React.FC = () => (
  <svg
    className="w-full h-full"
    viewBox="0 0 24 24"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <path
      d="M21 11.5C21.8284 12.3284 21.8284 13.6716 21 14.5L14.5 21C13.6716 21.8284 12.3284 21.8284 11.5 21L3 12.5L9.5 6L18 14.5C18.8284 13.6716 18.8284 12.3284 18 11.5L11.5 5C10.6716 4.17157 9.32843 4.17157 8.5 5L5 8.5"
      stroke="#FF9800"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
);

const BrawlerIcon: React.FC = () => (
  <svg
    className="w-full h-full"
    viewBox="0 0 24 24"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <circle cx="12" cy="8" r="5" fill="#E91E63" />
    <path
      d="M20 21C20 16.5817 16.4183 13 12 13C7.58172 13 4 16.5817 4 21"
      stroke="#E91E63"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
);

const EmoteIcon: React.FC = () => (
  <svg
    className="w-full h-full"
    viewBox="0 0 24 24"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <circle cx="12" cy="12" r="10" fill="#FFEB3B" />
    <path
      d="M8 15C8 15 9 17 12 17C15 17 16 15 16 15"
      stroke="#000"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
    <circle cx="8" cy="9" r="1.5" fill="#000" />
    <circle cx="16" cy="9" r="1.5" fill="#000" />
  </svg>
);

const DefaultIcon: React.FC = () => (
  <svg
    className="w-full h-full"
    viewBox="0 0 24 24"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
  >
    <rect x="3" y="3" width="18" height="18" rx="2" fill="#9E9E9E" />
    <path
      d="M12 8V16"
      stroke="white"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
    <path
      d="M8 12H16"
      stroke="white"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
);

export const getRewardIcon = (rewardType: string): React.ReactNode => {
  if (rewardType.includes("Coins")) {
    return <CoinIcon />;
  }
  if (rewardType.includes("Gems")) {
    return <GemIcon />;
  }
  // if (rewardType.includes("Box")) {
  //   return <BoxIcon />;
  // }
  if (rewardType.includes("Small Box")) {
    return <SmallBoxIcon />;
  }
  if (rewardType.includes("Big Box")) {
    return <BigBoxIcon />;
  }
  if (rewardType.includes("Power Points")) {
    return <PowerPointsIcon />;
  }
  if (rewardType.includes("Skin")) {
    return <SkinIcon />;
  }
  if (rewardType.includes("Brawler") || rewardType.includes("Warrior")) {
    return <BrawlerIcon />;
  }
  if (rewardType.includes("Emote")) {
    return <EmoteIcon />;
  }
  return <DefaultIcon />;
};
