// SPDX-License-Identifier: None
pragma solidity 0.8.17;

contract sum {

    uint256[] private arr; // = new uint256[](5);

    function getArray() public view returns(uint256[] memory) {
        return arr;
    }

    function insert(uint256[] memory _arr) public {
        for (uint i = 0; i<_arr.length; i++) {
            arr.push(_arr[i]);
        }
    }

    function sumHL(uint256[] memory _arr) public pure returns (uint256 _sum) {  // 26370 gas
        for (uint i = 0; i < _arr.length; i++) {
            _sum += _arr[i];
        }
    }

    function sumLL(uint256[] memory _arr) public pure returns (uint256 _sum) { // 24664 gas
        // _arr is the pointer in memory where the length of the array is stored
        assembly {
            let len := mload(_arr) // Load the length of the array from the first slot
            for {let i:=0} lt(i,len) { i:= add(i,1)} { // Start at i = 0 and iterate while i < len, incrementing i by 1 each time
                _sum := add(_sum, mload(add(add(_arr, 0x20), mul(i, 0x20)))) // Add the value at the current index to the sum
            }
        }
    }

    // minor optimization
    function sumLL2(uint256[] memory _arr) public pure returns (uint256 _sum) { // 24624 gas
        // _arr is the pointer in memory where the length of the array is stored
        assembly {
            let len := mload(_arr) // Load the length of the array from the first slot
            for {let i:=0} iszero(eq(i,len)) { i:= add(i,1)} { // Start at i = 0 and iterate while i < len, incrementing i by 1 each time
                _sum := add(_sum, mload(add(add(_arr, 0x20), mul(i, 0x20)))) // Add the value at the current index to the sum
            }
        }
    }
}