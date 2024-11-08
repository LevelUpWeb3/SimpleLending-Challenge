// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// In this example, the DataTypes library is used to query the AToken address that corresponds DAI
// Later, we will use the getReserveData that will return a ReserveData object.  
// Aave docs: https://docs.aave.com/developers/core-contracts/pool#getreservedata
library DataTypes {
  struct ReserveConfigurationMap {
    uint256 data;
  }

  struct ReserveData {
    ReserveConfigurationMap configuration;
    uint128 liquidityIndex;
    uint128 currentLiquidityRate;
    uint128 variableBorrowIndex;
    uint128 currentVariableBorrowRate;
    uint128 currentStableBorrowRate;
    uint40 lastUpdateTimestamp;
    uint16 id;
    address aTokenAddress;
    address stableDebtTokenAddress;
    address variableDebtTokenAddress;
    address interestRateStrategyAddress;
    uint128 accruedToTreasury;
    uint128 unbacked;
    uint128 isolationModeTotalDebt;
  }
}

// IPool is the main AAVE interface exposed to users, the most notable functions are borrow, supply and withdraw
// AAVE docs: https://docs.aave.com/developers/core-contracts/pool
interface IPool {
    function supply(
        address asset,
        uint256 amount,
        address onBehalfOf,
        uint16 referralCode) external;

    function withdraw(
        address asset,
        uint256 amount,
        address to) external returns (uint256);

    function getReserveData(
        address asset) external view returns (DataTypes.ReserveData memory);
}

// ERC20 interface used to interact with the staking token, which is DAI on this tutorial
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// This contract acts as a proxy to earn yield on AAVE. It can be used seamlessly on the background on
// a variety of contexts such as auctions, DAO treasuries, lotteries, etc...
contract AaveLender {
    // AAVE Pool Address, deployed on Scroll Sepolia at 0x48914C788295b5db23aF2b5F0B3BE775C4eA9440
    address public immutable AAVE_POOL_ADDRESS = 0x48914C788295b5db23aF2b5F0B3BE775C4eA9440;
    // In this example we will stake DAI, but any ERC20 supported by AAVE can be also used
    address public immutable STAKED_TOKEN_ADDRESS = 0x7984E363c38b590bB4CA35aEd5133Ef2c6619C40;

    // Function that stakes DAI and lends it on the background
    function stake(uint amount) public {
      ...
      // 1. Transfer the DAI tokens to be deposited into this contract
      // 2. Allow (or approve) the Aave Pool contract so it can manage the deposited DAI tokens
      // 3. Call the supply function in the Aave Pool on behalf of the transaction sender
    }

    // Every user is able to unstake the exact amount it has staked, all the yield generated by AAVE will go the owner
    function unstake(uint amount) public {
      ...
      // 1. Transfer the aDAI token (The AToken) to be withdrawn (notice you’ll need to retrieve the aDAI token address first)
      // 2. Allow (or approve) the Aave Pool contract so it can manage the deposited aDAI tokens
      // 3. Call the withdraw function so the sender receives the DAI back
    }
}