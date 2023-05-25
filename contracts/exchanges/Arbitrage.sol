pragma solidity ^0.8.13;
pragma abicoder v2;
import "./classic/opensea/OpenSea.sol";
import "./amm/sudoswap/SudoSwap.sol";
import "../utils/Ownable.sol";

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

import "../utils/Weth.sol";

import "../utils/Receiver.sol";

contract Arbitrage is Receiver, OpenSea, SudoSwap, Ownable, Weth {
    Params parameters;
    struct Params {
        address token;
        uint256 amount;
        address collection;
        bytes exchangeClassic;
        bytes exchangeAmm;
    }

    constructor(
        address _sudoswap,
        address _opensea,
        address _addrWeth
    ) SudoSwap(_sudoswap) OpenSea(_opensea) Weth(_addrWeth) {}

    function rugPullNft(address NFTAddress, uint256 _NFTId) public {
        IERC721 NFT = IERC721(NFTAddress);
        NFT.transferFrom(address(this), msg.sender, _NFTId);
    }

    function decode(bytes calldata _params) internal {
        parameters = abi.decode(_params, (Params));
    }

    function rugPull() external payable onlyOwner {
        msg.sender.call{value: address(this).balance}("");
        WETH.transfer(msg.sender, WETH.balanceOf(address(this)));
    }

    function startArbitrage(uint256 amount) external {
        this.buyErc721Opensea{value: amount}(parameters.exchangeClassic);
        this.sellErc721SudoSwap(parameters.exchangeAmm, parameters.collection);
    }
}
