// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
contract MonadDiceGame {

address public owner;
uint256 public constant ENTRY_FEE = 0.01 ether; // 0.01 MON
uint256 public houseCutPercentage = 10; // 10% house cut
struct PlayerStats {
uint256 gamesPlayed;
uint256 wins;
uint256 losses;
uint256 totalEarned;
}
struct LeaderboardEntry {
address player;
uint256 wins;
uint256 earnings;
}
mapping(address =&gt; PlayerStats) public playerStats;
LeaderboardEntry[] public leaderboard;
event GamePlayed(address indexed player, uint256 guess, uint256 result, bool won, uint256 payout);
event HouseWithdrawal(address indexed owner, uint256 amount);
event LeaderboardUpdated(address indexed player);
constructor() {
owner = msg.sender;
}
modifier onlyOwner() {
require(msg.sender == owner, "Only owner can call this");
_;
}
function playGame(uint256 guess) external payable {
require(guess &gt;= 1 &amp;&amp; guess &lt;= 6, "Guess must be between 1 and 6");
require(msg.value == ENTRY_FEE, "Incorrect entry fee");
// Simple pseudo-randomness using blockhash (not for production!)
uint256 random = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp, msg.sender))) % 6 + 1;
bool won = (guess == random);
uint256 payout = 0;
playerStats[msg.sender].gamesPlayed++;
if (won) {
uint256 houseCut = (address(this).balance * houseCutPercentage) / 100;
payout = address(this).balance - houseCut;
payable(msg.sender).transfer(payout);
playerStats[msg.sender].wins++;
playerStats[msg.sender].totalEarned += payout;
updateLeaderboard(msg.sender);
} else {
playerStats[msg.sender].losses++;
}
emit GamePlayed(msg.sender, guess, random, won, payout);
}
function updateLeaderboard(address player) internal {
PlayerStats storage stats = playerStats[player];
// Check if player is already in leaderboard
bool found = false;
for (uint i = 0; i &lt; leaderboard.length; i++) {
if (leaderboard[i].player == player) {
leaderboard[i].wins = stats.wins;
leaderboard[i].earnings = stats.totalEarned;
found = true;
break;
}
}
// If not found, add to leaderboard
if (!found) {
leaderboard.push(LeaderboardEntry({
player: player,
wins: stats.wins,
earnings: stats.totalEarned
}));
}
// Sort leaderboard by wins descending
for (uint i = 1; i &lt; leaderboard.length; i++) {
LeaderboardEntry memory key = leaderboard[i];
uint j = i - 1;
while (j &gt;= 0 &amp;&amp; leaderboard[j].wins &lt; key.wins) {
leaderboard[j + 1] = leaderboard[j];
j = j - 1;
}
leaderboard[j + 1] = key;
}
// Keep only top 10
if (leaderboard.length &gt; 10) {
leaderboard.pop();
}
emit LeaderboardUpdated(player);
}
function withdrawHouseCut() external onlyOwner {
uint256 balance = address(this).balance;
require(balance &gt; 0, "No funds to withdraw");
payable(owner).transfer(balance);
emit HouseWithdrawal(owner, balance);
}
function getLeaderboard() external view returns (LeaderboardEntry[] memory) {
return leaderboard;
}
function getPlayerStats(address player) external view returns (PlayerStats memory) {
return playerStats[player];
}
function getContractBalance() external view returns (uint256) {
return address(this).balance;
}
function setHouseCutPercentage(uint256 newPercentage) external onlyOwner {
require(newPercentage &lt;= 20, "House cut cannot exceed 20%");
houseCutPercentage = newPercentage;
}
}