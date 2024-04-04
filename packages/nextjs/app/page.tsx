"use client";

import { ReadBalance } from "./ReadBalance";
import { ReadOptions } from "./ReadOptions";
import { ReadRewards } from "./ReadRewards";
import { ReadStake } from "./ReadStake";
import { WriterAddWhiteList } from "./WriterAddWhiteList";
import { WriterApprove } from "./WriterApprove";
import { WriterClaim } from "./WriterClaim";
import { WriterDeposit } from "./WriterDeposit";
import { WriterWithdraw } from "./WriterWithdraw";
import type { NextPage } from "next";
import { useAccount, useNetwork } from "wagmi";
import { Address } from "~~/components/scaffold-eth";

// function ReadAllowed({ address }: { address: string }) {
//   const { data } = useScaffoldContractRead({
//     contractName: "Airdrop",
//     functionName: "allowed",
//     args: [address],
//   });
//   if (data) {
//     return <p>loading</p>;
//   }
//   return <>Allowed:{`${data}`}</>;
// }

// function ReadClaimed({ address }: { address: string }) {
//   const { data } = useScaffoldContractRead({
//     contractName: "Airdrop",
//     functionName: "claimed",
//     args: [address],
//   });
//   return <>claimed:{`${data}`}</>;
// }

const Home: NextPage = () => {
  const { chain } = useNetwork();
  const { address: connectedAddress, isConnected } = useAccount();

  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="px-5">
          <h1 className="text-center">
            <span className="block text-4xl font-bold">MemeToken Airdrop 🐸</span>
          </h1>
          <div className="flex justify-center items-center space-x-2">
            <p className="my-2 font-medium">Connected Address:</p>
            <Address address={connectedAddress} />
          </div>
          <div className="flex justify-center items-center space-x-2">{isConnected && <ReadOptions />}</div>
          <div className="flex justify-center items-center space-x-2">
            <h1>1: Add address to whitelist:</h1>
            {isConnected && connectedAddress && <WriterAddWhiteList address={connectedAddress} />}
            {/* {isConnected && connectedAddress && <ReadAllowed address={connectedAddress} />} */}
          </div>
          <div className="flex justify-center items-center space-x-2">
            <h1>2: Get tokens from airdrop:</h1>
            {isConnected && connectedAddress && <WriterClaim address={connectedAddress} />}
          </div>
          <div className="flex justify-center items-center space-x-2">
            {isConnected && connectedAddress && <ReadBalance address={connectedAddress} />}
          </div>
          <div className="flex justify-center items-center space-x-2">
            <h1>3: Approve token for deposit to stake:</h1>
            {isConnected && chain && <WriterApprove chainId={chain.id} />}
          </div>
          <div className="flex justify-center items-center space-x-2"></div>

          <div className="flex justify-center items-center space-x-2">
            <h1>4: Deposit the tokens for stake</h1>
            {isConnected && <WriterDeposit />}
          </div>
          {/* <div className="flex justify-center items-center space-x-2">
            {isConnected && connectedAddress && <ReadAllowed address={connectedAddress} />}
          </div>
          <div className="flex justify-center items-center space-x-2">
            {isConnected && connectedAddress && <ReadClaimed address={connectedAddress} />}
          </div> */}

          <div className="flex justify-center items-center space-x-2">
            {isConnected && connectedAddress && <ReadStake address={connectedAddress} />}
            {isConnected && connectedAddress && <ReadRewards address={connectedAddress} />}
          </div>
          <div className="flex justify-center items-center space-x-2">{isConnected && <WriterWithdraw />}</div>
        </div>
      </div>
    </>
  );
};

export default Home;
