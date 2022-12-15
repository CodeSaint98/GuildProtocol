// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import "./GuildToken.sol";

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
    uint public time_limit;
    GuildToken private guild_token;
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

    //allows users to purchase the guild token
    function purchaseGuildToken(uint amount) public payable{
      require(amount !=0, "Zero value detected");
      
    }
}