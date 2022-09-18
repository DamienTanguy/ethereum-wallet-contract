// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Owner {

    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

}