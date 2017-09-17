//Contract Factory Practice

pragma solidity ^0.4.6;
import "browser/Stoppable.sol";


contract Campaign is Stoppable{
    //Block number is used to track
    uint public deadline;
    
    //In units of Wei
    uint public goal;
    
    //Amount Raised
    uint public fundsRaised;
    
    //Funders
    struct FunderStruct{
        uint amount;
        uint amountRefunded;
    }
    
    //Events
    event LogContribution(address sender,uint amount);
    event LogRefund(address funder,uint amount);
    event LogRefundSent(address funder,uint amount);
    event LogWithdrawal(address beneficiary,uint amount);
    
    mapping (address=>FunderStruct) public funderStructs;

    //constructor
    function Campgain(uint campaignDuration,uint campaginGoal){
      deadline=block.number+campaignDuration;
      goal=campaginGoal;
    }
    
     /*Check whether campaign was successful
    */
    function isSuccess() public constant returns (bool){
        return (fundsRaised>=goal);
    }
    
    function hasFailed() public constant returns (bool){
        return ((fundsRaised < goal)&&(deadline<block.number));
    }
    
    
    /*
    Function for people to contribute to the campagin
    Returns boolean
    */
    function contribute() public payable requireRunning returns(bool success){
        if(msg.value==0) throw;
        //checking for deadline
        if(block.number>deadline) throw;
        //stop accepting after success or fail
        if(isSuccess()||hasFailed()) throw;
        if((fundsRaised+msg.value)<fundsRaised) throw;
        fundsRaised+=msg.value;
        funderStructs[msg.sender].amount+=msg.value;
        LogContribution(msg.sender,msg.value);
        success=true;
    }
    
    /*
    Function for owner to withdraw funds
    Returns boolean
    */
    function withdrawFunds() requireOwner requireRunning returns(bool success) {
        //check campaign deadline
        if(!isSuccess()) throw;
        uint _amount=this.balance;
        if((owner.balance+_amount)<owner.balance) throw;
        if(!owner.send(_amount)){
            throw;
        }
        LogWithdrawal(owner,this.balance);
        success=true;
    }
    
    function requestRefund() public requireRunning returns(bool){
        uint amountOwed = funderStructs[msg.sender].amount-funderStructs[msg.sender].amountRefunded;
        if(amountOwed==0) throw;
        if(!hasFailed()) throw;
        funderStructs[msg.sender].amountRefunded+=amountOwed;
        if(!msg.sender.send(amountOwed)) throw;
        LogRefundSent(msg.sender,funderStructs[msg.sender].amount);
        return true;
    }
    
  
    
}

