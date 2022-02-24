// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

import "@openzeppelin/contracts/utils/Counters.sol";
import "./shared/ERC721.sol";

interface StatsContract {
    function initializeHeroStats(uint256 _heroId, uint256 _class) external;

    function levelUp(uint256 _heroId) external;
}

contract Hero is ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _heroCount;

    address public statsAddr;
    StatsContract private stats;

    string public constant NAME = "Ethoria Heroes";
    string public constant SYMBOL = "EHE";

    struct HeroStruct {
        uint256 level;
        uint256 class;
        uint256 experience;
    }

    mapping(uint256 => HeroStruct) private heroes;

    event Summoned(address indexed owner, uint256 class, uint256 heroId);

    function summon(uint256 _class) external {
        _heroCount.increment();
        uint256 _newHeroId = _heroCount.current();
        _generateHero(_class, _newHeroId);
        _safeMint(msg.sender, _newHeroId);
        stats.initializeHeroStats(_newHeroId, _class);
        emit Summoned(msg.sender, _class, _newHeroId);
    }

    function _generateHero(uint256 _class, uint256 _newHeroId) internal {
        require(_class >= 1 && _class <= 8, "Class doesnt exist");
        HeroStruct memory newHero = HeroStruct(1, _class, 0);
        heroes[_newHeroId] = newHero;
    }

    function getHero(uint256 _heroId)
        external
        view
        returns (HeroStruct memory _hero)
    {
        return heroes[_heroId];
    }

    function classes(uint256 _class)
        public
        pure
        returns (string memory className)
    {
        if (_class == 1) {
            return "Knight";
        }
        if (_class == 2) {
            return "Wizard";
        }
        if (_class == 3) {
            return "Ranger";
        }
        if (_class == 4) {
            return "Cleric";
        }
        if (_class == 5) {
            return "Barbarian";
        }
        if (_class == 6) {
            return "Rogue";
        }
        if (_class == 7) {
            return "Druid";
        }
        if (_class == 8) {
            return "Necromancer";
        }
    }

    function levelUp(uint256 _heroId) external {
        require(_isApprovedOrOwner(msg.sender, _heroId), "Not owner");
        uint256 _level = heroes[_heroId].level;
        uint256 xpToNextLevel = xpRequired(_level);
        require(
            xpToNextLevel <= heroes[_heroId].experience,
            "Insufficient experience"
        );
        heroes[_heroId].experience -= xpToNextLevel;
        heroes[_heroId].level = _level + 1;
        stats.levelUp(_heroId);
    }

    function xpRequired(uint256 level)
        public
        pure
        returns (uint256 xpToNextLevel)
    {
        xpToNextLevel = (level * 1000) / 4;
    }

    function setStatsAddr(address _statsAddr) external {
        require(statsAddr == address(0), "Stats addr already set!");
        statsAddr = _statsAddr;
        stats = StatsContract(statsAddr);
    }

    // Test purpose
    function setXp(uint256 xp, uint256 heroId) external {
        heroes[heroId].experience += xp;
    }
}
