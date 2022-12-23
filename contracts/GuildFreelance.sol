// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import "./GuildToken.sol";
import "./IGuildLiquidityPool.sol";

contract GuildFreelancer {
    /*
     1. Allows a client to buy Guild tokens.
     2. Proposal function allows clients to list a proposal
        - stores client address
        - stores bounty amount that includes a tip amount
     3. Lock function accessible to client
        - locks in freelancer address
        - restores bounty amount in case of negotiation
        - checks if client has bounty amount
     4. Milestone based function
        - takes in a number rating the freelancer 
        - freelancer gets a tip depending on number
        - rest of the bounty stays in clients wallet
        - bounty amount is transferred to freelancer
     5. Hourly based storage function
        - Allows a freelancer to log in hours into the function.
        - Each freelancer has an hourly rate mapped to their address.
        - Freelancer can go below that hourly rate if they want to.
        - Hourly amounts are added up and stored.
        - Freelancer can put in a deadline to pay as well (default is 7 days).
     6. Hourly based payment function
        - Client can go in and pay the hourly amount.
        - Client cannot change number of hours.
        - Client is blacklisted if they do not pay on time.
    */
    // STATE VARIABLES
    address public guild_token_address;
    address public guild_pool_address;
    uint public time_limit;
    GuildToken private guild_token;
    IGuildLiquidityPool private guild_pool;
    constructor(
        address _guild_token_address,
        uint _time_limit
    ){
        require((_guild_token_address != address(0))
        &&(_time_limit != 0), "Zero Address detected");
        guild_token = GuildToken(_guild_token_address);
        guild_token_address = _guild_token_address;
        time_limit = _time_limit;
    }

    function setGuildPool(address _guild_pool_address) public{
      require(_guild_pool_address != address(0), "Zero address detected");
      guild_pool_address = _guild_pool_address;
      guild_pool = IGuildLiquidityPool(_guild_pool_address);
    }

   //returns guild token price with a precision of 1e6
    function guild_token_price() internal view returns(uint256){
      uint reserve0;
      uint reserve1;
      uint _eth_usd_price = 1227990000;
      (reserve0, reserve1, ) = guild_pool.getReserves();
      if(reserve0 == 0 || reserve1 == 0){
         return 1;
      }
      return ((_eth_usd_price*reserve1)/reserve1);
}

    //allows users to purchase the guild token
    function purchaseGuildToken(uint amount) public payable{
      require(amount !=0, "Zero value detected");
      uint _eth_usd_price = 1227990000;
      uint _guild_price = guild_token_price();
      uint _amount_usd = (msg.value * _eth_usd_price);
      require(_amount_usd/_guild_price >= amount, "GUILD:INSUFFICIENT_INPUT");
      guild_token.guildPoolMint(amount);
    }
}