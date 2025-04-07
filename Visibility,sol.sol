// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract visiblity{
    uint private x;
    uint public  y;
    uint internal z;
    
    function a() private view returns  (uint){
        return x+y+z;
    }

    function b() external view  returns (uint){
        return x+y+z;
    }

    function c() internal view returns(uint) {
        return x+y+z;
    }

    function d() public view returns (uint) {
        return x+y+z;
    }
}