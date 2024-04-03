"use client";

import { useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

export function WriterClaim({ address }: { address: string }) {
  const { writeAsync, isLoading } = useScaffoldContractWrite({
    contractName: "Airdrop",
    functionName: "claim",
    args: [address],
    blockConfirmations: 1,
    onBlockConfirmation: (txnReceipt: { blockHash: any }) => {
      console.log("Transaction blockHash", txnReceipt.blockHash);
    },
  });
  return (
    <>
      <button disabled={isLoading} className="btn btn-primary" onClick={() => writeAsync()}>
        claim
      </button>
    </>
  );
}
