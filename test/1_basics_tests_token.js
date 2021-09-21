const AFactory = artifacts.require("VoyrMemoriesFactory");
const ASub = artifacts.require("VoyrMemoriesSubscriptions");
const erc20 = artifacts.require("TestToken");

const truffleCost = require('truffle-cost');
const truffleAssert = require('truffle-assertions');
const BN = require('bn.js');
require('chai').use(require('chai-bn')(BN)).should();

let factory;
let subscription;
let token;
 
contract("Subscriptions manager", accounts => {

  const owner = accounts[0];
  const creator = accounts[1];
  const user = accounts[2];
  const receiver = accounts[3];
  const attacker = accounts[4];


  before(async function() {
    token = await erc20.new();
    factory = await AFactory.deployed();
  });

  describe("New creator", () => {
    it("New creator", async () => {
      await truffleCost.log(factory.newCreator(creator, token.address));
      assert.equal(await factory.creatorIds.call(creator), 1);
    });

    it("Child contract deployed", async () => {
      const child = await factory.child_contracts.call(1);
      subscription = await ASub.at(child);
      assert.notEqual(child, "0x0000000000000000000000000000000000000000");
    });

    it("Set price", async () => {
      await factory.setPrice(1, 1000);
      assert.equal(await subscription.current_price.call(), 1000);
    });
  });

  describe.skip("New subscription", () => {
    it("Subscription given", async () => {
      const obs_name = await x.name();
      assert.equal(obs_name, "Rewardeum", "incorrect name returned")
    });

    it("Set", async () => {
      const owned_by_0 = await x.isOwner.call(accounts[0]);
      assert.isTrue(owned_by_0, "Owner is not account[0]");
    });

    it("tot supply in owner", async () => {
      const bal = await x.balanceOf.call(accounts[0]);
      const theo = await x.totalSupply.call();
      bal.should.be.a.bignumber.that.equals(theo);
    });
  });

});
