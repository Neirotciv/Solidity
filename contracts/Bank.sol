// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract BankExercice {
    address admin;
    uint public balance;
    bool public firstTransaction;
    uint public firstTransactionTimestamp;
    // uint lockTime = 7884000;
    uint lockTime = 10;

    struct History {
        uint id;
        uint amount;
        uint timestamp;
    }

    History[] deposits;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(admin == msg.sender, "only owner please");
        _;
    }

    function deposit() public payable onlyAdmin {
        require(msg.value > 0, "please send more than 0");
        if (!firstTransaction) {
            firstTransactionTimestamp = block.timestamp;
            firstTransaction = true;
        }
        balance += msg.value;
    }

    function withdraw(address payable _to) public payable onlyAdmin {
        require((block.timestamp - firstTransactionTimestamp) > lockTime, "balance always locked");
        _to.transfer(balance);
        balance = 0;
    }
}