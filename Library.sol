// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

library MathLib {
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x <= y ? x : y;
    }
}

library ArrayUtils {
    function sum(uint256[] storage nums) internal view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i <= nums.length - 1; i++) {
            total += nums[i];
        }
        return total;
    }
}

contract LibraryContract {
    using ArrayUtils for uint256[];
    uint256 public x = 1;
    uint256 public y = 10;
    uint256[] public nums = [2, 3, 4, 1, 2, 34, 4];
    uint256 public min = MathLib.min(x, y);
    uint256 public sum = nums.sum();
}
