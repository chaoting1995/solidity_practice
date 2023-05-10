// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { Proxy } from "./Proxy.sol";

contract BasicProxy is Proxy {
  // First slot is the address of the current implementation
  address implementation;

  constructor(address _implementation) {
    implementation = _implementation;
  }

  fallback() external payable {
    _delegate(implementation);
  }

  receive() external payable {}
}

