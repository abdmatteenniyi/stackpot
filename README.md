Stackpot - Stacks Blockchain Lottery Contract
A trustless, decentralized lottery system built on Stacks blockchain using Clarity smart contracts.

Features
🎟️ Enter lottery with 10 STX
👥 Up to 100 participants per round
🎲 Fair random selection using block height
💰 Winner takes entire pot
🔒 Secure and transparent
Smart Contract Interface
Constants
Public Functions
Enter Lottery
Allows users to participate by sending 10 STX. Returns:

(ok true) on success
(err u101) if lottery is closed
(err u103) if already entered
(err u104) if max entries reached
Start New Round
Admin-only function to begin new round. Returns:

(ok true) on success
(err u100) if not admin
End Current Round
Admin-only function to select winner and distribute prize. Returns:

(ok true) on success
(err u100) if not admin
(err u106) if no entries
Read-Only Functions
Error Codes
Code	Description
u100	Not authorized
u101	Lottery closed
u103	Already entered
u104	Max entries reached
u105	Entry processing error
u106	No entries found
u107	Winner selection error
Local Development
Prerequisites
Clarinet
VS Code
Stacks Wallet
Setup
Testing
Run the test suite:

Deployment
Configure deployment settings in Clarinet.toml
Deploy to testnet:
Security Considerations
Randomness derived from block height
Admin restricted functions
Protected against reentrancy
Automated prize distribution
