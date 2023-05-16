const contract = require("./artifacts/contracts/Flashloan.sol/Flashloan.json");
const ethers = require("ethers");
const dotenv = require("dotenv");

dotenv.config();

const customHttpProvider = new ethers.providers.JsonRpcProvider(
  process.env.PROVIDER
);
const wallet = new ethers.Wallet(process.env.SECRET_KEY, customHttpProvider);

// // Contract
const flashLoan = new ethers.Contract(
  "0x9E5cf2E317731C8a59FC65e3847284d72cA87096",
  contract.abi,
  wallet
);

const getBalance = async () => {
  const balance = await flashLoan.getBalance();
  console.log("BALANCE", balance);
};

const rugPullNft = async () => {
  const tx = await flashLoan.rugPullNft({
    gasLimit: 3000000,
    // gasPrice: 3000000,
  });
  console.log("RugPullNft tx is: ", tx);
  await tx.wait();
};

const rugPull = async () => {
  const tx = await flashLoan.rugPull({
    gasLimit: 3000000,
    // gasPrice: 3000000,
  });
  console.log("RugPull tx is: ", tx);
  await tx.wait();
};

const startFlashloan = async () => {
  const tx = await flashLoan.requestFlashLoan(
    "0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000d0df82de051244f04bff3a8bb1f62e1cd39eed92000000000000000000000000000000000000000000000000001ff973cafa8000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000003e00000000000000000000000000000000000000000000000000000000000000320000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001f2cd0e5e77000000000000000000000000000c59cfbabd2dea8a52b62522751e601514ef50878000000000000000000000000004c00500000ad104d7dbd00e3ae0a5c00560c0000000000000000000000000005a0b0985ba3b7bd9ade8a7478caa2fa4fda24e5000000000000000000000000000000000000000000000000000000000000003400000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006455059000000000000000000000000000000000000000000000000000000000647de4100000000000000000000000000000000000000000000000000000000000000000360c6ebe0000000000000000000000000000000000000000015a329bb38a636d0000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f00000000007b02230091a7ed01230072f7006a004d60a8d4e71d599b8104250f00000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000024000000000000000000000000000000000000000000000000000000000000002a000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000cca2e51310000000000000000000000000000000a26b00c1f0df003000390027140000faa71900000000000000000000000000000000000000000000000000000000000000400f8d2662915d136f666a79f082757d613e58060d04b283caa9d2773ab7ba749875456b7d28dedecb5cac6b7b44691f5d8dd07e26a9acb818d5575e59e10fb1ed00000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000020000000000000000000000000df8a86ebbf5daad6afb57240fb246053a034648b000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000008",
    {
      gasLimit: 3000000,
      // gasPrice: 3000000,
    }
  );
  console.log("FlashLoan tx is: ", tx);
  await tx.wait();
};
