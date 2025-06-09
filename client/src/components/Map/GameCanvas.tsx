import React from "react";

export default function GameCanvas({ children }: { children: React.ReactNode;}) {
    return (
        <div className="relative w-full h-screen overflow-hidden">
            {children}
        </div>
    )
}