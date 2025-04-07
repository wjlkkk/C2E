// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract count{
    uint public counts;
    function counter() public  returns (uint) {
        counts +=1;
        return counts;
    }
}

contract fallbacktest{

    address immutable _count;
    constructor(address _address) {
        _count = _address;
    }
    fallback(bytes calldata _bytes) external payable returns (bytes memory) {
        (bool ok ,bytes memory res)=_count.call{value:msg.value}(_bytes);
        require(ok,'call failed');
        return res;
     }
}

contract test{
    event log(bytes);
    function testfallback(address _addr,bytes  calldata _data) external {
        (bool ok, bytes memory  res)=_addr.call(_data);
        require(ok,'call failde');
        emit log(res);
    }

    function getdata() external pure returns (bytes memory){
        return abi.encodeWithSignature("counter()");
    }
}