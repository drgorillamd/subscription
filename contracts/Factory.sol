pragma solidity 0.8.0;

import "@openzeppelin/contract/access/Ownable.sol";
import "./Subscription.sol";

interface ISub {
    function distribute() external returns (bool);

}

contract Factory is Ownable {

    uint256 current_id;

    mapping(address => bool) isCreator;

    address[] child_contracts;

    constructor () {}

    function newCreator(address _creator) external {
        require(!isCreator, "already creator");
        address _adr = new Subscription(_creator, current_id);
        child_contracts.push(adr);
        isCreator(_creator) = true;
        current_id++;
    }

    function payAll()

    function payOne(id)

    function suspendCreator(id) onlyOwner

    function resumeCreator(id) onlyOwner


}