// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract MostSignificantBit {
    // 计算最高有效位的位置
    function findMostSignificantBit(uint256 x) external pure returns (uint8 r) {
        // 如果 x >= 2^128，右移 128 位
        if (x >= 2 ** 128) {
            x >>= 128;
            r += 128;
        }
        // 如果 x >= 2^64，右移 64 位
        if (x >= 2 ** 64) {
            x >>= 64;
            r += 64;
        }
        // 如果 x >= 2^32，右移 32 位
        if (x >= 2 ** 32) {
            x >>= 32;
            r += 32;
        }
        // 如果 x >= 2^16，右移 16 位
        if (x >= 2 ** 16) {
            x >>= 16;
            r += 16;
        }
        // 如果 x >= 2^8，右移 8 位
        if (x >= 2 ** 8) {
            x >>= 8;
            r += 8;
        }
        // 如果 x >= 2^4，右移 4 位
        if (x >= 2 ** 4) {
            x >>= 4;
            r += 4;
        }
        // 如果 x >= 2^2，右移 2 位
        if (x >= 2 ** 2) {
            x >>= 2;
            r += 2;
        }
        // 如果 x >= 2^1，增加 1
        if (x >= 2) {
            r += 1;
        }
    }
}