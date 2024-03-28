// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity >=0.8.0 <0.9.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Stake {
    IERC20 internal _token;

    constructor(address token, address[] memory whitelist_) {
        _token = IERC20(token);
    }
}
