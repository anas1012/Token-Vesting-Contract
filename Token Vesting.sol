// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VestingContract {
    
    address public owner;
    IERC20 public token;

    uint256 public vestingStartTime;

    // User Role
    address public userBeneficiary;
    uint256 public userTotalAmount;
    uint256 public userCliffDuration;
    uint256 public userDuration;

    // Partner Role
    address public partnerBeneficiary;
    uint256 public partnerTotalAmount;
    uint256 public partnerCliffDuration;
    uint256 public partnerDuration;

    // Team Role
    address public teamBeneficiary;
    uint256 public teamTotalAmount;
    uint256 public teamCliffDuration;
    uint256 public teamDuration;

    // Events
    event VestingStarted(uint256 startTime);
    event BeneficiaryAdded(string role, address beneficiary, uint256 totalAmount, uint256 cliffDuration, uint256 duration);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor(address _token) {
        
        token=IERC20(_token);
        owner = msg.sender;
    }
        
    function addUserVestingSchedule(
        address beneficiary,
        uint256 totalAmount,
        uint256 cliffDuration,
        uint256 duration
    ) public onlyOwner {
        userBeneficiary = beneficiary;
        userTotalAmount = totalAmount;
        userCliffDuration = cliffDuration;
        userDuration = duration;

        emit BeneficiaryAdded("User", beneficiary, totalAmount,cliffDuration, duration);
    }

    function addPartnerVestingSchedule(
        address beneficiary,
        uint256 totalAmount,
        uint256 cliffDuration,
        uint256 duration
    ) public onlyOwner{
        partnerBeneficiary = beneficiary;
        partnerTotalAmount = totalAmount;
        partnerCliffDuration = cliffDuration;
        partnerDuration = duration;

        emit BeneficiaryAdded("Partner", beneficiary, totalAmount,cliffDuration, duration);
    }

    function addTeamVestingSchedule(
        address beneficiary,
        uint256 totalAmount,
        uint256 cliffDuration,
        uint256 duration
    ) public onlyOwner {
        teamBeneficiary = beneficiary;
        teamTotalAmount = totalAmount;
        teamCliffDuration = cliffDuration;
        teamDuration = duration;

        emit BeneficiaryAdded("Team", beneficiary, totalAmount,cliffDuration, duration);
    }

    function startVesting() public onlyOwner{
        vestingStartTime = block.timestamp;
        emit VestingStarted(vestingStartTime);
    }

    function calculateUserVestedAmount() public view returns(uint256){
        return _calculateVestedAmount(userCliffDuration,userDuration, userTotalAmount);
    }

    function calculatePartnerVestedAmount() public view returns(uint256){
        return _calculateVestedAmount(partnerCliffDuration,partnerDuration, partnerTotalAmount);
    }

    function calculateTeamVestedAmount() public view returns(uint256){
        return _calculateVestedAmount(teamCliffDuration,teamDuration, teamTotalAmount);
    }

    function _calculateVestedAmount(
        uint256 cliffDuration,
        uint256 duration,
        uint256 totalAmount
    ) internal view returns (uint256){
        if (block.timestamp < cliffDuration) {
            return 0;
        } else if (block.timestamp >= duration){
            return totalAmount;
        } else {
            return (totalAmount * (block.timestamp)) / duration;
        }
    }
}