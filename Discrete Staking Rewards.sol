// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/ERC";


contract Discete{
    IERC20 public immutable staketoken;
    IERC20 public immutable rewardtoken;
    event log(uint reward);
    uint public rewardrate;
    uint public totalsupply;
    struct Userinfo{
        uint balanceof;
        uint earned;
        uint rewardofthisuser;
    }
    uint private constant multiply =1e18;
    mapping (address=>Userinfo) public userinfo;

    constructor (address _staketoken,address _rewardtoken) {
        staketoken = IERC20(_staketoken);
        rewardtoken = IERC20(_rewardtoken);
    }


    modifier updateuserward(address account) {
        userinfo[account].earned = _calculateRewards(account);
        userinfo[account].rewardofthisuser = rewardrate;
        _;
    }

    function updaterewardindex(uint reward) external {
        rewardtoken.transferFrom(msg.sender, address(this), reward);
        rewardrate = reward * multiply / totalsupply;
        emit log(reward);
    }

    function _calculateRewards(address account) public  view  returns (uint){

        return (userinfo[account].earned + (userinfo[account].balanceof * (rewardrate - userinfo[account].rewardofthisuser))/multiply);
    }

    function stake(uint amount) external updateuserward(msg.sender){
        staketoken.transferFrom(msg.sender, address(this), amount);
        userinfo[msg.sender].balanceof += amount;
        totalsupply += amount;
    }

    function withdraw(uint amount) external  updateuserward(msg.sender) {
        staketoken.transfer(msg.sender,amount);
        userinfo[msg.sender].balanceof -= amount;
        totalsupply -= amount;
    }

    function claim() external updateuserward(msg.sender) {
        uint reward = _calculateRewards(msg.sender);
        rewardtoken.transfer(msg.sender, reward);
    }

    function getinfo(address account) external view  returns (Userinfo memory){
        return userinfo[account];
    }
    
}