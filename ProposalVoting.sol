

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proposals{
    struct Proposal{
        string description;
        uint256 vote_limit;
        uint256 approve;
        uint256 reject;
        uint256 pass;
        bool status;
        bool is_active;
        mapping (address=>bool) hasVoted;
    }

    address owner;
    constructor(){
        owner=msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender==owner,"You are the not owner");
        _;
    }
     modifier notVoted(uint256 proposalId) {
        require(!proposals[proposalId].hasVoted[msg.sender], "You have already voted");
        _;
    }

    uint256 proposalCount=1;
    mapping (uint256=>Proposal) public proposals;

    function createProposal(string memory _description, uint256 vote_limit) external onlyOwner{
        // proposals[proposalCount] = Proposal(_description, vote_limit,0,0,0,false,true);
        Proposal storage newProposal = proposals[proposalCount];
        newProposal.description = _description;
        newProposal.vote_limit = vote_limit;
        newProposal.approve = 0;
        newProposal.reject =0;
        newProposal.pass =0;
        newProposal.status= false;
        newProposal.is_active= true;
       
        proposalCount++;
    }



    function approveVote(uint256 id) external notVoted(id){
        require(owner!=msg.sender,"You are the owner of the contract, so you don't have the authority");
        require(proposals[id].is_active==true, "The proposal is not created");
        proposals[id].vote_limit+=1;
        proposals[id].hasVoted[msg.sender] = true;
        // voterCount++;
    }

    function rejectVote(uint256 id) external notVoted(id){
        require(owner!=msg.sender,"You are the owner of the contract, so you don't have the authority");
        require(proposals[id].is_active==true, "The proposal is not created");
        proposals[id].reject+=1;
        proposals[id].hasVoted[msg.sender] = true;
    }

    function passVote(uint256 id) external notVoted(id){
        require(owner!=msg.sender,"You are the owner of the contract, so you don't have the authority");
        require(proposals[id].is_active==true, "The proposal is not created");
        proposals[id].pass+=1;
        proposals[id].hasVoted[msg.sender] = true;
    }

    function endProposal(uint256 id) internal view returns(string memory){
        Proposal storage currentProposal = proposals[id];
        if(currentProposal.approve>=currentProposal.reject){
            return "approve vote greater";
        }
        else {
            return  "reject votes are greater";
        }
    }

    function checkProposalEnd(uint256 id) external  view {
        Proposal storage currentProposal = proposals[id];
        if(
            currentProposal.approve>=currentProposal.vote_limit ||
            currentProposal.reject>=currentProposal.vote_limit ||
            currentProposal.pass>=currentProposal.vote_limit
        ){
            endProposal(id);
        }
    }

    
}
