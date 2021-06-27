// "SPDX-License-Identifier: UNLICENSED"

pragma solidity ^0.6.0;


contract DefiMarket {
  
    //address payable public minter;
    //mapping (address => uint) public balances;

    // Events allow light clients to react on
    // changes efficiently.
    //event Sent(address from, address to, uint amount);

    constructor() public payable {
        minter = msg.sender;
    }
    
    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function wakeup(address payable receiver)  public payable
    {
        require(msg.sender != minter, "Only the owner can call this.");

        receiver.transfer(1);
    }
     
    function withdraw(uint amount) public payable {
         msg.sender.transfer(amount);
    }
    
    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
    
    function deposit() public payable {
        payable(address(this)).transfer(msg.value);
    }
    
    receive() external payable { }

    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
}