// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract S{
    string public name;
    constructor(string memory _name){
        name=_name;
    }
}

contract T{
    string public text;
    constructor(string memory _text){
        text=_text;
    }
}

//动态传递
contract U is S,T {
    constructor(string memory _name,string memory _text ) S(_name) T(_text){
        
    }
}

//静态传递

contract V is S('wjl'),T("abc"){
    constructor(){

    }
}

//混合传递

contract BB is S,T('aa'){
    constructor(string memory _text) S(_text) {

    }
}

//初始化顺序：先S,再T，因为contract BB is S,T('aa'){
