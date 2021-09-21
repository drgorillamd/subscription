const VoyrMemoriesFactory = artifacts.require("VoyrMemoriesFactory");

module.exports = function (deployer) {
  deployer.deploy(VoyrMemoriesFactory);
};
