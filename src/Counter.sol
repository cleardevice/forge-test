// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

error NotAnOwner();

contract Counter {
    uint256 public number;
    address public owner;

    event Inc(uint indexed number, address indexed initiator);

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner!");
        _;
    }

    modifier onlyOwnerCustomError() {
        if (msg.sender != owner) {
            revert NotAnOwner();
        }
        _;
    }

    constructor(uint _initialNum) {
        number = _initialNum;
        owner = msg.sender;
    }

    function setNumber(uint256 newNumber) external onlyOwner {
        number = newNumber;
    }

    function increment() external onlyOwner {
        number++;

        emit Inc(number, msg.sender);
    }

    function incrementCustomError() external onlyOwnerCustomError {
        number++;
    }

    receive() external payable {}
}
