// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract Wallsign{
    function hashmessage(string memory _message) internal pure returns (bytes32){
        return keccak256(abi.encodePacked(_message));
    }

    function Ehthashmessage(bytes32  _message) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",_message));//\x19Ethereum Signed Message:\n32 这个是ETH签名规范要求的
    } 


}