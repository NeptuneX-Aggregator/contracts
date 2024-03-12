// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0;

import {Script, console} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import "src/interaces/ICallHash.sol";
//import "src/CallHash.sol";

contract DeployCallHash is Script, Test {
    function run() external {
        // Verify that path 'foo/files/bar.txt' exists
        string memory validPath = "out/CallHash.sol/CalHash.json";
        assertTrue(vm.exists(validPath));

        vm.startBroadcast();
        address initHash = deployCode("CallHash.sol");
        //CallHash callhash = new CallHash();

        ICallHash callhash = ICallHash(initHash);
        bytes32 initCodeHash = callhash.getInitHash();

        vm.stopBroadcast();
    }
}

// forge script script/CallHash.s.sol:DeployCallHash --rpc-url $BLAST_TESTNET_RPC --private-key $PRIVATE_KEY --gas-price 8000000000 --broadcast
