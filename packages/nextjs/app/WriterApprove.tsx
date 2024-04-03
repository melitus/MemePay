"use client";

import deployedContracts from "~~/contracts/deployedContracts";
import { useScaffoldContractWrite } from "~~/hooks/scaffold-eth";

export function WriterApprove({ chainId }: { chainId: number }) {
  const id = chainId == 31337 ? 31337 : 11155111;

  const { writeAsync, isLoading } = useScaffoldContractWrite({
    contractName: "Token",
    functionName: "approve",
    args: [deployedContracts[id].StakeV1.address, BigInt(1e40)],
    blockConfirmations: 1,
    onBlockConfirmation: (txnReceipt: { blockHash: any }) => {
      console.log("Transaction blockHash", txnReceipt.blockHash);
    },
  });
  return (
    <>
      <button disabled={isLoading} className="btn btn-primary" onClick={() => writeAsync()}>
        Approve
      </button>
      {/* <button className="btn btn-primary" onClick={() => writeAsync()}>
              Send TX
            </button> */}
    </>
  );
}
