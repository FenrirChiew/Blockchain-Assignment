// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Durian {
    uint private _id;
    uint private _kind;
    uint private _weight;
    uint private _harvested_date_time;
    address private _harvested_by;
    uint private _harvest_tree;
    uint private _harvest_farm;
    address private _owner;
    string private _reviews;
    uint private _total_durians = 0;

    constructor(
        uint id,
        uint kind,
        uint weight,
        uint harvested_date_time,
        address harvested_by,
        uint harvest_tree,
        uint harvest_farm,
        address owner,
        string memory reviews
    ) {
        _id = id;
        _kind = kind;
        _weight = weight;
        _harvested_date_time = harvested_date_time;
        _harvested_by = harvested_by;
        _harvest_tree = harvest_tree;
        _harvest_farm = harvest_farm;
        _owner = owner;
        _reviews = reviews;
    }

    function getID() public view returns (uint) {
        return _id;
    }

    function setID(uint id) public {
        _id = id;
    }

    function getKind() public view returns (uint) {
        return _kind;
    }

    function setKind(uint kind) public {
        _kind = kind;
    }

    function getWeight() public view returns (uint) {
        return _weight;
    }

    function setWeight(uint weight) public {
        _weight = weight;
    }

    function getHarvestedDateTime() public view returns (uint) {
        return _harvested_date_time;
    }

    function setHarvestedDateTime(uint harvested_date_time) public {
        _harvested_date_time = harvested_date_time;
    }

    function getHarvestedBy() public view returns (address) {
        return _harvested_by;
    }

    function setHarvestedBy(address harvested_by) public {
        _harvested_by = harvested_by;
    }

    function getHarvestTree() public view returns (uint) {
        return _harvest_tree;
    }

    function setHarvestTree(uint harvest_tree) public {
        _harvest_tree = harvest_tree;
    }

    function getHarvestFarm() public view returns (uint) {
        return _harvest_farm;
    }

    function setHarvestFarm(uint harvest_farm) public {
        _harvest_farm = harvest_farm;
    }

    function getOwner() public view returns (address) {
        return _owner;
    }

    function setOwner(address owner) public {
        _owner = owner;
    }

    function getReviews() public view returns (string memory) {
        return _reviews;
    }

    function setReviews(string memory reviews) public {
        _reviews = reviews;
    }

    function getTotalDurians() public view returns (uint) {
        return _total_durians;
    }

    function setTotalDurians(uint total_durians) public {
        _total_durians = total_durians;
    }
}

contract DurianBucket {
    Durian[] public durians;
    uint private _total_durians = 0;

    function addDurian(
        uint kind,
        uint weight,
        uint harvested_date_time,
        address harvested_by,
        uint harvest_tree,
        uint harvest_farm,
        address owner,
        string memory reviews
    ) public {
        durians[_total_durians] = new Durian(
            _total_durians,
            kind,
            weight,
            harvested_date_time,
            harvested_by,
            harvest_tree,
            harvest_farm,
            owner,
            reviews
        );
        _total_durians += 1;
    }
}
