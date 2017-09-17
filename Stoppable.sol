pragma solidity ^0.4.6;

import "browser/Owned.sol";

contract Stoppable is Owned{
    
    bool public running;
    
    modifier requireRunning{ if(!running) throw;_;}
    
    event LogRunningChange(bool runningState);
    
    function Stoppable(){
        running=true;
    }
    
    function runSwitch(bool state) public requireOwner returns(bool){
        LogRunningChange(state);
        running=state;
        return true;
    }
}


