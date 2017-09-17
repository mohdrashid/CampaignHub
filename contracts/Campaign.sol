pragma solidity ^0.4.6;
import "./Stoppable.sol";


contract Campaign is Stoppable{
    address public sponsor;
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
    
    modifier requireSponsor{require(msg.sender==sponsor);_;}

    
    //Events
    event LogContribution(address sender,uint amount);
    event LogRefund(address funder,uint amount);
    event LogRefundSent(address funder,uint amount);
    event LogWithdrawal(address beneficiary,uint amount);
    
    mapping (address=>FunderStruct) public funderStructs;

    //constructor
    function Campaign(address campaignSponsor,uint campaignDuration,uint campaginGoal){
        sponsor=campaignSponsor;
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
        require(msg.value!=0);
        //checking for deadline
        require(block.number<deadline);
        //stop accepting after success or fail
        require(!isSuccess()||!hasFailed());
        require((fundsRaised+msg.value)>fundsRaised);
        fundsRaised+=msg.value;
        funderStructs[msg.sender].amount+=msg.value;
        LogContribution(msg.sender,msg.value);
        success=true;
    }
    
    /*
    Function for owner to withdraw funds
    Returns boolean
    */
    function withdrawFunds() requireSponsor requireRunning returns(bool success) {
        //check campaign deadline
        require(isSuccess());
        uint _amount=this.balance;
        require((owner.balance+_amount)>owner.balance);
        if(!owner.send(_amount)){
            revert();
        }
        LogWithdrawal(owner,this.balance);
        success=true;
    }
    
    function requestRefund() public requireRunning returns(bool){
        uint amountOwed = funderStructs[msg.sender].amount-funderStructs[msg.sender].amountRefunded;
        require(amountOwed!=0);
        require(hasFailed());
        funderStructs[msg.sender].amountRefunded+=amountOwed;
        if(!msg.sender.send(amountOwed)) revert();
        LogRefundSent(msg.sender,funderStructs[msg.sender].amount);
        return true;
    }
}
