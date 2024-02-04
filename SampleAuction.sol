// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.5;


contract SimpleAuction {
    
    uint auctionEnd;
    address public highestBidder;
    uint public highestBid;
    address payable public beneficiary;
    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns;

    // Set to true at the end, disallows any change
    bool ended;

    // Events that will be fired on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    event BeneFiciarySettlement(address beneficiary, uint amount);

    constructor (uint _biddingTime, address payable _beneficiary) {
        beneficiary = _beneficiary; 
        auctionEnd = block.timestamp + _biddingTime;        // unix epoch: 1 Jan 1970, 00:00:00 UTC
    } // seconds passed from the unix epoch to when this block was mined

    function bid() public payable {
        require (msg.value > highestBid);
        if (highestBid != 0) {
            pendingReturns[highestBidder] = pendingReturns[highestBidder]+ highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
            if (!msg.sender.send(amount)) { // payeeAddress.send(amount)
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true; 
    }

    function getFunds() view public returns(uint) {
        return address(this).balance;  // accountAddress.balance
    }

    function EndAuction() public {
        // 1. Conditions
        require (!ended); // this function has already been called
        uint amount = this.getFunds();
        // Beneficiary should get the highest bid amount.
        // not entire balance, entire balance can be transferred if
        // all other bidders except for winner has withdrawn money.
        if(beneficiary.send(amount)){ 
            emit BeneFiciarySettlement(beneficiary, amount);
            // Once the amount is transferred to beneficiary.
            // highest Bidder amount can be set to 0 in PendingReturns and cannot be withdrawn.
            pendingReturns[highestBidder] = 0;
        }
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);
    }
    
    function showMyBid() view public returns(uint){
        return pendingReturns[msg.sender];
    }
}
