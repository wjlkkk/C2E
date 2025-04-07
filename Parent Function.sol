// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract A{
    event LogMessage(string message);
    function foo() public virtual   {
        emit LogMessage('A Foo');
    }

    function bar() public virtual {
        emit LogMessage('A Bar');
    }
}


contract B is A{
    function foo() public override virtual {
        emit LogMessage('B Foo');
        A.foo();
    }

    function bar() public override virtual {
        emit LogMessage('B Bar');
        
    }

}

contract C is A{
    function foo() public override virtual {
        emit LogMessage('C Foo');
        A.foo();
    }

    function bar() public override virtual {
        emit LogMessage('C Bar');
        
    }

}
//这个时候的C3顺序变成了A-C-B-D
contract D is C,B{
    function foo() public override(B,C) virtual {
        emit LogMessage('D Foo');
        A.foo();
    }

    function bar() public override(B,C) virtual {
        emit LogMessage('D Bar');
        super.bar();
    }

}