"use client";

import { useScaffoldContractRead } from "~~/hooks/scaffold-eth";

export function ReadStake({ address }: { address: string }) {
  const { data } = useScaffoldContractRead({
    contractName: "StakeV1",
    functionName: "stake",
    args: [address],
  });
  const result = `${data}`.split(",");
  return (
    <>
      <p>Deposit:{Number(result[1]) / 1000000000000000000}</p>
    </>
  );
}
