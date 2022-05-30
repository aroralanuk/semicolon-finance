// require("dotenv").config();

// // WARNING: don't need this, only for reference

// // mumbai addresses - change if using a different network

// const host = "0xEB796bdb90fFA0f28255275e16936D25d3418603";
// const cfa = "0x49e565Ed1bdc17F3d220f72DF0857C26FA83F873";
// const fDAIx = "0x5D8B4C2554aeB7e86F387B4d6c00Ac33499Ed01f";

// const deployFramework = require("@superfluid-finance/ethereum-contracts/scripts/deploy-framework");
// const deployTestToken = require("@superfluid-finance/ethereum-contracts/scripts/deploy-test-token");
// const deploySuperToken = require("@superfluid-finance/ethereum-contracts/scripts/deploy-super-token");
// const SuperfluidSDK = require("@superfluid-finance/js-sdk");
// const Web3 = require("web3");
// const { defaultNetwork } = require("../hardhat.config");
// const config = require("../hardhat.config");

// require("dotenv");
// //your address here...
// const owner = process.env.OWNER_ADDRESS;

// module.exports = async ({ getNamedAccounts, deployments }) => {
//   const { deploy } = deployments;

//   const { deployer } = await getNamedAccounts();
//   console.log(deployer);

//   await deploy("CashflowNFT", {
//     from: deployer,
//     args: ["nifty_billboard", "NFTBoard"],
//     log: true,
//   });
// };
// module.exports.tags = ["CashflowNFT"];
