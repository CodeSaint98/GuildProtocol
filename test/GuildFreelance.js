const { expect } = require('chai');
const { ethers, waffle} = require("hardhat");
const provider = waffle.provider;
let GuildFreelance;
let Guildpool;
let GuildToken;
let WETH;

//start test block
describe("GuildFreelance contract testing", function () {
    it("Deployment", async function () {
        await setupGuildProtocol();
        console.log("Guild Token address:", GuildToken.address);
        console.log("Guild Liquidity Pool address:", Guildpool.address);
        console.log("GuildFreelance address:", GuildFreelance.address);
        console.log("Collateral Token address:", WETH.address);
        console.log("Reserves in guild liquidity pool:", (await Guildpool.getReserves()).toString())
    })
})

async function setupGuildProtocol(){
    [deployer, user] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
    const ethvalue = ethers.utils.parseEther("0.1");
    const guild_genesis = ethers.utils.parseEther("3000");
    //deployment variables
    const guild_freelance = await ethers.getContractFactory("GuildFreelancer");
    const guild_liquidity_pool = await ethers.getContractFactory("GuildLiquidityPool");
    const guild_token = await ethers.getContractFactory("GuildToken");
    const collateral_token = await ethers.getContractFactory("WETH");

    WETH = await collateral_token.deploy();
    GuildToken = await guild_token.deploy("GuildToken", "GT", guild_genesis, deployer.address);
    Guildpool = await guild_liquidity_pool.deploy(deployer.address);
    GuildFreelance = await guild_freelance.deploy(GuildToken.address,Guildpool.address,WETH.address, 30, deployer.address);
    await Guildpool.connect(deployer).initialize(GuildToken.address,WETH.address);
    await GuildFreelance.connect(deployer).creatorAddLiquidityETH({value: ethvalue});
    await GuildToken.connect(deployer).approve(GuildFreelance.address, guild_genesis);
    await GuildFreelance.connect(deployer).creatorAddLiquidityTokens(guild_genesis);
}