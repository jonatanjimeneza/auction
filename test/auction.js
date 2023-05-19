const { expect } = require("chai");

describe("Auction", function () {
  let Auction;
  let auction;
  let auctioneer;
  let bidder1;
  let bidder2;

  beforeEach(async function () {
    [auctioneer, bidder1, bidder2] = await ethers.getSigners();

    Auction = await ethers.getContractFactory("Auction");
    auction = await Auction.deploy();
    await auction.deployed();
  });

  it("should place a bid", async function () {
    const bidAmount = ethers.utils.parseEther("1.0");
    await auction.connect(bidder1).placeBid({ value: bidAmount });

    expect(await auction.highestBid()).to.equal(bidAmount);
    expect(await auction.highestBidder()).to.equal(bidder1.address);
  });

  it("should finalize the auction and transfer funds to the auctioneer", async function () {
    const bidAmount = ethers.utils.parseEther("1.0");
    await auction.connect(bidder1).placeBid({ value: bidAmount });

    await auction.connect(auctioneer).finalizeAuction();

    expect(await auction.highestBid()).to.equal(ethers.BigNumber.from("0"));
    expect(await auction.highestBidder()).to.equal(ethers.constants.AddressZero);
  });
});
