# smartcontract

## Truffle setup 

See: https://www.trufflesuite.com/tutorial

1. Install truffle
```bash
npm install -g truffle
```
2. Run truffle version
```bash
truffle version
```
3. Download ganache https://www.trufflesuite.com/docs/ganache/quickstart


let instance = await DefiMarket.deployed()
let accounts = await web3.eth.getAccounts()
instance.addTradeOffer(accounts[1], 123, {from: accounts[0], value: 1})
instance.listingIdToBuyersAddress.call(123, 0)
instance.getNumberOfBuyingOfferForListingId.call(123)