# Crowdfunding Smart Contract

## Overview
This **Crowdfunding Smart Contract** allows users to create and manage decentralized crowdfunding campaigns on the Ethereum blockchain. It ensures **secure, transparent, and trustless** fundraising without intermediaries.

## Features
✅ **Campaign Creation** – Users can launch campaigns with a funding goal and deadline.  
✅ **Secure Contributions** – Supporters can contribute funds securely.  
✅ **Fund Withdrawal** – Creators can withdraw funds only if the goal is met after the deadline.  
✅ **Automatic Refunds** – Contributors can claim refunds if the campaign fails.  
✅ **Event Logging** – Key actions are logged for transparency.  
✅ **Security Measures** – Prevents unauthorized withdrawals and potential re-entrancy attacks.

## Installation & Usage
### Prerequisites
- [Remix IDE](https://remix.ethereum.org/)
- MetaMask wallet (for testing with testnet ETH)

### Steps to Run in Remix IDE
1. Open **[Remix IDE](https://remix.ethereum.org/)** in your browser.
2. Create a new Solidity file (e.g., `Crowdfunding.sol`).
3. Copy and paste the smart contract code.
4. Compile the contract using Solidity 0.8.20 or later.
5. Deploy the contract using the **JavaScript VM (London)** environment.
6. Interact with the contract by creating a campaign, contributing, withdrawing funds, or claiming refunds.

## Smart Contract Functions
### `createCampaign(uint256 _goal, uint256 _duration)`
- **Creates a new campaign** with a specified goal (in wei) and duration (seconds).

### `contribute(uint256 _campaignId)`
- Allows users to **fund a campaign** by sending ETH.

### `withdrawFunds(uint256 _campaignId)`
- Enables **campaign creators to withdraw funds** if the goal is met and the deadline has passed.

### `claimRefund(uint256 _campaignId)`
- Allows contributors to **claim refunds** if the campaign fails to reach its goal.

## Events
- **CampaignCreated** – Triggered when a new campaign is created.
- **ContributionMade** – Triggered when a user contributes to a campaign.
- **FundsWithdrawn** – Triggered when a campaign creator withdraws funds.
- **RefundIssued** – Triggered when a contributor claims a refund.

## Security Considerations
- Uses **require statements** to validate conditions and prevent unauthorized actions.
- Implements **safe withdrawal mechanisms** to prevent re-entrancy attacks.
- Prevents **double withdrawals** by using a `withdrawn` flag.

## License
This project is licensed under the **MIT License**.

---
🚀 **Want to contribute or improve this project?** Fork the repo and start building!  
📩 **Have questions?** Feel free to reach out!
