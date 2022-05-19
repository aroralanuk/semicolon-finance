
// contracts/Factory.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "./CashflowNFT.sol";
import {RedirectAll, ISuperToken, IConstantFlowAgreementV1, ISuperfluid} from "./RedirectAll.sol";

contract Factory is Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  CashflowNFT public flowNFT;

  constructor(string memory _name, string memory _symbol) {
      flowNFT = CashflowNFT(_name, _symbol);
  }

    function mintNFT(
      address recipient,
      ISuperfluid host,
      IConstantFlowAgreementV1 cfa,
      ISuperToken acceptedToken
    )
    public returns (uint256) {

      uint256 tokenId = _tokenIds.get();
      flowNFT.mintWithFlow(
          tokenId,
          recipient,
          host,
          cfa,
          acceptedToken
      );

      return tokenId;
    }
}