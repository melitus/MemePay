"use client";

import Countdown from "~~/components/Countdown";
import { useScaffoldContractRead } from "~~/hooks/scaffold-eth";

export function ReadOptions() {
  const { data } = useScaffoldContractRead({
    contractName: "Airdrop",
    functionName: "options",
  });
  const result = `${data}`.split(",");
  return (
    <>
      <Countdown targetUnixTime={Number(result[1])} />
    </>
  );
}
