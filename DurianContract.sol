// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DurianContract {

    struct Durian {
        uint256 id;
        uint256 kind;
        uint256 weight;
        uint256 harvested_date_time;
        uint256 harvested_by;
        uint256 harvest_tree;
        uint256 harvest_farm;
        uint256 owner;
        uint256 reviews;
        uint256 image;
    }

    function addDurian(
        uint256 id,
        uint256 kind,
        uint256 weight,
        uint256 harvested_date_time,
        uint256 harvested_by,
        uint256 harvest_tree,
        uint256 harvest_farm,
        uint256 owner,
        uint256 reviews,
        uint256 image
    ) public {
        durianList.push(
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
                image
            )
        );
    }

    Durian[] durianList;

    function getDurianById(uint256 id) public view returns (Durian memory) {
        return durianList[id];
    }

    function setDurianById(
        uint256 id,
        uint256 kind,
        uint256 weight,
        uint256 harvested_date_time,
        uint256 harvested_by,
        uint256 harvest_tree,
        uint256 harvest_farm,
        uint256 owner,
        uint256 reviews,
        uint256 image
    ) public {
        durianList[id] = Durian(
            id,
            kind,
            weight,
            harvested_date_time,
            harvested_by,
            harvest_tree,
            harvest_farm,
            owner,
            reviews,
            image
        );
    }

    function getTotalDurians() public view returns(uint) {
        return durianList.length;
    }
}
