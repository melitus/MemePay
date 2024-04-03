"use client";

import { useScaffoldContractRead } from "~~/hooks/scaffold-eth";

export function ReadBalance({ address }: { address: string }) {
  const { data } = useScaffoldContractRead({
    contractName: "Token",
    functionName: "balanceOf",
    args: [address],
  });
  return (
    <>
      <p>TK balance:{`${Number(data) / 1000000000000000000}`}</p>
    </>
  );
}
