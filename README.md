# Fiat backed Stablecoin (Compliance and regulatory required coin)
A prototype of Khan ERC20 Stablecoin with minting , burning and redeeming requests. 

The stablecoin has following functionality 

1- Owner or the issuer entity can mint tokens.
2- Minting cannot be done without verfification of the existing reserves 
3- Redeem can be requested by the token holder.
4- On redeeming, the tokens will be burnt and logs the event by the token holder. 
5- Issuer can verify and confirm tokens are burnt and lock the account for additional redeeming request.
6- The issuer follows the compliance and regulatory requirement before fulfilling the request.
7- Oracle will check if fiat reserved is now equal to the balance token supply exist in the contract.
8- Redeemer will be allowed to recieve his fiat and issuer will record the fulfillment of redeeming process.
9- redeemer can now check how much till now he has redeemed. 


# Make sure to add security clauses and patterns

This project will show how the stable coin can be built especially the centralized stablecoin backed by fiat currency and financial institutions.

In order to create decentralized with crypto pegged stablecoin, you have to add rebalancing and additional scope should be taken care.
