pragma solidity ^0.4.6;

import "./Owned.sol";

contract Stoppable is Owned{
    
    bool public running;
    
    modifier requireRunning{ require(running);_;}
    
    event LogRunningChange(address sender,bool runningState);
    
    function Stoppable(){
        running=true;
    }
    
    function runSwitch(bool state) public requireOwner returns(bool){
        LogRunningChange(msg.sender,state);
        running=state;
        return true;
    }
}

