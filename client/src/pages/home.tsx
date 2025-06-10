"use client";

import type React from "react";
import { useState, useEffect } from "react";
import { WalletModal } from "../components/wallet/WalletModal";
import { GameBackground } from "../components/ui/GameBackground";
import { useWallet, WalletProvider } from "@/components/contexts/WalletContext";
import { useAccount, useDisconnect } from "@starknet-react/core";
import { ControllerConnector } from "@cartridge/connector";

const HomeContent: React.FC = () => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [username, setUsername] = useState<string | null>(null);

  const { isConnected, connector } = useAccount();
  const { disconnect } = useDisconnect();
  const { address, disconnectWallet } = useWallet();

  useEffect(() => {
    const timer = setTimeout(() => {
      if (!isConnected) {
        setIsModalOpen(true);
      }
    }, 1000);
    return () => clearTimeout(timer);
  }, [isConnected]);

  useEffect(() => {
    const fetchUsername = async () => {
      if (
        isConnected &&
        connector?.id === "controller" &&
        connector instanceof ControllerConnector
      ) {
        try {
          const name = await connector.username();
          console.log("Fetched username:", name);
          if (name) {
            setUsername(name);
          } else {
            console.warn("Username not found (maybe not set in Cartridge?)");
            setUsername(null);
          }
        } catch (err) {
          console.error("Error fetching username from Cartridge:", err);
          setUsername(null);
        }
      } else {
        setUsername(null);
      }
    };

    fetchUsername();
  }, [isConnected, connector]);

  const handleDisconnect = async () => {
    try {
      if (address != undefined) {
        await disconnectWallet();
      } else {
        await disconnect();
      }

      setUsername(null);
    } catch (error) {
      console.error("Error disconnecting:", error);
    }
  };

  return (
    <div className="relative w-full h-screen overflow-hidden">
      <GameBackground />
      <WalletModal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} />

      <div className="absolute top-0 left-0 right-0 px-4 py-3 flex justify-between items-center z-10">
        <div className="flex items-center">
          <img src="/1.png" alt="Stark Brawl" className="w-8 h-8 mr-2" />
          <h1 className="text-white font-bold">STARK BRAWL</h1>
        </div>

        {isConnected || address != undefined ? (
          <div className="flex items-center space-x-2">
            <div className="bg-gray-800 bg-opacity-70 px-3 py-1.5 rounded-lg text-white text-sm">
              {username
                ? username
                : `${address?.slice(0, 6)}...${address?.slice(-4)}`}
            </div>
            <button
              onClick={handleDisconnect}
              className="bg-red-600 hover:bg-red-700 text-white px-3 py-1.5 rounded-lg text-sm"
            >
              Disconnect
            </button>
          </div>
        ) : (
          <button
            onClick={() => setIsModalOpen(true)}
            className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg"
          >
            Connect Wallet
          </button>
        )}
      </div>
    </div>
  );
};

const HomePage: React.FC = () => {
  return (
    <WalletProvider>
      <HomeContent />
    </WalletProvider>
  );
};

export default HomePage;
