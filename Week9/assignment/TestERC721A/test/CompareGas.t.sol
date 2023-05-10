// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import {MyERC721E, MyERC721A} from "../src/CompareGas.sol";

contract CompareGasTest is Test {
  MyERC721E myERC721E;
  MyERC721A myERC721A;
  
  address user1;
  address user2;

  function setUp() public {
    user1 = address(0x1);
    user2 = address(0x2);
    vm.label(user1, "alice");
    vm.label(user2, "bob");

    myERC721E = new MyERC721E();
    myERC721A = new MyERC721A();
  }
  
  // - mint
  function testMint1() public {
      vm.startPrank(user1);
      myERC721E.mint(0); // tokenId 0
      myERC721A.mint(1); // quantity 1 // erc721a _startTokenId is 0
      vm.stopPrank(); 
  }

  function testMint4_() public {
      vm.startPrank(user1);
      for (uint256 i = 0; i < 4; i++) {
        myERC721E.mint(i);
      }
      myERC721A.mint(4);
      vm.stopPrank();
  }

  function testMint40_() public {
      vm.startPrank(user1);
      for (uint256 i = 0; i < 40; i++) {
        myERC721E.mint(i);
      }
      myERC721A.mint(40);
      vm.stopPrank();
  }

  function testMint400() public {
      vm.startPrank(user1);
      for (uint256 i = 0; i < 400; i++) {
        myERC721E.mint(i);
      }
      myERC721A.mint(400);
      vm.stopPrank();
  }

  function testGetTokenId0to4() public {
      vm.startPrank(user1);
      
      for (uint256 i = 0; i < 4; i++) {
        myERC721E.mint(i);
      }
      myERC721A.mint(4);

      console.log("myERC721E ownerOf(0)",myERC721E.ownerOfWithoutCheck(0));
      console.log("myERC721E ownerOf(1)",myERC721E.ownerOfWithoutCheck(1));
      console.log("myERC721E ownerOf(2)",myERC721E.ownerOfWithoutCheck(2));
      console.log("myERC721E ownerOf(3)",myERC721E.ownerOfWithoutCheck(3));
      console.log("myERC721E ownerOf(4)",myERC721E.ownerOfWithoutCheck(4));
      console.log("myERC721A ownerOf(0)",myERC721A.ownerOfByOriginData(0));
      console.log("myERC721A ownerOf(1)",myERC721A.ownerOfByOriginData(1));
      console.log("myERC721A ownerOf(2)",myERC721A.ownerOfByOriginData(2));
      console.log("myERC721A ownerOf(3)",myERC721A.ownerOfByOriginData(3));
      console.log("myERC721A ownerOf(4)",myERC721A.ownerOfByOriginData(4));
      console.log("myERC721A totalSupply",myERC721A.totalSupply());
      vm.stopPrank();
  }

  // - transfer
  function testERC721eTransferTokenId1() public {
      vm.startPrank(user1);
      for (uint256 i = 0; i < 4; i++) {
        myERC721E.mint(i);
      }
      myERC721A.mint(4);

      myERC721E.transferFrom(user1, user2, 1);
      myERC721A.transferFrom(user1, user2, 1);

      console.log("myERC721E ownerOf(0)",myERC721E.ownerOfWithoutCheck(0));
      console.log("myERC721E ownerOf(1)",myERC721E.ownerOfWithoutCheck(1));
      console.log("myERC721E ownerOf(2)",myERC721E.ownerOfWithoutCheck(2));
      console.log("myERC721E ownerOf(3)",myERC721E.ownerOfWithoutCheck(3));

      console.log("myERC721A ownerOf(0)",myERC721A.ownerOfByOriginData(0));
      console.log("myERC721A ownerOf(1)",myERC721A.ownerOfByOriginData(1));
      console.log("myERC721A ownerOf(2)",myERC721A.ownerOfByOriginData(2));
      console.log("myERC721A ownerOf(3)",myERC721A.ownerOfByOriginData(3));
      console.log("myERC721A totalSupply",myERC721A.totalSupply());
      vm.stopPrank();
  }
  
  function testERC721aTransferTokenIdEnd() public {
      vm.startPrank(user1);
      for (uint256 i = 0; i < 4; i++) {
        myERC721E.mint(i);
      }
      myERC721A.mint(4);

      myERC721E.transferFrom(user1, user2, 3);
      myERC721A.transferFrom(user1, user2, 3);

      console.log("myERC721E ownerOf(0)",myERC721E.ownerOfWithoutCheck(0));
      console.log("myERC721E ownerOf(1)",myERC721E.ownerOfWithoutCheck(1));
      console.log("myERC721E ownerOf(2)",myERC721E.ownerOfWithoutCheck(2));
      console.log("myERC721E ownerOf(3)",myERC721E.ownerOfWithoutCheck(3));

      console.log("myERC721A ownerOf(0)",myERC721A.ownerOfByOriginData(0));
      console.log("myERC721A ownerOf(1)",myERC721A.ownerOfByOriginData(1));
      console.log("myERC721A ownerOf(2)",myERC721A.ownerOfByOriginData(2));
      console.log("myERC721A ownerOf(3)",myERC721A.ownerOfByOriginData(3));
      console.log("myERC721A totalSupply",myERC721A.totalSupply());
      
      vm.stopPrank();
  }

  // - approve
  function testApprove() public {
      vm.startPrank(user1);
      for (uint256 i = 0; i < 4; i++) {
        myERC721E.mint(i);
      }
      myERC721A.mint(4);

      myERC721E.approve(user2, 3);
      myERC721A.approve(user2, 3);
      vm.stopPrank();
  }
}

// 沒設定價格，故可以任意 mint