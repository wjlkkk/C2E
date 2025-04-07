// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
contract MyContract {
     struct Vehicle{
        string make;
        uint256 year;
        address owner;
    }

    Vehicle public car;
    Vehicle[] public cars;

    function example() external {
        Vehicle storage tesla = Vehicle("China",2021,msg.sender);
        Vehicle memory Audi = 
        ("USA",2019,msg.sender);
        
    }
    
    
}