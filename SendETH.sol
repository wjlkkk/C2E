// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract SendETH{
    constructor() payable {}
    receive() external payable { }
    //35998gas
    function transfer(address payable _to) external  {
        _to.transfer(123);
    } 
    //36051gas
    function send(address payable _to) external {
        bool success=_to.send(123);
        require(success,'Send fail');
    }
    //36313gas
    function call(address payable _to) external {
        (bool success,) = _to.call{value:123}("");
        require(success,'Call fail');
    }

    function query() external view returns(uint) {
        return address(this).balance;
    }
}


contract ReceETH{
    receive() external payable { }
    fallback() external payable{}
}