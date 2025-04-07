// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";
contract StakeReward{
    IERC20 public  immutable stakingToken;
    IERC20 public  immutable rewardToken;

    address public owner;
    uint public totalsupply;
    uint public during;
    uint public endtime;
    uint public updatetime;
    mapping (address => uint) public balanceof;

    uint public rewardrate;
    uint public rewardPertoken;
    mapping (address => uint) public reward;
    mapping (address => uint) public userPertokenpaid;
    constructor (address _skatetoken,address _rewardtoken) {
        stakingToken = IERC20(_skatetoken);
        rewardToken = IERC20(_rewardtoken);
        owner = msg.sender;
    }
    modifier onlyowner{
        require(msg.sender == owner,'Not owner');
        _;
    }

    modifier updateReward(address _account){
        rewardPertoken = getrewardPerToken();
        updatetime = min(block.timestamp , endtime);
        if(_account != address(0)){
            reward[_account] = earned(_account);
            userPertokenpaid[_account] = rewardPertoken;
        }
        _;
    }
    function setduringtime(uint _during) external onlyowner{
        require(block.timestamp > endtime,'It not over');
        during = _during;
    }

    function notifyrewardtoken(uint _amount) external  onlyowner{
        console.log("test");
        require(_amount >0,"amount <0");
        if (block.timestamp > endtime){
             rewardrate = _amount /during;
             console.log("test2");
         }
        //else {
        //     uint remainningreward = rewardrate * (endtime-block.timestamp);
        //     console.log("test3");
        //     rewardrate = (_amount + remainningreward ) /during;
        //     console.log("test4");
        // }

        require(rewardrate >0,"rewardrate <0");
        // console.log("test5");
        // console.log(rewardToken.balanceOf(address(this)));
        // console.log(rewardrate);
        // console.log(endtime);
        // console.log((endtime - block.timestamp));
        // console.log(rewardrate * (endtime - block.timestamp));
        require(rewardrate * during<rewardToken.balanceOf(address(this)),"Reward Token is not enough");
        //console.log("test6");

        endtime = block.timestamp + during;
        updatetime = block.timestamp;
    }
    

    function skate(uint _amount) external updateReward(msg.sender){
        require(_amount>0,'amount <0');
        require(block.timestamp < endtime,'The stake is over');

        balanceof[msg.sender] += _amount;
        totalsupply += _amount;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint _amount) external updateReward(msg.sender) {
        require(_amount >0,'amount <0');
        require(balanceof[msg.sender] >0,'No balance');

        balanceof[msg.sender] -= _amount;
        totalsupply -= _amount;
        stakingToken.transfer(msg.sender,_amount);
    }

    function min(uint x , uint y) private pure returns (uint) {
        return  x<y?x:y;
    }

    function getrewardPerToken() public  returns (uint){
        if (totalsupply == 0) {
            rewardPertoken = 0;
        } else {
            rewardPertoken = rewardPertoken + (min(block.timestamp,endtime) - updatetime)* rewardrate * 1e18 / totalsupply;//避免小数点丢失
        }
        return rewardPertoken;
    }
    /**
    reward = 质押金额 * （每个token带来的reward -用户已经提取的每个token的reward）*1e18 + 提取的reward 
    **/
    function earned(address _account) public returns (uint) {
        uint userstake = balanceof[_account];
        return userstake*(getrewardPerToken()-userPertokenpaid[_account])/1e18 + reward[_account];//回归小数点
    }

    function getreward() external updateReward(msg.sender) {
        uint rewards = earned(msg.sender);
        require(rewards>0,'reward =0');
        rewardToken.transfer(msg.sender, rewards);
        reward[msg.sender] =0;
    }
}