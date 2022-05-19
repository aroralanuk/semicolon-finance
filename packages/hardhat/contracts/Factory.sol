
// contracts/Factory.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "./TradableCashflow.sol";
import {RedirectAll, ISuperToken, IConstantFlowAgreementV1, ISuperfluid} from "./RedirectAll.sol";

contract Factory is ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

  mapping (uint256 => TradableCashflow) public cashflows;

  function mintNFT(
      address recipient, 
      string memory tokenURI, 
      string memory _flowName, 
      string memory _flowSymbol, 
      ISuperfluid _host, 
      IConstantFlowAgreementV1 _cfa, 
      ISuperToken _acceptedToken) 
        public onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        cashflows[newItemId] = new TradableCashflow(
            msg.sender,  
            _flowName, 
            _flowSymbol, 
            _host, 
            _cfa, 
            _acceptedToken);

        return newItemId;
    }
}