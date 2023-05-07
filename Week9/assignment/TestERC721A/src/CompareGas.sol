// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721A} from "ERC721A/ERC721A.sol";

contract MyERC721 is ERC721Enumerable {
    constructor() ERC721("ERC721Enum Coin", "EEC") {}

    function mint(uint tokenId) public {
        _safeMint(msg.sender, tokenId);
    }

    // 繼承來的
    // approve
    // transferFrom
}

contract MyERC721A is ERC721A {
    constructor() ERC721A("ERC721A Coin", "EAC") {}

    function mint(uint quantity) public {
        _safeMint(msg.sender, quantity);
    }

    // 繼承來的
    // approve
    // transferFrom
}
