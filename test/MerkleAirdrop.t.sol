// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {KettlebellToken} from "../src/KettleBellToken.sol";

contract MerkleAirdropTest is Test {
    MerkleAirdrop public airdrop;
    KettlebellToken public token;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    address user;
    uint256 userPrivateKey;

    function setUp() public {
        token = new KettlebellToken();
        airdrop = new MerkleAirdrop(ROOT, token);
        (user, userPrivateKey) = makeAddrAndKey("user");
    }

    function testUsersCanClaim() public {
        console.log("user address: ", user);
    }
}
