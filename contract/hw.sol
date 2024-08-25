// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HomeworkSubmission {
    struct Submission {
        uint score;
        bool graded;
        bool rewarded;
    }

    mapping(address => Submission) public submissions;

    uint public rewardAmount = 1 ether;
    address public teacher;

    constructor() {
        teacher = msg.sender;
    }

    modifier onlyTeacher() {
        require(msg.sender == teacher, "Only the teacher can perform this action");
        _;
    }

    function submitHomework(uint _answer) public {
        require(!submissions[msg.sender].graded, "Homework already graded");

        uint score = (_answer == 42) ? 100 : 0;
        submissions[msg.sender] = Submission({score : score, graded: true, rewarded: true});
    }
function rewardStudent(address payable _student) public onlyTeacher {
    Submission storage submission = submissions[_student];
    
    // Check if the submission is graded and not yet rewarded
    require(submission.graded, "Submission not graded");
    require(!submission.rewarded, "Reward already given");

    // Determine if the student should be rewarded
    if (submission.score > 0) {
        // Check if the contract has sufficient balance
        uint contractBalance = address(this).balance;
        require(contractBalance >= rewardAmount, "Insufficient contract balance");
        
        // Mark the submission as rewarded
        submission.rewarded = true;
        
        // Transfer the reward
        (bool success, ) = _student.call{value: rewardAmount}("");
        require(success, "Transfer failed");
    }
}


    function depositFunds() public payable {}

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}


