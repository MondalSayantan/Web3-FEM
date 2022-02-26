// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

/*

We want to be able to generate random Hereos.
The user gets to put in their class of hero on generation
classes: Mage, Healer, Barbarian
Class will not influence stats created, therefore getting an epic hero will be hard.
I want to be paid... 0.05 eth per hero!
I should be able to get my heroes I have generated.
Heroes should be stored on the chain.
stats are strength, health, intellect, magic, dexterity
stats are randomly generated
A scale of 1 - 18
The stats are randomly picked and their amplitude is randomly determined according to the following:
Stat 1 can max at 18
Stat 2 can max at 17
Stat 3 can max at 16
...
You could imagine these being an NFT
They are non divisable

*/

contract Hero {
    enum Class {
        Mage,
        Healer,
        Barbarian
    }

    mapping(address => uint256[]) addressToHeroes; // address is the person who called the function

    // Takes address and produces out an array

    function generateRandom() public view returns (uint256) {
        return
            uint256(
                keccak256(abi.encodePacked(block.difficulty, block.timestamp))
            );
    }

    function getHeroes() public view returns (uint256[] memory) {
        return addressToHeroes[msg.sender];
    }

    function createHero(Class class) public payable {
        // Name of the enum and then the variable name
        require(msg.value >= 0.05 ether, "Please send more money");

        // stats are strength, health, dexterity, intellect, magic
        uint[] stats = new uint[](5);
        stats[0] = 2;
        stats[1] = 7;
        stats[2] = 12;
        stats[3] = 17;
        stats[4] = 22;

        uint len = 5;
        uint hero = uint(class);

        do{
            uint pos = generateRandom() % len;
            uint value = generateRandom() % (13 + len) + 1;

            hero != value << stats[pos];

            len--;
            stats[pos] = stats[len];
        } while (len > 0);

        addressToHeroes[msg.sender].push(hero);
    }
}
