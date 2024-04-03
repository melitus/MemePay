"use client";

import { useState } from "react";
import { EtherInput } from "~~/components/scaffold-eth";
import { useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

export function WriterDeposit() {
  const [ethAmount, setEthAmount] = useState("");
  const { writeAsync, isLoading } = useScaffoldContractWrite({
    contractName: "StakeV1",
    functionName: "deposit",
    args: [BigInt(Number(ethAmount) * 1000000000000000000)],
    blockConfirmations: 1,
    onBlockConfirmation: (txnReceipt: { blockHash: any }) => {
      console.log("Transaction blockHash", txnReceipt.blockHash);
    },
  });
  return (
    <>
      <EtherInput value={ethAmount} onChange={amount => setEthAmount(amount)} />
      <button disabled={isLoading} className="btn btn-primary" onClick={() => writeAsync()}>
        Deposit
      </button>
      {/* <button className="btn btn-primary" onClick={() => writeAsync()}>
              Send TX
            </button> */}
    </>
  );
}
