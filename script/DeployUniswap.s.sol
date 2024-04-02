// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0;

import {Script, console} from "forge-std/Script.sol";
import {Test} from "forge-std/Test.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract DeployUniswap is Script, Test {
    IUniswapV2Router02 uniswapRouter;
    address deployer = 0x435D2a6b96d7A65EC2Ae430C0b1CBd71A6F09095;

    address weth = 0x4200000000000000000000000000000000000023;
    function run() external returns (address router) {
        string
            memory validPath = "out/UniswapV2Factory.sol/UniswapV2Factory.json";
        assertTrue(vm.exists(validPath));

        string
            memory validPath2 = "out/UniswapV2Router02.sol/UniswapV2Router02.json";
        assertTrue(vm.exists(validPath2));

        vm.startBroadcast();

        address factory = deployCode(
            "UniswapV2Factory.sol",
            abi.encode(deployer)
        );
        console.log("Factory: %s", factory);

        router = deployCode("UniswapV2Router02.sol", abi.encode(factory, weth));
        console.log("Router: %s", router);
        vm.stopBroadcast();

        uniswapRouter = IUniswapV2Router02(router);
    }
}

// forge script script/DeployUniswap.s.sol:DeployUniswap --rpc-url $BLAST_TESTNET_RPC --private-key $PRIVATE_KEY --gas-price 8000000000 --broadcast
