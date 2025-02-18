// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Crowdfunding {
    // Structure to define a crowdfunding campaign
    struct Campaign {
        address payable creator; // Address of the campaign creator
        uint256 goal; // Funding goal to be reached
        uint256 deadline; // Campaign end time (timestamp)
        uint256 fundsRaised; // Total funds raised so far
        bool withdrawn; // Flag to track if funds were withdrawn
    }

    // Mapping to store all campaigns with their unique ID
    mapping(uint256 => Campaign) public campaigns;
    // Mapping to track contributions for each campaign and contributor
    mapping(uint256 => mapping(address => uint256)) public contributions;
    uint256 public campaignCount; // Counter to assign unique campaign IDs

    // Events to log important actions in the contract
    event CampaignCreated(uint256 indexed campaignId, address creator, uint256 goal, uint256 deadline);
    event ContributionMade(uint256 indexed campaignId, address contributor, uint256 amount);
    event FundsWithdrawn(uint256 indexed campaignId, address creator, uint256 amount);
    event RefundIssued(uint256 indexed campaignId, address contributor, uint256 amount);

    // Function to create a new crowdfunding campaign
    function createCampaign(uint256 _goal, uint256 _duration) external {
        require(_goal > 0, "Goal must be greater than zero");
        require(_duration > 0, "Duration must be greater than zero");
        
        uint256 campaignId = campaignCount++; // Assign a new campaign ID
        campaigns[campaignId] = Campaign({
            creator: payable(msg.sender),
            goal: _goal,
            deadline: block.timestamp + _duration, // Set deadline based on current time
            fundsRaised: 0,
            withdrawn: false
        });
        
        emit CampaignCreated(campaignId, msg.sender, _goal, block.timestamp + _duration);
    }

    // Function to contribute funds to an active campaign
    function contribute(uint256 _campaignId) external payable {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp < campaign.deadline, "Campaign has ended");
        require(msg.value > 0, "Contribution must be greater than zero");
        
        campaign.fundsRaised += msg.value; // Increase total funds raised
        contributions[_campaignId][msg.sender] += msg.value; // Track contribution amount
        
        emit ContributionMade(_campaignId, msg.sender, msg.value);
    }

    // Function to allow campaign creators to withdraw funds if the goal is met
    function withdrawFunds(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(msg.sender == campaign.creator, "Only campaign creator can withdraw");
        require(block.timestamp >= campaign.deadline, "Campaign is still active");
        require(campaign.fundsRaised >= campaign.goal, "Funding goal not met");
        require(!campaign.withdrawn, "Funds already withdrawn");
        
        campaign.withdrawn = true; // Mark as withdrawn
        uint256 amount = campaign.fundsRaised;
        campaign.fundsRaised = 0; // Reset fundsRaised to prevent re-entrancy attacks
        campaign.creator.transfer(amount); // Transfer funds to campaign creator
        
        emit FundsWithdrawn(_campaignId, msg.sender, amount);
    }

    // Function to allow contributors to claim a refund if the campaign fails
    function claimRefund(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp >= campaign.deadline, "Campaign is still active");
        require(campaign.fundsRaised < campaign.goal, "Funding goal met, no refunds");
        
        uint256 amount = contributions[_campaignId][msg.sender];
        require(amount > 0, "No contributions to refund");
        
        contributions[_campaignId][msg.sender] = 0; // Reset contributor's balance
        payable(msg.sender).transfer(amount); // Send refund to contributor
        
        emit RefundIssued(_campaignId, msg.sender, amount);
    }
}
