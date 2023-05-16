require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");

const dotenv = require("dotenv");

dotenv.config();
// Replace this private key with your Sepolia account private key
// To export your private key from Coinbase Wallet, go to
// Settings > Developer Settings > Show private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Beware: NEVER put real Ether into testing accounts

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.13",
  networks: {
    sepolia: {
      url: process.env.PROVIDER,
      accounts: [process.env.SECRET_KEY],
    },
  },
};
