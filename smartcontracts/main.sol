// "SPDX-License-Identifier: UNLICENSED"

pragma solidity ^0.6.0;


contract DefiMarket {
  
    address payable public minter;
    mapping (address => uint) public balances;
    mapping (address => uint) public items;
    mapping (address => address payable) public tradeReceivers;


    constructor() public payable {
        minter = msg.sender;
    }
    

    function wakeup(address payable seller)  public payable
    {
        require(msg.sender == minter, "Only the owner can call this.");
        
        uint amountToSend = balances[seller];
        address payable receiver = tradeReceivers[seller];
        
        receiver.transfer(amountToSend);
        
        balances[seller] = 0;
        tradeReceivers[seller] = address(0);
        items[seller] = 0;
    }
    
    function addTradeOffer(address payable receiver, uint256 itemId)  public payable
    {
        require(msg.value != 0, "You need to send ETH to buy a skin!");

        payable(address(this)).transfer(msg.value);
        
        balances[msg.sender] = msg.value;
        items[msg.sender] = itemId;
        tradeReceivers[msg.sender] = receiver;
    }
    
    function balanceOf(address _tokenHolder) public view returns (uint) {
        return balances[_tokenHolder];
    }
    
    function getMyBalance() public view returns (uint) {
        return balances[msg.sender];
    }
    
    function getMyTradeReceiver() public view returns (address) {
        return tradeReceivers[msg.sender];
    }
    
    function getMyTradeItem() public view returns (uint) {
        return items[msg.sender];
    }
     
    function withdraw(uint amount) public payable {
        require(msg.sender == minter, "Only the owner can call this.");

        msg.sender.transfer(amount);
    }
    
    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
    
    function deposit() public payable {
        require(msg.value != 0, "Useless to deposit 0 ETH");

        payable(address(this)).transfer(msg.value);
    }
    
    receive() external payable {}

}