// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol";

contract RebalancerLogic is Ownable {
    INonfungiblePositionManager public immutable pm;
    uint24 public constant poolFee = 3000;

    constructor(address _pm) Ownable(msg.sender) {
        pm = INonfungiblePositionManager(_pm);
    }

    /**
     * @dev Migrates liquidity from an old NFT to a new centered range.
     */
    function rebalance(
        uint256 _tokenId,
        int24 _newTickLower,
        int24 _newTickUpper,
        uint128 _liquidity
    ) external onlyOwner returns (uint256 newTokenId) {
        // 1. Decrease Liquidity
        pm.decreaseLiquidity(INonfungiblePositionManager.DecreaseLiquidityParams({
            tokenId: _tokenId,
            liquidity: _liquidity,
            amount0Min: 0,
            amount1Min: 0,
            deadline: block.timestamp
        }));

        // 2. Collect tokens
        (uint256 amount0, uint256 amount1) = pm.collect(INonfungiblePositionManager.CollectParams({
            tokenId: _tokenId,
            recipient: address(this),
            amount0Max: type(uint128).max,
            amount1Max: type(uint128).max
        }));

        // 3. Mint new position (Simplified: assumes balanced tokens)
        (newTokenId, , , ) = pm.mint(INonfungiblePositionManager.MintParams({
            token0: pm.positions(_tokenId).token0, // Pseudocode for fetching tokens
            token1: pm.positions(_tokenId).token1,
            fee: poolFee,
            tickLower: _newTickLower,
            tickUpper: _newTickUpper,
            amount0Desired: amount0,
            amount1Desired: amount1,
            amount0Min: 0,
            amount1Min: 0,
            recipient: address(this),
            deadline: block.timestamp
        }));
    }
}
