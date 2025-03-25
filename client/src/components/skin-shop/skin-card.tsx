import React, { useState } from "react";
import SkinModal from "./skin-details-modal";

interface Skin {
  name: string;
  description: string;
  price: number;
  rarity: "COMMON" | "RARE" | "EPIC" | "LEGENDARY";
  image: string;
  discountedPrice?: number;
}

const skins: Skin[] = [
  {
    name: "Cyber Samurai",
    description: "Futuristic samurai skin with neon effects and unique animations.",
    price: 149,
    rarity: "EPIC",
    image: "/nft1.png",
  },
  {
    name: "Desert Warrior",
    description: "Sand-themed warrior with unique desert storm abilities.",
    price: 100,
    discountedPrice: 80,
    rarity: "RARE",
    image: "/nft2.png",
  },
  {
    name: "Golden Gladiator",
    description: "Exclusive golden skin with special effects and animations.",
    price: 299,
    rarity: "LEGENDARY",
    image: "/nft3.png",
  },
  {
    name: "Shadow Ninja",
    description: "Stealthy ninja with smoke dash and shadow blend.",
    price: 129,
    rarity: "RARE",
    image: "/nft4.png",
  },
  {
    name: "Frost Mage",
    description: "Mage with freezing aura and snowy animations.",
    price: 159,
    rarity: "EPIC",
    image: "/nft5.png",
  },
  {
    name: "Jungle Beast",
    description: "Savage beast with wild roar and jungle camo effects.",
    price: 199,
    rarity: "LEGENDARY",
    image: "/nft6.png",
  },
];

const SkinCard = () => {
  const [selectedSkin, setSelectedSkin] = useState<Skin | null>(null);

  return (
    <>
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 p-6">
        {skins.map((skin, index) => (
          <div
            key={index}
            className="rounded-xl p-4 shadow-lg bg-gradient-to-br from-purple-600 to-indigo-800 text-white cursor-pointer hover:scale-105 transition"
            onClick={() => setSelectedSkin(skin)}
          >
            <div className="flex justify-between items-center mb-3">
              <span className="text-xs bg-blue-500 px-2 py-1 rounded-full uppercase text-white font-bold">
                {skin.rarity}
              </span>
            </div>
            <img
              src={skin.image}
              alt={skin.name}
              className="mx-auto mb-4 h-20"
            />
            <h2 className="text-lg font-bold">{skin.name}</h2>
            <p className="text-sm opacity-80">{skin.description}</p>
            <div className="flex justify-between items-center mt-4">
              <div>
                {skin.discountedPrice ? (
                  <div>
                    <p className="line-through text-sm text-red-300">
                      💎 {skin.price}
                    </p>
                    <p className="text-green-300 font-bold">
                      💎 {skin.discountedPrice} (-{100 - Math.round((skin.discountedPrice / skin.price) * 100)}%)
                    </p>
                  </div>
                ) : (
                  <p className="font-bold">💎 {skin.price}</p>
                )}
              </div>
              <button className="bg-orange-400 hover:bg-orange-500 text-white font-bold px-4 py-2 rounded-xl">
                + Add
              </button>
            </div>
          </div>
        ))}
      </div>

      <SkinModal skin={selectedSkin} onClose={() => setSelectedSkin(null)} />
    </>
  );
};

export default SkinCard;
