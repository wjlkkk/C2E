// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract test {
    address  public immutable owner;
    constructor(){
        owner=msg.sender;
    }

    function getOwner() view external returns (address){
        return owner;
    }
}