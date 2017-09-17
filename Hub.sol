pragma solidity ^0.4.6;
import "browser/Campaign.sol";

contract Hub is Stoppable{
    
    address[] public campaigns;
    mapping(address=>bool) campaignExists;
    
    modifier onlyIfCampaign(address campaign){
        if(!campaignExists[campaign]) throw;
        _;
    }
    
    event LogNewCampaign(address campaign, uint duration, uint goal);

    function Hub(){
        
    }
    
    function newCampaign(uint campaignDuration, uint campaignGoal) 
    public
    returns(address campaignContract)
    {
       Campaign trustedCampaign = new Campaign(msg.sender,campaignDuration,campaignGoal);
       campaigns.push(trustedCampaign);
       campaignExists[trustedCampaign]=true;
       LogNewCampaign(trustedCampaign,campaignDuration,campaignGoal);
       return trustedCampaign;
    }
    
    function getCampaignCount() 
    constant 
    public 
    returns(uint campaignCount){
        return campaigns.length;
    }
    
    //Pass-through Admin Controls
    function stopCampaign(address campaign) 
    requireOwner 
    onlyIfCampaign(campaign) 
    returns(bool success){
        Campaign trustedCampaign=Campaign(campaign);
        return trustedCampaign.runSwitch(false);
    }
    
    function startCampaign(address campaign) 
    requireOwner 
    onlyIfCampaign(campaign) 
    returns(bool success){
        Campaign trustedCampaign=Campaign(campaign);
        return trustedCampaign.runSwitch(true);
    }
    
    function changeCampaignOwner(address campaign,address newOwner) 
    requireOwner 
    onlyIfCampaign(campaign) 
    returns(bool success){
        Campaign trustedCampaign=Campaign(campaign);
        return trustedCampaign.changeOwner(newOwner);
    }
}
