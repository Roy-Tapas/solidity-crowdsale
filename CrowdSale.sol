pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundableCrowdsale {

    constructor(
        // Fill in the constructor parameters!
        uint rate, // conversion rate between ETH and TKN
        address payable wallet, // wallet address participating in crowdsale
        PupperCoin token, // new token
        uint256 goal,  // how much we want to raise through crowsale
        uint256 cap,  // maximum allowed limit of crowdsale, say 300 ETH
        uint256 openingTime, // use this in conjunction with closingTime to restrict crowdsale period, say 24 weeks
        uint256 closingTime // use this in conjunction with openingTime to restrict crowdsale period, say 24 weeks
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        public
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale(goal)
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        // constructor parameters
        string memory name,
        string memory symbol,
        address payable wallet // this address will receive all Ether raised by the crowdsale
    )
        public
    {
        // create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale Pupper_Sale = new PupperCoinSale(1, wallet, token, 100, 50, now, now + 24 weeks);
        token_sale_address = address(Pupper_Sale);
        
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
