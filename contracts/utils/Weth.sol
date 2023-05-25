pragma solidity ^0.8.13;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

interface IWETH9 is IERC20 {
    function deposit() external payable;

    function withdraw(uint256 wad) external;
}

contract Weth {
    IWETH9 public WETH;

    constructor(address _addrWeth) {
        WETH = IWETH9(_addrWeth);
    }

    function getBalance() public view returns (uint256) {
        return WETH.balanceOf(address(this));
    }

    function wrap() external payable {
        WETH.deposit{value: msg.value}();
    }

    function unwrap(uint256 amount) external {
        WETH.withdraw(amount);
    }
}
