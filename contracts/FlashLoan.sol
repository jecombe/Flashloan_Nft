pragma solidity ^0.8.13;
pragma abicoder v2;

import {FlashLoanSimpleReceiverBase} from "./loans/aave/interfaces/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "./loans/aave/interfaces/IPoolAddressesProvider.sol";
import "./exchanges/Arbitrage.sol";

contract Flashloan is FlashLoanSimpleReceiverBase, Arbitrage {
    constructor(
        address _addressProvider,
        address _routerSudoSwap,
        address _routerSeaport
    )
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
        Arbitrage(_routerSudoSwap, _routerSeaport)
    {}

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        //weth to eth
        //this.unwrapped(amount);

        //eth to weth
        //this.wrapped(amount);
        this.startArbitrage(amount);
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
}
