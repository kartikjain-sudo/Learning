// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Transfer {

    function transferFrom(address token, address from, address to, uint256 amount) public {
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, 0x23b872dd)
            mstore(add(ptr,0x04), from)
            mstore(add(ptr,0x24), to)
            mstore(add(ptr,0x44), amount)
            let callStatus := call(gas(), token, 0, ptr, 0x64, /* 4 + 32 * 3 == 100*/ 0, 0x20)
            if iszero(callStatus) {
                revert(0, 0)
            }
        }
    }
}
