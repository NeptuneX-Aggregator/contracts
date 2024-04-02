// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

interface IRingSwapRouter {
    function getPermittedAccount(
        address permittedAccount
    ) external view returns (bool enabled);
    function incentiveContract() external view returns (address);
    function setPermittedAccount(
        address permittedAccount,
        bool enabled
    ) external;
    function setIncentiveContract(address incentive) external;
}
