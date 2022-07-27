pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceConsumerV3 {
    AggregatorV3Interface internal priceFeed;

    /*
     * Network: Kovan
     * Aggregator: ETH/USD
     * https://docs.chain.link/docs/ethereum-addresses/
     */
    constructor() public {
        priceFeed = AggregatorV3Interface(
            0x9326BFA02ADD2366b30bacB125260Af641031331
        );
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timestamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}
