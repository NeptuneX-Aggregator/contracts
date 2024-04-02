// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

interface IIncentive {
    function incentivize(
        address sender,
        address receiver,
        address operator,
        uint256 amount
    ) external;
}
