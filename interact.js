const contract = require("./artifacts/contracts/Lock.sol/Lock.json");
const ethers = require("ethers");
const dotenv = require("dotenv");

dotenv.config();
console.log(contract);

// const customHttpProvider = new ethers.providers.AlchemyProvider(
//   (network = "goerli"),
//   "0xbbd95f266F32563aA6A813469947B09cA3727bdb"
// );

const customHttpProvider = new ethers.providers.JsonRpcProvider(
  process.env.PROVIDER
);
const wallet = new ethers.Wallet(process.env.SECRET_KEY, customHttpProvider);

// // Contract
const helloWorldContract = new ethers.Contract(
  "0x9b198A431b5eEBC4F42fC1200f3BdFdb7Ec83Fa2",
  contract.abi,
  wallet
);

async function main() {
  const message = await helloWorldContract.message();
  console.log("The message is: " + message);
}
main();
