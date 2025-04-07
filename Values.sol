// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract functionOutputs {
    function a() public pure returns (uint,bool){
        return (1,true);
    }
}

contract Multipleoutput{

    uint public number;
    bool public status;
    string public None;
    function returnMultiple() public  pure returns (uint,bool,string memory){
        return (256,false,"Hello World");
    }

    function captureOutputs() public{
        (number,status,None) = returnMultiple();
    } 

    function displayOutput() public view returns (uint,bool,string memory){
        return (number,status,None);
    }

}