
// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract Banking{
    //STATE VARIABLEs
    struct User{
        address userAddress;
        uint256 balance;
        uint256 userId;
    }

    mapping(uint256=>User) public users;
    address payable owner;
    constructor(){
        owner=payable (msg.sender);
    }

    //EVents
    event Withdraw(address indexed userAddress, uint256 balance);
    event Deposit(address indexed  userAddress, uint256 balance);
    uint256 public userCount;

    // mapping (address=>uint256) public balances;
   uint256 userIndex;

   function deposit() external payable {
    require(msg.value > 0, "Deposit more than 0");
    userCount++;
    User memory user = User({
        userAddress: msg.sender,
        balance: msg.value,
        userId: userCount
    });
    users[userCount] = user;
    emit Deposit(msg.sender, msg.value);
}


    function withdraw(uint256 userId,uint amount) external {
        require(users[userId].userAddress==msg.sender,"you are not the owner");
        require(amount>0,"amount shoudl greater than 0");
        require(users[userId].balance>=amount,"you don't have sufficient amount");

        users[userId].balance-=amount;
        payable(owner).transfer(amount);
        emit Withdraw(msg.sender, amount);
    }

    function transfer(uint256 userId, address receiver) external payable{
        require(users[userId].userAddress==msg.sender,"you are not the owner");
        require(msg.value>0,"amount shoudl greater than 0");
        require(users[userId].balance>=msg.value,"you don't have sufficient amount");

        payable (receiver).transfer(msg.value);
        users[userId].balance -=msg.value;

    }

    function getBalance(uint256 userId) public view returns (uint256){
        return users[userId].balance;
    } 

    function grantAccess(address user) external{
        require(owner==msg.sender,"you are not the contract owner");
        owner=payable (user);
    }

    function revoke() external{
        require(owner==msg.sender,"you are not the owner");
        // require(user==owner,"cannot revoke");
        owner = payable (msg.sender);
    }

    function destroy() external{
        require(owner==msg.sender,"you are not the owner");
        selfdestruct(owner);
    }
}
