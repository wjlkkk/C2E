// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC721 {
    function transferFrom(address from, address to, uint256 id) external;
}


contract DuthchAuction{
    uint private constant Duringdays=7 days;
    uint public immutable NFTID;
    address public immutable seller;
    uint public immutable StartPrice;
    uint public immutable DiscountRate;
    uint public immutable startAt;
    uint public immutable endAt;
    IERC721 public  immutable NFT;
    constructor (
        address _NFT,
        uint _NFTID,
        uint _StartPrice,
        uint _DiscountRate
    ){
        seller = payable(msg.sender);
        NFTID = _NFTID;
        StartPrice = _StartPrice;
        DiscountRate = _DiscountRate;
        startAt = block.timestamp;
        endAt = startAt + Duringdays;

        NFT = IERC721(_NFT);
    }


    function getPrice() public  view returns (uint) {
        uint Timeleft=block.timestamp - startAt;
        require(Timeleft>0,'Auction not begin');
        return StartPrice - DiscountRate*Timeleft;
    }

    function buy() payable external {
        uint price = getPrice();
        require(block.timestamp <= endAt,'Auction is over');
        require(msg.value>= price,'Not enough ETH');
        NFT.transferFrom(seller, msg.sender, NFTID);
        if (msg.value > price){
            payable(msg.sender).transfer(msg.value-price);
        }
    }
    
    

}