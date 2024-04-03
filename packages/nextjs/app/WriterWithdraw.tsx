"use client";

import { useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

export function WriterWithdraw() {
  const { writeAsync, isLoading } = useScaffoldContractWrite({
    contractName: "StakeV1",
    functionName: "withdraw",
    blockConfirmations: 1,
    onBlockConfirmation: (txnReceipt: { blockHash: any }) => {
      console.log("Transaction blockHash", txnReceipt.blockHash);
    },
  });
  return (
    <>
      <button disabled={isLoading} className="btn btn-primary" onClick={() => writeAsync()}>
        withdraw
      </button>
    </>
  );
}
