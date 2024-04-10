// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

import {Swap} from "../script/Swap.sol";
import {ERC20Token} from "../src/ERC20Token.sol";

import {DeploySwap} from "../script/DeploySwap.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract TestInitialized is Test {
    /** CONFIGURATION */
    DeploySwap deployment;
    HelperConfig helperConfig;

    Swap swap;
    ERC20Token token;

    /** CONSTRUCTOR ARGUMENTS */
    address tokenAddress;
    address routerAddress;

    /** HELPER VARIABLES */
    uint256 constant TOTAL_SUPPLY = 1_000_000_000 ether;
    uint256 constant LP_SUPPLY = 800_000_000 ether;
    uint256 constant STARTING_BALANCE = 10_000_000 ether;

    /** MODIFIERS */
    modifier fundedWithETH() {
        // fund contract with native coin
        vm.deal(address(swap), 10 ether);

        _;
    }

    modifier fundedWithTokens() {
        // fund contract with tokens
        vm.deal(address(swap), 10 ether);
        swap.swapETHForTokens(STARTING_BALANCE);
        _;
    }

    /** SETUP */
    function setUp() external virtual {
        deployment = new DeploySwap();
        (swap, helperConfig) = deployment.run();

        (tokenAddress, routerAddress) = helperConfig.activeNetworkConfig();
        token = ERC20Token(swap.getTokenAddress());
    }

    /** TESTS */
    function test__ConstructorArguments() public {
        assertEq(swap.getTokenAddress(), tokenAddress);
        assertEq(swap.getRouterAddress(), routerAddress);
    }

    function test__SwapETHForTokens() public fundedWithETH {
        uint256 amount = 10_000 ether;

        swap.swapETHForTokens(amount);

        assertApproxEqAbs(token.balanceOf(address(swap)), amount, 10 ** 18);
    }

    function test__SwapTokensForETH() public fundedWithTokens {
        uint256 startingBalance = address(swap).balance;

        uint256 amount = 1 ether;
        swap.swapTokensForETH(amount);

        assertGt(address(swap).balance, startingBalance);
    }
}
