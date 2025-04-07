// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract TimeLock {
    address public onwer;
    error Timedonotmatch();
    error Timehasexpired();
    error Timedonotrightnow();
    event Queued(
        address indexed target,
        uint256 value,
        string func,
        bytes data,
        uint256 timestamp
    );

    constructor() {
        onwer = msg.sender;
    }

    uint256 public constant MIN_DEL = 10;
    uint256 public constant MAX_DEL = 1000;
    uint256 public constant max_time = 100000;
    mapping(bytes32 => bool) public queued;

    modifier Onlyower() {
        require(msg.sender == onwer, "Not Owner");
        _;
    }

    function gettxid(
        address _address,
        uint256 _value,
        string calldata func,
        bytes memory _data,
        uint256 timestamp
    ) public pure returns (bytes32) {
        return keccak256(abi.encode(_address, _value, func, _data, timestamp)); ///?为什么要用哈希？直接encode有问题吗？
    }

    receive() external payable { }

    function queue(
        address _address,
        uint256 _value,
        string calldata func,
        bytes calldata _data,
        uint256 timestamp
    ) external Onlyower {
        bytes32 bytecode = gettxid(_address, _value, func, _data, timestamp);
        if (queued[bytecode]) {
            revert("Already Queue");
        }
        if (
            timestamp > block.timestamp + MAX_DEL
        ) {
            revert Timedonotmatch();
        }
        queued[bytecode] = true;

        emit Queued(_address, _value, func, _data, timestamp);
    }

    function execute(
        address _address,
        uint256 _value,
        string calldata func,
        bytes memory _data,
        uint256 timestamp
    ) external payable  Onlyower returns (bytes memory) {
        bytes32 bytecode = gettxid(_address, _value, func, _data, timestamp);
        require(queued[bytecode], "Not Queue");
        if (block.timestamp > timestamp + max_time) {
            revert Timehasexpired();
        }
        if (block.timestamp < timestamp) {
            revert Timedonotrightnow();
        }
        delete queued[bytecode];

        bytes memory datas;
        if (bytes(func).length > 0) {
            datas = abi.encodePacked(bytes4(keccak256(bytes(func))), _data);
        } else {
            datas = _data;
        }
        (bool ok, bytes memory res) = _address.call{value: _value}(datas);
        require(ok, "Execute failed");
        return res;
    }

    function cancel(bytes32 bytecode) external {
        require(queued[bytecode], "Not in queue");
        //delete queued[bytecode];
        queued[bytecode] = false;
    }

    function getbalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract TestTimeLock {
    address public timeLock;

    constructor(address _timeLock) {
        timeLock = _timeLock;
    }
    receive() external payable { }

    function test() external payable  {
        require(msg.sender == timeLock);
        // more code such as
        // - 升级合约
        // - 转移资产
        // - 修改预⾔机
    }

    function getTimestamp() external view returns (uint256) {
        return block.timestamp + 100;
    }
}
