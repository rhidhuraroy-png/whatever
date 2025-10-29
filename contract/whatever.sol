// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockScore {
    // Struct to store player info
    struct Player {
        string name;
        uint256 score;
    }

    // Mapping player address → Player details
    mapping(address => Player) public players;

    // Array to store addresses for leaderboard
    address[] public playerAddresses;

    // Event emitted when new score is recorded
    event ScoreRecorded(address indexed player, string name, uint256 score);

    // Function to record score (immutable once set)
    function recordScore(string calldata _name, uint256 _score) public {
        // Prevent overwriting existing score
        require(players[msg.sender].score == 0, "Score already recorded");

        players[msg.sender] = Player(_name, _score);
        playerAddresses.push(msg.sender);

        emit ScoreRecorded(msg.sender, _name, _score);
    }

    // Function to get player's score
    function getPlayer(address _player) public view returns (string memory, uint256) {
        Player memory p = players[_player];
        return (p.name, p.score);
    }

    // Function to get total number of players
    function getTotalPlayers() public view returns (uint256) {
        return playerAddresses.length;
    }

    // Function to get leaderboard (sorted view for off-chain apps)
    function getAllPlayers() public view returns (Player[] memory) {
        uint256 count = playerAddresses.length;
        Player[] memory allPlayers = new Player[](count);
        for (uint256 i = 0; i < count; i++) {
            allPlayers[i] = players[playerAddresses[i]];
        }
        return allPlayers;
    }
}

