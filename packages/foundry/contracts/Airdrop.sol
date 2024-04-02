// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity >=0.8.0 <0.9.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Airdrop {
    IERC20 internal _token;
    /// @dev get this array and compare if connect wallet address is in this array
    address[] public whitelist;
    /// @dev if return true doesnt show claim button
    mapping(address => bool) public claimed;
    /// @dev show the basic information about the aidrop
    struct Options {
        uint256 start;
        uint256 end;
        uint256 amount;
    }
    Options public options;

    modifier check(address address_) {
        require(!claimed[address_], "Airdrop already claimed");
        require(block.timestamp >= options.start, "Airdrop not started");
        require(block.timestamp <= options.end, "Airdrop Ended");
        require(allowed(address_), "Not allowed to airdrop");

        _;
    }

    constructor(
        address token,
        uint256 _amount,
        address[] memory whitelist_,
        uint256 start_,
        uint256 end_
    ) {
        _token = IERC20(token);
        whitelist = whitelist_;
        options = Options(start_, end_, _amount);
    }

    function allowed(address address_) public view returns (bool result) {
        result = false;
        for (uint i = 0; i < whitelist.length; i++) {
            if (address_ == whitelist[i]) {
                result = true;
            }
        }
    }

    /// @dev call this function
    function claim(address address_) external check(address_) returns (bool) {
        bool transferred = _token.transfer(address_, options.amount);
        if (transferred) {
            claimed[address_] = true;
            return true;
        }
        return false;
    }

    /// @dev use this function to add a address to airdrop for test
    function addWhitelist(address address_) external returns (bool) {
        whitelist.push(address_);
        return true;
    }

    function removeWhitelist(address address_) external returns (bool) {
        for (uint i = 0; i < whitelist.length; i++) {
            if (address_ == whitelist[i]) {
                whitelist[i] = whitelist[whitelist.length - 1];
            }
        }
        whitelist.pop();
        return true;
    }
}
