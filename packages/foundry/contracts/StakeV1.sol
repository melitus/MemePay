// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity >=0.8.0 <0.9.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakeV1 {
    IERC20 public immutable token_;
    uint256 bonus;
    struct Options {
        uint256 start;
        uint256 amount;
    }
    mapping(address => Options) public stake;

    constructor(address _token, uint256 _bonus) {
        token_ = IERC20(_token);
        bonus = _bonus;
    }

    function rewards(address user) public view returns (uint256 token) {
        token =
            (stake[user].amount / 1e18) *
            bonus *
            (block.timestamp - stake[user].start);
    }

    function deposit(address user, uint256 amount) public returns (bool) {
        bool transferred = token_.transferFrom(user, address(this), amount);
        if (transferred) {
            stake[user].amount = stake[user].amount + amount;
            stake[user].start = block.timestamp;
            return true;
        }
        return false;
    }

    function withdraw() public returns (bool) {
        require(stake[msg.sender].amount != 0, "No token was deposited");
        bool transferred = token_.transfer(
            msg.sender,
            stake[msg.sender].amount + rewards(msg.sender)
        );
        if (transferred) {
            stake[msg.sender].amount = 0;
            return true;
        }
        return false;
    }
}
