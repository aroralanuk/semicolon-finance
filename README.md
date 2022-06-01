# Semcolon Finance

Semicolon Finance is your one-stop stop for seamlessly rewarding your DAO's most loyal
contributors streaming them payments continously and conditionally based on
their performance every second gaslessly.

Made with [🏗 scaffold-eth](https://github.com/scaffold-eth/scaffold-eth)

🚀 Check out our [live demo](https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley) here!

## Techstack

- Polygon
- Superfluid
- UMA
- Coinbase Wallet

## User model

![semicolon_flowchart](semicolon_flowchart.png)

Note: this code has not been audited and is for example purposes only.

## Usage

1) Go get some test DAIx tokens at app.superfluid.finance on Mumbai testnet.
2) Add your own private key, public address and rpc URL for Mumbai inside of a ```.env``` file using the format in ```packages/hardhat/env.example```
3) Deploy Your Billboard NFT by following the instructions below.
4) Add your own custom message inside of each of the scripts as the value that is encoded and set to the ```userData``` variable.

## For Initial Setup and Contract Deployment:

- You need to change the `defaultNetwork` inside of `hardhat.config.js` to reflect your target network.
- If you're deploying locally, `ganache` or `localhost` should suffice. 
- If you're deploying to a live mainnet or testnet, you should change the default network and make sure that your private key and rpc url for that network are correct in your `.env` file.
- Inside of the deploy script, you will also need to add the address of the `host`, `cfa`, and super token you plan to use at the top of the file prior to deployment.

## 🏄‍♂️ Quick Start

Prerequisites: [Node](https://nodejs.org/en/download/) plus [Yarn](https://classic.yarnpkg.com/en/docs/install/) and [Git](https://git-scm.com/downloads)

> clone/fork repo:

```bash
git clone git@github.com:aroralanuk/semicolon-finance.git
```

> install and start your 👷‍ Hardhat chain:

```bash
cd semifluid-finance
yarn install
```

> in a second terminal window, start your 📱 React frontend:

```bash
cd semifluid-finance
yarn start
```

> in a third terminal window, 🛰 deploy your contract:

```bash
cd semifluid-finance
yarn deploy
```

Once the above is complete, you can run:

To create flow:
```yarn createFlow```

To add a contributor to the flow, issue them an NFT and start the flow:
```yarn addContributor```

To update flows and change the message:
```yarn updateFlow```

To delete flows:
```yarn deleteFlow```

To read data and see userData logged in the console:
```yarn readData```

NOTE: be careful with your private keys! Do not publish them to github. 
