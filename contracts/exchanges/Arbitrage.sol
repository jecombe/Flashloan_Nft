pragma solidity ^0.8.13;
pragma abicoder v2;
import "./classic/opensea/OpenSea.sol";
import "./amm/sudoswap/SudoSwap.sol";
import "../utils/Ownable.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

interface IWETH9 is IERC20 {
    function deposit() external payable;

    function withdraw(uint256 wad) external;
}

contract Arbitrage is IERC721Receiver, OpenSea, SudoSwap, Ownable {
    Params parameters;
    struct Params {
        address token;
        uint256 amount;
        uint256 exchange1;
        bytes byteExchange1;
        bytes bytesExchange2;
        address collection;
    }
    IWETH9 public constant WETH =
        IWETH9(0xD0dF82dE051244f04BfF3A8bB1f62E1cD39eED92);

    constructor(
        address _routerSudoSwap,
        address _routerSeaport
    ) OpenSea(_routerSeaport) SudoSwap(_routerSudoSwap) {}

    receive() external payable {}

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function rugPullNft(address NFTAddress, uint256 _NFTId) public {
        IERC721 NFT = IERC721(NFTAddress); // Create an instance of the NFT contract
        // Calling the NFT smart contract transferFrom function
        // From - receiver - NFT id
        NFT.transferFrom(address(this), msg.sender, _NFTId);
    }

    function decode(bytes calldata _params) internal {
        parameters = abi.decode(_params, (Params));
    }

    function getBalance() public view returns (uint256) {
        return WETH.balanceOf(address(this));
    }

    function rugPull() external payable onlyOwner {
        // withdraw all ETH
        msg.sender.call{value: address(this).balance}("");
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

    function startArbitrage2() external {
        if (parameters.exchange1 == 1) {
            // this.buyErc721Opensea{value: msg.value}(parameters.byteExchange1);
            this.sellErc721SudoSwap(
                parameters.bytesExchange2,
                parameters.collection
            );
        }
    }

    function testing(uint256 amount) public payable {
        WETH.withdraw(amount);

        // WETH.deposit{value: amount}();
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

    function test(uint256 amount) external {
        //decode(_params);
        //unwrap(payable(address(this)), amount);
        // this.startArbitrage{value: address(this).balance}();
        //this.wrap{value: amount}();
    }
}
