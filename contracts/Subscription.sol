pragma solidity ^0.8.6;

// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @author DrGorilla.eth / Voyager Media Group
/// @title Memories Subscription: individual creators
/// @notice this is the generic NFT compatible subscription token.
/// @dev accepted token is set by factory. totalySupply is, de facto, tthe current id minted,
/// Sub prices are individual to allow special offer for limited timeframe

// TODO : manage limited time offer reversibillity


contract Subscription is IERC721, Ownable {

    uint256 totalSupply;
    uint256 current_price; //in wei

    address creator;

    string private _symbol;

    IERC20 payment_token;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _owned;
    mapping(uint256 => uint256) public expirations; //id->timestamp
    mapping(address => uint256) public subscription_price;

    modifier onlyAdmin {
        require(msg.sender == creator || msg.sender == owner(), "Sub: unauthorized");
        _;
    }

    constructor(address _creator, string memory _id, address token_adr) {
        _symbol = _id;
        creator = _creator;
        payment_token = IERC20(token_adr);
    }

    function balanceOf(address _owner) public view virtual override returns (uint256) {
        require(_owner != address(0), "ERC721: balance query for the zero address");
        if(_owned[_owner] != 0) return 1;
        return 0;
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address _owner = _owners[tokenId];
        require(_owner != address(0), "ERC721: owner query for nonexistent token");
        return _owner;
    }

    function name() public view virtual returns (string memory) {
        return "VOYRME SUB";
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

/// @param length duration of subscription, in seconds
    function newSub(uint256 length) external {
        require(length != 0, "Invalid sub duration");
        if(_owned[msg.sender] != 0) renewSub(_owned[msg.sender]);
        else {
            subscription_price[msg.sender] = current_price;
            _owned[msg.sender] = totalSupply;
            _owners[totalSupply] = msg.sender;
            totalSupply++;
            Transfer(address(this), msg.sender, totalSupply);
            _processPayment();
        }
    }

    function renewSub(uint256 length) public {
        require(length != 0, "Invalid sub duration");
        require(_owned[msg.sender] != 0, "No sub owned");
        _processPayment(length);
    }

    function _processPayment(length) internal {
        uint256 to_pay = subscription_price[msg.sender]  * length;
        require(payment_token.allowance(msg.sender, address(this)) >= to_pay, "IERC20: insuf approval");
        expirations[msg.sender] += length;
        payment_token.transferFrom(msg.sender, address(this), to_pay);
    }

    function setCurrentPrice(uint256 _price) external onlyAdmin {
        current_price = _price;
    }


/// @dev no use case:

    function approve(address to, uint256 tokenId) public virtual override {}

    function getApproved(uint256 tokenId) public view virtual override returns (address) {return address(0);}

    function setApprovalForAll(address operator, bool approved) public virtual override {}

    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {return false;}

    function transferFrom(address from,address to,uint256 tokenId) public virtual override {}

    function safeTransferFrom(address from,address to,uint256 tokenId) public virtual override {}

    function safeTransferFrom(address from,address to,uint256 tokenId,bytes memory _data) public virtual override {}

    function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {return false;}

}
