// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DurianContract {
    address public ownerFarm;
    
    //set owner of blockchain access control
    modifier onlyBy(address _account) {
        require(msg.sender == _account);
        _;
    }

    //set staff access control
    modifier onlyByStaff() {
        address addressofStaff;
        for (uint256 i = staffs.length; i == 0; i--) {
            if (msg.sender == ownerFarm) {
                addressofStaff = ownerFarm;
                break;
            }
            if (staffs[i].staffAddress == msg.sender) {
                addressofStaff = staffs[i].staffAddress;
                break;
            }
        }
        require(msg.sender == addressofStaff);
        _;
    }

    //string comparison workaround
    function compare(string memory str1, string memory str2) private pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

    constructor() {
        ownerFarm = msg.sender;
    }

    //staff attributes
    struct Staff {
        address staffAddress;
        uint256 id;
        string name;
        string title;
    }
    Staff[] public staffs;//list of staff declaration

    //durian attributes
    struct Durian {
        uint256 id;
        uint256 kind;
        uint256 weight;
        uint256 harvested_date_time;
        address harvested_by;
        uint256 harvest_tree;
        uint256 harvest_farm;
        address owner;
        Reviews reviews;
        string location;
        bool onDelivery;
        string status;
    }
    Durian[] public durians; //list of durian declaration

    //enum for rating
    enum RatingNo {
        bad, 
        still_acceptable, 
        average, 
        good, 
        amazing
    }
    //review structure
    struct Reviews{
        string personalRemarks;
        string color;
        RatingNo taste;
        RatingNo fragrance;
        RatingNo creaminess;
        RatingNo overall_rating;
    }
    Reviews private defaultDurian = Reviews("default", "default", RatingNo.average, RatingNo.average, RatingNo.average, RatingNo.average);

    //convert ratings
    function convertRatings(uint256 number) private pure returns(RatingNo){
        if (number == 1) {
            return RatingNo.bad;
        }
        if (number == 2) {
            return RatingNo.still_acceptable;
        }
        if (number == 3) {
            return RatingNo.average;
        }
        if (number == 4) {
            return RatingNo.good;
        }
        if (number == 5) {
            return RatingNo.amazing;
        }
        return RatingNo.average;
    }

    //add new staff
    function addStaff(
        address[] memory newstaffs, 
        uint256 id, 
        string memory name, 
        string memory title
    ) public onlyBy(ownerFarm) {
        for (uint256 i = newstaffs.length; i == 0; i--) {
            staffs.push(
                Staff(
                    newstaffs[i],
                    id,
                    name,
                    title
                )
            );
        }
    }

    //adding a new durian
    function addDurian(
        uint256 id,
        uint256 species,
        uint256 weight,
        uint256 harvested_date_time,
        address harvested_by,
        uint256 harvest_tree,
        uint256 harvest_farm
    ) public onlyByStaff() {
        durians.push(
            Durian(
                id,
                species,
                weight,
                harvested_date_time,
                harvested_by,
                harvest_tree,
                harvest_farm,
                msg.sender,
                defaultDurian,
                "farm",
                false,
                "good"
            )
        );
    }

    

    //worker submit durian for delivery
    function deliverDurian(
        string memory startingPoint,
        string memory destination,
        uint256 id
    ) onlyByStaff() public returns (bool) {
        if (compare(startingPoint, durians[id].location)) {
            durians[id].location = destination;
            durians[id].onDelivery = true;
            return true;
        }
        return false;
    }

    //worker check on recieved durians
    function receiveDurians(
        uint256 id,
        string memory destination,
        string memory status
    ) public onlyByStaff() returns (bool) {
        if (compare(destination, durians[id].location)) {
            durians[id].status = status;
            durians[id].onDelivery = false;
            return true;
        }
        return false;
    }

    //durian sold ------future modifications needed
    function soldDurians (
        address buyer,
        uint256 id
    ) public returns (string memory) {
        if (compare(durians[id].status, "damaged")) {
            return "durian damaged please select another durian";
        }
        durians[id].owner = buyer;
        return "successful";
    }

    //customer make review
    function review(
        uint256 id,
        string memory personalReview, 
        string memory color, 
        uint256[4] memory numbers
    ) public {
        if (msg.sender == durians[id].owner) {
            durians[id].reviews = Reviews(personalReview, color, convertRatings(numbers[0]), convertRatings(numbers[1]), convertRatings(numbers[2]), convertRatings(numbers[3]));
        }
    }


    //Getters
    //total ammount of durian in the system
    function getTotalDurians() public view returns (uint256) {
        return durians.length;
    }

    //specific durian
    function getDurianById(uint256 id) public view returns (Durian memory) {
        return durians[id];
    }

    //owner address
    function getOwnerAdd() external view returns (address){
        return ownerFarm;
    }
}
