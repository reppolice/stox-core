pragma solidity ^0.4.23;
import "../../Ownable.sol";

/*
    @title UpgradablePredictionFactory contract - A factory contract for generating predictions.
    It delegates the createPrediction() calls to the up-to-date prediction creation contract (address dispatched dynamically).
 */
contract UpgradablePredictionFactory is Ownable {

    /*
     * Members
     */
    address predictionFactoryImplRelay;
    
    constructor(address _predictionFactoryImplRelay) 
        public 
        Ownable(msg.sender) 
        {
            predictionFactoryImplRelay = _predictionFactoryImplRelay;
    }

    /*
        @dev Set a new PredictionFactoryImpl address

        @param _predictionFactoryImplRelay       PredictionFactoryImpl new address
    */
    function setPredictionFactoryImplRelay(address _predictionFactoryImplRelay) 
        public 
        ownerOnly 
        {
            predictionFactoryImplRelay = _predictionFactoryImplRelay;
    }

    
    /*
        @dev Fallback function to delegate calls to the relay contract

    */
    function() public {
         
        if (!predictionFactoryImplRelay.delegatecall(msg.data)) 
           revert();
    }

}

