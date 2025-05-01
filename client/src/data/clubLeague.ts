export interface Season {
  id: string;
  number: number;
  rank: number;
  trophies: number;
  rewards: string;
}

export const previousSeasons: Season[] = [
  {
    id: '1',
    number: 15,
    rank: 2,
    trophies: 12450,
    rewards: '1200 Club Coins, 500 Star Points'
  },
  {
    id: '2',
    number: 14,
    rank: 1,
    trophies: 13200,
    rewards: '1500 Club Coins, 800 Star Points'
  },
  {
    id: '3',
    number: 13,
    rank: 3,
    trophies: 11800,
    rewards: '1000 Club Coins, 400 Star Points'
  },
  {
    id: '4',
    number: 12,
    rank: 2,
    trophies: 12100,
    rewards: '1200 Club Coins, 500 Star Points'
  },
  {
    id: '5',
    number: 11,
    rank: 5,
    trophies: 10500,
    rewards: '800 Club Coins, 300 Star Points'
  }
];

export const currentSeason = {
  status: 'Active',
  timeRemaining: '2 days, 14 hours',
  rank: '2nd',
  trophies: 8450,
  matchesPlayed: '18/30'
};