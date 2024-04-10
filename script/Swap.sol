// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {IERC20, ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Router01} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

/// @title Swap Contract
/// @author Nadina Oates
/// @notice Contract to demonstrate local testing with UniswapV2
contract Swap {
    IERC20 private s_erc20Token;
    IUniswapV2Router02 private s_routerV2;
    address private s_pairV2;

    /// @notice Constructor
    /// @param erc20Token address of ERC20 token to swap
    /// @param routerV2 address of deployed uniswap router
    constructor(address erc20Token, address routerV2) {
        s_erc20Token = IERC20(erc20Token);
        s_routerV2 = IUniswapV2Router02(routerV2);
    }

    receive() external payable {}

    /// @notice gets ERC20 token address
    function getTokenAddress() external view returns (address) {
        return address(s_erc20Token);
    }

    /// @notice gets uniswap router address
    function getRouterAddress() external view returns (address) {
        return address(s_routerV2);
    }

    /// @notice Swaps tokens for ETH
    /// @param amount amount of tokens
    function swapTokensForETH(uint256 amount) external {
        address[] memory path = new address[](2);
        path[0] = address(s_erc20Token);
        path[1] = s_routerV2.WETH();

        s_erc20Token.approve(address(s_routerV2), amount);
        s_routerV2.swapExactTokensForETH(
            amount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    /// @notice Swaps ETH for tokens
    /// @param amount amount of tokens
    function swapETHForTokens(uint256 amount) external {
        address[] memory path = new address[](2);
        path[0] = s_routerV2.WETH();
        path[1] = address(s_erc20Token);

        uint256 ethAmount = s_routerV2.getAmountsIn(amount, path)[0];

        s_routerV2.swapExactETHForTokens{value: ethAmount}(
            amount,
            path,
            address(this),
            block.timestamp
        );
    }
}
