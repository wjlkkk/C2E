// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract addall{
    function sum(uint n) external pure returns (uint) {
        uint  total = 0 ;
        for (uint i=1;i<=n;i=i+2){
            total = total +i ;
            while(total < 10){
                break ;
            }
        }
        return total;

    }
}