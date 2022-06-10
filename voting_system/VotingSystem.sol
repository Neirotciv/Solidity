// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Voting is Ownable {
    address admin;
    uint winningProposalId;
    
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint voteProposalId;
    }
    
    struct Proposal {
        string description;
        uint voteCount;
    }

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    WorkflowStatus public session;

    Proposal[] public proposalList;

    mapping(address => Voter) voters; 

    event VoterRegistered(address voterAddress); 
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted (address voter, uint proposalId);

    constructor() {
        admin = msg.sender;
    }

    function changeWorkflowStatus(WorkflowStatus _status) internal onlyOwner {
        session = _status;
    }

    // Add voters to the whitelist
    function addingVotersToWhitelist(address _address) external onlyOwner {
        voters[_address] = Voter(true, false, 0);
    }

    // Start new session
    function startPropositionSession() public onlyOwner {
        emit WorkflowStatusChange(session, WorkflowStatus.ProposalsRegistrationStarted);
        session = WorkflowStatus.ProposalsRegistrationStarted;
    }

    /*  Les électeurs inscrits sont autorisés à enregistrer 
        leurs propositions pendant que la session d'enregistrement 
        est active.
    */
    function addProposal(string memory _description) external {
        require(session == WorkflowStatus.ProposalsRegistrationStarted, "The session has not started yet");
        require(voters[msg.sender].isRegistered, "You are not registered");
        proposalList.push(Proposal(_description, 0));
        voters[msg.sender].hasVoted = true;
    }

    function endCurrentSession() external onlyOwner {
        require(
            session == WorkflowStatus.ProposalsRegistrationStarted ||
            session == WorkflowStatus.VotingSessionStarted,
            "No session to end"
        );
        if (session == WorkflowStatus.ProposalsRegistrationStarted) {
            session = WorkflowStatus.ProposalsRegistrationEnded;
            emit WorkflowStatusChange(session, WorkflowStatus.ProposalsRegistrationStarted);
        } else {
            session = WorkflowStatus.VotingSessionEnded;
            emit WorkflowStatusChange(session, WorkflowStatus.ProposalsRegistrationStarted);
        }
    }
}