# Merkle Airdrop Implementation

This project implements a Merkle-based token airdrop system for Ethereum using Foundry as the development framework. The implementation allows for gas-efficient token distribution to a large number of recipients through cryptographic proofs.

## Core Technologies

### Merkle Trees

Merkle trees are a fundamental data structure used in this project for efficient verification of data integrity. Key aspects include:

- **Structure**: Binary trees where each non-leaf node is the hash of its child nodes
- **Merkle Root**: Single 32-byte hash at the top of the tree representing all data
- **Merkle Proofs**: Allow verification of data inclusion without storing the entire dataset on-chain
- **Double-Hashing Pattern**: The implementation uses a double-hashing pattern to:
  - Prevent second preimage attacks by ensuring leaf nodes have the same format as internal nodes
  - Standardize node formatting throughout the tree

### ERC-20 Tokens

The airdrop distributes ERC-20 tokens to eligible recipients:

- **KettlebellToken**: Custom ERC-20 implementation with minting capabilities
- **OpenZeppelin**: Leverages the battle-tested OpenZeppelin contracts
- **SafeERC20**: Used to handle non-standard ERC-20 implementations and ensure safe transfers

### Smart Contract Security Patterns

The contracts implement several important security patterns:

- **Checks-Effects-Interactions**: State changes occur before external calls to prevent reentrancy attacks
- **SafeERC20**: Ensures consistent behavior across different token implementations
- **Immutable Variables**: Critical values like the Merkle root are stored as immutable to reduce gas costs
- **Error Handling**: Custom error types improve gas efficiency and provide clear error messages

## Project Components

### MerkleAirdrop Contract

The core contract manages the verification and distribution of tokens:

- **Claiming**: Allows users to claim tokens by providing a valid Merkle proof
- **Double-Claiming Prevention**: Tracks claimed addresses to prevent duplicate claims
- **Proof Verification**: Uses OpenZeppelin's MerkleProof library for secure verification
- **Gas Optimization**: Minimizes storage operations and leverages immutable variables

### KettlebellToken Contract

A custom ERC-20 token implementation with:

- **Ownable Pattern**: Restricts minting capability to the contract owner
- **Standard ERC-20 Interface**: Provides all standard token functionality

## Development Tools

### Foundry Suite

This project is built using the Foundry development framework:

- **Forge**: Testing framework with Solidity-native tests
- **Cast**: CLI tool for interacting with the blockchain
- **Anvil**: Local Ethereum node for development
- **Chisel**: Solidity REPL for rapid prototyping

### Testing Framework

Comprehensive tests ensure correct functionality:

- **Unit Tests**: Verify individual component behavior
- **Fuzzing**: Randomized inputs to catch edge cases
- **Verification**: Ensures cryptographic proofs work correctly

## Cryptographic Concepts

### Keccak256 Hashing

The project relies heavily on Ethereum's cryptographic primitives:

- **Leaf Construction**: `keccak256(bytes.concat(keccak256(abi.encode(account, amount))))`
- **Secure Hashing**: Provides collision resistance needed for Merkle tree security
- **Gas Efficiency**: Optimized for on-chain operations

### Verification Process

The proof verification works through:

1. Leaf node calculation from user data (address + amount)
2. Traversal of the Merkle tree using the provided proof
3. Comparison of calculated root with stored root
4. Token transfer upon successful verification

## Advanced Features

### Checks-Effects-Interactions Pattern

The contract follows the CEI pattern to prevent reentrancy attacks:

1. **Checks**: Validates the Merkle proof and checks if tokens have already been claimed
2. **Effects**: Updates the internal state to mark tokens as claimed
3. **Interactions**: Transfers tokens only after state changes are complete

### Gas Optimization Techniques

Several techniques reduce gas costs:

- **Immutable Variables**: `i_merkleRoot` and `i_airdropToken` are immutable to save gas
- **Minimal Storage**: Only claimed status is stored on-chain
- **Efficient Data Structures**: Mappings provide O(1) lookup for claim status

## Usage Instructions

### Generating Merkle Trees

To create a Merkle tree for your airdrop:

1. Define a list of recipient addresses and token amounts
2. Generate the Merkle tree using tools like Murky
3. Store the Merkle root in the contract during deployment
4. Generate and distribute proofs to recipients off-chain

### Claiming Tokens

Recipients can claim tokens by:

1. Obtaining their Merkle proof (typically from a frontend or API)
2. Calling the `claim` function with their address, amount, and proof
3. Receiving tokens upon successful verification

### Development Commands

```shell
# Build the project
forge build

# Run tests
forge test

# Deploy to network
forge script script/DeployMerkleAirdrop.s.sol:DeployMerkleAirdropScript --rpc-url <your_rpc_url> --private-key <your_private_key>

# Verify contract
forge verify-contract <deployed-address> src/MerkleAirdrop.sol:MerkleAirdrop --etherscan-api-key <your_etherscan_key>
```

## Security Considerations

- **Front-Running**: Claims are tied to specific addresses, mitigating front-running risks
- **Proof Verification**: Cryptographic proof verification prevents unauthorized claims
- **Reentrancy Protection**: CEI pattern prevents reentrancy attacks during token transfers
- **Access Control**: Only eligible recipients with valid proofs can claim tokens

## Conclusion

This Merkle-based airdrop system provides an efficient way to distribute tokens to a large number of recipients while minimizing gas costs. The implementation follows best practices for smart contract development, ensuring security and gas efficiency.
