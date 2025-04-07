// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract _ERC20 is ERC20 {
    constructor() ERC20("TEST", "TEST"){
    }

    function _update(address from,address  to, uint value) override external  {
        
    }
    
}
