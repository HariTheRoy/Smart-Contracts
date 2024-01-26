// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Count{
    address public owner;

    struct Counter{
        uint number;
        string description;
    }

    Counter counter;

    modifier  onlyOwner(){
        require(msg.sender == owner, "only the owner can increment and decreament the counter");
        _;
    }
    
    constructor(uint intial_value, string memory description){
        owner ==msg.sender;
        counter = Counter(intial_value, description);
    }

    function increment_counter() external  onlyOwner{
        counter.number+=1;
    }
    function decrement_counter() external onlyOwner{
        counter.number-=1;
    }

    function get_counter_value() external view returns(string memory){
        return counter.description;
    }
}
