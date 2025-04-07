// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Wallet{
    address payable public ownerWallet;
    constructor(){
        ownerWallet = payable(msg.sender);
    }

    function get() external view onlyOwner returns (uint){
        //return ownerWallet.balance;
        return msg.sender.balance;
    }

    modifier onlyOwner{
        require (msg.sender == ownerWallet,'Caller not onwer');
        _;
    }
        
    function withdraw(uint amount)   external onlyOwner {
        payable(msg.sender).transfer(amount);
    }
    receive() external payable { }

    fallback() external payable { }
}