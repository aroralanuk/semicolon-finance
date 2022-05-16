// deploy/00_deploy_your_contract.js

const { ethers } = require("hardhat");
require("dotenv").config();
const config = require("../hardhat.config");

// mumbai
// const acct1 = "0x5966aa11c794893774a382d9a19743B8be6BFFd1";
// const acct2 = "0x9421FE8eCcAfad76C3A9Ec8f9779fAfA05A836B3";

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  // change this 'deployer' to HD wallet provider and send from a different account

  // await hre.network.provider.request({
  //   method: "hardhat_impersonateAccount",
  //   params: [acct1],
  // });

  // await hre.network.provider.request({
  //   method: "hardhat_impersonateAccount",
  //   params: [acct2],
  // });

  const { deployer } = await getNamedAccounts();
  console.log(deployer);

  console.log("----------------------------------------------------");
  console.log("Deploying GovernanceToken and waiting for confirmations...");

  const governanceToken = await deploy("GovernanceToken", {
    from: deployer,
    args: [],
    log: true,
  });
  console.log(`GovernanceToken at ${governanceToken.address}`);

  //   console.log(`Delegating to ${deployer}`);
  //   const governanceContract = await ethers.getContract(
  //     "GovernanceToken",
  //     governanceToken.address
  //   );
  //   const transactionResponse = await governanceContract.delegate(deployer);
  //   await transactionResponse.wait(1);
  //   console.log(
  //     `Checkpoints: ${await governanceContract.numCheckpoints(deployer)}`
  //   );

  //   console.log("Delegated!");

  // await deploy("YourContract", {
  //   // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
  //   from: deployer,
  //   //args: [ "Hello", ethers.utils.parseEther("1.5") ],
  //   log: true,
  // });

  /*
    // Getting a previously deployed contract
    const YourContract = await ethers.getContract("YourContract", deployer);
    await YourContract.setPurpose("Hello");
  
    To take ownership of yourContract using the ownable library uncomment next line and add the 
    address you want to be the owner. 
    // yourContract.transferOwnership(YOUR_ADDRESS_HERE);

    //const yourContract = await ethers.getContractAt('YourContract', "0xaAC799eC2d00C013f1F11c37E654e59B0429DF6A") //<-- if you want to instantiate a version of a contract at a specific address!
  */
};
module.exports.tags = ["GovernanceToken"];
