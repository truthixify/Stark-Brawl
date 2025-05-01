"use client"

import {
  createContext,
  useContext,
  useState,
  useEffect,
  type ReactNode,
} from "react"
import { connect, disconnect } from "starknetkit"
import type { StarknetWindowObject, StarknetkitConnector } from "starknetkit"

// Extended interface to fix type errors by adding missing properties
interface ExtendedStarknetWindowObject extends StarknetWindowObject {
  isConnected?: boolean
  account?: {
    address: string
  }
  enable?: (options?: { starknetVersion: string }) => Promise<any>
}

interface WalletContextType {
  wallet: ExtendedStarknetWindowObject | null
  address: string | undefined
  isConnecting: boolean
  error: string | null
  connectWallet: (walletId: string) => Promise<void>
  disconnectWallet: () => Promise<void>
}

const WalletContext = createContext<WalletContextType | undefined>(undefined)

export function useWallet() {
  const context = useContext(WalletContext)
  if (!context) {
    throw new Error("useWallet must be used within a WalletProvider")
  }
  return context
}

interface WalletProviderProps {
  children: ReactNode
}

export function WalletProvider({ children }: WalletProviderProps) {
  const [wallet, setWallet] = useState<ExtendedStarknetWindowObject | null>(
    null
  )
  const [address, setAddress] = useState<string | undefined>(undefined)
  const [isConnecting, setIsConnecting] = useState(false)
  const [error, setError] = useState<string | null>(null)

  // Try to restore a previous session on mount
  useEffect(() => {
    const checkExistingConnection = async () => {
      try {
        const result = await connect({
          modalMode: "neverAsk",
          dappName: "Stark Brawl",
        })

        const existingWallet = result.wallet as ExtendedStarknetWindowObject

        if (existingWallet && existingWallet.isConnected) {
          console.log("Found existing wallet connection:", existingWallet)
          setWallet(existingWallet)

          if (existingWallet.account) {
            setAddress(existingWallet.account.address)
          }
        }
      } catch (error) {
        console.error("Failed to restore wallet connection:", error)
      }
    }

    checkExistingConnection()
  }, [])

  const connectWallet = async (walletId: string) => {
    setIsConnecting(true)
    setError(null)

    try {
      console.log(`Attempting to connect to wallet: ${walletId}`)

      let selectedConnector: StarknetkitConnector
      switch (walletId) {
        case "argent":
        case "argentX":
          selectedConnector = { id: "argentX" } as StarknetkitConnector
          break
        case "braavos":
          selectedConnector = { id: "braavos" } as StarknetkitConnector
          break
        case "okx":
        case "okxwallet":
          selectedConnector = { id: "okxwallet" } as StarknetkitConnector
          break
        case "metamask":
          selectedConnector = {
            id: "starknetMetaMask",
          } as StarknetkitConnector
          break
        default:
          selectedConnector = { id: walletId } as StarknetkitConnector
      }

      const result = await connect({
        modalMode: "neverAsk",
        webWalletUrl: "https://web.argent.xyz",
        dappName: "Stark Brawl",
        connectors: [selectedConnector],
      })

      const connectedWallet = result.wallet as ExtendedStarknetWindowObject

      if (connectedWallet) {
        console.log("Wallet connected successfully:", connectedWallet);
        setWallet(connectedWallet);
      
        try {
          if (typeof connectedWallet.enable === "function") {
            await connectedWallet.enable({ starknetVersion: "v5" });
            await new Promise((res) => setTimeout(res, 500)); // Wait for wallet to populate account
          }
      
          console.log("Wallet enabled successfully");
      
          if (connectedWallet.account) {
            console.log("Account found:", connectedWallet.account);
            setAddress(connectedWallet.account.address);
          } else {
            console.error("No account found after enabling wallet");
            console.log("Connected wallet debug:", connectedWallet);
            throw new Error("No account found. Please ensure your wallet is unlocked and approved for connection.");
          }
        } catch (enableError) {
          console.error("Error enabling wallet:", enableError);
          throw new Error("Failed to enable wallet. Please make sure your wallet is unlocked.");
        }
      }
      
      // Fallback: Show modal to manually pick
      console.log("Fallback: opening modal")
      const modalResult = await connect({
        modalMode: "alwaysAsk",
        webWalletUrl: "https://web.argent.xyz",
        dappName: "Stark Brawl",
      })

      const modalWallet = modalResult.wallet as ExtendedStarknetWindowObject

      if (modalWallet) {
        setWallet(modalWallet)

        if (typeof modalWallet.enable === "function") {
          await modalWallet.enable({ starknetVersion: "v5" })
        }

        if (modalWallet.account) {
          setAddress(modalWallet.account.address)
        } else {
          throw new Error("No account found in connected wallet.")
        }
      } else {
        throw new Error("Failed to connect wallet. Please try again.")
      }
    } catch (error) {
      console.error("Wallet connection error:", error)
      setError(
        error instanceof Error
          ? error.message
          : "Failed to connect wallet. Please try again."
      )
    } finally {
      setIsConnecting(false)
    }
  }

  const disconnectWallet = async () => {
    if (wallet) {
      try {
        await disconnect()
        setWallet(null)
        setAddress(undefined)
        setError(null)
        console.log("Wallet disconnected successfully")
      } catch (error) {
        console.error("Wallet disconnection error:", error)
        setError("Failed to disconnect wallet. Please try again.")
      }
    }
  }

  const value = {
    wallet,
    address,
    isConnecting,
    error,
    connectWallet,
    disconnectWallet,
  }

  return (
    <WalletContext.Provider value={value}>{children}</WalletContext.Provider>
  )
}
