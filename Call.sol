// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract TestContract {
    string public message;
    uint public number;
    event Log(string);
    function foo(string calldata _msg,uint _number) public payable  {
        message = _msg;
        number = _number;
    }

    receive() external payable { }
    fallback() external payable {
        emit Log('fallback is called.');
    }
    
}


contract Caller {
    bytes public data;
    function callFoo(address _address,string calldata _msg,uint _number) external payable {
       (bool success, bytes memory re)=_address.call{value:123,gas:43637}(abi.encodeWithSignature("foo(string,uint256)",_msg,_number));
        require(success,'Call failed');
        data = re;
    }

    function callnotexist(address _address) external payable {
        (bool success,)=_address.call{value:1}(abi.encodeWithSignature("test", "Hello, world!"));
        require(success,'Call failed');
    }
}