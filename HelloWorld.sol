// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld {
    // Declare a state variable to store the unsigned integer
    uint public storedNumber;

    // Function to store an unsigned integer
    function storeNumber(uint number) public {
        storedNumber = number;
    }

    // Function to retrieve the stored unsigned integer
    function retrieveNumber() public view returns (uint) {
        return storedNumber;
    }
}
