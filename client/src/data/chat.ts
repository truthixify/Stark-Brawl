export interface Message {
  id: string;
  sender: string;
  content: string;
  time: string;
}

export const messages: Message[] = [
  {
    id: '1',
    sender: 'BrawlMaster99',
    content: 'Everyone ready for club league this weekend?',
    time: '10:30 AM'
  },
  {
    id: '2',
    sender: 'SuperNova42',
    content: 'Yes! Let\'s aim for first place this time.',
    time: '10:32 AM'
  },
  {
    id: '3',
    sender: 'StarKiller',
    content: 'I\'ll be available all weekend. Count me in!',
    time: '10:35 AM'
  },
  {
    id: '4',
    sender: 'GalaxyWarrior',
    content: 'What time are we starting?',
    time: '10:40 AM'
  },
  {
    id: '5',
    sender: 'BrawlMaster99',
    content: 'Let\'s start at 2 PM on Saturday. We\'ll form teams in advance.',
    time: '10:42 AM'
  },
  {
    id: '6',
    sender: 'CosmicEntity',
    content: 'Works for me!',
    time: '10:45 AM'
  },
  {
    id: '7',
    sender: 'NebulaNinja',
    content: 'I can play all day Saturday, but Sunday I\'ll only be free after 6 PM.',
    time: '10:50 AM'
  },
  {
    id: '8',
    sender: 'AstralHunter',
    content: 'Does anyone want to practice some team compositions tonight?',
    time: '10:55 AM'
  },
  {
    id: '9',
    sender: 'VoidWalker',
    content: 'I\'m down for practice! Around 8 PM works for me.',
    time: '11:02 AM'
  },
  {
    id: '10',
    sender: 'StarDust',
    content: 'Make sure to use your tickets everyone, we need all 30 matches!',
    time: '11:15 AM'
  }
];