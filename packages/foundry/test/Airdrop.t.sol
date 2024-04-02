// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity >=0.8.0 <0.9.0;
import "forge-std/Test.sol";
import {Token} from "../contracts/Token.sol";
import {Airdrop} from "../contracts/Airdrop.sol";
import {StakeV1} from "../contracts/StakeV1.sol";

contract AirdropTest is Test {
    address admin = makeAddr("admin");
    address minter = makeAddr("minter");
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    Token token;
    Airdrop airdrop;
    StakeV1 stake;
    address[] _address;

    function setUp() public {
        _address.push(alice);
        for (uint256 i = 1; i < 10; i++) {
            _address.push(address(0));
        }

        token = new Token(admin, minter);
        airdrop = new Airdrop(address(token), 10e18, _address, 10, 50);
        stake = new StakeV1(address(token), 1e3);
        vm.prank(minter);
        token.mint(address(airdrop), 1e28);
        vm.stopPrank();
        vm.prank(minter);
        token.mint(address(stake), 1e50);
        vm.stopPrank();
    }

    function test_options() public view {
        (uint256 start, uint256 end, uint256 amount) = airdrop.options();
        assertEq(start, 10);
        assertEq(end, 50);
        assertEq(amount, 10e18);
    }

    function test_mint_depoist() public view {
        uint256 balanceOfAirdrop = token.balanceOf(address(airdrop));
        assertEq(balanceOfAirdrop, 1e28);
        uint256 balanceOfStake = token.balanceOf(address(stake));
        assertEq(balanceOfStake, 1e50);
    }

    function test_allowed_and_unallowed() public view {
        assertTrue(airdrop.allowed(alice));
        assertFalse(airdrop.allowed(bob));
    }

    function test_airdrop() public {
        vm.warp(10);
        uint256 balance = token.balanceOf(alice);
        assertEq(balance, 0);
        airdrop.claim(alice);
        balance = token.balanceOf(alice);
        assertEq(balance, 10e18);
    }

    function test_add_airdrop() public {
        vm.warp(10);
        vm.expectRevert(bytes("Not allowed to airdrop"));
        airdrop.claim(bob);
        airdrop.addWhitelist(bob);
        uint256 balance = token.balanceOf(bob);
        assertEq(balance, 0);
        airdrop.claim(bob);
        balance = token.balanceOf(bob);
        assertEq(balance, 10e18);
    }

    function test_double_airdrop() public {
        vm.warp(10);
        airdrop.claim(alice);
        vm.expectRevert(bytes("Airdrop already claimed"));
        airdrop.claim(alice);
    }

    function test_unallowed_airdrop() public {
        vm.warp(10);
        vm.expectRevert(bytes("Not allowed to airdrop"));
        airdrop.claim(bob);
    }

    function test_airdrop_not_started() public {
        vm.expectRevert(bytes("Airdrop not started"));
        airdrop.claim(alice);
    }

    function test_airdrop_ended() public {
        vm.warp(51);
        vm.expectRevert(bytes("Airdrop Ended"));
        airdrop.claim(alice);
    }

    function test_remove_address_whitelist() public {
        assertEq(airdrop.whitelist(0), alice);
        airdrop.removeWhitelist(alice);
        assertFalse(airdrop.whitelist(0) == alice);
    }

    function test_add_whitlist() public {
        airdrop.addWhitelist(bob);
        assertEq(airdrop.whitelist(10), bob);
    }

    function test_skate_deposit() public {
        vm.warp(10);
        airdrop.claim(alice);
        vm.prank(alice);
        token.approve(address(stake), 10e18);
        vm.stopPrank();
        vm.prank(alice);
        vm.warp(20);
        stake.deposit(10e18);
        vm.stopPrank();
        vm.warp(30);
        assertEq(stake.rewards(alice), 100000);
        vm.warp(300);
        assertEq(stake.rewards(alice), 2800000);
    }

    function test_skate_withdraw() public {
        vm.warp(10);
        airdrop.claim(alice);
        vm.prank(alice);
        token.approve(address(stake), 10e18);
        vm.stopPrank();
        vm.prank(alice);
        stake.deposit(10e18);
        vm.warp(110);
        vm.prank(alice);
        stake.withdraw();
        vm.stopPrank();
        uint256 balance = token.balanceOf(alice);
        assertEq(balance, 10000000000001000000);
    }
}
