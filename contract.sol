pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Approval
 */
contract Approval {

    address private currentApprover;
    mapping (uint256 => address) private steps;
    mapping (address => uint8) private approveChain; 
    uint256 currentStep;
    
    
    // event for EVM logging
    event DoASet(address indexed oldOwner, address indexed newOwner);
    
    // modifier to check if caller is owner
    modifier isCurrentApprover() {
        require(msg.sender == currentApprover, "Caller is not the current approver");
        _;
    }
    
    /**
     * @dev Set approvers
     */
    constructor(address[] memory approverSet) {
        for (uint i = 0; i < approverSet.length; i++) {
            currentStep = 0;
            steps[i] = approverSet[i];
            approveChain[approverSet[i]] = 0;
        }
        currentApprover = steps[0];
    }
    
    function setStepStatus(uint8 status) public isCurrentApprover {
        address currentOriginalApprover = steps[currentStep];
        approveChain[currentOriginalApprover] = status;
        currentStep = currentStep + 1;
        currentApprover = steps[currentStep];
    }

    /**
     * @dev Change Approver
     * @param newApprover address of new approver
     */
    function changeApprover(address newApprover) public isCurrentApprover {
        emit DoASet(currentApprover, newApprover);
        currentApprover = newApprover;
    }

    /**
     * @dev Return current approver address 
     * @return address of the currentApprover
     */
    function getCurrentApprover() external view returns (address) {
        return currentApprover;
    }
}
