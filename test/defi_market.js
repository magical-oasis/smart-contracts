const { assert, log } = require('console')

const DefiMarket = artifacts.require('DefiMarket')

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract('DefiMarket', accounts => {
  it('Get number of pending purchases should return 0 when there is no offer', () => {
    DefiMarket.deployed()
      .then(instance => {
        instance.getNumberOfPendingPurchasesForBuyer.call(accounts[0])
          .then(nbOfPendingPurchases => {
            assert.equal(nbOfPendingPurchases, 0, 'Should be init at 0')
          })
      })
  })

  it('Get number of buying offer should return 0 when there is no offer', () => {
    DefiMarket.deployed().then(instance => {
      instance.getNumberOfBuyingOfferForListingId.call(1234).then(nbOfBuyingOffer => {
        assert.equal(nbOfBuyingOffer, 0, 'Should be init at 0')
      })
    })
  })

  // it('Add trade offer should add a trade', () => {
  //  let meta
  //  let addr

  //  DefiMarket.deployed()
  //    .then(instance => {
  //      meta = instance
  //      meta.addTradeOffer(accounts[1], 1234, { from: accounts[0], value: 1 })
  //        .then(() => {
  //          addr = meta.listingIdToBuyersAddress.call(1234, 0)
  //        })
  //    })
  //    .then(() => {
  //      assert.equal(addr, 'test', 'Address is not added or not the good one')
  //    })
  // })
})
