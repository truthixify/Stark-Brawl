// Define interfaces for each map type
export interface OfficialMap {
    featured?:boolean,
    name: string;
    mode: string;
    status: string;
    likes: number | null;
    dislikes: number | null; // Used as plays in the UI
    players: number | null;
  }
  
  export interface CommunityMap {
    featured?:boolean,
    name: string;
    mode: string;
    creator?: string;
    status?: string; // Used for "Featured" badge
    created: string;
    likes: number | null;
    dislikes: number | null;
    players: number | null;
  }
  
  export interface MyMap {
    type:string;
    name: string;
    mode: string;
    published?:boolean;
    status: string; // "Published" or "Draft"
    lastEdited: string;
    likes: number | null;
    dislikes: number | null;
    players: number | null;
  }
  
  export interface MapsData {
    official: OfficialMap[];
    community: CommunityMap[];
    mine: MyMap[];
  }
  
  export const mapsData: MapsData = {
    official: [
      {
        featured:true,
        name: "Crystal Cavern",
        mode: "Gem Grab",
        status: "Current",
        likes: 24680,
        dislikes: 1250000,
        players: null,
      },
      {
        name: "Forsaken Falls",
        mode: "Showdown",
        status: "In 2 hours",
        likes: 22450,
        dislikes: 980000,
        players: null,
      },
      {
        name: "Super Stadium",
        mode: "Brawl Ball",
        status: "In 4 hours",
        likes: null,
        dislikes: null,
        players: null,
      },
      {
        name: "Lunar Base",
        mode: "Bounty",
        status: "In 6 hours",
        likes: 18000,
        dislikes: 750000,
        players: null,
      },
      {
        name: "Starlight Plains",
        mode: "Heist",
        status: "In 8 hours",
        likes: 19500,
        dislikes: 820000,
        players: null,
      },
      {
        name: "Meteor Shower",
        mode: "Siege",
        status: "In 10 hours",
        likes: 21000,
        dislikes: 900000,
        players: null,
      },
      {
        name: "Galactic Core",
        mode: "Hot Zone",
        status: "In 12 hours",
        likes: 23000,
        dislikes: 950000,
        players: null,
      },
    ],
    community: [
      {
        featured:true,
        name: "Skull Creek",
        mode: "Showdown",
        creator: "SuperNova42",
        status: "Featured",
        created: "2 days ago",
        likes: 8750,
        dislikes: 1230,
        players: 45000,
      },
      {
        name: "Gem Factory",
        mode: "Gem Grab",
        creator: "GalaxyWarrior",
        created: "3 days ago",
        likes: 7650,
        dislikes: 980,
        players: 38000,
      },
      {
        name: "Twisted Tunnels",
        mode: "Brawl Ball",
        creator: "CosmicEntity",
        created: "5 days ago",
        likes: 400,
        dislikes: 1280,
        players: 34300,
      },
      {
        name: "Frosty Peaks",
        mode: "Bounty",
        creator: "StarBlazer",
        created: "1 week ago",
        likes: 6500,
        dislikes: 850,
        players: 32000,
      },
      {
        name: "Echo Caverns",
        mode: "Heist",
        creator: "NovaKnight",
        created: "4 days ago",
        likes: 7200,
        dislikes: 1100,
        players: 40000,
      },
      {
        name: "Shadow Realm",
        mode: "Siege",
        creator: "DarkMatter",
        created: "6 days ago",
        likes: 5800,
        dislikes: 900,
        players: 35000,
      },
      {
        name: "Neon Circuit",
        mode: "Hot Zone",
        creator: "CyberSmith",
        created: "3 days ago",
        likes: 8000,
        dislikes: 1200,
        players: 42000,
      },
    ],
    mine: [
      {
        type:"Published",
        name: "Cosmic Arena",
        mode: "Gem Grab",
        status: "Published",
        lastEdited: "5 days ago",
        likes: 1250,
        dislikes: 320,
        players: 8500,
      },
      {
        type:"Draft",
        name: "Asteroid Belt",
        mode: "Showdown",
        status: "Published",
        lastEdited: "1 week ago",
        likes: 980,
        dislikes: 210,
        players: 6200,
      },
      {
        type:"Draft",
        name: "Nebula Nexus",
        mode: "Brawl Ball",
        status: "Draft",
        lastEdited: "1 day ago",
        likes: null,
        dislikes: null,
        players: null,
      },
      {
        type:"Draft",
        name: "Stellar Drift",
        mode: "Bounty",
        status: "Published",
        lastEdited: "2 days ago",
        likes: 1100,
        dislikes: 280,
        players: 7500,
      },
      {
        type:"Published",
        name: "Quantum Rift",
        mode: "Heist",
        status: "Draft",
        lastEdited: "3 days ago",
        published:true,
        likes: 1100,
        dislikes: 280,
        players: 7500,
      },
      {
        type:"Draft",
        name: "Solar Flare",
        mode: "Siege",
        status: "Published",
        lastEdited: "4 days ago",
        likes: 900,
        dislikes: 190,
        players: 5800,
      },
      {type:"Draft",
        name: "Dark Nebula",
        published:true,
        mode: "Hot Zone",
        status: "Draft",
        lastEdited: "6 days ago",
        likes: 1100,
        dislikes: 280,
        players: 7500,
      },
    ],
  };