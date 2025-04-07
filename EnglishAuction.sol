// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC721 {
    function transferFrom(address from, address to, uint256 id) external;
}



contract EnglishAuction{
    IERC721 public immutable nft;
    uint public immutable nftid;
    address payable public immutable seller;
    address public bidder;
    uint32 public  starttime;
    uint32 public endtime;
    bool public isstart;
    uint public  highestprice;
    mapping (address => uint) public bids;
    event Logstart(uint indexed _nftid,uint32 indexed starttime);
    event Logbig(address indexed  bidder , uint amount);
    event Logrefund(address indexed refunder,uint amount);
    constructor(
        address _nft,
        uint _nftid,
        uint _highestprice
        ){
            nft = IERC721(_nft);
            nftid =_nftid;
            highestprice = _highestprice;
            seller = payable(msg.sender);
        }

    function start() external {
        require(msg.sender == seller,"not allowed");
        require(!isstart,'started');
        isstart = true;
        endtime = uint32(block.timestamp +60);
        nft.transferFrom(seller, address(this), nftid);
        emit Logstart(nftid,starttime);
    }

    function big() external payable  {
        require(isstart,'Not start');
        require(block.timestamp < endtime,'It has benn finished ');
        require(msg.value > highestprice,'You must give a higher price!');
        
        highestprice = msg.value;
        bidder = msg.sender;
        bids[bidder] = msg.value;
        
        emit  Logbig(bidder, msg.value);

    }

    function refund() external  {
        require(bids[msg.sender]!=0,'Not found');
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);
        //(bool success,) = payable(address(this)).call{value:bids[msg.sender]}('');
        emit Logrefund(msg.sender,bids[msg.sender]);
        
    }
    
    function end() external {
        //require(isstart,'Not end');
        require(block.timestamp >=endtime,'It has not benn finished ');
        if (bidder != address(0)){
            isstart = false;
            nft.transferFrom(address(this), bidder, nftid);
            payable(seller).transfer(bids[bidder]);
        } else {
            nft.transferFrom(address(this), seller, nftid);
        }
        

    }
    
    
}