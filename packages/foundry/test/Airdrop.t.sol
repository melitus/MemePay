// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity >=0.8.0 <0.9.0;
import "forge-std/Test.sol";
import {Token} from "../contracts/Token.sol";
import {Airdrop} from "../contracts/Airdrop.sol";
import {Stake} from "../contracts/Stake.sol";

contract AirdropTest is Test {
    address admin = makeAddr("admin");
    address minter = makeAddr("minter");
    address user = makeAddr("user");
    Token token;
    Airdrop airdrop;
    Stake stake;
    address[] _address;

    function setUp() public {
        _address.push(user);
        for (uint256 i = 1; i < 1e4; i++) {
            _address.push(address(0));
        }

        token = new Token(admin, minter);
        airdrop = new Airdrop(address(token), 10e18, _address, 1, 10);
        stake = new Stake(address(token), address(token));
        vm.prank(minter);
        token.mint(address(airdrop), 1e28);
        vm.stopPrank();
        vm.prank(minter);
        token.mint(address(stake), 1e50);
        vm.stopPrank();
    }

    function test_mint_depoist() public view {
        uint256 balanceOfAirdrop = token.balanceOf(address(airdrop));
        assertEq(balanceOfAirdrop, 1e28);
        uint256 balanceOfStake = token.balanceOf(address(stake));
        assertEq(balanceOfStake, 1e50);
    }

    function test_start_airdrop() public {
        uint256 balance = token.balanceOf(user);
        assertEq(balance, 0);
        airdrop.claim(user);
        balance = token.balanceOf(user);
        assertEq(balance, 10e18);
    }

    function test_stake() public {
        airdrop.claim(user);
        vm.prank(user);
        token.approve(address(stake), 10e18);
        vm.stopPrank();
        vm.prank(user);
        stake.stake(10e18);
        vm.stopPrank();
        vm.warp(1e15);
        assertEq(stake.rewardPerToken(), 0);
    }
}
