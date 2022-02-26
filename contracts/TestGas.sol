// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract TestGas {
    uint256 a;
    uint256 b;
    uint256 c;

    function test1() public {
        a++;
    }

    function test2() public {
        a++;
        b++;
    }

    function test3() public {
        a++;
        b++;
        c++;
    }

    function test4() public {
        c = a + b;
    }

    function test5() public {
        test4();
        b = c + a;
    }
}
