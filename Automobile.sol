
// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Automobile{
     //State Variables
    enum Technology {
        digitalDisplay,
        Connectivity,
        GpsNavigation
    }
    struct Vehicle{
        address owner;
        uint256 vehicleNo;
        string vehicleType;
        string vehicleBrand;
        string color;
        uint256 milage;
        uint256 price;
        string description;
        uint256 topSpeed;
        string engineCC;
        Technology tech;
    }
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    uint256 public newVehicleCount;
    uint256 public oldVehicleCount;

    //MAPINGS
    mapping (uint256=>Vehicle) public newVehicles;
    mapping(uint256=>Vehicle) public oldVehicles;

    //Events
    event ListVehicleDetails(address owner,uint256 vehicleNo, string vehicleType, uint256 price, string description);
    event UpdateVehicleList(uint256 price, string vehicleType, string description, uint256 topSpeed);
    event UpdatePrice(uint256 price, uint256 vehicleNo);
    event BuyVehicle(address indexed buyer, uint256 vehicleNo, string vehicleType, uint256 price, string description);

    //FUNCTIONS

    function addVehicle(
        uint256 _vehicleNo,
        string memory _vechileType,
        string memory _vechileBrand,
        string memory _color,
        uint256 _milage,
        uint256 _price,
        string memory _description,
        uint256 _topSpeed,
        string memory _engineCC,
        Technology _tech
    ) external{
        Vehicle memory vechile = Vehicle(msg.sender, _vehicleNo,_vechileType,_vechileBrand,
        _color,_milage,_price,_description,_topSpeed,_engineCC,_tech);

        if(vechile.owner==owner){
            newVehicleCount++;
            newVehicles[newVehicleCount] = vechile;
        }
        else {
            oldVehicleCount++;
            oldVehicles[oldVehicleCount] =vechile;
        }

        emit ListVehicleDetails(msg.sender, _vehicleNo, _vechileType, _price, _description);
    }

    function updateVehicle(
        uint256 _vehicleNo,
        string memory _vehicleType,
        string memory _vehicleBrand,
        string memory _color,
        uint256 _milage,
        uint256 _price,
        string memory _description,
        uint256 _topSpeed,
        string memory _engineCC,
        Technology _tech
    ) external{
        // require(_vehicleNo>=1 && ((_vehicleNo <=newVehicleCount && newVehicles[_vehicleNo].owner==owner ) ||(_vehicleNo<=oldVehicleCount && oldVehicles[_vehicleNo].owner==msg.sender)),"You dont have the access to update the vechile");
        require(_vehicleNo>=1,"Enter the valid vehicle No");
        if(_vehicleNo<=newVehicleCount && newVehicles[_vehicleNo].owner==msg.sender){
            Vehicle storage vehicle = newVehicles[_vehicleNo];
            vehicle.vehicleType = _vehicleType;
            vehicle.vehicleBrand = _vehicleBrand;
            vehicle.color = _color;
            vehicle.description = _description;
            vehicle.milage = _milage;
            vehicle.price = _price;
            vehicle.topSpeed = _topSpeed;
            vehicle.engineCC = _engineCC;
            vehicle.tech = _tech;
        }
        else if(_vehicleNo<= oldVehicleCount && oldVehicles[_vehicleNo].owner==msg.sender){
            Vehicle storage vehicle = oldVehicles[_vehicleNo];
             vehicle.vehicleType = _vehicleType;
            vehicle.vehicleBrand = _vehicleBrand;
            vehicle.color = _color;
            vehicle.description = _description;
            vehicle.milage = _milage;
            vehicle.price = _price;
            vehicle.topSpeed = _topSpeed;
            vehicle.engineCC = _engineCC;
            vehicle.tech = _tech;
        }
        else{
            revert("You are not the owner or enter the valid vehicle no");
        }

        emit UpdateVehicleList(_price, _vehicleType, _description, _topSpeed);
    }

    function updatePrice(uint256 _vehicleNo, uint256 _price) external{
        // require(_vehicleNo >= 1 && ((_vehicleNo <= newVehicleCount && newVehicles[_vehicleNo].owner == msg.sender) || (_vehicleNo <= oldVehicleCount && oldVehicles[_vehicleNo].owner == msg.sender)), "Enter the correct vehicle no");
        require(_vehicleNo>=1,"Enter the valid vehicle no");

        if (_vehicleNo <= newVehicleCount && newVehicles[_vehicleNo].owner==msg.sender) {
            newVehicles[_vehicleNo].price = _price;
        } else if(_vehicleNo<= oldVehicleCount && oldVehicles[_vehicleNo].owner == msg.sender) {
            oldVehicles[_vehicleNo].price = _price;
        }
        else{
            revert("You are not the owner or enter the correc th vehicle no");
        }

        emit UpdatePrice(_price, _vehicleNo);
    }


    function buyNewVehicle(uint256 _vehicleNo) external payable {
        require(_vehicleNo>=1 && _vehicleNo<=newVehicleCount,"enter the correct vehicle no");
        Vehicle memory vehicle = newVehicles[_vehicleNo];
        require(vehicle.price==msg.value,"You don't have the sufficient amounts");

        (bool sent,) = (vehicle.owner).call{value:msg.value}("");
        require(sent,"Failed to sent");
        vehicle.owner= msg.sender;

        emit BuyVehicle(msg.sender, _vehicleNo, vehicle.vehicleType, vehicle.price, vehicle.description);
    }

        function buyOldVehicle(uint256 _vehicleNo) external payable {
        require(_vehicleNo>=1 && _vehicleNo<=oldVehicleCount,"enter the correct vehicle no");
        Vehicle memory vehicle = oldVehicles[_vehicleNo];
        require(vehicle.price==msg.value,"You don't have the sufficient amounts");

        (bool sent,) = (vehicle.owner).call{value:msg.value}("");
        require(sent,"Failed to sent");
        vehicle.owner= msg.sender;

        emit BuyVehicle(msg.sender, _vehicleNo, vehicle.vehicleType, vehicle.price, vehicle.description);
    }

    function getVehicles(bool _isNew) public view returns (Vehicle[] memory) {
        uint256 vehicleCount = _isNew ? newVehicleCount : oldVehicleCount;
        Vehicle[] memory listVehicles = new Vehicle[](vehicleCount);

        for (uint256 i = 0; i < vehicleCount; i++) {
            if (_isNew) {
                listVehicles[i] = newVehicles[i + 1];
            } else {
                listVehicles[i] = oldVehicles[i + 1];
            }
        }

        return listVehicles;
    }

    function getOldVehicles() public view returns(Vehicle[] memory){
            Vehicle[] memory listVehicles = new Vehicle[](oldVehicleCount);

            for(uint i=0;i<oldVehicleCount;i++){
                Vehicle memory vehicle = oldVehicles[i+1];

                listVehicles[i] = vehicle; 
            }
            return listVehicles;
        }

         function getNewVehicles() public view returns(Vehicle[] memory){
            Vehicle[] memory listVehicles = new Vehicle[](newVehicleCount);

            for(uint i=0;i<newVehicleCount;i++){
                Vehicle memory vehicle = newVehicles[i+1];

                listVehicles[i] = vehicle; 
            }
            return listVehicles;
        }
}
