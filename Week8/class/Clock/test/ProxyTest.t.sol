// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";
import {Clock} from "../src/Clock.sol";
import {ClockV2} from "../src/ClockV2.sol";
import {BasicProxy} from "../src/BasicProxy.sol";
import {BasicProxyV2} from "../src/BasicProxyV2.sol";

contract ProxyTest is Test {
    Clock public clock;
    ClockV2 public clockV2;
    BasicProxy public basicProxy;
    BasicProxyV2 public basicProxyV2;
    uint256 public alarm1Time;

    function setUp() public {
        clock = new Clock();
        clockV2 = new ClockV2();
        basicProxy = new BasicProxy(address(clock));
        basicProxyV2 = new BasicProxyV2(address(clock));
    }

    function testProxyWorks() public {
        // check Clock functionality is successfully proxied
        Clock clockProxy = Clock(address(basicProxy));
        clockProxy.setAlarm1(100);
        assertEq(clockProxy.alarm1(), 100);
        assertEq(clockProxy.getTimestamp(), block.timestamp);
    }

    function testInitialize() public {
        // check initialize works
        Clock clockProxy = Clock(address(basicProxy));
        clockProxy.initialize(100);
        assertEq(clockProxy.alarm1(), 100);
    }

    function testUpgrade() public {
        // check Clock functionality is successfully proxied
        Clock clockProxy = Clock(address(basicProxyV2));
        clockProxy.setAlarm1(100);
        assertEq(clockProxy.alarm1(), 100);
        assertEq(clockProxy.alarm2(), 0);
        assertEq(clockProxy.getTimestamp(), block.timestamp);

        // shouldn't be able to setAlarm2
        ClockV2 clockProxyV2 = ClockV2(address(basicProxyV2));
        vm.expectRevert();
        clockProxyV2.setAlarm2(100);

        // upgrade
        basicProxyV2.upgradeTo(address(clockV2));
        // check state hadn't been changed
        assertEq(clockProxyV2.alarm1(), 100);
        assertEq(clockProxyV2.alarm2(), 0);
        // check new functionality is available
        clockProxyV2.setAlarm2(100);
        assertEq(clockProxyV2.alarm2(), 100);
    }

    function testUpgradeAndCall() public {
        // calling initialize right after upgrade
        basicProxyV2.upgradeToAndCall(
            address(clockV2),
            abi.encodeWithSignature("initialize(uint256)", 100)
        );
        assertEq(ClockV2(address(basicProxyV2)).alarm1(), 100);
    }
}
