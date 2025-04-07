// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyHash{
    function hashFunction(string memory text,uint num,address addr) external pure returns (bytes32){
        return keccak256(abi.encodePacked(text,num,addr));
    }
    function encodeFunction(string memory text0,string memory text1) external pure returns (bytes memory){
        return abi.encode(text0,text1);
    }
    function PackedFunction(string calldata text0,string calldata text1) external pure returns (bytes memory){
        return  abi.encodePacked(text0,text1);
    }

    // 避免哈希冲突，比如输入字符串'AAA' 'BBB' 哈希之后和'AA''ABBB'的哈希是一样的，所以要避免哈希冲突。在两个字符串之间加入输入一个uint即可
    //
}