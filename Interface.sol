// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface Conter {
    function count() external view  returns (uint);
    function add() external ;
    function withdraw(uint _amount) external payable ;   
}

contract Mymain{
    function getCounter(address _address) external view  returns (uint256){
        return  Conter(_address).count();
    }

    function addcount(address _address) external {
        Conter(_address).add();
    }

    function withdraw(address _address,uint256 _amount) external payable {
        Conter(_address).withdraw(_amount);
    }
    
    receive() external payable { }

    fallback() external payable { }
}