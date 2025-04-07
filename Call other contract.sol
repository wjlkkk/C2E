// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MyTargetContract{
    uint public x;
    uint public value;
    function setTargetX(uint _x) public{
        x=_x;
    }

    function getTargetX() public view returns (uint){
        return x;
    }

    function setXAndReceEth(uint _x) external payable {
        x =_x;
        value = msg.value;
    }

    function getXAndValue() public view returns (uint , uint ){
        return (x,value);
    }
} 

contract MyCallerContract{
    function setTargetX(address _test,uint _x) public {
        MyTargetContract(_test).setTargetX(_x);//这个_test是指MyTargetContract部署之后的合约的地址
        
    }
}