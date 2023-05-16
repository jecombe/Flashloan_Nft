pragma solidity ^0.8.13;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

interface IWETH9 is IERC20 {
    function deposit() external payable;

    function withdraw(uint256 wad) external;
}

contract Weth {
    IWETH9 public constant WETH =
        IWETH9(0xD0dF82dE051244f04BfF3A8bB1f62E1cD39eED92);

    constructor() {}

    function getBalance() public view returns (uint256) {
        return WETH.balanceOf(address(this));
    }

    function wrapped(uint256 amount) public {
        //create WETH from ETH

        WETH.deposit{value: amount}();
    }

    function unwrapped(uint256 amount) public {
        // address payable sender = payable(msg.sender);

        WETH.withdraw(amount);
        //sender.transfer(address(this).balance);
    }
}
