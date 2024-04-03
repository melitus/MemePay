//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./DeployHelpers.s.sol";
import {Token} from "../contracts/Token.sol";
import {Airdrop} from "../contracts/Airdrop.sol";
import {StakeV1} from "../contracts/StakeV1.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);
    address[] _address;

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
 console.logString(
            string.concat("deployer key: ", vm.toString(deployerPrivateKey))
        );
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }
        vm.startBroadcast(deployerPrivateKey);
        Token token = new Token(
            vm.addr(deployerPrivateKey),
            vm.addr(deployerPrivateKey)
        );
        console.logString(
            string.concat("Token deployed at: ", vm.toString(address(token)))
        );
        vm.stopBroadcast();

        vm.startBroadcast(deployerPrivateKey);
        Airdrop airdrop = new Airdrop(
            address(token),
            10e18,
            _address,
            block.timestamp,
            block.timestamp + 2592000
        );
        console.logString(
            string.concat(
                "Airdrop deployed at: ",
                vm.toString(address(airdrop))
            )
        );
        vm.stopBroadcast();

        vm.startBroadcast(deployerPrivateKey);
        StakeV1 stake = new StakeV1(address(token), 1e3);
        console.logString(
            string.concat("StakeV1 deployed at: ", vm.toString(address(stake)))
        );
        vm.stopBroadcast();
        /**
         * This function generates the file containing the contracts Abi definitions.
         * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
         * This function should be called last.
         */
        exportDeployments();
    }

    function test() public {}
}
