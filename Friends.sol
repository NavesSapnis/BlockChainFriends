// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FriendsRegistry {
    address private owner;
    
    struct Friend {
        string name;
        bool exists;
    }

    mapping(address => Friend) private friends;
    mapping(address => address[]) private friendsList;

    event FriendAdded(address indexed friendAddress, string name);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addFriend(address _friendAddress, string memory _name) public onlyOwner {
        require(!friends[_friendAddress].exists, "Friend already exists");
        
        friends[_friendAddress] = Friend({
            name: _name,
            exists: true
        });

        friendsList[msg.sender].push(_friendAddress);

        emit FriendAdded(_friendAddress, _name);
    }

    function getFriendName(address _friendAddress) public view returns (string memory) {
        return friends[_friendAddress].name;
    }

    function getFriendsList() public view returns (string[] memory) {
        address[] memory friendAddresses = friendsList[msg.sender];
        string[] memory friendsInfo = new string[](friendAddresses.length);

        for (uint256 i = 0; i < friendAddresses.length; i++) {
            address friendAddress = friendAddresses[i];
            string memory friendName = friends[friendAddress].name;

            // Формируем строку в нужном формате
            friendsInfo[i] = string(abi.encodePacked(friendName, " - ", toString(friendAddress)));
        }

        return friendsInfo;
    }

    function toString(address _addr) public pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3 + i * 2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
    }
}
