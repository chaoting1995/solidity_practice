// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/week7/WETH9.sol";

contract WETH9Test is Test {
    WETH9 public instance;
    address public owner1;

    string public constant WETH9_NAME = "WETH9";
    string public constant WETH9_SYMBOL = "WETH";

    uint256 public constant INSTANCE_INIT_ETH = 0 ether;
    uint256 public constant INSTANCE_INIT_WETH = 0 ether;
    uint256 public constant OWNER1_INIT_WETH = 0 ether;
    uint256 public constant OWNER1_INIT_ETH = 100 ether;
    uint256 public constant OWNER2_INIT_WETH = 0;
    uint256 public constant DEPOSIT_ETH = 2 ether;
    uint256 public constant WITHDRAW_ETH = 1 ether;
    uint256 public constant TRANSFER_WETH = 1 ether;
    uint256 public constant APPROVE_WETH = 1 ether;

    event Deposit(address indexed _sender, uint256 _amount);
    event Withdraw(address indexed _owner, uint256 _amount);

    // receive() external payable {}

    function setUp() public {
        instance = new WETH9(WETH9_NAME, WETH9_SYMBOL);

        owner1 = address(0x82A9d1DCDd415bfC67a9E0d577aCDa514E4d29BF);
        vm.label(owner1, "Ryan");
        vm.deal(owner1, OWNER1_INIT_ETH);
    }

    // 測項 0-1: msg.value 有 100 ether
    function testInitEtherOfOwner1() public {
        assertEq(address(owner1).balance, OWNER1_INIT_ETH);
    }

    // 測項 0-2: msg.value 有 0 weth
    function testInitWethOfOwner1() public {
        assertEq(instance.balanceOf(owner1), OWNER1_INIT_WETH);
    }

    // 測項 0-3: instance 有 0 weth
    function testInitTotalSupplyOfInstance() public {
        assertEq(instance.totalSupply(), INSTANCE_INIT_WETH);
    }

    // 測項 0-4: instance 有 0 weth
    function testInitEtherOfInstance() public {
        assertEq(instance.totalSupply(), INSTANCE_INIT_ETH);
    }

    // 測項 1: deposit 應該將與 msg.value 相等的 ERC20 token mint 給 user
    function testDepositWithMint() public {
        vm.prank(owner1);
        instance.deposit{value: DEPOSIT_ETH}();

        // 檢查：owner1 的 WETH 是否正確增加
        assertEq(
            instance.balanceOf(owner1),
            OWNER1_INIT_WETH + DEPOSIT_ETH, // 0 + 2
            "owner1 doesn't have correct WETH"
        );
        // 檢查：instance 的總供給量是否正確增加
        assertEq(
            instance.totalSupply(),
            INSTANCE_INIT_WETH + DEPOSIT_ETH,
            "instance doesn't have correct WETH"
        );
    }

    // 測項 2: deposit 應該將 msg.value 的 ether 轉入合約
    function testDepositEther() public {
        vm.prank(owner1);
        instance.deposit{value: DEPOSIT_ETH}();

        // 檢查：instance 的 ether 是否正確增加
        assertEq(
            address(instance).balance,
            INSTANCE_INIT_ETH + DEPOSIT_ETH, // 0 + 2
            "instance doesn't have correct ETH"
        );
        // 檢查：owner1 的 ether 是否正確減少
        assertEq(
            address(owner1).balance,
            OWNER1_INIT_ETH - DEPOSIT_ETH, // 100 - 2
            "owner1 doesn't have correct ETH"
        );
    }

    // 測項 3: deposit 應該要 emit Deposit event
    function testDepositWithEvent() public {
        vm.prank(owner1);
        vm.expectEmit(true, true, true, true);
        emit Deposit(owner1, DEPOSIT_ETH);
        instance.deposit{value: DEPOSIT_ETH}();
    }

    // 測項 4: withdraw 應該要 burn 掉與 input parameters 一樣的 erc20 token
    function testWithdrawWithBurn() public {
        vm.startPrank(owner1);
        instance.deposit{value: DEPOSIT_ETH}();

        // 檢查：owner1 的 WETH 是否正確增加
        assertEq(
            instance.balanceOf(owner1),
            OWNER1_INIT_WETH + DEPOSIT_ETH, // 0 + 2
            "owner1 doesn't have correct WETH"
        );

        instance.withdraw(WITHDRAW_ETH);

        // 檢查：owner1 的 WETH 是否正確減少
        assertEq(
            instance.balanceOf(owner1),
            OWNER1_INIT_WETH + DEPOSIT_ETH - WITHDRAW_ETH, // 0 + 2 - 1
            "owner1 doesn't have correct WETH"
        );

        // 檢查：instance 的總供給量是否正確減少
        assertEq(
            instance.totalSupply(),
            INSTANCE_INIT_WETH + DEPOSIT_ETH - WITHDRAW_ETH, // 0 + 2 - 1
            "instance doesn't have correct WETH"
        );
        vm.stopPrank();
    }

    // 測項 5: withdraw 應該將 burn 掉的 erc20 換成 ether 轉給 user
    function testWithdrawEther() public {
        vm.startPrank(owner1);
        instance.deposit{value: DEPOSIT_ETH}();

        // 檢查：owner1 的 ether 是否正確減少
        assertEq(
            address(owner1).balance,
            OWNER1_INIT_ETH - DEPOSIT_ETH, // 100 - 2
            "owner1 doesn't have correct ETH"
        );

        // 檢查：instance 的 ether 是否正確增加
        assertEq(
            address(instance).balance,
            INSTANCE_INIT_ETH + DEPOSIT_ETH, // 0 + 2
            "instance doesn't have correct ETH"
        );

        instance.withdraw(WITHDRAW_ETH);

        // 檢查：owner1 的 ETH 是否正確增加
        assertEq(
            address(owner1).balance,
            OWNER1_INIT_ETH - DEPOSIT_ETH + WITHDRAW_ETH, // 100 - 2 + 1
            "owner1 doesn't have correct ETH"
        );

        // 檢查：instance 的總供給量是否正確減少
        assertEq(
            instance.totalSupply(),
            INSTANCE_INIT_ETH + DEPOSIT_ETH - WITHDRAW_ETH, // 0 + 2 - 1
            "instance doesn't have correct ETH"
        );

        vm.stopPrank();
    }

    // 測項 6: withdraw 應該要 emit Withdraw event
    function testWithdrawWithEvent() public {
        vm.startPrank(owner1);
        // vm.prank(owner1);
        instance.deposit{value: DEPOSIT_ETH}();

        vm.expectEmit(true, true, true, true);
        emit Withdraw(owner1, WITHDRAW_ETH);
        instance.withdraw(WITHDRAW_ETH);
        // vm.stopPrank();
    }

    // 測項 7: transfer 應該要將 erc20 token 轉給別人
    function testTransfer() public {
        vm.startPrank(owner1);
        instance.deposit{value: DEPOSIT_ETH}();

        // 檢查：owner1 的 WETH 是否正確增加
        assertEq(
            instance.balanceOf(owner1),
            OWNER1_INIT_WETH + DEPOSIT_ETH, // 0 + 2
            "owner1 doesn't have correct WETH"
        );
        // 檢查：instance 的總供給量是否正確增加
        assertEq(
            instance.totalSupply(),
            INSTANCE_INIT_WETH + DEPOSIT_ETH,
            "instance doesn't have correct WETH"
        );

        address owner2 = address(0x1);
        instance.transfer(owner2, TRANSFER_WETH);

        // 檢查：owner1 的 ether 是否正確減少
        assertEq(
            instance.balanceOf(owner1),
            OWNER1_INIT_WETH + DEPOSIT_ETH - TRANSFER_WETH, // 0 + 2  - 1
            "owner1 doesn't have correct WETH"
        );
        // 檢查：owner2 的 ether 是否正確增加
        assertEq(
            instance.balanceOf(owner2),
            OWNER2_INIT_WETH + TRANSFER_WETH, // 0 + 1
            "owner2 doesn't have correct WETH"
        );
        vm.stopPrank();
    }

    // 測項 8: approve 應該要給他人 allowance
    function testApproveWithAllowance() public {
        vm.startPrank(owner1);

        address onwer2 = address(0x1);
        instance.approve(onwer2, APPROVE_WETH);
        assertEq(
            instance.allowance(owner1, onwer2),
            APPROVE_WETH,
            "owner2 doesn't have correct allowance from owner1"
        );

        vm.stopPrank();
    }

    // 測項 9: transferFrom 應該要可以使用他人的 allowance
    function testTransferFromWithAllowance() public {
        vm.startPrank(owner1);
        address onwer2 = address(0x1);
        instance.deposit{value: DEPOSIT_ETH}();

        instance.approve(owner1, APPROVE_WETH);
        instance.transferFrom(owner1, onwer2, APPROVE_WETH);
        // 檢查：owner2 的 WETH 是否正確增加
        assertEq(
            instance.balanceOf(onwer2),
            OWNER2_INIT_WETH + APPROVE_WETH,
            "owner2 doesn't have correct allowance from owner1"
        );
        vm.stopPrank();
    }

    // 測項 10: transferFrom 後應該要減除用完的 allowance
    function testTransferFromWithUpdateAllowance() public {
        vm.startPrank(owner1);
        address onwer2 = address(0x1);
        instance.deposit{value: DEPOSIT_ETH}();

        instance.approve(owner1, APPROVE_WETH);
        instance.transferFrom(owner1, onwer2, APPROVE_WETH);
        // 檢查：owner2 的 allowance WETH 是否正確減少
        assertEq(
            instance.allowance(owner1, onwer2),
            APPROVE_WETH - APPROVE_WETH, // 1 - 1
            "owner2 doesn't have correct allowance from owner1"
        );
        vm.stopPrank();
    }

    // 其他可以 test case
    function testERC20Constructor() public {
        // 檢查：Name
        assertEq(instance.name(), WETH9_NAME);
        // 檢查：Symbol
        assertEq(instance.symbol(), WETH9_SYMBOL);
    }
}
