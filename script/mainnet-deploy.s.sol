// SPDX-License-Identifier: MIT

pragma solidity >=0.4.0;

// import {Script, console} from "forge-std/Script.sol";
// import {Test} from "forge-std/Test.sol";
// // import "src/interaces/ICallHash.sol";
// // import "src/ERC20Token.sol";
// // import "src/mock/UniswapV2Pair.sol";
// //import "src/CallHash.sol";

// contract DeployUni is Script, Test {
//     address deployer = 0x435D2a6b96d7A65EC2Ae430C0b1CBd71A6F09095;

//     address weth = 0x4200000000000000000000000000000000000023;
//     address a = 0;
//     address b = 0;
//     uint256 a_amount = 1;
//     uint256 b_amount = 2;

//     function run() external {
//         string
//             memory validPath = "out/UniswapV2Factory.sol/UniswapV2Factory.json";
//         assertTrue(vm.exists(validPath));

//         string
//             memory validPath2 = "out/UniswapV2Router02.sol/UniswapV2Router02.json";
//         assertTrue(vm.exists(validPath2));

//         vm.startBroadcast();
//         address factory = deployCode(
//             "UniswapV2Factory.sol",
//             abi.encode(deployer)
//         );
//         console.log("Factory: %s", factory);

//         ERC20(a).approve(a_amount, address(factory));
//         ERC20(b).approve(b_amount, address(factory));

//         address pair = factory.createPair(a, b);

//         type(pair).creationCode

//         address router = deployCode(
//             "UniswapV2Router02.sol",
//             abi.encode(factory, weth)
//         );
//         console.log("Router: %s", router);

//         vm.stopBroadcast();
//     }
// }

// // forge script script/DeployUni.s.sol:DeployUni --rpc-url $BLAST_TESTNET_RPC --private-key $PRIVATE_KEY --gas-price 1100000 --broadcast
