
// contracts/Factory.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "./CashflowNFT.sol";
import {RedirectAll, ISuperToken, IConstantFlowAgreementV1, ISuperfluid} from "./RedirectAll.sol";

import "hardhat/console.sol";

contract Factory is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    ISuperfluid public _host; // host
    IConstantFlowAgreementV1 private _cfa; 
    ISuperToken private _acceptedToken;

    CashflowNFT public flowNFT;

    event NFTCreated(address indexed owner, uint256 indexed tokenId);

    constructor(string memory _name, string memory _symbol) {
        flowNFT = new CashflowNFT(_name, _symbol);
    }

    function setHost(ISuperfluid host) public {
      _host = host;
    }

    function setCFA(IConstantFlowAgreementV1 cfa) public {
      _cfa = cfa;
    }

    function setAcceptedToken(ISuperToken acceptedToken) public {
      _acceptedToken = acceptedToken;
    }

    function dummy() public view returns (uint) {
      console.log("What a dummy");
      return 1;
    }

    function getCashflow(uint256 tokenId) public view returns (RedirectAll) {
      return flowNFT.cashflows(tokenId);
    }

    function mintNFT(
      address recipient,
      ISuperfluid host,
      IConstantFlowAgreementV1 cfa,
      ISuperToken acceptedToken
    )
    public returns (uint256) {

      uint256 tokenId = _tokenIds.current();
      flowNFT.mintWithFlow(
          tokenId,
          recipient,
          host,
          cfa,
          acceptedToken
      );
      _tokenIds.increment();

      emit NFTCreated(msg.sender, tokenId);
      return tokenId;
    }

    function addContributor (address contributor) public {
      mintNFT(contributor, _host, _cfa, _acceptedToken);
    }



}