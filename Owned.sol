pragma solidity ^0.4.6;

contract Owned{
    
    address public owner;
    
    modifier requireOwner{if(msg.sender!=owner) throw;_;}
    
    event LogNewOwner(address oldOwner,address newOwner);
    
    function Owned(){
        owner=msg.sender;
    }
    
    function changeOwner(address newOwner) requireOwner returns(bool){
        if(newOwner==0) throw;
        LogNewOwner(owner,newOwner);
        owner=newOwner;
        return true;
    }
}
