"use client";

import { useState, useEffect } from "react";
import { WalletOption } from "./WalletOption";
import { FeatureCard } from "./FeatureCard";
import { useWallet } from "@/components/contexts/WalletContext";
import { useStarknetConnect } from "@/hooks/use-controller";

type WalletModalProps = {
  isOpen: boolean;
  onClose: () => void;
};

interface WalletAvailability {
  argent?: boolean;
  braavos?: boolean;
  okx?: boolean;
  metamask?: boolean;
  cartredge?: boolean;
}

export const WalletModal = ({ isOpen, onClose }: WalletModalProps) => {
  const {
    connectWallet,
    isConnecting,
    error: contextError,
    address,
  } = useWallet();
  const { handleConnect } = useStarknetConnect();
  const [selectedWallet, setSelectedWallet] = useState<string | null>(null);
  const [walletAvailability, setWalletAvailability] =
    useState<WalletAvailability>({
      argent: true,
      braavos: true,
      okx: true,
      metamask: true,
      cartredge: true,
    });

  const [localError, setLocalError] = useState<string | null>(null);

  useEffect(() => {
    if (isOpen && typeof window !== "undefined") {
      const checkWalletAvailability = () => {
        const availability: WalletAvailability = {
          argent: typeof window !== "undefined" && !!(window as any).argentX,
          braavos: typeof window !== "undefined" && !!(window as any).braavos,
          okx: typeof window !== "undefined" && !!(window as any).okxwallet,
          metamask:
            typeof window !== "undefined" && !!(window as any).starknetMetaMask,
        };

        console.log("Wallet availability:", availability);
        setWalletAvailability(availability);
      };

      checkWalletAvailability();
    }
  }, [isOpen]);

  useEffect(() => {
    if (address) {
      onClose();
    }
  }, [address, onClose]);

  useEffect(() => {
    if (!isOpen) {
      setSelectedWallet(null);
      setLocalError(null);
    }
  }, [isOpen]);

  useEffect(() => {
    if (contextError && !isConnecting) {
      setLocalError(contextError);
    }
  }, [contextError, isConnecting]);

  if (!isOpen) return null;

  const wallets = [
    { id: "argent", name: "Argent X", icon: "/wallets/argent.svg" },
    { id: "braavos", name: "Braavos", icon: "/wallets/braavos.png" },
    { id: "okx", name: "OKX Wallet", icon: "/wallets/okx.svg" },
    {
      id: "metamask",
      name: "MetaMask Starknet",
      icon: "/wallets/metamask.svg",
    },
    { id: "controller", name: "Controller", icon: "/wallets/controller.svg" },
  ];

  const features = [
    { id: "nft", name: "Brawlers NFT", icon: "/features/nft.png" },
    { id: "token", name: "Token BRAWLS", icon: "/features/token.png" },
    {
      id: "marketplace",
      name: "Marketplace",
      icon: "/features/marketplace.png",
    },
    { id: "p2e", name: "Play-to-Earn", icon: "/features/p2e.png" },
  ];

  const handleConnectWallet = async (walletId: string) => {
    try {
      setLocalError(null);
      setSelectedWallet(walletId);

      await connectWallet(walletId);
    } catch (error) {
      console.error("Error in handleConnectWallet:", error);
    }
  };

  const displayError = localError || contextError;

  return (
    <div className="fixed inset-0 flex items-center justify-center z-50">
      <div
        className="absolute inset-0 bg-black bg-opacity-20"
        onClick={onClose}
      />

      <div
        className="relative bg-black bg-opacity-50 rounded-xl shadow-2xl max-w-sm w-full overflow-hidden border border-gray-700"
        onClick={(e) => e.stopPropagation()}
        style={{ maxWidth: "380px" }}
      >
        <div className="flex items-center p-3 border-b border-gray-800">
          <div className="flex items-center">
            <img src="/1.png" alt="Stark Brawl" className="w-7 h-7 mr-2" />
            <div className="text-white font-bold text-sm">STARKNET EDITION</div>
          </div>
          <button
            onClick={onClose}
            className="ml-auto text-gray-400 hover:text-white"
          >
            <span className="sr-only">Sound</span>
            <img src="/sound.svg" alt="Sound toggle" />
          </button>
        </div>

        <div className="p-4">
          <h2 className="text-xl font-bold text-white mb-1 text-center">
            Connect Your Wallet
          </h2>
          <p className="text-gray-300 mb-4 text-sm text-center">
            Connect your Starknet wallet to play and manage your onchain assets
          </p>

          {displayError && (
            <div className="bg-red-500/20 border border-red-500 text-red-200 px-3 py-2 rounded-md mb-4 text-xs">
              {displayError}
            </div>
          )}

          <div className="space-y-2 mb-6">
            {wallets.map((wallet) => (
              <WalletOption
                key={wallet.id}
                name={wallet.name}
                icon={wallet.icon}
                isLoading={isConnecting && selectedWallet === wallet.id}
                onClick={() => {
                  if (wallet.id === "controller") {
                    console.log("handle connect");
                    handleConnect();
                  } else {
                    handleConnectWallet(wallet.id);
                  }
                }}
                disabled={
                  walletAvailability[wallet.id as keyof WalletAvailability] ===
                    false ||
                  (isConnecting && selectedWallet !== wallet.id)
                }
              />
            ))}
          </div>

          <div className="relative mb-4">
            <div className="border-t border-gray-700"></div>
            <div className="flex justify-center -mt-2.5">
              <span className="bg-black px-3 text-xs text-gray-400">
                Onchain Features
              </span>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            {features.map((feature) => (
              <FeatureCard
                key={feature.id}
                name={feature.name}
                icon={feature.icon}
              />
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};
