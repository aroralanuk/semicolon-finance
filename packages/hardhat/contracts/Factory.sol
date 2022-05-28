
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
    // Only works if non-transferrable (need to find some other method to keep track if transferrable)
    mapping(address => uint256[]) public flowIdsByAddress; 

    event FlowCreated(address indexed owner, uint256 indexed flowId);
    event ContributorAdded(address indexed contributor, uint256 indexed flowId, uint256 indexed tokenId);
    event ContributorRemoved(address indexed contributor, uint256 indexed flowId, uint256 indexed tokenId);
    event ContributorKicked(address indexed contributor);

    constructor(ISuperfluid host, IConstantFlowAgreementV1 cfa, ISuperToken acceptedToken) {
        _host = host;
        _cfa = cfa;
        _acceptedToken = acceptedToken;
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

    // @dev returns the array index+1 if address owns the flow, 0 otherwise
    function isOwner(address contributor, uint256 flowId) public view returns (uint) {
      for(uint i = 0; i < flowIdsByAddress[contributor].length; i++) {
        if(flowIdsByAddress[contributor][i] == flowId) 
          return i+1;
      }
      return 0;
    }

    // =============================
    // ==== CONTRIBUTOR METHODS ====
    // =============================

    // @dev adds a contributor to the flowId and mints an nft
    function addContributor (address contributor, uint256 flowId) public onlyOwner {
      require(isOwner(contributor, flowId) == 0, "Contributor already added");
      CashflowNFT flow = flowNFTs[flowId];
      flow.issueNFT(contributor);
      flowIdsByAddress[contributor].push(flowId);

      emit ContributorAdded(contributor, flowId, flow.nextId() - 1);
    }

    // @dev removes a contributor from the flowId and burns the nft
    function removeContributor (address contributor, uint256 flowId) public onlyOwner {
      require(flowIdsByAddress[contributor].length > 0, "Contributor does not have any flows");

      uint index = isOwner(contributor, flowId);
      require(index > 0, "Contributor does not own this flow");

      CashflowNFT flow = flowNFTs[flowId];

      delete flowIdsByAddress[contributor][index];
      flow.burnNFT(flow.initialFlowContributor(contributor));
      emit ContributorRemoved(contributor, flowId, flow.nextId() - 1); 
    }

    // @dev kicks the contributor from all flowIds and burns all nfts
    function kickContributor (address contributor) public onlyOwner {
      require(flowIdsByAddress[contributor].length > 0, "Contributor does not have any flows");

      for(uint i = 0; i < flowIdsByAddress[contributor].length; i++) {
        uint flowId = flowIdsByAddress[contributor][i];
        CashflowNFT flow = flowNFTs[flowId];
        flow.burnNFT(flow.initialFlowContributor(contributor));
        emit ContributorRemoved(contributor, flowId, flow.nextId() - 1);
      }
      delete flowIdsByAddress[contributor];

      emit ContributorKicked(contributor);
    }


    // @dev returns the flowIds[] given user address
    function getContributorFlows(address contributor) public view returns (uint256[] memory) {
      return flowIdsByAddress[contributor];
    }

    // @dev returns a contributor's net flow 
    function getContributorNetFlow(address contributor) public view returns (int96) {
      if(flowIdsByAddress[contributor].length == 0) return 0;

      int96 netflow = 0;
      for(uint i = 0; i < flowIdsByAddress[contributor].length; i++) {
        uint256 index = flowIdsByAddress[contributor][i];
        CashflowNFT flow = flowNFTs[index];
        netflow += flow.getFlowRate(contributor);
      }

      return netflow;
    }
   
}