// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {KettlebellToken} from "../src/KettlebellToken.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract DeployMerkleAirdrop is Script {
    bytes32 private s_merkleRoot = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    uint256 private s_amountToTransfer = 4 * 25 * 1e18;

    function run() external returns (MerkleAirdrop, KettlebellToken) {
        return deployMerkleAirdrop();
    }

    function deployMerkleAirdrop() public returns (MerkleAirdrop, KettlebellToken) {
        vm.startBroadcast();
        KettlebellToken token = new KettlebellToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(s_merkleRoot, token);
        token.mint(token.owner(), s_amountToTransfer);
        token.transfer(address(airdrop), s_amountToTransfer);
        vm.stopBroadcast();

        return (airdrop, token);
    }
}
