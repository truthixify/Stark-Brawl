"use client"

import type React from "react"
import { useState, useEffect } from "react"
import { WalletModal } from "../components/wallet/WalletModal"
import { GameBackground } from "../components/ui/GameBackground"
import { WalletProvider, useWallet } from "@/components/contexts/WalletContext"

// Inner component that uses wallet context
const HomeContent: React.FC = () => {
  const [isModalOpen, setIsModalOpen] = useState(false)
  const { address, disconnectWallet, error } = useWallet()
  
  // Show modal on first load if not connected
  useEffect(() => {
    const timer = setTimeout(() => {
      if (!address) {
        setIsModalOpen(true)
      }
    }, 1000); // Small delay to allow checking for existing connections
    
    return () => clearTimeout(timer);
  }, [address]);

  // Show modal if there's an error
  useEffect(() => {
    if (error) {
      setIsModalOpen(true);
    }
  }, [error]);
  
  return (
    <div className="relative w-full h-screen overflow-hidden">
      <GameBackground />

      {/* Wallet connection modal */}
      <WalletModal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} />

      {/* Navigation bar with wallet status */}
      <div className="absolute top-0 left-0 right-0 px-4 py-3 flex justify-between items-center z-10">
        <div className="flex items-center">
          <img src="/1.png" alt="Stark Brawl" className="w-8 h-8 mr-2" />
          <h1 className="text-white font-bold">STARK BRAWL</h1>
        </div>
        
        {address ? (
          <div className="flex items-center space-x-2">
            <div className="bg-gray-800 bg-opacity-70 px-3 py-1.5 rounded-lg text-white text-sm">
              {address.substring(0, 6)}...{address.substring(address.length - 4)}
            </div>
            <button 
              onClick={disconnectWallet}
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
  )
}

// Wrapper component that provides the wallet context
const HomePage: React.FC = () => {
  return (
    <WalletProvider>
      <HomeContent />
    </WalletProvider>
  )
}

export default HomePage