// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.12;

import "@openzeppelin/contracts/utils/math/Math.sol";

interface HeroContract {
    struct HeroStruct {
        uint256 level;
        uint256 class;
        uint256 experience;
    }

    function getApproved(uint256) external view returns (address);

    function ownerOf(uint256) external view returns (address);

    function setStatsAddr(address _statsAddr) external;
}

contract Stats {
    using Math for uint256;

    address public heroAddr;
    HeroContract private hero;

    struct StatsStruct {
        uint256 strength;
        uint256 vitality;
        uint256 dexterity;
        uint256 intelligence;
        uint256 health;
        uint256 defense;
        uint256 meleeAttack;
        uint256 magicAttack;
        uint256 hitRate;
    }

    mapping(uint256 => StatsStruct) public stats;
    mapping(uint256 => uint256) public pointsToSpend;
    mapping(uint256 => bool) public heroExist;

    event Created(
        address indexed owner,
        uint256 heroId,
        uint256 strength,
        uint256 vitality,
        uint256 dexterity,
        uint256 intelligence,
        uint256 health,
        uint256 defense,
        uint256 meleeAttack,
        uint256 magicAttack,
        uint256 hitRate
    );
    event Leveled(
        address indexed owner,
        uint256 heroId,
        uint256 strength,
        uint256 vitality,
        uint256 dexterity,
        uint256 intelligence,
        uint256 health,
        uint256 defense,
        uint256 meleeAttack,
        uint256 magicAttack,
        uint256 hitRate
    );

    modifier onlyHeroContract() {
        require(msg.sender == heroAddr, "Not authorized");
        _;
    }

    constructor(address _heroAddr) {
        heroAddr = _heroAddr;
        hero = HeroContract(heroAddr);
        hero.setStatsAddr(address(this));
    }

    function initializeHeroStats(uint256 _heroId, uint256 _class)
        external
        onlyHeroContract
    {
        require(!heroExist[_heroId], "Hero already exist");
        heroExist[_heroId] = true;
        stats[_heroId] = _getClassInitStats(_class);
        pointsToSpend[_heroId] = 0;
        emit Created(
            msg.sender,
            _heroId,
            stats[_heroId].strength,
            stats[_heroId].vitality,
            stats[_heroId].dexterity,
            stats[_heroId].intelligence,
            stats[_heroId].health,
            stats[_heroId].defense,
            stats[_heroId].meleeAttack,
            stats[_heroId].magicAttack,
            stats[_heroId].hitRate
        );
    }

    function levelUp(uint256 _heroId) external onlyHeroContract {
        require(heroExist[_heroId], "Hero doesnt exist");
        pointsToSpend[_heroId] += 5;
    }

    function getHeroStats(uint256 _heroId)
        external
        view
        returns (StatsStruct memory)
    {
        return stats[_heroId];
    }

    function getHeroPointsToSpend(uint256 _heroId)
        external
        view
        returns (uint256)
    {
        return pointsToSpend[_heroId];
    }

    function _increaseBase(uint256 _heroId, uint32 _points) internal {
        require(_isApprovedOrOwner(_heroId), "Not owner");
        require(pointsToSpend[_heroId] >= _points, "Not enough points");
        require(heroExist[_heroId], "Hero doesnt exist");
        pointsToSpend[_heroId] -= _points;
    }

    function increaseIntelligence(uint256 _heroId, uint32 _points) external {
        _increaseBase(_heroId, _points);
        StatsStruct storage _stats = stats[_heroId];
        _stats.intelligence += _points;
        _stats.magicAttack = _calcMagicAttack(_stats.intelligence);
        emit Leveled(
            msg.sender,
            _heroId,
            stats[_heroId].strength,
            stats[_heroId].vitality,
            stats[_heroId].dexterity,
            stats[_heroId].intelligence,
            stats[_heroId].health,
            stats[_heroId].defense,
            stats[_heroId].meleeAttack,
            stats[_heroId].magicAttack,
            stats[_heroId].hitRate
        );
    }

    function increaseVitality(uint256 _heroId, uint32 _points) external {
        _increaseBase(_heroId, _points);
        StatsStruct storage _stats = stats[_heroId];
        _stats.vitality += _points;
        _stats.defense = _calcDefense(_stats.vitality);
        _stats.health = _calcHealth(_stats.vitality);
        emit Leveled(
            msg.sender,
            _heroId,
            stats[_heroId].strength,
            stats[_heroId].vitality,
            stats[_heroId].dexterity,
            stats[_heroId].intelligence,
            stats[_heroId].health,
            stats[_heroId].defense,
            stats[_heroId].meleeAttack,
            stats[_heroId].magicAttack,
            stats[_heroId].hitRate
        );
    }

    function increaseStrength(uint256 _heroId, uint32 _points) external {
        _increaseBase(_heroId, _points);
        StatsStruct storage _stats = stats[_heroId];
        _stats.strength += _points;
        _stats.meleeAttack = _calcMeleeAttack(_stats.strength);
        emit Leveled(
            msg.sender,
            _heroId,
            stats[_heroId].strength,
            stats[_heroId].vitality,
            stats[_heroId].dexterity,
            stats[_heroId].intelligence,
            stats[_heroId].health,
            stats[_heroId].defense,
            stats[_heroId].meleeAttack,
            stats[_heroId].magicAttack,
            stats[_heroId].hitRate
        );
    }

    function increaseDexterity(uint256 _heroId, uint32 _points) external {
        _increaseBase(_heroId, _points);
        StatsStruct storage _stats = stats[_heroId];
        _stats.dexterity += _points;
        _stats.hitRate = _calcHitRate(_stats.strength);
        emit Leveled(
            msg.sender,
            _heroId,
            stats[_heroId].strength,
            stats[_heroId].vitality,
            stats[_heroId].dexterity,
            stats[_heroId].intelligence,
            stats[_heroId].health,
            stats[_heroId].defense,
            stats[_heroId].meleeAttack,
            stats[_heroId].magicAttack,
            stats[_heroId].hitRate
        );
    }

    function _isApprovedOrOwner(uint256 _hero) internal view returns (bool) {
        return
            hero.getApproved(_hero) == msg.sender ||
            hero.ownerOf(_hero) == msg.sender;
    }

    function _getClassInitStats(uint256 _class)
        internal
        pure
        returns (StatsStruct memory _stats)
    {
        if (_class == 1) {
            // Knight
            return
                StatsStruct(
                    10, // str
                    10, // vit
                    9, // dex
                    1, // int
                    _calcHealth(10),
                    _calcDefense(10),
                    _calcMeleeAttack(10),
                    _calcMagicAttack(1),
                    _calcHitRate(9)
                );
        }
        if (_class == 2) {
            // Wizard
            return
                StatsStruct(
                    1, // str
                    9, // vit
                    10, // dex
                    10, // int
                    _calcHealth(9),
                    _calcDefense(9),
                    _calcMeleeAttack(1),
                    _calcMagicAttack(10),
                    _calcHitRate(10)
                );
        }
        if (_class == 3) {
            // Ranger
            return
                StatsStruct(
                    5, // str
                    10, // vit
                    10, // dex
                    5, // int
                    _calcHealth(10),
                    _calcDefense(10),
                    _calcMeleeAttack(5),
                    _calcMagicAttack(5),
                    _calcHitRate(10)
                );
        }
        if (_class == 4) {
            // Cleric
            return
                StatsStruct(
                    1, // str
                    10, // vit
                    9, // dex
                    10, // int
                    _calcHealth(10),
                    _calcDefense(10),
                    _calcMeleeAttack(1),
                    _calcMagicAttack(10),
                    _calcHitRate(9)
                );
        }
        if (_class == 5) {
            // Barbarian
            return
                StatsStruct(
                    10, // str
                    10, // vit
                    9, // dex
                    1, // int
                    _calcHealth(10),
                    _calcDefense(10),
                    _calcMeleeAttack(10),
                    _calcMagicAttack(1),
                    _calcHitRate(9)
                );
        }
        if (_class == 6) {
            // Rogue
            return
                StatsStruct(
                    5, // str
                    5, // vit
                    10, // dex
                    10, // int
                    _calcHealth(5),
                    _calcDefense(5),
                    _calcMeleeAttack(5),
                    _calcMagicAttack(10),
                    _calcHitRate(10)
                );
        }
        if (_class == 7) {
            // Druid
            return
                StatsStruct(
                    1, // str
                    10, // vit
                    9, // dex
                    10, // int
                    _calcHealth(10),
                    _calcDefense(10),
                    _calcMeleeAttack(1),
                    _calcMagicAttack(10),
                    _calcHitRate(9)
                );
        }
        if (_class == 8) {
            // Necromancer
            return
                StatsStruct(
                    1, // str
                    9, // vit
                    10, // dex
                    10, // int
                    _calcHealth(9),
                    _calcDefense(9),
                    _calcMeleeAttack(1),
                    _calcMagicAttack(10),
                    _calcHitRate(10)
                );
        }
    }

    //------------------------------------------------------------------------------
    //----------------------------CALC STATUS FUNCTIONS-----------------------------
    //------------------------------------------------------------------------------

    function _calcHealth(uint256 _vit) internal pure returns (uint256) {
        return (1 * _vit) + 1;
    }

    function _calcDefense(uint256 _vit) internal pure returns (uint256) {
        return Math.ceilDiv(1 * _vit, 2);
    }

    function _calcHitRate(uint256 _dex) internal pure returns (uint256) {
        return Math.ceilDiv(1 * _dex, 2);
    }

    function _calcMeleeAttack(uint256 _str) internal pure returns (uint256) {
        return (1 * _str) + 1;
    }

    function _calcMagicAttack(uint256 _int) internal pure returns (uint256) {
        return (1 * _int) + 1;
    }
}
