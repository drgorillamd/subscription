pragma solidity ^0.8.6;
// SPDX-License-Identifier: GPL


import "@openzeppelin/contracts/access/Ownable.sol";
import "./VoyrMemoriesSubscriptions.sol";

/// @author DrGorilla.eth / Voyager Media Group
/// @title Memories Factory
/// @notice this is the factory and controller for subscription contracts.
/// Each contract created by this factory is init with the name 'VOYR SUB' 
/// and the symbol 'id XX' (where XX is the creator id)

contract VoyrMemoriesFactory is Ownable {

    uint256 current_id;

    mapping(address => bool) isCreator;

    VoyrMemoriesSubscriptions[] child_contracts;

    constructor () {}

    function newCreator(address _creator, address token_adr) external {
        require(!isCreator[_creator], "already creator");
        string memory current_id_str = string(abi.encodePacked("id ", uint2str(current_id)));
        VoyrMemoriesSubscriptions _adr = new VoyrMemoriesSubscriptions(_creator, current_id_str, token_adr);
        child_contracts.push(_adr);
        isCreator[_creator] = true;
        current_id++;
    }

    /// @dev send the sub to creator_id from user to the burn address + cancel any ongoing sub
    function burn(uint256 creator_id, address user) external onlyOwner {
        child_contracts[creator_id].burn(user);
    }

    /// @dev create a new sub and mint if needed
    function give(uint256 creator_id, address receiver, uint256 length) external onlyOwner {
        child_contracts[creator_id].sendSubscription(receiver, length);
    }

    function setPrice(uint256 creator_id, uint256 price) external onlyOwner {
        child_contracts[creator_id].setCurrentPrice(price);
    }

    function suspendCreator(uint256 creator_id) external onlyOwner {
        child_contracts[creator_id].pause();
    }

    function resumeCreator(uint256 creator_id) external onlyOwner {
        child_contracts[creator_id].resume();
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }


}