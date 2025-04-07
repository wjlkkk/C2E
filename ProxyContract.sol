// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;



/**
◦ 错误实现可升级代理合约
◦ 分析错误实现中的问题
◦ 返回回退函数中的数据
◦ 在智能合约的存储槽中写⼊任意数据
◦ 存储实现合约地址和管理员地址
◦ 分离管理员和⽤⼾界⾯
◦ 编写代理管理员合约
◦ 实际操作演⽰
**/
contract CounterV1{
    uint public count;
    function inc() external returns (uint){
        count +=1;
        return count;
    }
}

contract CounterV2{
    uint public count;
    function inc() external returns (uint){
        count +=1;
        return count;
    }

    function des() external returns (uint) {
        count-=1;
        return count;
    }
}


contract BuggyProxy{
    
    address public target;

    function upgradeto(address _target) external {
        target = _target;
    }

    function _delegatecall(bytes32  _data) private {
        target.delegatecall(_data);
    }

    fallback() external payable { 
        _delegatecall();
    } 

    receive() external payable { 
        _delegatecall();
    }
}