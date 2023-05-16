pragma solidity ^0.8.13;
pragma abicoder v2;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "./Arbitrage.sol";

contract Flashloan is FlashLoanSimpleReceiverBase, Arbitrage {
    constructor(
        address _addressProvider
        address _routerSudoSwap
        address _routerSeaport
    ) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) Arbitrage(_routerSudoSwap, _routerSeaport) {}

    /**
        This function is called after your contract has received the flash loaned amount
     */

    /* function wrap() external payable {
        //create WETH from ETH
        if (msg.value != 0) {
            WETH.deposit{value: msg.value}();
        }
        require(
            WETH.balanceOf(address(this)) >= msg.value,
            "Ethereum not deposited"
        );
    }

    function unwrap(address payable recipient, uint256 amount) internal {
        if (amount != 0) {
            WETH.transferFrom(msg.sender, address(this), amount);
            WETH.withdraw(amount);
            recipient.transfer(amount);
        }
    }*/

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        //weth to eth
        this.unwrapped(amount);

        //eth to weth
        this.wrapped(amount);
        //this.startArbitrage{value: amount}();
        //this.startArbitrage2();
        uint256 amountOwed = amount + premium;
        WETH.approve(address(POOL), amountOwed);
        // IERC20(asset).approve(address(POOL), amountOwed);

        return true;
    }

    function requestFlashLoan(bytes calldata _params) external {
        // paramsArb = _params;
        address receiverAddress = address(this);

        bytes memory params = "";
        uint16 referralCode = 0;

        decode(_params);

        POOL.flashLoanSimple(
            receiverAddress,
            parameters.token,
            parameters.amount,
            params,
            referralCode
        );
    }

    function requestFlashLoan2(address _token, uint256 _amount) external {
        // paramsArb = _params;
        address receiverAddress = address(this);

        bytes memory params = "";
        uint16 referralCode = 0;

        // decode(_params);

        POOL.flashLoanSimple(
            receiverAddress,
            _token,
            _amount,
            params,
            referralCode
        );
    }

    function getBalance(address _tokenAddress) public view returns (uint256) {
        return WETH.balanceOf(address(this));
    }

    //function() external payable {}
}
