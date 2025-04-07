// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Abi{
    struct my{
        uint x;
        uint[] y;
        string z;
    }

    uint a;
    address myaddress;
    uint[] arr;

    function encode(uint _a,address _address,my calldata mystruct, uint[] calldata _arr) external pure returns(bytes memory){
        return abi.encode(_a,_address,mystruct,_arr);
    }

    function decode(bytes calldata _bytecode) external  pure returns (uint _a,address _myaddress,my memory mystruct,uint[] memory _arr){
        (_a,_myaddress,mystruct,_arr) = abi.decode(_bytecode,(uint,address,my,uint[]));
    } 
}