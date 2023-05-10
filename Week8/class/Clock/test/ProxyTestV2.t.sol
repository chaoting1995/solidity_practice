// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {ClockV1} from "../src/ClockV1.sol";
import {ClockV2} from "../src/ClockV2.sol";
import {BasicProxy} from "../src/BasicProxy.sol";
import {BasicProxyV2} from "../src/BasicProxyV2.sol";

contract ProxyTestV2 is Test {
    ClockV1 public clockV1;
    ClockV2 public clockV2;
    BasicProxy public basicProxy;
    BasicProxyV2 public basicProxyV2;

    function setUp() public {
        clockV1 = new ClockV1();
        clockV2 = new ClockV2();
        
        // basicProxyV2 指向 clockV1 合約
        // 注意：初始化，是先指向 clockV1
        basicProxyV2 = new BasicProxyV2(address(clockV1)); 
    }

    function testUpgrade() public {
        // check Clock functionality is successfully proxied

        ClockV1 clockProxy = ClockV1(address(basicProxyV2));

        // call alarm1 和 setAlarm1 來檢查功能是否正常
        clockProxy.setAlarm1(100);
        assertEq(clockProxy.alarm1(), 100);
        
        assertEq(clockProxy.alarm2(), 0);
        ClockV2 clockProxyV2 = ClockV2(address(basicProxyV2));
        vm.expectRevert();
        // shouldn't be able to setAlarm2
        // 因為 basicProxyV2 的 implementation 指向的是 clockV1
        // will be revert
        clockProxyV2.setAlarm2(100);

        // upgrade
        // basicProxyV2 更新 implementation，指向 clockV2 合約
        basicProxyV2.upgradeTo(address(clockV2));
        // check state hadn't been changed
        // basicProxyV2 alarm1 應維持原樣
        assertEq(clockProxyV2.alarm1(), 100);
        
        // check new functionality is available
        assertEq(clockProxyV2.alarm2(), 0);
        clockProxyV2.setAlarm2(100);
        assertEq(clockProxyV2.alarm2(), 100);
    }

    function testUpgradeAndCall() public {
        // calling initialize right after upgrade
        // 更新 implementation 後，立刻初始化 basicProxyV2
        // but, 這樣還算初始化嗎？
        basicProxyV2.upgradeToAndCall(
            address(clockV2),
            abi.encodeWithSignature("initialize(uint256)", 100)
        );
        assertEq(ClockV2(address(basicProxyV2)).alarm1(), 100);
    }
}
