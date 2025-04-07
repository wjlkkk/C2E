// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Mytest{
    enum OrderStatus{
        None,
        Pending,
        Shipped,
        Completed,
        Rejected,
        Cancelled
    }

    OrderStatus public status;
    struct Order{
        address BuyerAddress;
        OrderStatus status;
    }
    
    Order[] public  orders;
    mapping (address =>uint) public  BuyerisDone;
    mapping (address=>bool) public BuyerisExist;

    modifier cap(address buyer){
        require(BuyerisExist[buyer] == true,'Buyer not exist');
        require(buyer!=address(0),'Invalid address');
        _;
    }

    function add_order(address buyer,OrderStatus status) external {
        require(buyer!=address(0),'Invalid address');
        orders.push(Order(buyer,status));
        BuyerisDone[buyer] = orders.length-1; 
        BuyerisExist[buyer] = true;
    }

    function update_order(address buyer,OrderStatus _status) external cap(buyer){
        uint orderIndex = BuyerisDone[buyer];
        orders[orderIndex].status=_status;
        
    }

    function get_order(address buyer) external  cap(buyer) view returns (OrderStatus) {
        return orders[BuyerisDone[buyer]].status;
    }

    function reset_order(address buyer)  cap(buyer) external {
        orders[BuyerisDone[buyer]].status = OrderStatus.None;
    }
}