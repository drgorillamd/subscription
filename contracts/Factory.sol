pragma solidity ^0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Subscription.sol";

interface ISub {
    function distribute() external returns (bool);

}

contract Factory is Ownable {

    uint256 current_id;

    mapping(address => bool) isCreator;

    Subscription[] child_contracts;

    constructor () {}

    function newCreator(address _creator, address token_adr) external {
        require(!isCreator[_creator], "already creator");
        string memory current_id_str = string(abi.encodePacked("id ", uint2str(current_id)));
        Subscription _adr = new Subscription(_creator, current_id_str, token_adr);
        child_contracts.push(_adr);
        isCreator[_creator] = true;
        current_id++;
    }

    function payAll() external {}

    function payOne(uint256 id) external {}

    function suspendCreator(uint256 id) external onlyOwner {}

    function resumeCreator(uint256 id) external onlyOwner {}

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