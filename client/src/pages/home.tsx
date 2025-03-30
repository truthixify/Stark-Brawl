import React, { useState } from 'react';
import { WalletModal } from '../components/wallet/WalletModal';
import { GameBackground } from '../components/ui/GameBackground';

const HomePage: React.FC = () => {
    const [isModalOpen, setIsModalOpen] = useState(true);

    return (
        <div className="relative w-full h-screen overflow-hidden">
            <GameBackground />
            
            {/* Content container */}
            <div className="absolute inset-0 flex flex-col items-center justify-center">
                <div className="text-center mb-8">
                    <h1 className="text-5xl font-bold text-white drop-shadow-lg mb-4">STARK BRAWL</h1>
                    <p className="text-xl text-white drop-shadow-md">
                        Connect your wallet to start playing
                    </p>
                </div>
                
                {/* Button to open modal (hidden if modal is already open) */}
                {!isModalOpen && (
                    <button
                        onClick={() => setIsModalOpen(true)}
                        className="px-8 py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-lg 
                                            shadow-lg transition duration-300 ease-in-out transform hover:scale-105"
                    >
                        Connect Wallet
                    </button>
                )}
            </div>

            {/* Wallet connection modal */}
            <WalletModal 
                isOpen={isModalOpen}
                onClose={() => setIsModalOpen(false)}
            />
        </div>
    );
};

export default HomePage;
