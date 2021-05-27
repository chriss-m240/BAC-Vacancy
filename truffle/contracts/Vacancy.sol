// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.8.0;

/** 
 * @title Vacancy
 * @dev Implements voting process in the applicant selection for an open vacancy
 */
 
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "./Authenticated.sol";
 
contract Vacancy is Authenticated {
    address public admin;
    string public name;
    string public description;
    uint public treshold;
    bool public isOpen = true;
    uint256 public applicantCount = 0;
    uint256 public vacancyVersion = 0;

    mapping(uint256 => Applicant) public applicants;
    mapping(address => bool) public alreadyApplied;
    
    address[] auxRegisteredUsers;

    int256 public ethSalary;

    // Oraculo
    AggregatorV3Interface internal priceFeed;

    struct Applicant {
        address payable applicant;
        string name;
        string bio;
        string skillsAchievementsInfo;
        uint  score;
        int256 salary;
        int256 currentEthValue;
    }

    event ApplicantAdded(
        address payable applicant,
        string name,
        string bio,
        string skillsAchievementsInfo,
        uint score,
        int256 salary
    );

    constructor(string memory _name, string memory _description, uint _treshold) {
        admin = msg.sender;
        name = _name;
        description = _description;
        treshold = _treshold;
        
        priceFeed = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    }
    
    function getLatestPrice() internal view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
    
    function registerUser(address _user) onlyAdmin public {
        require(isOpen, "Vacancy is not open");
        registeredUsers[_user] = true;
        auxRegisteredUsers.push(_user);
    }
    
    function addEvaluator(address _evaluator) onlyAdmin public {
        require(isOpen, "Vacancy is not open");
        evaluators[_evaluator] = true;
    }

    function addApplicant(string memory _name, string memory _bio, string memory _skillsAchievementsInfo, int256 _salary) public onlyRegisteredUser {
        require(isOpen, "Vacancy is not open");
        require(!alreadyApplied[msg.sender], "Applicant has already applied");
        require(bytes(_name).length > 0);
        require(bytes(_bio).length > 0);
        require(bytes(_skillsAchievementsInfo).length > 0);
        
        alreadyApplied[msg.sender] = true;
        
        applicantCount++;
        applicants[vacancyVersion + applicantCount] = Applicant(payable(msg.sender), _name, _bio, _skillsAchievementsInfo, 0, _salary, getLatestPrice());
        emit ApplicantAdded(payable(msg.sender), _name, _bio, _skillsAchievementsInfo, 0, _salary);
    }

    function evaluateUser(uint256 _id) public payable onlyEvaluator {
        require(isOpen, "Vacancy is not open");
        require(msg.value <= 100, "Evaluator can only assign at most 100 points");
        
        require(_id > 0 && _id <= applicantCount);
        
        Applicant memory _applicant = applicants[vacancyVersion + _id];
        address payable _applicantAddress = _applicant.applicant;
        
        _applicantAddress.transfer(msg.value);
        _applicant.score = _applicant.score + msg.value;
        
        applicants[vacancyVersion + _id] = _applicant;
    }
    
    function openVacancy() public onlyAdmin {
        require(!isOpen, "Vacancy is already open");

        isOpen = true;
        vacancyVersion += 3;
        applicantCount = 0;

        for (uint i=0; i< auxRegisteredUsers.length ; i++){
            alreadyApplied[auxRegisteredUsers[i]] = false;
        }
    }
    
    function closeVacancy() public onlyAdmin {
        isOpen = false;
    }
}
