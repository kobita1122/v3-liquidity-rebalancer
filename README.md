# V3 Liquidity Rebalancer

Concentrated liquidity is powerful but requires constant maintenance. This repository automates the "Re-centering" process for Protocol-Owned Liquidity (POL).

## Core Logic
* **Drift Threshold**: Defines how far the price can move (e.g., 2%) before a rebalance is triggered.
* **Migration Flow**:
    1. **Burn**: Remove all liquidity from the out-of-range NFT.
    2. **Collect**: Harvest all accumulated trading fees and principal.
    3. **Swap**: If the asset ratio is skewed, perform a small swap to return to a 50/50 value split.
    4. **Mint**: Open a new position centered on the current `tick`.

## Efficiency
By keeping the range tight (e.g., ±1%), the DAO achieves **50x-100x capital efficiency** compared to Uniswap V2, meaning a small amount of treasury funds can provide massive price support.
