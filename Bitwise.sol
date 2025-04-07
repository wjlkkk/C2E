// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract bitoperate{
    function getLastBits(uint256 x,uint bits) external pure returns (uint){
        uint mask = (1 << bits) -1;
        return (x & mask);
    }
}