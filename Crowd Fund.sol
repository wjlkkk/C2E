// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC20 {
    function transferfrom(address _from,address _to, uint amount) external;
    function transfer(address,uint) external ;
     
}


contract CorwdFund{
    struct Campagin{
        address creator;
        uint  goal;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
        uint pledged;
    }

    IERC20 public immutable token;
    mapping(uint => Campagin) public campaigns;
    uint public count;
    mapping(uint => mapping(address => uint)) public pledgedAmount;
    event Loglauch(uint goal,address creator);
    event Logcancel(address creator,uint countid);
    event Logpledge(address pledger,uint amount);
    event Logunpledge(address pledger,uint amount);
    event Logclaim(uint amount);
    event Logrefund(address,uint);

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(uint _goal , uint continuedays ) external {
        count +=1;
        campaigns[count] = Campagin({
            creator:msg.sender,
            goal: _goal,
            startAt:uint32(block.timestamp),
            endAt:uint32(continuedays*1 days + block.timestamp) ,
            claimed : false,
            pledged :0
        });

        emit Loglauch(_goal ,msg.sender);

    } 



    function cancel(uint countid) external {
        require(campaigns[countid].creator == msg.sender, "Only creator can cancel");
        delete campaigns[countid];
        emit Logcancel(msg.sender,countid);
    }

    function pledge(uint countid,uint amount) external  {
        require(amount !=0,'Invalid amount');
        Campagin storage campaign = campaigns[countid];
        require(campaign.pledged <campaign.goal,'It is over goal');
        require(block.timestamp>=campaign.startAt&&block.timestamp<= campaign.endAt,"Pledge must be between start and end");
        token.transferfrom(msg.sender,address(this), amount );
        pledgedAmount[countid][msg.sender]+=amount;//用 += 是因为考虑到同一地址有多笔投入
        campaign.pledged +=amount;
        emit Logpledge(msg.sender,amount);
    }

    function unpledge(uint countid,uint amount) external {
        require(pledgedAmount[countid][msg.sender] !=0 &&pledgedAmount[countid][msg.sender] >= amount ,'Invalid pledger');
        Campagin storage campaign = campaigns[countid];
        require(block.timestamp<= campaign.endAt,'It has been over');
        token.transfer(msg.sender, amount);
        campaign.pledged -= amount;
        pledgedAmount[countid][msg.sender] -= amount;
        emit Logunpledge(msg.sender,amount);
    }

    function claim(uint countid) external {
        Campagin storage campaign = campaigns[countid];
        require(campaign.creator == msg.sender,'Only owner can do this');
        require(campaign.pledged >= campaign.goal,'It is not over goal');
        require(block.timestamp>= campaign.endAt,'It has not finish');
        require(!campaign.claimed,'It has been claimed');
        campaign.claimed = true;
        token.transfer(campaign.creator,campaign.pledged);
        campaign.pledged = 0;
        emit Logclaim(campaign.pledged);
    }   

    function refund(uint countid) external {
        Campagin storage campaign = campaigns[countid];
        require(block.timestamp >= campaign.endAt,'It has not been over');
        require(pledgedAmount[countid][msg.sender] != 0,'Not found');
        require(!campaign.claimed,'It has been claimed');
        uint bal = pledgedAmount[countid][msg.sender];
        token.transfer(msg.sender,bal);
        pledgedAmount[countid][msg.sender] =0 ;
        campaign.pledged -= bal;
        emit Logrefund(msg.sender,bal);
    }
}