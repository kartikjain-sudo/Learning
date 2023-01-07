// SPDX-License-Identifier: None
pragma solidity 0.8.17;

contract Masking {
    address public owner;
    uint256 public x;

    constructor() {
        owner = msg.sender;
        x = uint256(uint160(owner));
    }

    function callerInSolidity() public view returns(bool res) {
        address storedCaller = address(uint160(x));
        res = msg.sender == storedCaller;
    }

    function callerInAssemblyWrong() public view returns(bool res) {
        address storedCaller = address(uint160(x));
        assembly {
            res := eq(caller(), storedCaller)
        }
    }

    function callerInAssemblyRight() public view returns(bool res) {
        address storedCaller = address(uint160(x));
        assembly {
            res := eq(caller(), and(storedCaller, 0xffffffffffffffffffffffffffffffffffffffff))
        }
    }

    function retCall() public view returns(uint256) {
        return uint256(uint160(msg.sender));
    }

    function storedCall() public view returns(address) {
        return address(uint160(msg.sender));
    }

    function ca() public view returns(address r) {
        assembly {
            r := caller()
        }
    }

    function stoCall() public view returns(address s) {
        s = address(uint160(msg.sender));
        assembly {
            s := shr(96, shl(96, s))
        }
    }

    function load() public view returns(uint256) {
        uint256 a;
        assembly {
            a := sload(0x01)
        }
        return a;
    }
}