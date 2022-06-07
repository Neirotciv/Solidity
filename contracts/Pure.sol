// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

// Don't read state variables, smart contract or blockchain
contract PureFunction {
    uint public number;

    // Don't be pure because it modify state variable
    function addToNumber(uint _a) external {
        number += _a;
    }    

    // just do a compute, it must be pure
    function multiply(uint _a, uint _b) public pure returns(uint) {
        return _a * _b;
    }
}