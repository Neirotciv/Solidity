// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract Summary {
    uint public balance;
    // Mapping, dictionnaire clé => valeur
    mapping(address => bool) whitelist;

    // Struct, type défini, regroupe plusieurs variables
    struct Person {
        string name;
        uint age;
    }

    // Tableau dynamique de type Person, public = obtenir un getter
    Person[] public personsArray;

    // Fonctions sur les tableaux
        // .length, .push(x), .pop()

    // Mapping strucure à une adresse
    mapping(address => Person) persons;

    // Enumérations, type personnalisé avec ensemble de valeurs constantes
    enum State { Created, Locked, Inactive }
    // Déclaration d'une variable de type State
    State public defaultState = State.Locked;

    // Manipulation d'une structure
    function addPerson(string memory _name, uint _age) public {
        // Variable person de type Person
        Person memory person;
        person.name = _name;
        person.age = _age;

        // Ou bien
        // Person memory person = Person(_name, _age);

        // Ajout dans le tableau
        personsArray.push(person);

        // Ajout dans le mapping
        persons[msg.sender] = person;
    }

    function addToWhitelist() public {
        
        whitelist[msg.sender] = true;
    }
    
    // Récupérer une valeur dans un mapping
    function getNameFromAdress() public view returns(string memory) {
        return persons[msg.sender].name;
    }

    // Modificateur
    modifier onlyWhitelisted() {
        require(
            whitelist[msg.sender] == true, 
            "Vous devez etre dans la whitelist pour acheter"
        );
        _; // Indique la ou la fonction doit être executée
    }

    // Traitement des erreurs
    function buy(uint _amount) public onlyWhitelisted{
        if (_amount < 5) {
            revert("Montant inferieur a 5");
        }
        balance += _amount;
    }
}