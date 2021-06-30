const DefiMarket = artifacts.require("DefiMarket");

module.exports = function (deployer) {
  deployer.deploy(DefiMarket);
};
