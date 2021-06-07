pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;
    
    function createCampaign(uint minimum) public {
        // creates new contract that gets 
        // deployed to the blockchain
        // returns and stores address of newly 
        // created Campaign
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {
    // definition type
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        mapping(address => bool) approvals;
        uint approvalCount; // people who voted yes
    }
    
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    Request[] public requests;
    uint public approversCount;
    
    // manager restricted modifier
    modifier restricted {
        require(msg.sender == manager);
        _;
    }
    
    function Campaign(uint minimum, address creator) public {
        // person creating contract
        manager = creator;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        // has to be greater than min contribution
        require(msg.value > minimumContribution);
        
        // set contributer to true in approvers mapping
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    function createRequest(string description, uint value, address recipient) 
        public restricted {
    
        // storage keyword pass reference
        // memory keyword pass value rather than reference
        Request memory newRequest = Request({
           description: description,
           value: value,
           recipient: recipient,
           complete: false,
           approvalCount: 0
        });
        
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public {
        Request storage request =  requests[index];
        // must be a contributer
        require(approvers[msg.sender]);
        // must not have voted on request before
        require(!request.approvals[msg.sender]);
        
        // mark user as voted
        request.approvals[msg.sender] = true;
        // increment approvalcount
        request.approvalCount++;
    }
    
    function finaliseRequest(uint index) public restricted {
        Request storage request =  requests[index];
        
        // must have more than 50% approval
        require(request.approvalCount > (approversCount / 2));
        
        // request must not already be finalised
        require(!request.complete);
        
        // send money to recipient
        request.recipient.transfer(request.value);
        // mark request as complete
        request.complete = true;
    }

    function getSummary() public view returns (
        uint, uint, uint, uint, address
    ) {
        return (
            minimumContribution,
            this.balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
    
}