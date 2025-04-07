// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract constructortest{
    uint public  x;
    address public owner;
    constructor(){
        x=123;
        owner = msg.sender;
    }
}

contract test{
    uint public x =1234;
    address public owner = msg.sender;
}