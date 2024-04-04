"use client";

import { useScaffoldContractRead } from "~~/hooks/scaffold-eth";

export function ReadRewards({ address }: { address: string }) {
  const { data } = useScaffoldContractRead({
    contractName: "StakeV1",
    functionName: "rewards",
    args: [address],
  });
  console.log({ data }, { address });
  const result = `${data}`.split(",");
  return (
    <>
      <p>Rewards:{result[0]}</p>
    </>
  );
}
