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

const owner = accounts[0];
const creator = accounts1];
const user = accounts[2];
const attacker = accounts[3];
 
contract("Basic tests", accounts => {

  before(async function() {
    token = await erc20.new();
    factory = await AFactory.deployed();
  });

  describe("New creator", () => {
    it("New creator", async () => {
      await factory.newCreator(creator, token.address);
      assert.isTrue(await factory.isCreator(creator));
    });

    it("Child contract deployed", async () => {
      const owned_by_0 = await x.isOwner.call(accounts[0]);
      assert.isTrue(owned_by_0, "Owner is not account[0]");
    });
  });
/*
  describe("New subscription", () => {
    it("Initialized - return proper name()", async () => {
      const obs_name = await x.name();
      assert.equal(obs_name, "Rewardeum", "incorrect name returned")
    });

    it("deployer = owner", async () => {
      const owned_by_0 = await x.isOwner.call(accounts[0]);
      assert.isTrue(owned_by_0, "Owner is not account[0]");
    });

    it("tot supply in owner", async () => {
      const bal = await x.balanceOf.call(accounts[0]);
      const theo = await x.totalSupply.call();
      bal.should.be.a.bignumber.that.equals(theo);
    });
  });*/

});
