// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Targetfun{
    function fun1() external view  returns (uint,uint) {
        return (1,block.timestamp);
    }

    function fun2(uint num) external view  returns (uint,uint) {
        return (num+1,block.timestamp);
    }

    function getdata1() external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.fun1.selector);
    }

    function getdata2() external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.fun2.selector,"2");
    }


}


contract MultiCall{
    function multicall(address[] calldata _address,bytes[] calldata _data) external view returns (bytes[] memory) {
       require(_address.length== _data.length,"Invalid parameters");
       bytes[] memory result = new bytes[](_data.length);
       for (uint i = 0;i<_address.length;i++){
        (bool success,bytes memory re) = _address[i].staticcall(_data[i]); // staticcall 和 call 有啥区别
        require(success,'tx failed');
        result[i] =re;
       }
       return result;
    } 
}