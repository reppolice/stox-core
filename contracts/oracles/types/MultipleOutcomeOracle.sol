pragma solidity ^0.4.18;
import "../../Ownable.sol";
import "../../Utils.sol";

/*
    @title Multiple Outcome Oracle contract - supporting multiple outcome pool predictions.
    The oracle can register predictions and set their outcomes.
 */
contract MultipleOutcomeOracle is Ownable, Utils {

    /*
     *  Events
     */
    event OutcomeAssigned(address indexed _predictionAddress, bytes32 indexed _outcomeId);
    event PredictionRegistered(address indexed _predictionAddress);
    event PredictionUnregistered(address indexed _predictionAddress);
    event OracleNameChanged(string _newName);

    /*
     *  Members
     */
    string                      public version = "0.1";
    string                      public name;
    mapping(address=>bool)      public predictionsRegistered;    // An index of all the predictions registered for this oracle
    mapping(address=>bytes32)   public predictionsOutcome;       // Mapping of prediction -> outcomes

    /*
        @dev constructor

        @param _owner                       Oracle owner / operator
        @param _name                        Oracle name
    */
    constructor(address _owner, string _name) public notEmptyString(_name) Ownable(_owner) {
        name = _name;
    }

    /*
        @dev Allow the oracle owner to register an prediction

        @param _prediction Prediction address to register
    */
    function registerPrediction(address _prediction) public validAddress(_prediction) ownerOnly {
        predictionsRegistered[_prediction] = true;

        emit PredictionRegistered(_prediction);
    }

    /*
        @dev Allow the oracle owner to unregister an prediction

        @param _prediction Prediction address to unregister
    */
    function unRegisterPrediction(address _prediction) public validAddress(_prediction) ownerOnly {
        delete predictionsRegistered[_prediction];

        emit PredictionUnregistered(_prediction);
    }

    /*
        @dev Check if a prediction is registered
        
        @param _prediction  The prediction address
    */
    function isPredictionRegistered(address _prediction) private view returns (bool) {
        return (predictionsRegistered[_prediction]);
    }

    /*
        @dev Allow the oracle owner to set a specific outcome for an prediction
        The prediction should be registered before calling set outcome.
        Note that setting the outcome does not directly affect the prediction contract. The prediction contract still needs to call the resolve()
        method in order to pull the outcome id from the oracle.

        @param _prediction  Prediction address to set outcome for
        @param _outcomeId   Winning outcome
    */
    function setOutcome (address _prediction, bytes32 _outcome)
            public 
            validAddress(_prediction)
            ownerOnly {
        
        require(isPredictionRegistered(_prediction));
        
        predictionsOutcome[_prediction] = _outcome;
        
        emit OutcomeAssigned(_prediction, _outcome);
    }

    /*
        @dev Returns the outcome id for a specific prediction

        @param _prediction  Prediction address

        @return             Outcome
    */ 
    function getOutcome(address _prediction) public view returns (bytes32) {
        return predictionsOutcome[_prediction];
    }

    /*
        @dev Allow the oracle owner to set the oracle name

        @param _newName New oracle name
    */
    function setName(string _newName) notEmptyString(_newName) external ownerOnly {
        name = _newName;
        emit OracleNameChanged(_newName);
    }
}

