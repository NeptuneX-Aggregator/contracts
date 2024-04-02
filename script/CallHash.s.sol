// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0;

import {Script, console} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import "src/interaces/ICallHash.sol";
//import "src/CallHash.sol";

contract DeployCallHash is Script, Test {
    function run() external {
        // Verify that path 'foo/files/bar.txt' exists
        string memory validPath = "out/CallHash.sol/CallHash.json";
        assertTrue(vm.exists(validPath));

        vm.startBroadcast();
        address initHash = deployCode("CallHash.sol");
        //CallHash callhash = new CallHash();

        ICallHash callhash = ICallHash(initHash);
        bytes32 initCodeHash = callhash.getInitHash(); // 0x75a006e6713aaf95877ce6f1df01031d9b533866995056f9664f1aa742ac42c4
        console.logBytes32(initCodeHash);
        vm.stopBroadcast();
    }
}

// forge script script/CallHash.s.sol:DeployCallHash --rpc-url $BLAST_TESTNET_RPC --private-key $PRIVATE_KEY --gas-price 1100252 --broadcast
// forge create src/CallHash.sol:CallHash --rpc-url $BLAST_TESTNET_RPC --private-key $PRIVATE_KEY --gas-price 1100252
