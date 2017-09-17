pragma solidity ^0.4.6;
import "browser/Campaign.sol";

contract Hub is Stoppable{
    
    address[] public campaigns;
    
    event LogNewCampaign(address campaign, uint duration, uint goal);

    function Hub(){
        
    }
    
    function newCampaign(uint campaignDuration, uint campaignGoal) 
    public
    returns(address campaignContract)
    {
       Campaign trustedCampaign = new Campaign(campaignDuration,campaignGoal);
       campaigns.push(trustedCampaign);
       LogNewCampaign(trustedCampaign,campaignDuration,campaignGoal)
       return trustedCampaign;
    }
    
    function getCampaignCount() constant public returns(uint campaignCount){
        return campaigns.length;
    }
}
