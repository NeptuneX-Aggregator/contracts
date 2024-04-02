// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import {UniswapV2Library} from "src/mock/periphery/UniswapV2Library.sol";
import {UniswapImmutables} from "src/mock/periphery/UniswapImmutables.sol";
import {Payments} from "src/mock/periphery/Payments.sol";
import {Permit2Payments} from "src/mock/periphery/Permit2Payments.sol";
import {Constants} from "src/mock/periphery/Constants.sol";
import {ERC20} from "src/mock/periphery/ERC20.sol";
import {IFewWrappedToken} from "src/mock/periphery/IFewWrappedToken.sol";
import {IIncentive} from "src/mock/periphery/IIncentive.sol";
import {IRingSwapRouter} from "src/mock/periphery/IRingSwapRouter.sol";
import {SafeMath} from "src/mock/periphery/SafeMath.sol";

/// @title Router for Ring + Uniswap v2 Trades
abstract contract RingSwapRouter is
    UniswapImmutables,
    Permit2Payments,
    IRingSwapRouter
{
    using SafeMath for uint256;

    error RingV2TooLittleReceived();
    error RingV2TooMuchRequested();
    error RingV2InvalidPath();
    error RingV2Forbidden();

    mapping(address => bool) public override getPermittedAccount;
    address public override incentiveContract;

    function setPermittedAccount(
        address permittedAccount,
        bool enabled
    ) external override {
        if (msg.sender != IUniswapV2Factory(RING_V2_FACTORY).feeToSetter())
            revert RingV2Forbidden();

        getPermittedAccount[permittedAccount] = enabled;
    }

    function setIncentiveContract(address incentive) external override {
        if (!getPermittedAccount[msg.sender]) revert RingV2Forbidden();

        incentiveContract = incentive;
    }

    function _ringV2Swap(
        address[] calldata path,
        address recipient,
        address pair
    ) private {
        unchecked {
            if (path.length < 2) revert RingV2InvalidPath();

            // cached to save on duplicate operations
            (address token0, ) = UniswapV2Library.sortTokens(path[0], path[1]);
            uint256 finalPairIndex = path.length - 1;
            uint256 penultimatePairIndex = finalPairIndex - 1;
            uint256 incentiveAmount = 0;
            for (uint256 i; i < finalPairIndex; i++) {
                (address input, address output) = (path[i], path[i + 1]);
                (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pair)
                    .getReserves();
                (uint256 reserveInput, uint256 reserveOutput) = input == token0
                    ? (reserve0, reserve1)
                    : (reserve1, reserve0);
                uint256 amountInput = ERC20(input).balanceOf(pair) -
                    reserveInput;
                uint256 amountOutput = UniswapV2Library.getAmountOut(
                    amountInput,
                    reserveInput,
                    reserveOutput
                );
                if (incentiveContract != address(0)) {
                    if (input == FWRNG) {
                        incentiveAmount = incentiveAmount.add(amountInput);
                    } else if (output == FWRNG) {
                        incentiveAmount = incentiveAmount.add(amountOutput);
                    }
                }
                (uint256 amount0Out, uint256 amount1Out) = input == token0
                    ? (uint256(0), amountOutput)
                    : (amountOutput, uint256(0));
                address nextPair;
                (nextPair, token0) = i < penultimatePairIndex
                    ? UniswapV2Library.pairAndToken0For(
                        RING_V2_FACTORY,
                        RING_V2_PAIR_INIT_CODE_HASH,
                        output,
                        path[i + 2]
                    )
                    : (recipient, address(0));
                IUniswapV2Pair(pair).swap(
                    amount0Out,
                    amount1Out,
                    nextPair,
                    new bytes(0)
                );
                pair = nextPair;
            }
            if (incentiveContract != address(0)) {
                IIncentive(incentiveContract).incentivize(
                    msg.sender,
                    msg.sender,
                    msg.sender,
                    incentiveAmount
                );
            }
        }
    }

    /// @notice Performs a Ring + Uniswap v2 exact input swap
    /// @param recipient The recipient of the output tokens
    /// @param amountIn The amount of input tokens for the trade
    /// @param amountOutMinimum The minimum desired amount of output tokens
    /// @param path The path of the trade as an array of few wrapped token addresses
    /// @param payer The address that will be paying the input
    function ringV2SwapExactInput(
        address recipient,
        uint256 amountIn,
        uint256 amountOutMinimum,
        address[] calldata path,
        address payer,
        bool isOriginalOutput
    ) internal {
        address firstPair = UniswapV2Library.pairFor(
            RING_V2_FACTORY,
            RING_V2_PAIR_INIT_CODE_HASH,
            path[0],
            path[1]
        );
        if (
            amountIn != Constants.ALREADY_PAID // amountIn of 0 to signal that the pair already has the few wrapped tokens
        ) {
            address token = IFewWrappedToken(path[0]).token();
            if (amountIn != Constants.CONTRACT_BALANCE) {
                payOrPermit2Transfer(token, payer, address(this), amountIn);
            } else {
                amountIn = ERC20(token).balanceOf(address(this));
            }
            if (amountIn > 0) {
                ERC20(token).approve(path[0], amountIn);
                IFewWrappedToken(path[0]).wrapTo(amountIn, firstPair);
            }
        }

        ERC20 tokenOut = ERC20(path[path.length - 1]);
        address outputRecipient;
        if (isOriginalOutput) {
            outputRecipient = address(this);
        } else {
            outputRecipient = recipient;
        }
        uint256 balanceBefore = tokenOut.balanceOf(outputRecipient);

        _ringV2Swap(path, outputRecipient, firstPair);

        uint256 amountOut = tokenOut.balanceOf(outputRecipient) - balanceBefore;
        if (amountOut < amountOutMinimum) revert RingV2TooLittleReceived();

        if (isOriginalOutput) {
            IFewWrappedToken(path[path.length - 1]).unwrapTo(
                amountOut,
                recipient
            );
        }
    }

    /// @notice Performs a Ring + Uniswap v2 exact output swap
    /// @param recipient The recipient of the output tokens
    /// @param amountOut The amount of output tokens to receive for the trade
    /// @param amountInMaximum The maximum desired amount of input tokens
    /// @param path The path of the trade as an array of few wrapped token addresses
    /// @param payer The address that will be paying the input
    function ringV2SwapExactOutput(
        address recipient,
        uint256 amountOut,
        uint256 amountInMaximum,
        address[] calldata path,
        address payer,
        bool isOriginalOutput
    ) internal {
        (uint256 amountIn, address firstPair) = UniswapV2Library
            .getAmountInMultihop(
                RING_V2_FACTORY,
                RING_V2_PAIR_INIT_CODE_HASH,
                amountOut,
                path
            );
        if (amountIn > amountInMaximum) revert RingV2TooMuchRequested();

        address token = IFewWrappedToken(path[0]).token();
        if (amountInMaximum != Constants.CONTRACT_BALANCE) {
            payOrPermit2Transfer(token, payer, address(this), amountIn);
        }
        if (amountIn > 0) {
            ERC20(token).approve(path[0], amountIn);
            IFewWrappedToken(path[0]).wrapTo(amountIn, firstPair);
        }

        address outputRecipient;
        if (isOriginalOutput) {
            outputRecipient = address(this);
        } else {
            outputRecipient = recipient;
        }

        _ringV2Swap(path, outputRecipient, firstPair);

        if (isOriginalOutput) {
            IFewWrappedToken(path[path.length - 1]).unwrapTo(
                amountOut,
                recipient
            );
        }
    }
}
