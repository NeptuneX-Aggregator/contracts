// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

interface IBlast {
    function configureAutomaticYield() external;
    function configureClaimableGas() external;
    function claimAllGas(
        address contractAddress,
        address recipient
    ) external returns (uint256);
    function claimMaxGas(
        address contractAddress,
        address recipientOfGas
    ) external returns (uint256);
}
