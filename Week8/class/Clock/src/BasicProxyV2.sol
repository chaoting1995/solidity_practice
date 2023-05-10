// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { BasicProxy } from "./BasicProxy.sol";

contract BasicProxyV2 is BasicProxy {
  // First slot is the address of the current implementation

  constructor (address _implementation) BasicProxy (_implementation) {}

  function upgradeTo(address newImplementation) public {
    implementation = newImplementation;
  }

  function upgradeToAndCall(address newImplementation, bytes memory data) external {
    upgradeTo(newImplementation);
    (bool success, ) = newImplementation.delegatecall(data);
    require(success);
  }
}