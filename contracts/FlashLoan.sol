pragma solidity ^0.8.13;
pragma abicoder v2;

import {FlashLoanSimpleReceiverBase} from "./loans/aave/interfaces/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "./loans/aave/interfaces/IPoolAddressesProvider.sol";
import "./exchanges/Arbitrage.sol";

contract Flashloan is FlashLoanSimpleReceiverBase, Arbitrage {
    constructor(
        address _addressProvider,
        address _routerSudoSwap,
        address _routerSeaport,
        address _addrWeth
    )
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
        Arbitrage(_routerSudoSwap, _routerSeaport, _addrWeth)
    {}

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        //weth to eth
        this.unwrap(amount);

        this.startArbitrage(amount);

        //eth to weth
        this.wrap{value: amount}();
        uint256 amountOwed = amount + premium;
        WETH.approve(address(POOL), amountOwed);

        return true;
    }

    function requestFlashLoan(bytes calldata _params) external {
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
}
