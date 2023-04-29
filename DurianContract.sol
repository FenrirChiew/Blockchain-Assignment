// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DurianContract {
    address public ownerFarm;
    
    //set owner of blockchain
    modifier onlyBy(address _account) {
        require(msg.sender == _account);
        _;
    }

    //string comparison workaround
    function compare(string memory str1, string memory str2) private pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

    constructor() {
        ownerFarm = msg.sender;
    }

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
    }
    Durian[] public durians; //list of durian declaration

    //adding a new durian
    function addDurian(
        uint256 id,
        uint256 kind,
        uint256 weight,
        uint256 harvested_date_time,
        address harvested_by,
        uint256 harvest_tree,
        uint256 harvest_farm,
        address owner,
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
                owner,
                reviews,
                "farm"
            )
        );
    }

    //get durian
    function getDurianById(uint256 id) public view returns (Durian memory) {
        return durians[id];
    }

    function deliverDurian(
        string memory startingPoint,
        string memory destination,
        uint256 id
    ) public {
        if (compare(startingPoint, durians[id].location)) {
            durians[id].location = destination;
        }
        
    }

    function getTotalDurians() public view returns (uint256) {
        return durians.length;
    }
}
