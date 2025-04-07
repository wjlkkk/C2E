// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract _StakingRewards  {
    // 事件
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    // 代币接口
    IERC20 public immutable stakingToken; // 质押代币
    IERC20 public immutable rewardToken;  // 奖励代币

    // 奖励参数
    uint256 public rewardRate; // 每秒奖励量 (单位: rewardToken)
    uint256 public lastUpdateTime; // 上次更新时间戳
    uint256 public rewardPerTokenStored; // 每个代币累计的奖励

    // 用户数据结构
    struct UserInfo {
        uint256 balance; // 用户质押的余额
        uint256 userRewardPerTokenPaid; // 用户上次领取奖励时的奖励系数
        uint256 rewards; // 用户待领取的奖励
    }

    // 用户信息映射
    mapping(address => UserInfo) public userInfo;

    // 总质押量
    uint256 private _totalSupply;

    // 构造函数
    constructor(IERC20 _stakingToken, IERC20 _rewardToken) {
        stakingToken = _stakingToken;
        rewardToken = _rewardToken;
    }

    // 修改器：确保调用者已质押
    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;

        if (account != address(0)) {
            userInfo[account].rewards = earned(account);
            userInfo[account].userRewardPerTokenPaid = rewardPerTokenStored;
        }
        _;
    }

    // 获取每单位代币的累计奖励
    function rewardPerToken() public view returns (uint256) {
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored +
            (((block.timestamp - lastUpdateTime) * rewardRate * 1e18) / _totalSupply);
    }

    // 计算用户可获得的奖励
    function earned(address account) public view returns (uint256) {
        return
            (userInfo[account].balance *
                (rewardPerToken() - userInfo[account].userRewardPerTokenPaid)) /
            1e18 +
            userInfo[account].rewards;
    }

    // 设置奖励率 (仅限管理员)
    function setRewardRate(uint256 _rewardRate) external onlyOwner {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        rewardRate = _rewardRate;
    }

    // 通知合约收到了奖励代币 (仅限管理员)
    function notifyRewardAmount(uint256 reward) external onlyOwner {
        require(reward > 0, "Reward must be greater than 0");
        rewardToken.transferFrom(msg.sender, address(this), reward);

        uint256 currentTime = block.timestamp;
        if (currentTime >= lastUpdateTime) {
            rewardRate = reward / (currentTime - lastUpdateTime);
        }
    }

    // 质押代币
    function stake(uint256 amount) external updateReward(msg.sender) {
        require(amount > 0, "Cannot stake 0");
        _totalSupply += amount;
        userInfo[msg.sender].balance += amount;
        stakingToken.transferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

    // 提取代币
    function withdraw(uint256 amount) external updateReward(msg.sender) {
        require(amount > 0, "Cannot withdraw 0");
        require(userInfo[msg.sender].balance >= amount, "Insufficient balance");

        _totalSupply -= amount;
        userInfo[msg.sender].balance -= amount;
        stakingToken.transfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    // 领取奖励
    function getReward() external updateReward(msg.sender) {
        uint256 reward = userInfo[msg.sender].rewards;
        if (reward > 0) {
            userInfo[msg.sender].rewards = 0;
            rewardToken.transfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    // 获取总质押量
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }
}