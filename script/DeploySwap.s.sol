// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0;

import {Script} from "forge-std/Script.sol";
import {Swap} from "../src/Swap.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeploySwap is Script {
    function run() external returns (Swap swap, HelperConfig helperConfig) {
        helperConfig = new HelperConfig();
        (address tokenAddress, address routerAddress) = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        swap = new Swap(tokenAddress, routerAddress);
        vm.stopBroadcast();
    }
}
