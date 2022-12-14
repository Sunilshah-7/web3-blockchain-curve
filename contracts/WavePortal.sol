//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal{
    uint256 totalWaves;

    // we will be using this to generate a random number;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave{
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user waved at us.
     */
    mapping(address => uint256) public lastWavedAt;

    constructor() payable{
        console.log("Hello from the smart contract");

        // set the initial seed
        seed = ( block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public{
        // we need to make sure the current timestamp is 15 mins bigger than the last timestamp stored
        require(lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Wait 30 seconds before waving");
        // update current timestamp we have for user
        lastWavedAt[msg.sender] = block.timestamp;


        totalWaves +=1;
        console.log("%s has waved",msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        // generate new seed for next user that sends the wave
        seed = (block.difficulty+block.timestamp+seed)%100;
        console.log("Random #s generated %d",seed);

        // give a 50% chance that user wins the prize
        if(seed<50){
            console.log("%s won!", seed);

            uint256 prizeAmount = 0.00001 ether;
        require(
            prizeAmount <= address(this).balance,
            "Trying to withdraw more money than the contract has."
        );
        (bool success, )=(msg.sender).call{value:prizeAmount}("");
        require(success, "failed to withdraw money from contract.");
        }

        emit NewWave(msg.sender,block.timestamp,_message);

        
    }

    function getAllWaves() public view returns(Wave[] memory){
        return waves;
    }
    function getTotalWaves() public view returns(uint256){
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}
