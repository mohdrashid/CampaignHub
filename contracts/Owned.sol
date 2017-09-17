pragma solidity ^0.4.6;

contract Owned{
    
    address public owner;
    
    modifier requireOwner{require(msg.sender==owner);_;}
    
    event LogNewOwner(address sender,address oldOwner,address newOwner);
    
    function Owned(){
        owner=msg.sender;
    }
    
    function changeOwner(address newOwner) requireOwner returns(bool){
        require(newOwner!=0);
        LogNewOwner(msg.sender,owner,newOwner);
        owner=newOwner;
        return true;
    }
}