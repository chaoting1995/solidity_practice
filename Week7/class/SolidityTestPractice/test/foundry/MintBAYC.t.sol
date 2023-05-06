// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import { MintBAYC } from "../../contracts/MintBAYC.sol";

// 引入 BAYC 合約的 ABI
interface BAYC {
    function mintApe(uint numberOfTokens) external payable;
    function balanceOf(address owner) external view returns (uint256 balance);
}

contract MintBAYCTest is Test {

  address user1;
  string MAINNET_RPC_URL;
  uint BLOCK_NUMBER;
  uint256 forkId;


  function setUp() public {
    user1 = address(0x82A9d1DCDd415bfC67a9E0d577aCDa514E4d29BF);
    MAINNET_RPC_URL = "https://mainnet.infura.io/v3/ee11e79fa3d94cac84f2325726a61ba0";
    BLOCK_NUMBER = 12_299_047;

    forkId = vm.createFork(MAINNET_RPC_URL, BLOCK_NUMBER);
    vm.selectFork(forkId);


  }

  function testCreateFork() public {
    assertEq(block.number, BLOCK_NUMBER);
  }

  function testSelectFork() public {
    assertEq(vm.activeFork(), forkId);
  }

  function testMintApeFunction() public {
    // 在這裡填入 BAYC 合約的地址
    BAYC baycContract = BAYC(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
      
      
    vm.prank(user1);

    vm.deal(address(user1), 10 ether);

    baycContract.mintApe{value: 0.8 ether}(10);
    assertEq(baycContract.balanceOf(address(user1)), 10);
  }
}
