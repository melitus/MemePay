// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity >=0.8.0 <0.9.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Airdrop {
    IERC20 internal _token;
    address[] internal _whitelist;
    mapping(address => bool) internal _claimed;
    struct Options {
        uint256 start;
        uint256 end;
        uint256 amount;
    }
    Options public options;

    constructor(
        address token,
        uint256 _amount,
        address[] memory whitelist_,
        uint256 start_,
        uint256 end_
    ) {
        _token = IERC20(token);
        _whitelist = whitelist_;
        options = Options(start_, end_, _amount);
    }

    function allowed(address address_) public view returns (bool) {
        for (uint i = 0; i < _whitelist.length; i++) {
            if (address_ == _whitelist[i]) {
                return true;
            }
        }
        return false;
    }

    function claim(address address_) external returns (bool) {
        bool permited = allowed(address_);
        if (permited) {
            bool transferred = _token.transfer(address_, options.amount);
            if (transferred) {
                _claimed[address_] = true;
                return true;
            }
            return false;
        }
        return false;
    }

    function whitelist() external view returns (address[] memory) {
        return _whitelist;
    }

    // function updateWhitelist(
    //     address[] memory newAddress
    // ) external view returns (bool) {
    //     return false;
    // }

    // function addWhitelist() external view returns (bool) {
    //     return false;
    // }

    // function removeWhitelist() external view returns (bool) {
    //     return false;
    // }
}
