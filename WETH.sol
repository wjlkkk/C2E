// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {
    event Deposit(address indexed account,uint amount);
    event Withdraw(address indexed ,uint amount);
    constructor () ERC20 ("Wrapped ETH","WETH") {}

    fallback() external payable {
        deposit();
     }

    function deposit() public  payable   {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) external {
        require(balanceOf(msg.sender)>=amount,'You donot have enough token');
        _burn(msg.sender, amount);
        payable (msg.sender).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }
}