// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.8.0;

/**
 * @title Owner
 * @dev Set & change owner
 */
contract Authenticated {

    address private admin;
    mapping(address => bool) public registeredUsers;
    mapping(address => bool) public evaluators;
    
    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    // modifier to check if caller is owner

    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perfom this action");
        _;
    }
    
    modifier onlyRegisteredUser() {
        require(registeredUsers[msg.sender], "Only registered users can perfom this action");
        _;
    }

    modifier onlyEvaluator() {
        require(evaluators[msg.sender], "Only evaluator can perfom this action");
        _;
    }
    
    constructor() {
        admin = msg.sender; 
    }
}