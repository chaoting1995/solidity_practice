// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { ClockV1 } from "./ClockV1.sol";

contract ClockV2 is ClockV1 {

  function setAlarm2 (uint256 _timestamp) public {
    alarm2 = _timestamp;
  }
}