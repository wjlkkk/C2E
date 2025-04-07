// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MultiDelegateCall{
    event Log(address);
    function multiDelegatecall(bytes[] calldata _data) external payable returns (bytes[] memory result) {
        result = new bytes[](_data.length);
        for ( uint i = 0;i<_data.length;i++) {
            (bool success,bytes memory re) = address(this).delegatecall(_data[i]);
            require(success,'tx failed');
            result[i] =re;
            emit Log(msg.sender);
        }
    }  
}


contract Targetfun is MultiDelegateCall {
    function fun1() external view  returns (uint,uint) {
        return (1,block.timestamp);
    }

    function fun2(uint num) external view  returns (uint,uint) {
        return (num+1,block.timestamp);
    }

    function getdata1() external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.fun1.selector);
    }

    function getdata2(uint num) external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.fun2.selector,num);
    }

}


//注意转账风险！！可能在多次调用时会发生多次转账
