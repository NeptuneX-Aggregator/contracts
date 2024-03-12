pragma solidity =0.5.16;

import "src/interaces/IBlast.sol";
import "src/interaces/IBlastPoints.sol";
import "src/interaces/IBlastManager.sol";
import "lib/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

contract BlastManagerFromFactory is IBlastManager {
    IBlast public constant BLAST =
        IBlast(0x4300000000000000000000000000000000000002);
    address public manager;

    modifier onlyManager() {
        require(
            msg.sender == IUniswapV2Factory(manager).feeToSetter(),
            "FORBIDDEN"
        );
        _;
    }

    constructor() public {
        manager = msg.sender;
        BLAST.configureAutomaticYield();
        BLAST.configureClaimableGas();
    }

    function claimGas(
        address recipient,
        bool isMax
    ) external onlyManager returns (uint256) {
        if (isMax) {
            return BLAST.claimMaxGas(address(this), recipient);
        } else {
            return BLAST.claimAllGas(address(this), recipient);
        }
    }

    function setManager(address _manager) external onlyManager {
        manager = _manager;
    }

    function setGasMode(address blastGas) external onlyManager {
        IBlast(blastGas).configureClaimableGas();
    }

    function setPointsOperator(
        address blastPoints,
        address operator
    ) external onlyManager {
        // This method can be called only once, and operator must be an EOA.
        IBlastPoints(blastPoints).configurePointsOperator(operator);
    }
}
