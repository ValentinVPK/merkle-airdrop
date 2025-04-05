// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleAirdrop {
    using SafeERC20 for IERC20;
    // some list of addresses
    // Allow someone in the list to claim ERC-20 tokens

    event Claimed(address indexed account, uint256 amount);

    // merkle proofs
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;

    error MerkleAirdrop__InvalidProof();

    constructor(bytes32 merkleRoot, IERC20 airdropToken) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        // calculate using the account and the amount, the hash -> leaf node
        // Double-hashing pattern: First hash encodes the data, second hash ensures leaf nodes
        // have the same format as internal nodes (prevents second preimage attacks)
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));

        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert MerkleAirdrop__InvalidProof();
        }

        emit Claimed(account, amount);
        i_airdropToken.safeTransfer(account, amount);
    }
}
