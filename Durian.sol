// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Durian {
    uint private _id;
    uint private _kind;
    uint private _weight;
    uint private _total_durians = 0;
    
    constructor(uint id, uint kind, uint weight) {
        _id = id;
        _kind = kind;
        _weight = weight;
    }

    function getID() public view returns(uint) {
        return _id;
    }

    function getKind() public view returns(uint) {
        return _kind;
    }

    function getWeight() public view returns(uint) {
        return _weight;
    }

    function getTotalDurians() public view returns(uint) {
        return _total_durians;
    }
}

contract DurianBucket {

    Durian[] public durians;
    uint private _total_durians = 0;

    function addDurian(uint kind, uint weight) public {
        durians[_total_durians] = new Durian(_total_durians, kind, weight);
        _total_durians += 1;
    }

}