-include .env

.PHONY: all test clean deploy-anvil

install:; @forge install OpenZeppelin/openzeppelin-contracts --no-commit && forge install Cyfrin/foundry-devops --no-commit && forge install https://github.com/Uniswap/v2-core --no-commit && forge install https://github.com/Uniswap/v2-periphery --no-commit && forge install https://github.com/Uniswap/solidity-lib.git --no-commit

-include ${FCT_PLUGIN_PATH}/makefile-external