// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;


contract DefiMarket {
  
    address payable public minter;
    mapping (address => uint) public balances;
    mapping (address => string) public items;
    mapping (address => address payable) public tradeReceivers;


    constructor() public payable {
        minter = msg.sender;
    }
    

    function wakeup(address payable buyer)  public payable
    {
        require(msg.sender == minter, "Only the owner can call this.");
        
        uint amountToSend = balances[buyer];
        address payable receiver = tradeReceivers[buyer];
        
        receiver.transfer(amountToSend);
        
        balances[buyer] = 0;
        tradeReceivers[buyer] = address(0);
        items[buyer] = "";
    }
    
    function addTradeOffer(address payable receiver, string memory itemId)  public payable
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
    
    function getMyTrade() public view returns (string memory, address, uint) {
        return (items[msg.sender], tradeReceivers[msg.sender], balances[msg.sender]);
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