// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract Struct {
    struct Person {
        string name;
        uint age;
    }

    mapping(address => Person) persons;

    function addPerson(string memory _name, uint _age) public pure {
        Person memory person;
        person.name = _name;
        person.age = _age;
    }

    function addOtherPerson(string memory _name, uint _age) public {
        Person memory person = Person(_name, _age);
        persons[msg.sender] = person;
    }

    function addPersonAgain(string memory _name, uint _age) public {
        persons[msg.sender] = Person({ name: _name, age: _age });
    }

    function loop(uint _i) public pure returns(uint) {
        uint i;

        for (i=1; i == _i; i++) {
            if (i == _i) {
                return i;
            }
        }

        return 0;
    }
}