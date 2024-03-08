// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0;

import {Script, console} from "forge-std/Script.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract DeployUniswap is Script {
    IUniswapV2Router02 uniswapRouter;

    function run() external returns (address router) {
        vm.startBroadcast();
        address wbnb = deployCode("WETH.sol:WETH9");
        console.log("WETH9: %s", wbnb);

        address factory = deployCode(
            "UniswapV2Factory.sol",
            abi.encode(address(1))
        );
        console.log("Factory: %s", factory);

        router = deployCode("UniswapV2Router02.sol", abi.encode(factory, wbnb));
        console.log("Router: %s", router);
        vm.stopBroadcast();

        uniswapRouter = IUniswapV2Router02(router);
    }
}
