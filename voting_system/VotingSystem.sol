// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

/*
    Le vote n'est pas secret
    Chaque électeur peux voir le code des autres
    Le gagnant est déterminé à la majorité
    La proposition qui obtient le plus de voix l'emporte

    Ne pas pouvoir rajouter un voter déjà inscrit
*/

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

    mapping(address => Voter) public voters; 

    event VoterRegistered(address voterAddress); 
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted (address voter, uint proposalId);

    function changeWorkflowStatus(WorkflowStatus _status) internal onlyOwner {
        session = _status;
    }

    /*  
        L'administrateur du vote enregistre une liste blanche d'électeurs 
        identifiés par leur adresse Ethereum
    */
    function addingVotersToWhitelist(address _address) external onlyOwner {
        voters[_address] = Voter(true, false, 0);
    }

    // L'administrateur du vote peut commencer une session d'enregistrement de la proposition
    function startPropositionSession() public onlyOwner {
        emit WorkflowStatusChange(session, WorkflowStatus.ProposalsRegistrationStarted);
        session = WorkflowStatus.ProposalsRegistrationStarted;
    }

    // L'administrateur du vote commence la session de vote
    function startVotingSession() public onlyOwner {
        emit WorkflowStatusChange(session, WorkflowStatus.VotingSessionStarted);
        session = WorkflowStatus.VotingSessionStarted;
    }

    /*  
        Les électeurs inscrits sont autorisés à enregistrer 
        leurs propositions pendant que la session d'enregistrement 
        est active
    */
    function addProposal(string memory _description) external {
        require(voters[msg.sender].isRegistered, "You are not registered");
        require(session == WorkflowStatus.ProposalsRegistrationStarted, "The session has not started yet");
        proposalList.push(Proposal(_description, 0));
    }

    // Mettre fin à une session, proposition et vote
    function endCurrentSession() external onlyOwner {
        require(
            session == WorkflowStatus.ProposalsRegistrationStarted ||
            session == WorkflowStatus.VotingSessionStarted,
            "No session to end"
        );
        
        WorkflowStatus previousStatus = session;
        if (session == WorkflowStatus.ProposalsRegistrationStarted) {
            session = WorkflowStatus.ProposalsRegistrationEnded;
            emit WorkflowStatusChange(previousStatus, session);
        } else {
            session = WorkflowStatus.VotingSessionEnded;
            emit WorkflowStatusChange(previousStatus, session);
        }
    }

    // Les électeurs inscrits votent pour leur proposition préférée, inscrit et n'a pas voté
    function voteForProposition(uint _proposalId) public {
        require(session == WorkflowStatus.VotingSessionStarted, "The voting session has not started yet");
        require(voters[msg.sender].isRegistered, "You are not registered");
        require(!voters[msg.sender].hasVoted, "You have already voted");
        proposalList[_proposalId].voteCount++;
        voters[msg.sender].hasVoted = true;
    }

    // Comptabiliser les votes
    function countTheVotes() public onlyOwner {
        uint id;
        uint count;
        // Parcourir la liste des propositions
        for (uint i; i < proposalList.length; i++) {
            if (proposalList[i].voteCount > count) {
                count = proposalList[i].voteCount;
                id = i;
            }
        }
        winningProposalId = id;
    }

    function getAllProposals() public view returns (Proposal[] memory) {
        return proposalList;
    }

    function getWinningProposal() public view  returns (Proposal memory) {
        return proposalList[winningProposalId];
    }
}