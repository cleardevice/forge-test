// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import { Counter, NotAnOwner } from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    event Inc(uint indexed number, address indexed initiator);

    function setUp() public {
        counter = new Counter(100);
    }

    function testReceive() public {
        assertEq(address(counter).balance, 0);

        (bool success,) = address(counter).call{value: 100}("");
        assertEq(success, true);
        assertEq(address(counter).balance, 100);
    }

    function testIncrement() public {
        vm.expectEmit(true, true, true, false);
        emit Inc(101, address(this));

        counter.increment();
        assertEq(counter.number(), 101);
    }

    function testSetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function testFailIncrementNotOwner() public {
        vm.prank(address(0));
        counter.increment();
    }

    function testIncrementNotOwner() public {
        vm.expectRevert(bytes("not an owner!"));
        vm.prank(address(0));
        counter.increment();
    }

    function testIncrementNotOwnerCustomError() public {
        vm.expectRevert(NotAnOwner.selector);
        vm.prank(address(0));
        counter.incrementCustomError();
    }

    function testFailSubstraction() public view {
        uint num = counter.number();
        num -= 1000;
    }

    function testSubstractionUnderflow() public {
        uint num = counter.number();
        vm.expectRevert(stdError.arithmeticError);
        num -= 1000;
    }
}
