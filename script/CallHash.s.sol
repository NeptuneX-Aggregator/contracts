// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0;

import {Script, console} from "forge-std/Script.sol";
import "src/interaces/ICallHash.sol";

contract DeployCallHash is Script {
    function run() external {
        vm.startBroadcast();
        address initHash = deployCode("CallHash.sol");

        ICallHash callhash = ICallHash(initHash);
        bytes32 initCodeHash = callhash.getInitHash();

        vm.stopBroadcast();
    }
}

// forge script  script/CallHash.s.sol:DeployCallHash --rpc-url $SCROLL_SEPOLIA_RPC --private-key $PRIVATE_KEY --legacy --gas-price 8000000000 --broadcast
