# 🏆 Stark Brawl - Offline Wave-Based Shooter with Blockchain on Starknet and Dojo

🔥 **Stark Brawl** is an **offline** shooter where players face **waves of enemies**, using NFT characters on **Starknet**. The game integrates **Dojo**, an on-chain game engine in Cairo, allowing game mechanics to be managed in a decentralized way while remaining a fully local experience.

---

## 📌 Features

- **Offline gameplay** with no multiplayer or online requirements.
- **Wave-based enemies** with increasing difficulty.
- **Starknet integration** for NFT character ownership.
- **Cairo + Dojo contracts** to store player progression on-chain.
- **Reward system** with tokens for surviving more waves.
- **2D graphics** with **PixiJS/Phaser.js**.
- **Web3 wallet connection** (Argent X, Braavos).

---

## ⚙️ Technologies Used

| Component      | Technology               |
|---------------|--------------------------|
| **Frontend**  | React + Vite + TypeScript |
| **Graphics**  | PixiJS or Phaser.js       |
| **Blockchain** | Starknet + Cairo + Dojo  |
| **Local State** | localStorage + IndexedDB |
| **Contracts** | Starknet.js + Dojo        |

---

## 🛠 Installation and Setup

### 📋 Prerequisites

Ensure you have the following installed:

- **Node.js** (>= 16.x)
- **npm** or **yarn**
- **Starknet Wallet Extension** (Argent X or Braavos)
- **Dojo CLI** (to compile Cairo contracts)

Install Dojo:

```sh
curl -L https://install.dojoengine.org | bash
📥 Clone the Repository
  git clone https://github.com/youruser/stark-brawl.git
  cd stark-brawl
📦 Install Dependencies
  npm install
  # or
  yarn install
🚀 Run the Project
  npm run dev
  # or
  yarn dev
  Open http://localhost:3000/ in your browser to play.
```

🔗 Blockchain Implementation with Dojo
  This project uses Dojo to handle on-chain game logic on Starknet. The Cairo contracts store:

Ownership of characters as NFTs.
  Player progression (waves survived, rewards earned).
  Token system for upgrades and skins.
  
  📜 Deploying Contracts with Dojo
  🏗️ Compile Cairo Contracts
    cd contract
    dojo build

🚀 Deploy to Starknet Testnet
    dojo deploy --network testnet
    
🔗 Connect the Frontend to the Contracts
    Update contract addresses in client/src/blockchain/config.ts:
    export const CONTRACT_ADDRESS = "0xYOUR_CONTRACT";
    export const NETWORK = "testnet";

🎮 How to Play
  Log in with your Starknet wallet.
  Select your NFT character.
  Survive waves of enemies and earn token rewards.
  Use tokens to upgrade skills or buy NFT skins.

```
📜 Project Structure
stark-brawl/
│── client/                 # Frontend (React + Vite)
│   ├── public/             # Static assets (images, sounds, etc.)
│   ├── src/
│   │   ├── assets/         # Game assets (sprites, animations, etc.)
│   │   ├── components/     # UI Components (buttons, HUD, menus)
│   │   ├── game/           # Game logic (PixiJS/Phaser.js)
│   │   ├── hooks/          # Custom React hooks
│   │   ├── blockchain/     # Starknet smart contract interactions
│   │   ├── utils/          # Utility functions
│   │   ├── styles/         # Global styles
│   │   ├── App.tsx         # Main React App
│   │   ├── main.tsx        # React root rendering
│   │   ├── config.ts       # Game configuration settings
│   ├── index.html          # Main HTML file
│   ├── vite.config.ts      # Vite configuration
│   ├── package.json        # Project dependencies
│   ├── tsconfig.json       # TypeScript configuration
│── contract/               # Smart Contracts (Cairo + Dojo)
│   ├── src/
│   │   ├── components/     # Dojo components (NFTs, Tokens, etc.)
│   │   ├── systems/        # Game logic in Cairo
│   │   ├── resources/      # Game state management
│   ├── manifest.yaml       # Dojo contract manifest
│   ├── Scarb.toml          # Scarb package manager config
│   ├── Makefile            # Automation scripts
│── .gitignore              # Git ignored files
│── README.md               # Project documentation
│── LICENSE                 # License file
```

🤝 Contributions
  If you want to contribute, fork the repository, create a new branch with your changes, and submit a pull request.
    git checkout -b my-new-feature
    git commit -m "Added new feature"
    git push origin my-new-feature

All contributions are welcome! 🚀
