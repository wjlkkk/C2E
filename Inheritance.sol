// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract A {
    string public test='abcd';

    function foo() public virtual view returns (string memory) {
        return test;
    }

    function bar() public virtual pure returns (string memory) {
        return 'A';
    }

    function ttt() public pure returns (string memory ) {
        return 'test';
    }
}


contract B is A {
    function foo() public override virtual  view returns (string memory) {
        return test;
    }

    function bar() public override virtual  pure returns (string memory) {
        return 'B';
    }

    function boo() public pure virtual  returns (string memory) {
        return 'B';
    }
    
}

contract C is B {
    function bar() public override   pure returns (string memory) {
        return 'C';
    }
  
}

contract Z is A, B{
    function bar() public  override(A, B) pure returns (string memory) {
        return 'Z';
    } 

    function foo() public  view  override (A,B) returns (string memory){
        return test;}

    function boo() public pure override (B) returns (string memory ) {
        return 'Z';}
}

//派生合约必须重写 foo 的原因可以归结为以下几点：

// 多重继承中的函数冲突 ：
// 当多个父合约定义了同名函数时，派生合约必须明确解决冲突。
// 编译器的安全性要求 ：
// 编译器无法自动选择实现，必须由开发者显式声明。
// 灵活性和可控性 ：
// 派生合约可以通过 override 提供自己的实现或调用特定父合约的实现。