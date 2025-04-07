// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Errortest{
    function testreq(uint x) public pure {
        require(x<10,'invaild number');
    }

    function testrevert(uint x) external pure{
        if ( x <10 ) {
            revert('x<=10');
        }else if (x>10){
            revert('x>10');
        }
    }

    uint public num = 123;

    function setnum(uint i) external  {
        num=i;
    } 
    function testassert() external view {
        assert(num==123);
    }
    
    error  Myerror(address caller,uint i );

    function testcustomError(uint x ) public view {
        if (x<10){
            revert Myerror(msg.sender,x);
        }
    }
}