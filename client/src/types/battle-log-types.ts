export type Player = {
  name: string;
  power: number;
  trophies: number;
  specialty: string;
};

export type Team = {
  your: Player[];
  opponents: Player[];
};

export type BattleStats = {
  [key: string]: number | string;
};

export type BattleResult = "victory" | "defeat" | "rank";

export type Battle = {
  id: string;
  mode: string;
  map: string;
  timeAgo: string;
  duration: string;
  result: BattleResult;
  resultLabel: string;
  trophyChange: number;
  teams: Team;
  stats: BattleStats;
}; 