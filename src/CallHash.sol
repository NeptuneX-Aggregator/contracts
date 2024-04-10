pragma solidity =0.5.16;
import "src/UniswapV2Pair.sol";

contract CallHash {
    function getInitHash() public pure returns (bytes32) {
        bytes memory bytecode = type(UniswapV2Pair).creationCode;
        return keccak256(abi.encodePacked(bytecode));
    }
}

// cast send --rpc-url $sepolia_rpc --private-key $PRIVATE_KEY 0x7f11f79DEA8CE904ed0249a23930f2e59b43a385 "mint(address,uint256)" 0x435D2a6b96d7A65EC2Ae430C0b1CBd71A6F09095 1000000000000000000000
// cast send --rpc-url $sepolia_rpc --private-key $PRIVATE_KEY 0x7f11f79DEA8CE904ed0249a23930f2e59b43a385 "approve(address,uint256)" "0xc644cc19d2A9388b71dd1dEde07cFFC73237Dca8" 1000000000000000000000

// cast send --rpc-url $sepolia_rpc --private-key $PRIVATE_KEY --gas-limit 500000 0xc644cc19d2A9388b71dd1dEde07cFFC73237Dca8 "bridgeERC20(address localToken,address remoteToken,uint256 amount,uint32,bytes)" "0x7f11f79DEA8CE904ed0249a23930f2e59b43a385" "0x4200000000000000000000000000000000000022" 1000000000000000000000 500000 0x
