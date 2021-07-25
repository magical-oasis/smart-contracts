// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract DefiMarket {
    address payable public minter;

    // TODO(marco) create struct for this
    // TODO(marco) support one than more trade
    mapping(address => uint256) public priceInWei;
    mapping(address => uint256) public listingIds;
    mapping(address => address payable) public ethAddrOfSellers;

    mapping(uint256 => address[]) public listingIdsWithBuyingOffers;

    constructor() {
        minter = payable(msg.sender);
    }

    function wakeup(address payable buyer) public payable {
        require(msg.sender == minter, "Only the owner can call this.");

        uint256 amountToSend = priceInWei[buyer];
        address payable receiver = ethAddrOfSellers[buyer];

        receiver.transfer(amountToSend);

        priceInWei[buyer] = 0;
        ethAddrOfSellers[buyer] = payable(address(0));
        listingIds[buyer] = 0;
    }

    function addTradeOffer(address payable receiver, uint256 listingId)
        public
        payable
    {
        require(msg.value != 0, "You need to send ETH to buy a skin!");

        payable(address(this)).transfer(msg.value);

        priceInWei[msg.sender] = msg.value;
        listingIds[msg.sender] = listingId;
        ethAddrOfSellers[msg.sender] = receiver;
        listingIdsWithBuyingOffers[listingId].push(msg.sender);
    }

    function getNumberOfBuyingOfferForListingId(uint256 listingId) public view returns (uint)
    {
        uint length = listingIdsWithBuyingOffers[listingId].length;
        return length;
    }

    function withdraw(uint256 amount) public payable {
        require(msg.sender == minter, "Only the owner can call this.");

        payable(msg.sender).transfer(amount);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function deposit() public payable {
        require(msg.value != 0, "Useless to deposit 0 ETH");

        payable(address(this)).transfer(msg.value);
    }

    receive() external payable {}
}
