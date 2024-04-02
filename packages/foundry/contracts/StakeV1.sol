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

    /// @dev Show in ui combined with stake[address].amount
    function rewards(address user) public view returns (uint256 token) {
        token =
            (stake[user].amount / 1e18) *
            bonus *
            (block.timestamp - stake[user].start);
    }

    /// @dev call this function
    function deposit(uint256 amount) public returns (bool) {
        bool transferred = token_.transferFrom(
            msg.sender,
            address(this),
            amount
        );
        if (transferred) {
            stake[msg.sender].amount = stake[msg.sender].amount + amount;
            stake[msg.sender].start = block.timestamp;
            return true;
        }
        return false;
    }

    /// @dev call this function
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
