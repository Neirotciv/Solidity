// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract BankExercice is Ownable {
    address admin;
    uint public balance;
    bool public isFirstTransaction;
    uint public firstTransactionTimestamp;
    // uint lockTime = 7884000;
    uint lockTime = 10;
    uint totalDeposits = 0;

    mapping(uint => uint) public history;

    constructor() {
        
    }

    modifier onlyAdmin() {
        require(admin == msg.sender, "only owner please");
        _;
    }

    function deposit() public payable onlyOwner {
        require(msg.value > 0, "please send more than 0");
        if (!isFirstTransaction) {
            firstTransactionTimestamp = block.timestamp;
            isFirstTransaction = true;
        }
        balance += msg.value;
        totalDeposits++;
        history[totalDeposits] = msg.value;
    }

    function withdraw(address payable _to) public payable onlyOwner {
        require((block.timestamp - firstTransactionTimestamp) > lockTime, "balance always locked");
        _to.transfer(balance);
        balance = 0;
    }
}