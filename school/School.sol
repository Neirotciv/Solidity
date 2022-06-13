// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract School {
    address biologyProfessor = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address mathProfessor = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    address frenchProfessor = 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB;

    struct Student {
        string name;
        uint noteBiology;
        uint noteMath;
        uint noteFrench;
    }

    mapping(address => Student) students;

    Student[] public studentList;
    
    constructor() {
        // Init some students
        addStudent(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, "stud_1", 12, 4, 13);
        addStudent(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db, "stud_2", 18, 14, 11);
        addStudent(0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB, "stud_3", 10, 9, 15);
    }

    function addNote(uint _id, uint _note, string calldata _education) external {
        // Check the professor
        // require();

        // Select the student
        studentList[_id].noteMath = 3;
    }

    // function setNote() {

    // }

    // function getNote() {

    // }

    function getStudentAverageNote(address _address) public view returns(uint) {
        return (students[_address].noteBiology + students[_address].noteMath + students[_address].noteFrench) / 3;
    }

    function addStudent(address _address, string memory _name, uint _note1, uint _note2, uint _note3) public {
        studentList.push(Student(_name, _note1, _note2, _note3));
        students[_address] = Student(_name, _note1, _note2, _note3);
    }

    function getStudent(uint _id) public view returns (Student memory) {
        return studentList[_id];
    }

}