export interface Season {
  number: number;
  name: string;
  daysRemaining: number;
}

export interface Progress {
  currentTokens: number;
  totalTokens: number;
  currentTier: number;
  nextTier: number;
  percentToNextTier: number;
}

export interface Reward {
  type: string;
  claimed: boolean;
}

export interface Tier {
  id: number;
  number: number;
  unlocked: boolean;
  active: boolean;
  completed: boolean;
  freeReward: Reward;
  premiumReward: Reward;
}
