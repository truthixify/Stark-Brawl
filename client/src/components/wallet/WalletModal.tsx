import React from 'react';
import { WalletOption } from './WalletOption';
import { FeatureCard } from './FeatureCard';

type WalletModalProps = {
    isOpen: boolean;
    onClose: () => void;
};
// Importing necessary styles or additional dependencies if required
export const WalletModal: React.FC<WalletModalProps> = ({ isOpen, onClose }) => {
    if (!isOpen) return null;

    // Supported wallets data (for the example)
    const wallets = [
        { id: 'argent', name: 'Argent X', icon: '/wallets/argent.svg' },
        { id: 'braavos', name: 'Braavos', icon: '/wallets/braavos.png' },
        { id: 'okx', name: 'OKX Wallet', icon: '/wallets/okx.svg' },
        { id: 'metamask', name: 'MetaMask Starknet', icon: '/wallets/metamask.svg' },
    ];

    // Onchain features for the example
    const features = [
        { id: 'nft', name: 'Brawlers NFT', icon: '/features/nft.png', color: 'bg-purple-600' },
        { id: 'token', name: 'Token BRAWLS', icon: '/features/token.png', color: 'bg-blue-600' },
        { id: 'marketplace', name: 'Marketplace', icon: '/features/marketplace.png', color: 'bg-green-600' },
        { id: 'p2e', name: 'Play-to-Earn', icon: '/features/p2e.png', color: 'bg-yellow-600' },
    ];

    return (
        <div className="fixed inset-0 flex items-center justify-center z-50">
            {/* Backdrop with blur effect */}
            <div 
                className="absolute inset-0 bg-black bg-opacity-50 backdrop-blur-sm"
                onClick={onClose}
            />
            
            {/* Modal container */}
            <div 
                className="relative bg-gradient-to-b from-gray-900 to-gray-800 rounded-xl shadow-2xl 
                                    max-w-md w-full mx-4 overflow-hidden border border-gray-700"
                onClick={(e) => e.stopPropagation()}
            >
                {/* Logo and title */}
                <div className="flex items-center p-4 border-b border-gray-700">
                    <div className="flex items-center">
                        <img 
                            src="/1.png" 
                            alt="Stark Brawl" 
                            className="w-8 h-8 mr-2"
                        />
                        <div className="text-white font-bold">STARKNET EDITION</div>
                    </div>
                    <button 
                        onClick={onClose}
                        className="ml-auto text-gray-400 hover:text-white"
                    >
                        <span className="sr-only">Close</span>
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>
                
                {/* Modal content */}
                <div className="p-6">
                    <h2 className="text-2xl font-bold text-white mb-1">Connect Your Wallet</h2>
                    <p className="text-gray-300 mb-6">
                        Connect your Starknet wallet to play and manage your onchain assets
                    </p>
                    {/* Wallet list */}
                    <div className="space-y-3 mb-8">
                        {wallets.map(wallet => (
                            <WalletOption 
                                key={wallet.id} 
                                name={wallet.name} 
                                icon={wallet.icon} 
                                onClick={() => console.log(`Connecting to ${wallet.name}...`)} 
                            />
                        ))}
                    </div>
                    
                    {/* Separator */}
                    <div className="relative my-8">
                        <div className="absolute inset-0 flex items-center">
                            <div className="w-full border-t border-gray-600"></div>
                        </div>
                        <div className="relative flex justify-center">
                            <span className="bg-gray-800 px-3 text-sm text-gray-400">
                                Onchain Features
                            </span>
                        </div>
                    </div>
                    
                    {/* Feature cards */}
                    <div className="grid grid-cols-2 gap-4">
                        {features.map(feature => (
                            <FeatureCard 
                                key={feature.id}
                                name={feature.name}
                                icon={feature.icon}
                                color={feature.color}
                            />
                        ))}
                    </div>
                </div>
            </div>
        </div>
    );
};
