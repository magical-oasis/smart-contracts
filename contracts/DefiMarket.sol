// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract DefiMarket {
    address payable public minter;

    struct TradeOffer {
        uint256 priceInWei;
        uint256 listingId;
        address payable ethAddrOfSellers;
    }

    mapping(address => TradeOffer[]) public buyerPendingPurchases;

    mapping(uint256 => address[]) public listingIdToBuyersAddress;

    constructor() {
        minter = payable(msg.sender);
    }

    function wakeup(address payable buyer, uint256 listingId) public payable {
        require(msg.sender == minter, "Only the owner can call this.");

        uint256 amountToSend = 0;
        address payable receiver = payable(address(0));
        uint256 itemIndex = 0;

        uint256 length = buyerPendingPurchases[buyer].length;
        for (uint256 i = 0; i < length; i++) {
            TradeOffer memory offer = buyerPendingPurchases[buyer][i];
            if (offer.listingId == listingId) {
               amountToSend = offer.priceInWei; 
               receiver = offer.ethAddrOfSellers;
               itemIndex = i;
               break;
            }
        }

        delete buyerPendingPurchases[buyer][itemIndex];

        // TODO(marco): take 2% fees before sending money
        // put it in a map
        // mapping (address => uint) public balances;
        // balances[minter] = 2%;
        receiver.transfer(amountToSend);
    }

    // TODO(marco): remove trade offer
    // What do we do when an other trade offer is already there for an item? can we have more than one? do people need to cancel them or we return the money after 7 days?
    // TODO(marco): validate duplicate offer
    function addTradeOffer(address payable ethAddressOfSeller, uint256 listingId)
        public
        payable
    {
        require(msg.value != 0, "You need to send ETH to buy a skin!");

        payable(address(this)).transfer(msg.value);

        buyerPendingPurchases[msg.sender].push(
            TradeOffer({priceInWei: msg.value, listingId: listingId, ethAddrOfSellers: ethAddressOfSeller})
        );

        listingIdToBuyersAddress[listingId].push(msg.sender);
    }

    function getNumberOfPendingPurchasesForBuyer(address buyer) public view returns (uint)
    {
        uint length = buyerPendingPurchases[buyer].length;
        return length;
    }

    function getNumberOfBuyingOfferForListingId(uint256 listingId) public view returns (uint)
    {
        uint length = listingIdToBuyersAddress[listingId].length;
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
