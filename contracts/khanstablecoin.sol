// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Khansstablecoin is ERC20, Ownable{

    uint256 private constant INITIAL_SUPPLY = 1_000_000; // * 1e18; 

    mapping(address => uint256) private redemptionRequest;
    mapping(address => bool) private redemptionLock;

    mapping(address => uint256) private redemptionFulfilled;

    event Minting(address indexed minter,uint256 value);
    event burning(address indexed burner,uint256 value); 
    event oracleCallToCheckReserves(address indexed owner,uint256 value); 
    event oracleCallToCheckFiatsAreTransferred(address indexed redeemer,uint256 value);
    event fulfilledRedeem(address indexed redeemer,uint256 value); 
    event lockToRedeem(address indexed redeemer, uint256 amount, address indexed owner);


    constructor(string memory name, string memory symbol,address initialOwner) ERC20(name,symbol) Ownable(initialOwner) {

        _mint(initialOwner,INITIAL_SUPPLY); // mint 1 million tokens
    }

    // When demand is over supply , we should use this
    function mint(address to, uint256 amount) external onlyOwner {

        // require: oracle call to check if reserved custodian has enough balance
        emit oracleCallToCheckReserves(msg.sender,amount);

        _mint(to,amount);

        emit Minting(to,amount);

    }

    //token holder will call this function 
    function RedeemToFiat(uint256 amount) external  {

        require(balanceOf(msg.sender)>=amount,"Insufficient amount in your balance");
        require(!redemptionLock[msg.sender],"Your existing redeeming amount is under progress, please wait for additional redeeming");

        _burn(msg.sender,amount);
        redemptionRequest[msg.sender] += amount;
        emit burning(msg.sender, amount);
    }

    function LockRedemption(address account) external onlyOwner {
        redemptionLock[account] = true;
        emit lockToRedeem(account,redemptionRequest[account],msg.sender);
    }

    function UnlockRedemption(address account) external onlyOwner {
        redemptionLock[account] = false;
    }


    // it should be called after fiat transferred to the redeemer
    function fulfillRedemption(address account,uint256 amount) external onlyOwner {

        require(redemptionRequest[account]>0,"There is no request to fulfill any redeem");

        //check and balance based on your regulatory compliance 

        // fiat transfer checking through oracle could 
       emit oracleCallToCheckFiatsAreTransferred(account,amount);

        // unlock the redeemer for next any new redeem
        redemptionLock[account] = false;

        // rebalancing the statuses of redeemer
        redemptionRequest[account] -= amount;
        redemptionFulfilled[account] += amount; 

        emit fulfilledRedeem(account,amount);
    }

    function amountRedeemedbyMe() public view returns (uint256 amount) {
        return redemptionFulfilled[msg.sender];
    }

}