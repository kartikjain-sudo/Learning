// SPDX-License-Identifier: None
pragma solidity 0.8.0;

contract Test1 {
    function add(uint a, uint b) public pure returns(uint256){  //Simply add the two arguments and return
        return a+b;
    }
    function max() public pure returns (uint256){  //If the function signature doesn't check out, return -1
        return 2**256-1;
    }
}

contract Test2 {
    Test1 test1;

    constructor(Test1 addr) {  //Constructor function
        test1 = addr; // new Test1();  //Create new "Test1" function
    }

    function test(uint a, uint b) public view returns (uint c){
        address addr = address(test1);  //Place the test1 address on the stack
        bytes4 sig = bytes4(keccak256("add(uint256,uint256)")); //Function signature
        // console.log(string(sig));

        assembly {
            let x := mload(0x40)   //Find empty storage location using "free memory pointer"
            mstore(x,sig) //Place signature at begining of empty storage 
            mstore(add(x,0x04),a) //Place first argument directly next to signature
            mstore(add(x,0x24),b) //Place second argument next to first, padded to 32 bytes

            let success := staticcall(      //This is the critical change (Pop the top stack value)
                                5000, //5k gas
                                addr, //To addr
                                //0,    //No value
                                x,    //Inputs are stored at location x
                                0x44, //Inputs are 68 bytes long
                                x,    //Store output over input (saves space)
                                0x20) //Outputs are 32 bytes long

            c := mload(x) //Assign output value to c
            mstore(0x40,add(x,0x44)) // Set storage pointer to empty space
        }

    }

    function test2(uint a, uint b) public view returns(uint256 c){ //Make sure the Test1 function works properly
        return test1.add(a,b); // (It does)
    }
}
