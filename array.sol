// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract test{
    uint[] public nums = [1,2,3,4];
    uint[3] public numsfixed = [1,2,3];
    
    function insert() public  {
        nums.push(5);
    }

    function display(uint _index) public view returns (uint) {
        return (nums[_index]);
    }

    function update(uint _index, uint _number) public {
        nums[_index] = _number;
    }

    function deletedelete(uint _index) public  {
        delete nums[_index];
    }

    function getlength() public view returns (uint) {
        return uint(nums.length);
    }
}