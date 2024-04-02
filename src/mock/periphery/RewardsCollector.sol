// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.15;

import {ERC20} from "src/mock/periphery/ERC20.sol";
import {SafeTransferLib} from "src/mock/periphery/SafeTransferLib.sol";
import {NFTImmutables} from "src/mock/periphery/NFTImmutables.sol";
import {IRewardsCollector} from "src/mock/periphery/IRewardsCollector.sol";

abstract contract RewardsCollector is IRewardsCollector, NFTImmutables {
    using SafeTransferLib for ERC20;

    event RewardsSent(uint256 amount);

    error UnableToClaim();

    /// @inheritdoc IRewardsCollector
    function collectRewards(bytes calldata looksRareClaim) external {
        (bool success, ) = LOOKS_RARE_REWARDS_DISTRIBUTOR.call(looksRareClaim);
        if (!success) revert UnableToClaim();

        uint256 balance = LOOKS_RARE_TOKEN.balanceOf(address(this));
        LOOKS_RARE_TOKEN.transfer(ROUTER_REWARDS_DISTRIBUTOR, balance);
        emit RewardsSent(balance);
    }
}
