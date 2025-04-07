// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MultiSigWallet {
    event Deposit(address indexed sender,uint amount);
    event Submit(uint indexed txId);
    event Approve(address indexed owner,uint indexed txId);
    event Execute(uint indexed txId);
    event Revoke(address indexed owner,uint indexed txId);

    address[] public owners;
    mapping (address => bool) public isOwner;
    uint public required;
    struct Transactions{
        address to;
        uint amount;
        bytes data;
        bool executed;
    }
    mapping (uint =>mapping (address => bool)) public approve;
    Transactions[] public transactions;
    constructor(address[] memory _owners,uint _required){
        require(_owners.length>0 && _required>0, 'At least one owner is required for multisig wallet');
        required =_required;
        require(_owners.length>_required,'The minimum number of owners required must be less than the total');
        for (uint i=0;i<_owners.length;i++){
            require(_owners[i]!=address(0),'Invalid address');
            require(isOwner[_owners[i]]==false,'Address already exists in');
            isOwner[_owners[i]]=true;
            owners.push(_owners[i]);
        }
    }

    receive() external payable { 
        emit Deposit(msg.sender, msg.value);
    }

    modifier Onlyonwer(){
        require(isOwner[msg.sender]==true,'Only owner can do it');
        _;
    }

    modifier txExist(uint _txId){
        require(_txId >= 0 && _txId < transactions.length,'TxId not Exist');
        _;
    }

    modifier notApproved(uint _txId){
        require(!approve[_txId][msg.sender],'It has benn approved');
        _;
    }

    modifier notExecuted(uint _txId){
        require(!transactions[_txId].executed,'It has been executed');
        _;
    }
    function _submit(address _to,uint _amount,bytes memory _data) external Onlyonwer() {
        require(_to!=address(0),'Invalid to address');
        transactions.push(Transactions({
            to:_to,
            amount:_amount,
            data:_data,
            executed: false
        }));
        emit Submit(transactions.length-1);
    }


    function Approved(uint txId ) external txExist(txId) notApproved(txId) notExecuted(txId) Onlyonwer() {
        approve[txId][msg.sender]=true;
        emit Approve(msg.sender, txId);
    } 

    function checkapprovalcount(uint txId) private view txExist(txId) notExecuted(txId) returns (uint count){
        for (uint i=0;i<owners.length;i++){
            if (approve[txId][owners[i]]){
                count +=1;
            }
        }
    }

    function execute(uint txId) external txExist(txId) notExecuted(txId) Onlyonwer(){
        uint count = checkapprovalcount(txId);
        require(count>=required,'Not enough owner approve');
        Transactions storage transferinfo = transactions[txId];
        (bool success,) = transferinfo.to.call{value:transferinfo.amount}(transferinfo.data);
        require(success,'Failed to execute');
        transferinfo.executed =true;
        emit Execute(txId);
    }

    function revoked(uint txId) external Onlyonwer() txExist(txId) {
        approve[txId][msg.sender]=false;
        emit Revoke(msg.sender, txId);
    }
}