// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Clock} from "../src/Clock.sol";
import {ClockV1} from "../src/ClockV1.sol";
// import {ClockV2} from "../src/ClockV2.sol";
import {BasicProxy} from "../src/BasicProxy.sol";
// import {BasicProxyV2} from "../src/BasicProxyV2.sol";

contract ProxyTest is Test {
    Clock public clock;
    ClockV1 public clockV1;
    // ClockV2 public clockV2;
    BasicProxy public basicProxy;
    BasicProxy public basicProxyV1;
    // BasicProxyV2 public basicProxyV2;

    function setUp() public {
        clock = new Clock(0);
        // clockV2 = new ClockV2();
        basicProxy = new BasicProxy(address(clock));
        basicProxyV1 = new BasicProxy(address(clockV1));
        // basicProxyV2 = new BasicProxyV2(address(clock));
    }

    function testProxyWorks() public {
        // check Clock functionality is successfully proxied
        Clock clockProxy = Clock(address(basicProxy));

        clockProxy.setAlarm1(100);
        assertEq(clockProxy.alarm1(), 100);        
        assertEq(clockProxy.getTimestamp(), block.timestamp);
    }

    function testProxyWorks1() public {
        // check Clock functionality is successfully proxied
        // Clock clockProxy = Clock(address(basicProxy));
        
        // clockProxy.setAlarm1(100);
        bytes memory payload1 = abi.encodeWithSignature("setAlarm1(uint256)", 100);
        (bool success,) = address(basicProxy).call(payload1) ;
        require (success);

        // assertEq(clockProxy.alarm1() , 100);
        bytes memory payload2 = abi.encodeWithSignature("alarm1()") ;
        (bool success1, bytes memory returnedData1) = address(basicProxy).call(payload2);
        require (success1);
        uint256 result1 = abi.decode(returnedData1, (uint256)) ;
        console.log("result1",result1);
        assertEq(result1, 100);
        
        // assertEq (clockProxy. getTimestamp(), block.timestamp);
        bytes memory payload3 = abi.encodeWithSignature("getTimestamp()");
        (bool success2, bytes memory returnedData2) = address(basicProxy).call(payload3);
        require (success2);
        uint result2 = abi.decode(returnedData2, (uint256));
        console.log("result2",result2);
        assertEq(result2, block.timestamp);
    }

    function testProxyWorks2() public {
        // check Clock functionality is successfully proxied
        Clock clockProxy = Clock(address(basicProxy));

        clockProxy.setAlarm1(100);
        assertEq(clockProxy.alarm1(), 100);        
        assertEq(clockProxy.getTimestamp(), block.timestamp);

        console.log("block.timestamp", block.timestamp);
        console.log("baseProxy.getTimestamp()", basicProxy.getTimestamp());
        console.log("clockProxy.getTimestamp()", clockProxy.getTimestamp());
        console.log("clock.getTimestamp()", clock.getTimestamp());
    }

    function testAfterDeployClock() public {
        clock = new Clock(200);
        console.log("alarm1",clock.alarm1()); // 200

        Clock clockProxy = Clock(address(basicProxy));
        console.log("alarm1",clockProxy.alarm1()); // 0

        assertEq(clockProxy.alarm1(), 200); // will be revert
    }

    function testAfterDeployClockV1() public {
        // check initialize works
        ClockV1 clockProxyV1 = ClockV1(address(basicProxyV1));
        clockProxyV1.initialize(200);
        console.log("alarm1",clockProxyV1.alarm1()); // 200

        assertEq(clockProxyV1.alarm1(), 200); // will pass
    }

    // function testUpgrade() public {
    //     // check Clock functionality is successfully proxied
    //     Clock clockProxy = Clock(address(basicProxyV2));
    //     clockProxy.setAlarm1(100);
    //     assertEq(clockProxy.alarm1(), 100);
    //     assertEq(clockProxy.alarm2(), 0);
    //     assertEq(clockProxy.getTimestamp(), block.timestamp);

    //     // shouldn't be able to setAlarm2
    //     ClockV2 clockProxyV2 = ClockV2(address(basicProxyV2));
    //     vm.expectRevert();
    //     clockProxyV2.setAlarm2(100);

    //     // upgrade
    //     basicProxyV2.upgradeTo(address(clockV2));
    //     // check state hadn't been changed
    //     assertEq(clockProxyV2.alarm1(), 100);
    //     assertEq(clockProxyV2.alarm2(), 0);
    //     // check new functionality is available
    //     clockProxyV2.setAlarm2(100);
    //     assertEq(clockProxyV2.alarm2(), 100);
    // }

    // function testUpgradeAndCall() public {
    //     // calling initialize right after upgrade
    //     basicProxyV2.upgradeToAndCall(
    //         address(clockV2),
    //         abi.encodeWithSignature("initialize(uint256)", 100)
    //     );
    //     assertEq(ClockV2(address(basicProxyV2)).alarm1(), 100);
    // }
}
