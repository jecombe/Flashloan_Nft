// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "./interfaces/IRouter.sol";

contract SudoSwap {
    IRouter internal immutable LSSVM;
    address internal router;

    constructor(address _router) {
        router = _router;
        LSSVM = IRouter(_router);
    }

    function testBuySpecific(address _pair, uint256 _nftId) public payable {
        uint256[] memory nftIds = new uint256[](1);
        nftIds[0] = _nftId;

        PairSwapSpecific memory data = PairSwapSpecific({
            pair: _pair,
            nftIds: nftIds
        });

        PairSwapSpecific[] memory swapList = new PairSwapSpecific[](1);
        swapList[0] = data;

        LSSVM.swapETHForSpecificNFTs{value: msg.value}(
            swapList,
            payable(msg.sender),
            msg.sender,
            block.timestamp
        );
    }

    function sellErc721SudoSwap(
        bytes memory _params,
        address collection
    ) external {
        IERC721(collection).setApprovalForAll(router, true);

        PairSwapSpecific memory swap = abi.decode(_params, (PairSwapSpecific));
        PairSwapSpecific[] memory swapList = new PairSwapSpecific[](1);
        swapList[0] = swap;

        LSSVM.swapNFTsForToken(
            swapList,
            0,
            payable(address(this)),
            block.timestamp
        );
    }
}
