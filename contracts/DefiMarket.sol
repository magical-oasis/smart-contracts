// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract DefiMarket {

    uint feesPercentage = 3;

    address payable public minter;

    mapping(address => uint256) public availableBalances;

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

        // refund when oders have an offer but not accepted
        // TODO(marco) remove others offer before deleting here and money in their balance
        delete listingIdToBuyersAddress[listingId];

        // Put the money in the good balance
        // And take the fees
        uint feesAmount = amountToSend * feesPercentage / 100;
        uint amountWithfeesRemoved = amountToSend - feesAmount;
    
        availableBalances[receiver] += amountWithfeesRemoved;
        availableBalances[minter] += feesAmount;
    }

    // Idea for later(marco) if the is no msg.value and if there is a parameter with the wei to use for the item than take it in the balance
    function addTradeOffer(address payable ethAddressOfSeller, uint256 listingId)
        public
        payable
    {
        require(msg.value != 0, "You need to send ETH to buy a skin!");

        require(getNumberOfBuyingOfferForListingId(listingId) == 0, "There is already an offer for this item");

        //uint nbOfPendingPurchases = getNumberOfPendingPurchasesForBuyer(msg.sender);
        //for (uint i = 0; i < nbOfPendingPurchases; i++) {
        //    if (listingId == buyerPendingPurchases[msg.sender][i].listingId) {
        //        require(false, "Trade offer already exist for this item");
        //    }
        //} 

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

    // TODO fix this
    function withdrawMyAvailableBalance() public payable {
        payable(address(this)).transfer(availableBalances[msg.sender]);
        availableBalances[msg.sender] = 0;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {}
}
