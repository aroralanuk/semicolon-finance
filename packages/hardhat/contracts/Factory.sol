
// contracts/Factory.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "./CashflowNFT.sol";
import "./governance/GovernorContract.sol";

import "hardhat/console.sol";

contract Factory is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _flowIds;

    // superfluid vars
    ISuperfluid public _host; // host
    IConstantFlowAgreementV1 private _cfa; 
    ISuperToken private _acceptedToken;

    // Mapping from flowIds to CashflowNFT
    mapping(uint256 => CashflowNFT) public flowNFTs;
    // Mapping from user address to flowIds[]
    mapping(address => uint256[]) public flowIdsByAddress; 

    event FlowCreated(address indexed owner, uint256 indexed flowId);
    event ContributorAdded(address indexed contributor, uint256 indexed flowId, uint256 indexed tokenId);

    constructor(string memory _name, string memory _symbol) {
        // flowNFT = new CashflowNFT(_name, _symbol);
    }

    function setHost(ISuperfluid host) public onlyOwner {
      _host = host;
    }

    function setCFA(IConstantFlowAgreementV1 cfa) public onlyOwner {
      _cfa = cfa;
    }

    function setAcceptedToken(ISuperToken acceptedToken) public onlyOwner {
      _acceptedToken = acceptedToken;
    }

    // =============================
    // ======= FLOW METHODS ========
    // =============================

    // @dev returns the CashflowNFT object given flowId
    function getFlow(uint256 flowId) public view returns (CashflowNFT) {
      return flowNFTs[flowId];
    }

    // @dev returns the flowIds[] given user address
    function getUserFlows(address contributor) public view returns (uint256[] memory) {
      return flowIdsByAddress[contributor];
    }

    // @dev creates a CashflowNFT object and returns the flowId
    function createFlow(
      string memory name,
      string memory symbol,
      int96 flowRate
    )
    public returns (uint256) {
      uint256 flowId = _flowIds.current();
      flowNFTs[flowId] = new CashflowNFT(
        name,
        symbol,
        flowRate,
        _host,
        _cfa,
        _acceptedToken
      );
      _flowIds.increment();

      emit FlowCreated(msg.sender, flowId);
      return flowId;
    }

    function setFlowRate(uint256 flowId, int96 flowRate) public onlyOwner {
      flowNFTs[flowId].setGlobalFlowRate(flowRate);
    }

    // =============================
    // ==== CONTRIBUTOR METHODS ====
    // =============================

    // @dev adds a contributor to the flowId and mints an nft
    function addContributor (address contributor, uint256 flowId) public onlyOwner {
      CashflowNFT flow = flowNFTs[flowId];
      flow.issueNFT(contributor);
      flowIdsByAddress[contributor].push(flowId);

      emit ContributorAdded(contributor, flowId, flow.nextId() - 1);
    }

    // @dev removes a contributor from the flowId and burns the nft

    // @dev kicks the contributor from all flowIds and burns all nfts

    // @dev returns a contributor's net flow 
   
}