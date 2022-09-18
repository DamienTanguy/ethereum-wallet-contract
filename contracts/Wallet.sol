// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import './Owner.sol';

contract Wallet is Owner {

    struct Payment {
        uint amount;
        uint timestamp;
    }

    struct Balance {
        address walletAddress;
        uint totalBalance;
        uint numPayments;
        mapping(uint => Payment) payments;
    }

    mapping(address => Balance) wallets;

    function getBalance() public isOwner view returns(uint) { //Only the oner of the contract can know the total amount of the contract
        return address(this).balance; //return the balance of this current contract
    }

    function withdrawAllMoney(address payable _to) public { //anyone can use this function --> public
        uint amount = wallets[msg.sender].totalBalance;
        wallets[msg.sender].totalBalance = 0;
        _to.transfer(amount);
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        require(_amount <= wallets[msg.sender].totalBalance, "Not enough fund");
        wallets[msg.sender].totalBalance -= _amount;
        _to.transfer(_amount);
    }

    receive() external payable {
        Payment memory thisPayment = Payment(msg.value, block.timestamp); //Not stored in the blockchain --> save of gas 
        wallets[msg.sender].totalBalance += msg.value;
        wallets[msg.sender].payments[wallets[msg.sender].numPayments] = thisPayment;
        wallets[msg.sender].numPayments++;
    }

}