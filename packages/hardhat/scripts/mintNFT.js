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

// TODO: mint NFT and then create a flow to multiple people
const FactoryJSON = require("../artifacts/contracts/Factory.sol/Factory.json");
const CashflowNFTJSON = require("../artifacts/contracts/CashflowNFT.sol/CashflowNFT.json");

const FactoryABI = FactoryJSON.abi;
const CashflowNFTABI = CashflowNFTJSON.abi;

// temporarily hardcode contract address and sender address
// need to manually enter contract address and sender address here
const deployedFactory = require("../deployments/polytest/Factory.json");
const deployedCashflowNFT = require("../deployments/polytest/CashflowNFT.json");

const FactoryAddress = deployedFactory.address;
const CashflowNFTAddress = deployedCashflowNFT.address;

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
  const factory = new web3.eth.Contract(FactoryABI, FactoryAddress);
  const CashflowNFT = new web3.eth.Contract(CashflowNFTABI, CashflowNFTAddress);

  const fDAIx = "0x5D8B4C2554aeB7e86F387B4d6c00Ac33499Ed01f";
  const userData = web3.eth.abi.encodeParameter("string", "HODL MATIC");

  const nonce = await web3.eth.getTransactionCount(sender, "latest"); // nonce starts counting from 0

  const owner = process.env.OWNER_ADDRESS;

  // create flow by calling host directly in this function
  // create flow from sender to Tradable cashflow address
  // pass in userData to the flow as a parameter
  async function initFactory() {
    // const initTx = await factory.methods
    //   .mintNFT(owner, hostAddress, cfaAddress, fDAIx)
    //   .call(function (err, res) {
    //     if (err) {
    //       console.log("ERROR", err.message);
    //     } else {
    //       console.log(res.message);
    //     }
    //   });

    const initTx = await factory.methods.dummy().call(function (err, res) {
      if (err) {
        console.log("ERROR", err.message);
      } else {
        console.log(res);
      }
    });
  }

  // async function startFlow() {
  //   const cfaTx = await cfa.methods
  //     .createFlow(
  //       fDAIx,
  //       // sender,
  //       CashflowNFTAddress,
  //       "3858024691358",
  //       "0x"
  //     )
  //     .encodeABI();

  //   const txData = await host.methods
  //     .callAgreement(cfaAddress, cfaTx, userData)
  //     .encodeABI();

  //   const tx = {
  //     to: hostAddress,
  //     gas: 3000000,
  //     nonce,
  //     data: txData,
  //   };

  //   const signedTx = await web3.eth.accounts.signTransaction(
  //     tx,
  //     process.env.MUMBAI_DEPLOYER_PRIV_KEY
  //   );

  //   await web3.eth.sendSignedTransaction(
  //     signedTx.rawTransaction,
  //     function (error, hash) {
  //       if (!error) {
  //         console.log(
  //           "🎉 The hash of your transaction is: ",
  //           hash,
  //           "\n Check Alchemy's Mempool to view the status of your transaction!"
  //         );
  //       } else {
  //         console.log(
  //           "❗Something went wrong while submitting your transaction:",
  //           error
  //         );
  //       }
  //     }
  //   );
  // }

  await initFactory();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
