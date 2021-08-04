const DefiMarket = artifacts.require('DefiMarket')

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract('DefiMarket', function(accounts) {
  it('Get number of pending purchases should return 0 when there is no offer', async function () {
    const instance = await DefiMarket.deployed()
    const nbOfPendingPurchases = await instance.getNumberOfPendingPurchasesForBuyer.call(accounts[0])
    return assert.equal(nbOfPendingPurchases, 0)
  })

  it('Get number of buying offer should return 0 when there is no offer', async function() {
    const instance = await DefiMarket.deployed()
    const nbOfBuyingOffer = await instance.getNumberOfBuyingOfferForListingId(1234)
    assert.equal(nbOfBuyingOffer, 0)
  })

  it('Add trade offer should add a trade', async function() {
    const instance = await DefiMarket.deployed()
    await instance.addTradeOffer(accounts[1], 1234, { from: accounts[0], value: 1 })
    const addr = await instance.listingIdToBuyersAddress.call(1234, 0)

    assert.equal(addr.toString(), accounts[0], 'Address is not added or not the good one')

    const item = await instance.buyerPendingPurchases.call(accounts[0], 0)
    assert.equal(item[0], 1)
    assert.equal(item[1], 1234)
    assert.equal(item[2], accounts[1])

    const x = await instance.getContractBalance.call()
    assert.equal(x, 1)
  })

  it('Add a duplicate trade offer should fail', async function() {
    let errorCaught = false

    const instance = await DefiMarket.deployed()

    try {
      await instance.addTradeOffer(accounts[1], 1234, { from: accounts[0], value: 1 })
    } catch (error) {
      assert.isTrue(true)
      errorCaught = true
    }

    if (!errorCaught) {
      assert.isTrue(false)
    }
  })
})
