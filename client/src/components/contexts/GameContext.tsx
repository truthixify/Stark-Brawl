import React, { useContext, createContext, useState } from "react";

interface GameContextProps {
    tileSize: number;
    setTileSize: (size: number) => void;
}

const GameContext = createContext<GameContextProps | null>(null);

// eslint-disable-next-line react-refresh/only-export-components
export const useGame = () => {
    const context = useContext(GameContext);
    if (!context) throw new Error("GameContext not found");
    return context;
}

export function GameProvider({ children }: { children: React.ReactNode }) {
    const [tileSize, setTileSize] = useState(64);
    return (
        <GameContext.Provider value={{ tileSize, setTileSize }}>
            {children}
        </GameContext.Provider>
    )
}