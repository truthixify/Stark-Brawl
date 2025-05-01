export type MemberRole = 'President' | 'Vice President' | 'Senior' | 'Member';

export interface Member {
  id: string;
  name: string;
  role: MemberRole;
  trophies: number;
  lastActive: string;
}

export const members: Member[] = [
  {
    id: '1',
    name: 'BrawlMaster99',
    role: 'President',
    trophies: 24680,
    lastActive: '2 min ago'
  },
  {
    id: '2',
    name: 'SuperNova42',
    role: 'Vice President',
    trophies: 23450,
    lastActive: '15 min ago'
  },
  {
    id: '3',
    name: 'StarKiller',
    role: 'Vice President',
    trophies: 22780,
    lastActive: '1 hour ago'
  },
  {
    id: '4',
    name: 'GalaxyWarrior',
    role: 'Senior',
    trophies: 21340,
    lastActive: '3 hours ago'
  },
  {
    id: '5',
    name: 'CosmicEntity',
    role: 'Senior',
    trophies: 20980,
    lastActive: '5 hours ago'
  },
  {
    id: '6',
    name: 'NebulaNinja',
    role: 'Member',
    trophies: 19870,
    lastActive: 'Yesterday'
  },
  {
    id: '7',
    name: 'AstralHunter',
    role: 'Member',
    trophies: 18650,
    lastActive: 'Yesterday'
  },
  {
    id: '8',
    name: 'VoidWalker',
    role: 'Member',
    trophies: 17890,
    lastActive: '2 days ago'
  },
  {
    id: '9',
    name: 'StarDust',
    role: 'Member',
    trophies: 16750,
    lastActive: '3 days ago'
  },
  {
    id: '10',
    name: 'CosmicRay',
    role: 'Member',
    trophies: 16240,
    lastActive: '3 days ago'
  }
];