// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DurianContract {
    address public ownerFarm;
    
    //set owner of blockchain
    modifier onlyBy(address _account) {
        require(msg.sender == _account);
        _;
    }

    modifier onlyByThese() {
        address addressofStaff;
        for (uint256 i = staffs.length; i == 0; i--) {
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
        string reviews;
        string location;
        bool onDelivery;
        string status;
    }
    Durian[] public durians; //list of durian declaration

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
        uint256 kind,
        uint256 weight,
        uint256 harvested_date_time,
        address harvested_by,
        uint256 harvest_tree,
        uint256 harvest_farm,
        string memory reviews
    ) public {
        durians.push(
            Durian(
                id,
                kind,
                weight,
                harvested_date_time,
                harvested_by,
                harvest_tree,
                harvest_farm,
                msg.sender,
                reviews,
                "farm",
                false,
                "good"
            )
        );
    }

    //get durian
    function getDurianById(uint256 id) public view returns (Durian memory) {
        return durians[id];
    }

    //worker submit durian for delivery
    function deliverDurian(
        string memory startingPoint,
        string memory destination,
        uint256 id
    ) public returns (bool) {
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
    ) public returns (bool) {
        if (compare(destination, durians[id].location)) {
            durians[id].status = status;
            durians[id].onDelivery = false;
            return true;
        }
        return false;
    }

    //durian sold
    function soldDurians(
        address buyer,
        uint256 id
    ) public returns (string memory) {
        if (compare(durians[id].status, "damaged")) {
            return "durian damaged please select another durian";
        }
        durians[id].owner = buyer;
        return "successful";
    }

    

    //return total ammount of durian in the system
    function getTotalDurians() public view returns (uint256) {
        return durians.length;
    }
}
