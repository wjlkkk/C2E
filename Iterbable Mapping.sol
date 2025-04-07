// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract iterable{
    mapping (address => uint) balance;
    mapping (address => bool) inserted;
    address[] public keys;

    function set(address _address , uint amount) external {
        require(_address!= address(0),'Invalid Address');
        balance[_address] = amount;
        keys.push(_address);
        inserted[_address] = true;
    }

    function getsize() external  view  returns  (uint){
        return (keys.length);
    }

    function checkamount(uint _index) external view returns (uint) {
        address Nowaddress = keys[_index];
        require(inserted[Nowaddress]==true,'Not find the answer');
        return (balance[Nowaddress]);
    }
}