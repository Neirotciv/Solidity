// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract Visibility {
    uint private a = 2;
    uint internal b = 3;
    uint public c = 4;
    
    // private, only inside contract
    function privateFunc() private view returns(uint) {
        return a;
    }
    
    // internal, only inside contract and child contract
    function internalFunc() internal view returns(uint) {
        return a;
    }

    // public, inside and outside contract
    function publicFunc() public view returns(uint) {
        return a;
    }

    // external, only from outside contract
    function externalFunc() external view returns(uint) {
        return a;
    }
}

contract VisibilityChild is Visibility {
    function callPrivateFunc() public view returns(uint) {
        return internalFunc();
    }

    function callPublicFunc() public view returns(uint) {
        return externalFunc();
    }
}