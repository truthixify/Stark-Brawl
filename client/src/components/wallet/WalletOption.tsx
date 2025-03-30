import React from 'react';

type WalletOptionProps = {
    name: string;
    icon: string;
    onClick: () => void;
};

export const WalletOption: React.FC<WalletOptionProps> = ({ name, icon, onClick }) => {
    return (
        <button
            onClick={onClick}
            className="w-full flex items-center justify-between p-3 rounded-lg 
                 bg-gray-700 hover:bg-gray-600 transition-colors duration-200
                 text-white border border-gray-600"
        >
            <div className="flex items-center">
                <div className="w-8 h-8 flex items-center justify-center rounded-full overflow-hidden bg-white">
                    <img src={icon} alt={name} className="w-8 h-8 object-contain" />
                </div>
                <span className="ml-3 font-medium">{name}</span>
            </div>

            {/* Copy/connect icon */}
            <div className="text-gray-400">
                <img
                    src="/wallets/wallet.svg"
                    className="w-6 h-6 mr-2"
                />
            </div>
        </button>
    );
};
