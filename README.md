# SplitCoin
This is an open-source, web3 app built on 🏗 Scaffold-ETH 2. With this app you can share expenses with your friends for an event such as a birthday and then you can split the expenses.

**The steps are:**
• Create a project
• Select the project you have created
• Enter the participants with whom you want to share expenses
• Enter the expenses
• Once you have entered all the expenses, you can go to calculate to see who pays who. If you have to pay you will see the "pay" button together with the amount.

## Requirements

Before you begin, you need to install the following tools:

- [Node (>= v18.17)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))
- [Git](https://git-scm.com/downloads)

## Quickstart

To get started with SplitCoin, follow the steps below:

1. Clone this repo & install dependencies

```
git clone https://github.com/hdevelopergit/splitcoin.git splitcoin
cd splitcoin
yarn install
```

2. Run a local network in the first terminal:

```
yarn chain
```

This command starts a local Ethereum network using Hardhat. The network runs on your local machine and can be used for testing and development. You can customize the network configuration in `hardhat.config.ts`.

3. On a second terminal, deploy the test contract:

```
yarn deploy
```

This command deploys a test smart contract to the local network. The contract is located in `packages/hardhat/contracts` and can be modified to suit your needs. The `yarn deploy` command uses the deploy script located in `packages/hardhat/deploy` to deploy the contract to the network. You can also customize the deploy script.

4. On a third terminal, start your NextJS app:

```
yarn start
```

Visit your app on: `http://localhost:3000`. You can interact with your smart contract using the `Debug Contracts` page. You can tweak the app config in `packages/nextjs/scaffold.config.ts`.

