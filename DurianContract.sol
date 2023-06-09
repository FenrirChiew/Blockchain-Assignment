// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DurianContract {
    //declaration
    address payable public ownerFarm;
    uint256 public durianCount;
    uint256 public staffCount;
    string[] public array;
    
    //set owner of blockchain access control
    modifier onlyBy(address _account) {
        require(msg.sender == _account);
        _;
    }//set staff access control
    modifier recieveAccess() {
        require(compare(staffs[msg.sender].title, "Distribution Worker")||compare(staffs[msg.sender].title, "Retail Worker")||(msg.sender == ownerFarm));
        _;
    }//access for retrieving durian
    modifier deliverAccess() {
        require(compare(staffs[msg.sender].title, "Distribution Worker")||compare(staffs[msg.sender].title, "Farm Worker")||(msg.sender == ownerFarm));
        _;
    }//access for delivering durian
    modifier harvestAccess() {
        require(compare(staffs[msg.sender].title, "Farm Worker")||(msg.sender == ownerFarm));
        _;
    }//access for adding durian

//___________________modifiers________________________
    //string comparison workaround
    function compare(string memory str1, string memory str2) private pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }

//__________________private function__________________

    constructor() {
        ownerFarm = payable(msg.sender);
    }

    //staff attributes
    struct Staff {
        address staffAddress;
        uint256 id;
        string name;
        string title;
    }
    mapping (address => Staff) public staffs; //staff dictionary

    //durian attributes
    struct Durian {
        string id;
        string species; //inserts the pricing of that species per kg
        uint256 weight; 
        uint256 harvested_date_time;
        address harvested_by;
        string harvest_tree;
        uint256 harvest_farm;
        address owner;
        Reviews reviews;
        string location;
        bool onDelivery;
        string status;
    }
    mapping (string => Durian) public durians; //durian dictionary

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

    //species structure
    struct SpeciesPrice {
        string speciesName;
        uint pricePerKG; //100 == RM1
    }
    mapping (string => SpeciesPrice) public PricingList;

    //farm structure
    struct Farm {
        string name;
        string farmID;
        address farmOwner;
    }
    mapping (string => Farm) public FarmList;

    //tree structure
    struct Tree {
        string treeID;
        string speciesName;
        string[] childs;
    }
    mapping  (string => Tree) public TreeList;

//__________________________structures______________________________

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
        address newstaffs, 
        uint256 id, 
        string memory name, 
        string memory title
    ) public onlyBy(ownerFarm) {
        staffs[newstaffs] = Staff(
            newstaffs, 
            id, 
            name, 
            title 
        );
        staffCount++;
    }
    //adding new durian -- maps id to the struct for durian --adds tree automatically
    function addDurian(
        string memory id,
        string memory species,
        uint256 weight,
        uint256 harvested_date_time,
        string memory harvest_tree,
        uint256 harvest_farm
    ) public harvestAccess() {
        durians[id] = Durian(
            id, 
            species, 
            weight, 
            harvested_date_time, 
            msg.sender, 
            harvest_tree, 
            harvest_farm,
            ownerFarm,
            defaultDurian,
            "farm",
            false,
            "perfect"
        );
        if (!compare(TreeList[harvest_tree].treeID,harvest_tree)) {
            array.push(id);
            TreeList[harvest_tree] = Tree(
                harvest_tree,
                species,
                array
            );
            array.pop();
        }
        else {
            TreeList[harvest_tree].childs.push(id);
        }
        durianCount++;
    }
    //adding new price for species
    function addPrice(
        string memory name,
        uint256 price
    ) public harvestAccess() {
        PricingList[name] = SpeciesPrice(
            name,
            price
        );
    }

    function addFarm(
        string memory name,
        string memory farmID,
        address farmOwner
    ) public onlyBy(farmOwner){
        FarmList[name] = Farm(
            name,
            farmID,
            farmOwner
        );
    }

//===========additions

    //worker submit durian for delivery
    function deliverDurian(
        string memory startingPoint,
        string memory destination,
        string memory id
    ) deliverAccess() public returns (bool) {
        if (compare(startingPoint, durians[id].location)) {
            durians[id].location = destination;
            durians[id].onDelivery = true;
            return true;
        }
        return false;
    }

    //worker check on recieved durians
    function receiveDurians(
        string memory id,
        string memory destination,
        string memory status
    ) public recieveAccess() returns (bool) {
        if (compare(destination, durians[id].location)) {
            durians[id].status = status;
            durians[id].onDelivery = false;
            return true;
        }
        return false;
    }

    //durian sold ------future modifications needed
    function buyDurians (
        address buyer,
        string memory id
    ) public payable returns (string memory) {
        if (compare(durians[id].status, "damaged")) {
            return "durian damaged please select another durian";
        }
        if (durians[id].weight == 0) {
            return "durian not found";
        }
        require(msg.value >= (durians[id].weight * PricingList[durians[id].species].pricePerKG));
        ownerFarm.transfer(msg.value);
        durians[id].owner = buyer;
        return "successful";
    }

    //customer make review
    function review(
        string memory id,
        string memory personalReview, 
        string memory color, 
        uint256[4] memory numbers
    ) public {
        if (msg.sender == durians[id].owner) {
            durians[id].reviews = Reviews(
                personalReview, 
                color, 
                convertRatings(numbers[0]), 
                convertRatings(numbers[1]), 
                convertRatings(numbers[2]), 
                convertRatings(numbers[3])
            );
        }
    }

    //Getters
    //total ammount of durian in the system
    function getTotalDurians() public view returns (uint256) {
        return durianCount;
    }

    //total ammount of staff in the system
    function getTotalstaffs() public view returns (uint256) {
        return staffCount;
    }

    //specific durian
    function getDurianById(string memory id) public view returns (Durian memory) {
        return durians[id];
    }

    //owner address
    function getOwnerAdd() external view returns (address){
        return ownerFarm;
    }

//_____________________________functions_________________________________
}