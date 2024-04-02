// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0;

import {Script, console} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
// import "src/mock/UniswapV2Factory.sol";
// import "src/mock/UniswapV2Router02.sol";

contract DeployUni2 is Script, Test {
    address deployer = 0x435D2a6b96d7A65EC2Ae430C0b1CBd71A6F09095;

    address weth = 0x4200000000000000000000000000000000000023;

    // UniswapV2Factory factory;
    // UniswapV2Router02 router;
    function run() external {
        vm.startBroadcast();

        // factory = new UniswapV2Factory(deployer);
        // console.log("Factory: %s", address(factory));

        // router = new UniswapV2Router02(address(factory), weth);
        // console.log("Router: %s", router);

        vm.stopBroadcast();
    }
}

// forge script script/DeployUni2.s.sol:DeployUni2 --rpc-url $BLAST_TESTNET_RPC --private-key $PRIVATE_KEY --gas-price 1100000 --broadcast

// forge create src/mock/UniswapV2Factory.sol:UniswapV2Factory --constructor-args "0x435D2a6b96d7A65EC2Ae430C0b1CBd71A6F09095" --rpc-url $BLAST_TESTNET_RPC --private-key $PRIVATE_KEY --gas-price 1100000
// forge create src/mock/UniswapV2Router02.sol:UniswapV2Router02 --constructor-args "0x2fc1E147D6C10B6ACaE0AAC3EB0b528668045c84" "0x4200000000000000000000000000000000000023" --rpc-url $BLAST_TESTNET_RPC --private-key $PRIVATE_KEY --gas-price 1100000

// forge create usrc/Multicall2.sol:Multicall2  --rpc-url $BLAST_TESTNET_RPC --private-key $PRIVATE_KEY --gas-price 1500000000
