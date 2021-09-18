const HDWalletProvider = require('@truffle/hdwallet-provider')


module.exports = {
  networks: {
    rinkeby: {
      provider: function () {
          return new HDWalletProvider(process.env.WALLET_SECRET_KEY, process.env.ARB_PROVIDER_RINKEBY, 0)
      },
      network_id: '*',
      gas: 4500000,
      gasPrice: 10000000000,
    },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: '0.8.6' // Fetch exact version from solc-bin (default: truffle's version)
    }
  },

  // Truffle DB is currently disabled by default; to enable it, change enabled: false to enabled: true
  //
  // Note: if you migrated your contracts prior to enabling this field in your Truffle project and want
  // those previously migrated contracts available in the .db directory, you will need to run the following:
  // $ truffle migrate --reset --compile-all

  db: {
    enabled: false
  }
}
