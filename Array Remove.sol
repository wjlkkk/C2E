// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract ArrayRemove {
    function remove(uint[] memory arr,uint index) public pure returns (uint[] memory) {
        require(index > 0 && index < arr.length,"Index out of bounds");
        arr[index] = arr[arr.length-1];
        uint[] memory newArr = new uint[](arr.length-1); // 在内存中新增数组。动态分配内存
        for(uint i = index;i<arr.length -1 ;i++){
            newArr[i]=arr[i];
        }
        return newArr;
        
    }//这种删除之后顺序是跟旧数据数组是不一样的

    uint[] public nums = [1,2,3,4];
    function efficientRemove(uint index) public{
        nums[index] = nums[nums.length-1];
        nums.pop();
    }

    function test() public view {
        assert(nums.length==3);
        assert(nums[0] == 1);
    }
}