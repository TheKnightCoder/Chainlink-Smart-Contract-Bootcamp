pragma solidity ^0.8.4;

// testnet jobs - https://docs.chain.link/docs/any-api-testnet-nodes/
// to find jobs go to discord and market.link (https://docs.chain.link/docs/listing-services/)
//https://data.chain.link/
// market.link
// https://reputation.link/

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract APIConsumer is ChainlinkClient {
    using Chainlink for Chainlink.Request; //Library:  puts Chainlink functions onto Chainlink.Request struct (see source code)

    uint256 public volume;

    bytes32 private jobId;
    uint256 private fee;

    /**
     * Network: Kovan
     * Chainlink -
     * Fee: 0.1 LINK
     */
    constructor() public {
        setPublicChainlinkToken();
        setChainlinkOracle(0x74EcC8Bdeb76F2C6760eD2dc8A46ca5e581fA656); // source: https://docs.chain.link/docs/any-api-testnet-nodes/
        jobId = "ca98366cc7314957b8c012c72f05aeeb";
        fee = 0.1 * 10**18; // 0.1 LINK
    }

    // Send LINK to the contract first to pay the fee
    function requestVolumeData() public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );
        request.add(
            "get",
            "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD"
        );
        request.add("path", "RAW,ETH,USD,VOLUME24HOUR"); // add key value string
        int256 timesAmount = 10**18;
        request.addInt("times", timesAmount); // add key value int
        return sendChainlinkRequest(request, fee);
    }

    function fulfill(bytes32 _requestId, uint256 _volume)
        public
        recordChainlinkFulfillment(_requestId)
    {
        volume = _volume;
    }

    // Withdraw link (warning: can be withdrawn by any address)
    function withdrawLink() external {
        LinkTokenInterface linkToken = LinkTokenInterface(
            chainlinkTokenAddress()
        );
        require(
            linkToken.transfer(msg.sender, linkToken.balanceOf(address(this))),
            "unable to withdraw"
        );
    }
}
