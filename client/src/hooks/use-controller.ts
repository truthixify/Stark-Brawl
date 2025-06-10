import { useConnect, useAccount } from "@starknet-react/core";
import { useCallback } from "react";

export function useStarknetConnect() {
  const { connect, connectors } = useConnect();
  const { status } = useAccount();

  const handleConnect = useCallback(async () => {
    console.log(connectors);
    const connector = connectors[2];
    console.log(connector);
    if (!connector) return;

    await connect({ connector });
    console.log("exit");
  }, [connect, connectors]);

  return { status, handleConnect };
}
