// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const Lock = await hre.ethers.getContractFactory("Flashloan");
  const lock = await Lock.deploy(
    "0x0496275d34753A48320CA58103d5220d394FF77F",
    "0x25b4EfC43c9dCAe134233CD577fFca7CfAd6748F",
    "0x00000000000000ADc04C56Bf30aC9d3c0aAF14dC"
  );

  await lock.deployed();

  console.log(`deployed to ${lock.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
