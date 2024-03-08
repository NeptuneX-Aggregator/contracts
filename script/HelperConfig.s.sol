// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ERC20Token} from "../src/ERC20Token.sol";
import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {DeployUniswap} from "./DeployUniswap.s.sol";
import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract HelperConfig is Script {
    // chain configurations
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address tokenAddress;
        address routerAddress;
    }

    constructor() {
        activeNetworkConfig = getAnvilConfig();
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        // fund contract with ETH
        vm.deal(tx.origin, 1000 ether);

        // deploy uniswap
        DeployUniswap deployment = new DeployUniswap();
        address router = deployment.run();
        IUniswapV2Router02 uniswapRouter = IUniswapV2Router02(router);

        // deploy erc20 token
        vm.broadcast();
        ERC20Token token = new ERC20Token();

        // add LP for erc20 token
        uint256 lpTokenAmount = token.balanceOf(tx.origin);
        uint256 lpETHAmount = 100 ether;

        vm.startBroadcast();
        token.approve(address(uniswapRouter), lpTokenAmount);
        (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        ) = uniswapRouter.addLiquidityETH{value: lpETHAmount}(
                address(token),
                lpTokenAmount,
                0,
                0,
                tx.origin,
                block.timestamp
            );
        vm.stopBroadcast();

        console.log("\nERC20 TOKEN");
        console.log("Token Amount: ", amountToken);
        console.log("ETH Amount: ", amountETH);
        console.log("Liquidity Amount: ", liquidity);

        return
            NetworkConfig({
                tokenAddress: address(token),
                routerAddress: address(uniswapRouter)
            });
    }
}
