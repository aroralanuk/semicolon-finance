require("dotenv").config();

const Web3 = require("web3");
const { defaultNetwork } = require("../hardhat.config");
const config = require("../hardhat.config");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();
  console.log(deployer);

  await deploy("Factory", {
    from: deployer,
    args: ["Rari Contributor Brigade", "RCB"],
    log: true,
  });
};

module.exports.tags = ["TradableCashflow"];
