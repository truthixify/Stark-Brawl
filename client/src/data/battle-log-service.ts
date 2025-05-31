import { Battle } from "../types/battle-log-types";

export const fetchBattles = (): Promise<Battle[]> => {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve([
        {
          id: "1",
          mode: "Gem Grab",
          map: "Crystal Cavern",
          timeAgo: "10 minutes ago",
          duration: "2:45",
          result: "victory",
          resultLabel: "Victory",
          trophyChange: 8,
          teams: {
            your: [
              { name: "BrawIMaster99", power: 11, trophies: 750, specialty: "Cyber Warrior" },
              { name: "SuperNova42", power: 10, trophies: 720, specialty: "Golden Knight" },
              { name: "StarKiller", power: 9, trophies: 680, specialty: "Mystic Archer" }
            ],
            opponents: [
              { name: "GalaxyWarrior", power: 10, trophies: 710, specialty: "Desert Warrior" },
              { name: "CosmicEntity", power: 9, trophies: 690, specialty: "Zombie Hunter" },
              { name: "NebulaNinja", power: 10, trophies: 700, specialty: "Frost Mage" }
            ]
          },
          stats: {
            "Gems Collected": 12,
            "Eliminations": 8,
            "Deaths": 3,
            "Damage": 24680
          }
        },
        {
          id: "2",
          mode: "Showdown",
          map: "Forsaken Falls",
          timeAgo: "25 minutes ago",
          duration: "2:15",
          result: "rank",
          resultLabel: "Rank #2",
          trophyChange: 7,
          teams: {
            your: [
              { name: "BrawIMaster99", power: 11, trophies: 720, specialty: "Golden Knight" }
            ],
            opponents: [
              { name: "Player1", power: 10, trophies: 700, specialty: "Brawler1" },
              { name: "Player2", power: 9, trophies: 690, specialty: "Brawler2" },
              { name: "Player3", power: 10, trophies: 680, specialty: "Brawler3" },
              { name: "Player4", power: 10, trophies: 670, specialty: "Brawler4" },
              { name: "Player5", power: 9, trophies: 660, specialty: "Brawler5" },
              { name: "Player6", power: 8, trophies: 650, specialty: "Brawler6" },
              { name: "Player7", power: 8, trophies: 640, specialty: "Brawler7" },
              { name: "Player8", power: 7, trophies: 630, specialty: "Brawler8" },
              { name: "Player9", power: 7, trophies: 620, specialty: "Brawler9" }
            ]
          },
          stats: {
            "Position": "#2",
            "Eliminations": 4,
            "Damage": 18450
          }
        },
        {
          id: "3",
          mode: "Brawl Ball",
          map: "Super Stadium",
          timeAgo: "1 hour ago",
          duration: "1:50",
          result: "defeat",
          resultLabel: "Defeat",
          trophyChange: -5,
          teams: {
            your: [
              { name: "BrawIMaster99", power: 9, trophies: 660, specialty: "Mystic Archer" },
              { name: "AstraHunter", power: 10, trophies: 600, specialty: "Zombie Hunter" },
              { name: "VoxWildWar", power: 10, trophies: 700, specialty: "Frost Mage" }
            ],
            opponents: [
              { name: "Star Dust", power: 10, trophies: 790, specialty: "Desert Warrior" },
              { name: "Cosmic Ray", power: 9, trophies: 780, specialty: "Cyber Knight" },
              { name: "Lunar Eclipse", power: 10, trophies: 720, specialty: "Frost Mage" }
            ]
          },
          stats: {
            "Goals": 1,
            "Goals Allowed": 2,
            "Eliminations": 5,
            "Deaths": 7
          }
        },
        {
          id: "4",
          mode: "Heist",
          map: "Safe Zone",
          timeAgo: "Yesterday",
          duration: "2:30",
          result: "defeat",
          resultLabel: "Defeat",
          trophyChange: -6,
          teams: {
            your: [
              { name: "BrawIMaster99", power: 13, trophies: 720, specialty: "Desert Raider" },
              { name: "GalaxyWarrior", power: 12, trophies: 660, specialty: "Cyber Knight" },
              { name: "CosmicEntity", power: 10, trophies: 700, specialty: "Frost Mage" }
            ],
            opponents: [
              { name: "Player1", power: 10, trophies: 700, specialty: "Brawler1" },
              { name: "Player2", power: 10, trophies: 690, specialty: "Brawler2" },
              { name: "Player3", power: 10, trophies: 680, specialty: "Brawler3" }
            ]
          },
          stats: {
            "Safe Damage": "45%",
            "Enemy Safe": "100%",
            "Eliminations": 6,
            "Deaths": 8
          }
        }
      ]);
    }, 1000);
  });
}; 