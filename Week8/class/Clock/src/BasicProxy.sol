// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import { Proxy } from "./Proxy.sol";

contract BasicProxy is Proxy {
  // First slot is the address of the current implementation
  address impl;

  constructor(address _impl) {
    impl = _impl;
  }

  fallback() external payable {
    _delegate(impl);
  }

  receive() external payable {}
}

