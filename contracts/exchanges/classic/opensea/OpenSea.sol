// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.13;

import "./interfaces/SeaportInterface.sol";

contract OpenSea {
    AdditionalRecipient[] additionalRecipients;
    SeaportInterface public SEAPORT;

    constructor(address _router) {
        SEAPORT = SeaportInterface(_router);
    }

    struct ParamsOpensea {
        address considerationToken;
        uint256 considerationIdentifier;
        uint256 considerationAmount;
        address offerer;
        address zone;
        address offerToken;
        uint256 offerIdentifier;
        uint256 offerAmount;
        uint256 orderType;
        uint256 startTime;
        uint256 endTime;
        bytes32 zoneHash;
        uint256 salt;
        bytes32 offererConduitKey;
        bytes32 fulfillerConduitKey;
        uint256 totalOriginalAdditionalRecipients;
        AdditionalRecipient[] additionalRecipients;
        bytes signature;
    }

    function buyErc721Opensea(
        bytes memory _params
    ) public payable returns (bool) {
        ParamsOpensea memory orderParams = abi.decode(_params, (ParamsOpensea));

        BasicOrderParameters memory order = BasicOrderParameters({
            considerationToken: orderParams.considerationToken,
            considerationIdentifier: orderParams.considerationIdentifier,
            considerationAmount: orderParams.considerationAmount,
            offerer: payable(orderParams.offerer),
            zone: orderParams.zone,
            offerToken: orderParams.offerToken,
            offerIdentifier: orderParams.offerIdentifier,
            offerAmount: orderParams.offerAmount,
            basicOrderType: BasicOrderType.ETH_TO_ERC721_FULL_OPEN,
            startTime: orderParams.startTime,
            endTime: orderParams.endTime,
            zoneHash: orderParams.zoneHash,
            salt: orderParams.salt,
            offererConduitKey: orderParams.offererConduitKey,
            fulfillerConduitKey: orderParams.fulfillerConduitKey,
            totalOriginalAdditionalRecipients: orderParams
                .totalOriginalAdditionalRecipients,
            additionalRecipients: orderParams.additionalRecipients,
            signature: orderParams.signature
        });

        return SEAPORT.fulfillBasicOrder{value: msg.value}(order);
    }

    //function() external payable {}
}
