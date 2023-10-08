// SPDX-License-Identifier: GPL-3.0
// This line indicates the license under which the code is released, in this case, the GNU General Public License v3.0.

pragma solidity >=0.7.0 <0.9.0;
// This line specifies the compiler version to be used for compiling the Solidity code. It should be >=0.7.0 and <0.9.0.

contract Ballot {
    // The 'Ballot' contract is declared, which will contain all the functionality needed for the voting system.

    struct Voter {
        // This struct type defines the properties of a Voter in the voting system.
        uint weight;
        // 'weight' indicates the weight of a voter's vote. Initially it's set to 1 for each voter, but may increase due to delegations.
        bool voted;
        // 'voted' is a boolean indicating whether the voter has voted or not.
        address delegate;
        // 'delegate' is an address to which the voter can delegate their vote.
        uint vote;
        // 'vote' is an unsigned integer that stores the index of the voted proposal.
    }

    struct Proposal {
        // This struct type defines the properties of a Proposal in the voting system.
        bytes32 name;
        // 'name' is the name of the proposal (stored as bytes32 for optimization).
        uint voteCount;
        // 'voteCount' stores the number of votes that this proposal has received.
    }

    address public chairperson;
    // 'chairperson' is an address that identifies the person/entity that created the contract and can give voting rights to others.
    mapping(address => Voter) public voters;
    // 'voters' is a mapping that associates addresses with their respective 'Voter' struct.
    Proposal[] public proposals;
    // 'proposals' is a dynamic array that stores the 'Proposal' structs.

    uint public startTime;
    // 'startTime' stores the timestamp when the voting starts.
    uint public votingDuration = 5 minutes;
    // 'votingDuration' indicates how long the voting period will last.

    modifier onlyChairperson() {
        // The 'onlyChairperson' modifier is used to restrict certain function calls to the 'chairperson' only.
        require(msg.sender == chairperson, "Only chairperson can perform this action.");
        // It checks that the sender of the transaction/message is the 'chairperson'.
        _;
        // Placeholder for the modified function's code.
    }


    modifier voteEnded() {
        // The 'voteEnded' modifier checks that the voting period has ended.
        require(block.timestamp < startTime + votingDuration, "Voting has ended.");
        // It checks that the current block timestamp is before the voting end time.
        _;
        // Placeholder for the modified function's code.
    }

    constructor(bytes32[] memory proposalNames) {
        // The constructor is called when the contract is deployed. It initializes the 'proposals' array and sets the 'chairperson'.
        chairperson = msg.sender;
        // The person deploying the contract (msg.sender) is set as the 'chairperson'.
        voters[chairperson].weight = 1;
        // The 'chairperson' is given a vote weight of 1.
        startTime = block.timestamp;
        // The current block timestamp is set as the voting start time.

        for (uint i = 0; i < proposalNames.length; i++) {
            // A loop initializes the 'proposals' array with the provided 'proposalNames'.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
            // Each 'proposalNames' entry is used to create a 'Proposal' struct and added to the 'proposals' array.
        }
    }

    function giveRightToVote(address voter) external onlyChairperson {
        // This function allows the 'chairperson' to give voting rights to an address.
        require(!voters[voter].voted, "The voter already voted.");
        // It checks that the voter has not voted yet.
        require(voters[voter].weight == 0);
        // It checks that the voter has not been given voting rights yet.
        voters[voter].weight = 1;
        // It assigns a voting weight of 1 to the voter.
    }

    function delegate(address to) external voteEnded {
        // This function allows a voter to delegate their vote to another voter.
        Voter storage sender = voters[msg.sender];
        // It retrieves the 'Voter' struct of the sender.
        require(!sender.voted, "You already voted.");
        // It checks that the sender has not voted yet.
        require(to != msg.sender, "Self-delegation is disallowed.");
        // It checks that the sender is not trying to delegate to themselves.

        while (voters[to].delegate != address(0)) {
            // It checks for delegation loops.
            to = voters[to].delegate;
            // If the target of the delegation has delegated their vote to someone else, it updates the target to that person.
            require(to != msg.sender, "Found loop in delegation.");
            // It checks again for delegation loops.
        }

        sender.voted = true;
        // It marks the sender as having voted.
        sender.delegate = to;
        // It sets the delegate of the sender to the final target of the delegation.
        Voter storage delegate_ = voters[to];
        // It retrieves the 'Voter' struct of the delegate.
        if (delegate_.voted) {
            // If the delegate has already voted, it adds the sender’s vote to the voted proposal.
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            // If the delegate has not voted yet, it adds the sender’s vote weight to the delegate's weight.
            delegate_.weight += sender.weight;
        }
    }

    function vote(uint proposal) external voteEnded {
        // This function allows a voter to vote for a proposal.
        Voter storage sender = voters[msg.sender];
        // It retrieves the 'Voter' struct of the sender.
        require(sender.weight != 0, "Has no right to vote");
        // It checks that the sender has voting rights.
        require(!sender.voted, "Already voted.");
        // It checks that the sender has not voted yet.
        sender.voted = true;
        // It marks the sender as having voted.
        sender.vote = proposal;
        // It records the index of the proposal that the sender voted for.
        proposals[proposal].voteCount += sender.weight;
        // It adds the sender's vote weight to the voted proposal's vote count.
    }

    function winningProposal() public view returns (uint winningProposal_) {
        // This function returns the index of the proposal with the most votes.
        uint winningVoteCount = 0;
        // It initializes a variable to keep track of the highest vote count seen.
        for (uint p = 0; p < proposals.length; p++) {
            // It loops through all the proposals.
            if (proposals[p].voteCount > winningVoteCount) {
                // If the current proposal has more votes than the highest seen so far:
                winningVoteCount = proposals[p].voteCount;
                // It updates the highest vote count seen.
                winningProposal_ = p;
                // It updates the index of the proposal with the most votes.
            }
        }
        return winningProposal_;
        // It returns the index of the proposal with the most votes.
    }

    function winnerName() external view returns (bytes32 winnerName_) {
        // This function returns the name of the proposal with the most votes.
        winnerName_ = proposals[winningProposal()].name;
        // It calls 'winningProposal()' to get the index of the winning proposal, and then retrieves its name.
    }
}
