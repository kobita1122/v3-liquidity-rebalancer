const { ethers } = require("ethers");

/**
 * Script to monitor if the current tick is outside the safety threshold.
 */
async function checkDrift(currentTick, lowerTick, upperTick, thresholdPercent) {
    const rangeWidth = upperTick - lowerTick;
    const midPoint = lowerTick + (rangeWidth / 2);
    const drift = Math.abs(currentTick - midPoint);
    
    // Convert 1% drift to ticks (rough estimate)
    const driftThreshold = 100; 

    if (drift > driftThreshold) {
        console.log("ALERT: Position is drifting! Triggering rebalance...");
        return true;
    }
    console.log("Position healthy and centered.");
    return false;
}

checkDrift(-20000, -21000, -19000, 0.01);
