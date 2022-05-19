//SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "hardhat/console.sol";

import {RedirectAll, ISuperToken, IConstantFlowAgreementV1, ISuperfluid} from "./RedirectAll.sol";

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/* Hello and welcome to your first Super App!
* In order to deploy this contract, you'll need a few things
* Get the deployed SF addresses here: https://docs.superfluid.finance/superfluid/resources/networks
* or using the js-sdk as shown here https://docs.superfluid.finance/superfluid/protocol-tutorials/setup-local-environment
*/


contract CashflowNFT is ERC721 {

  constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) {}
  RedirectAll[] public cashflows;

  function mintWithFlow (
    uint256 tokenId,
    address recipient,
    ISuperfluid host,
    IConstantFlowAgreementV1 cfa,
    ISuperToken acceptedToken

  ) public 
      {
        _mint(recipient, 1);
        cashflows[tokenId] = new RedirectAll(
          host, 
          cfa,
          acceptedToken,
          recipient
        );
        console.log("Minting erc721");
  }

  //now I will insert a nice little hook in the _transfer, including the RedirectAll function I need
  function _beforeTokenTransfer(
    address /*from*/,
    address to,
    uint256 tokenId
  ) internal override {
      cashflows[tokenId]._changeReceiver(to);
  }
}
