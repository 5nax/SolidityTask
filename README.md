# Hello World Smart Contract

This is a simple "Hello World" smart contract written in Solidity which retrieves a stored uint value.

# Balllot Smart Contract

This is a simple "Ballot" smart contract written in Solidity which added functionality to limit the voting period. 


## Getting Started

These instructions will help you deploy and test the smart contract on the Ethereum blockchain using Remix or any other Ethereum development environment.

### Prerequisites

Before you begin, make sure you have the following installed:

- An Ethereum development environment (e.g., Remix, Truffle, or Hardhat)
- An Ethereum wallet (e.g., MetaMask) for interacting with the contract on a testnet or mainnet

### Deployment

1. Clone this GitHub repository to your local machine.

2. Open the `HelloWorld.sol / Ballot.sol` file in your Ethereum development environment (e.g., Remix).

3. Deploy the contract to the desired Ethereum network (e.g., local development network, Ropsten testnet, or mainnet).

### Usage

1. After deploying the HelloWorld contract, you will see the following functions:
   - `storeNumber(uint256 _number)`: Stores an unsigned integer.
   - `retrieveNumber()`: Retrieves the stored unsigned integer.
     
2. After deploying the Ballot contract, you will see the following :
   - Start the voting period by calling the `startVoting` function.
   - After starting the voting period, you have 5 minutes to cast your vote by calling the `vote` function with your chosen value. The contract will revert transactions if you attempt to vote after the voting period has ended.
   - `startVoting()`: Starts the voting period. This can only be done once.
   - `vote(uint256 _voteValue)`: Votes (with custom logic, implement as needed) but can only be done during the voting period, which is limited to 5 minutes.


### Customization

- You can customize the contract by adding your own voting logic inside the `vote` function.
- Modify the `voteEnded` modifier to change the duration of the voting period.
