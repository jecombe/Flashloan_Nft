pragma solidity ^0.8.13;

/// ============ Structs ============
struct PairSwapSpecific {
    address pair;
    uint256[] nftIds;
}

struct PairSwapAny {
    address pair;
    uint256 numItems;
}
