// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/Context.sol';
import '../Utils/Owned.sol';

contract GuildToken is ERC20, Owned{

    /* ========== MODIFIERS ========== */
    modifier onlyByOwner(){
        require(msg.sender == owner, "You are not the owner");
        _;
    }
    modifier onlyGuildPool(){
        require(msg.sender == guild_pool_address, "Only the pool can mint and burn tokens");
        _;
    }

    /* ========= STATE VARIABLES ====== */
    address public guild_pool_address;
    address public smartcontract_owner;
    uint public genesis_supply;
    
    /* ========= CONSTRUCTOR ======== */

    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 _genesis_supply, 
        address _smartcontract_owner
     ) Owned(_smartcontract_owner)ERC20(_name, _symbol){
        require(_smartcontract_owner != address(0), "Zero address detected");
        require(_genesis_supply != 0, "Zero value is detected");
        genesis_supply = _genesis_supply;
        _mint(smartcontract_owner, genesis_supply);
        smartcontract_owner = _smartcontract_owner;
    }

    function setGuildPool(address _guild_pool_address) public onlyOwner{
        require(_guild_pool_address != address(0), "Zero address detected");
        guild_pool_address = _guild_pool_address;
    }

    function guildPoolMint(uint amount) public onlyGuildPool{
        super._mint(guild_pool_address,amount);
    }

    function eth_usd_price() public pure returns(uint){
        return 1227990000;
    }
}