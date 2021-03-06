require("hardhat");
require("dotenv");
const Web3 = require("web3");

// all addresses hardcoded for mumbai - will only work on mumbai deployment
const hostJSON = require("../artifacts/@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol/ISuperfluid.json");

const hostABI = hostJSON.abi;
const hostAddress = "0xEB796bdb90fFA0f28255275e16936D25d3418603";

const cfaJSON = require("../artifacts/@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol/IConstantFlowAgreementV1.json");

const cfaABI = cfaJSON.abi;
const cfaAddress = "0x49e565Ed1bdc17F3d220f72DF0857C26FA83F873";

const CashflowNFTJSON = require("../artifacts/contracts/CashflowNFT.sol/CashflowNFT.json");
const FactoryJSON = require("../artifacts/contracts/Factory.sol/Factory.json");

const CashflowNFTABI = CashflowNFTJSON.abi;
const FactoryABI = FactoryJSON.abi;

// temporarily hardcode contract address and sender address
// need to manually enter contract address and sender address here
const deployedCashflowNFT = require("../deployments/polytest/CashflowNFT.json");
const deployedFactory = require("../deployments/polytest/Factory.json");

const CashflowNFTAddress = deployedCashflowNFT.address;
const FactoryAddress = deployedFactory.address;

// your address here:
const sender = process.env.SENDER_ADDRESS;

// create a flow
async function main() {
  const web3 = new Web3(
    new Web3.providers.HttpProvider(process.env.MUMBAI_ALCHEMY_URL)
  );

  // create contract instances for each of these
  const host = new web3.eth.Contract(hostABI, hostAddress);
  const cfa = new web3.eth.Contract(cfaABI, cfaAddress);
  // eslint-disable-next-line no-unused-vars
  const CashflowNFT = new web3.eth.Contract(CashflowNFTABI, CashflowNFTAddress);

  const Factory = new web3.eth.Contract(FactoryABI, FactoryAddress);

  const fDAIx = "0x5D8B4C2554aeB7e86F387B4d6c00Ac33499Ed01f";

  const nonce = await web3.eth.getTransactionCount(sender, "latest"); // nonce starts counting from 0

  // create flow by calling host directly in this function
  // create flow from sender to Tradable cashflow address
  // pass in userData to the flow as a parameter
  async function createFlow(NFTname = "FWB badge", NFTsymbol = "FWB") {
    const initCashflow = await Factory.methods.createFlow(
      NFTname,
      NFTsymbol,
      1000
    );

    // cheating here - calling vs invoking function - need to fix this
    const output = await Factory.methods
      .createFlow(NFTname, NFTsymbol, 1000)
      .call();

    console.log("Creating cashflow: ", output);
  }

  await createFlow();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
