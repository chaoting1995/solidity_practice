// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../src/week7/MyContract.sol";

contract MyContractTest is Test {
    MyContract instance;
    address user1;

    address user2;

    function setUp() public {
        // TODO:
        // 1. Set user1, user2
        user1 = address(0x82A9d1DCDd415bfC67a9E0d577aCDa514E4d29BF);
        user2 = address(0x3E7facf843E2208B022EF357656A436e13595Fd1);
        instance = new MyContract(user1, user2);
        // 2. Create a new instance of MyContract
        instance = new MyContract(user1, user2);
        // 3. (optional) label user1 as bob, user2 as alice
        vm.label(user1, "bob");
        vm.label(user2, "alice");
    }

    function testConstructor() public {
        // TODO:
        // 1. Assert instance.user1() is user1
        assertEq(instance.user1(), user1);
        // 2. Assert instance.user2() is user2
        assertEq(instance.user2(), user2);
    }

    function testReceiveEther() public {
        // TODO:
        // 1. pretending you are user1
        vm.startPrank(user1);
        // 2. let user1 have 1 ether
        vm.deal(user1, 1 ether);
        // 3. send 1 ether to instance
        (bool sent, ) = address(instance).call{value: 1 ether}("");
        assertTrue(sent);
        // 4. Assert instance has 1 ether in balance
        assertEq(address(instance).balance, 1 ether);
        // 5. stop pretending
        vm.stopPrank();
    }
}