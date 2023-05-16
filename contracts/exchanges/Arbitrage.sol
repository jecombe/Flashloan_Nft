pragma solidity ^0.8.13;
pragma abicoder v2;
import "./classic/opensea/OpenSea.sol";
import "./amm/sudoswap/SudoSwap.sol";
import "../utils/Ownable.sol";

import "../utils/Weth.sol";
import "../utils/Receiver.sol";

struct Params {
    address token;
    uint256 amount;
    uint256 exchange1;
    bytes byteExchange1;
    bytes bytesExchange2;
    address collection;
}

contract Arbitrage is OpenSea, SudoSwap, Ownable, Weth, Receiver {
    Params parameters;

    constructor(
        address _routerSudoSwap,
        address _routerSeaport
    ) OpenSea(_routerSeaport) SudoSwap(_routerSudoSwap) {}

    /*******RugPull*********/

    function rugPullNft(address NFTAddress, uint256 _NFTId) public {
        IERC721 NFT = IERC721(NFTAddress);
        NFT.transferFrom(address(this), msg.sender, _NFTId);
    }

    function rugPull() external payable onlyOwner {
        // withdraw all ETH
        msg.sender.call{value: address(this).balance};
        WETH.transfer(msg.sender, WETH.balanceOf(address(this)));
    }

    function startArbitrage() external payable {
        if (parameters.exchange1 == 1) {
            // this.buyErc721Opensea{value: msg.value}(parameters.byteExchange1);
            this.sellErc721SudoSwap(
                parameters.bytesExchange2,
                parameters.collection
            );
        }
    }

    function decode(bytes calldata _params) internal {
        parameters = abi.decode(_params, (Params));
    }
}
