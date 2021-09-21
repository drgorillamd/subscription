const AFactory = artifacts.require("VoyrSubFactory");
const ASub = artifacts.require("VoyrSubscriptions");
const erc20 = artifacts.require("TestToken");

const truffleCost = require('truffle-cost');
const truffleAssert = require('truffle-assertions');
const BN = require('bn.js');
const { advanceTimeAndBlock } = require('./helper/timeshift');
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
      console.log("child: "+subscription.address);
      assert.notEqual(child, "0x0000000000000000000000000000000000000000");
    });

    it("Set price", async () => {
      await factory.setPrice(1, 1000);
      assert.equal(await subscription.current_price.call(), 1000);
    });
  });

  describe("New subscription", () => {
    it("Subscription given", async () => {
      await truffleCost.log(factory.give(1, receiver, 60));
      const theo = new BN( (Date.now()/1000) + 60);
      const observed = await subscription.expirations.call(receiver);
      observed.should.be.a.bignumber.equals(theo);
    });

    it("NFT Balance", async () => {
      const observed = await subscription.balanceOf(receiver);
      observed.should.be.a.bignumber.equals(new BN('1'));
    });

    it("Subscription bought", async () => {
      await token.transfer(user, '10000', {from: owner});
      await token.approve(subscription.address, '10000', {from: user});
      await truffleCost.log(subscription.newSub(10, {from: user}));

      const observed = await subscription.balanceOf(user);
      observed.should.be.a.bignumber.equals(new BN('1'));

      const ts_theo = new BN( (Date.now()/1000) + 10);
      const ts_observed = await subscription.expirations.call(user);
      ts_observed.should.be.a.bignumber.equals(ts_theo);
    });

    it("Renew", async () => {
      await token.transfer(user, '10000', {from: owner});
      await token.approve(subscription.address, '10000', {from: user});

      const tmp = await subscription.expirations.call(user);
      const ts_theo = tmp.add(new BN('10'));
      await truffleCost.log(subscription.newSub(10, {from: user}));
      const ts_after = await subscription.expirations.call(user);

      ts_after.should.be.a.bignumber.equals(ts_theo);
    });

    it("Access control", async () => {
      assert.isTrue(await subscription.subscriptionActive.call({from: user}));
      await advanceTimeAndBlock(600);
      assert.isFalse(await subscription.subscriptionActive.call({from: user}));
    });
  });

});
