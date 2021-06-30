const DefiMarket = artifacts.require("DefiMarket");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("DefiMarket", function (/* accounts */) {
  it("should assert true", async function () {
    await DefiMarket.deployed();
    return assert.isTrue(true);
  });
});
