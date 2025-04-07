// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/interfaces/IERC20.sol";


contract CSAMM{
    
    IERC20 public immutable sol;
    IERC20 public  immutable Eth;

    uint public  sol_amount;
    uint public  Eth_amount1;
    uint public  totalsupply;

    constructor (address token1 , address token2) {
        sol = IERC20(token1);
        Eth =IERC20(token2);
    }

    mapping (address => uint ) public  balanceof;

    function _burn(address _from,uint amount) private {
        balanceof[_from] -= amount;
        totalsupply -= amount;
    }

    function _update(uint bal0,uint bal1) private {
        sol_amount = bal0;
        Eth_amount1 = bal1;
    }
    
    
    function swap(uint amountIn, address tokenIn) external {
        require(tokenIn == address(sol) || tokenIn == address(Eth),'Invalid token');
        
        bool issol = tokenIn == address(sol);
        (IERC20 tokenIn,IERC20 tokenout , uint balIn , uint balout) = issol? (sol,Eth,sol_amount,Eth_amount1) :(Eth,sol,sol_amount,Eth_amount1);

        // 接受转账
        tokenIn.transferFrom(msg.sender,address(this), amountIn);
        // 更新数量
        uint _amountIn = tokenIn.balanceOf(address(this)) - balIn;
        // 计算出
        uint amountOut = amountIn * 0.97
        

    }
    function AddLiquidity() external {}
    function Remove_Liquidity() external {}
}