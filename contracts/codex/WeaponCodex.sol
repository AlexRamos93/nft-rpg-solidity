// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

contract WeaponCodex {
    struct Weapon {
        uint256 id;
        string name;
        string description;
        bool twoHanded;
        uint256 attack;
        uint256 defense;
        uint256 strModifier;
        uint256 vitModifier;
        uint256 dexModifier;
        uint256 intModifier;
        uint256 healthModifier;
        uint256 defenseModifier;
        uint256 atkModifier;
        uint256 mAtkModifier;
        uint256 hitModifier;
        uint8 weaponType;
    }

    function getWeaponType(uint8 _type)
        external
        pure
        returns (string memory weaponType)
    {
        if (_type == 1) {
            return "Melee";
        }
        if (_type == 2) {
            return "Ranged";
        }
        if (_type == 3) {
            return "Magic";
        }
    }

    function getWeaponById(uint256 _id)
        public
        pure
        returns (Weapon memory _weapon)
    {
        if (_id == 1) {
            return sword();
        }
        if (_id == 2) {
            return fireSword();
        }
    }

    function sword() public pure returns (Weapon memory _weapon) {
        _weapon.id = 1;
        _weapon.name = "Sword";
        _weapon.description = "";
        _weapon.twoHanded = false;
        _weapon.attack = 10;
        _weapon.defense = 0;
        _weapon.strModifier = 0;
        _weapon.vitModifier = 0;
        _weapon.dexModifier = 0;
        _weapon.intModifier = 0;
        _weapon.healthModifier = 0;
        _weapon.defenseModifier = 0;
        _weapon.atkModifier = 0;
        _weapon.mAtkModifier = 0;
        _weapon.hitModifier = 0;
        _weapon.weaponType = 1;
    }

    function fireSword() public pure returns (Weapon memory _weapon) {
        _weapon.id = 2;
        _weapon.name = "Fire sword";
        _weapon.description = "";
        _weapon.twoHanded = false;
        _weapon.attack = 26;
        _weapon.defense = 0;
        _weapon.strModifier = 0;
        _weapon.vitModifier = 0;
        _weapon.dexModifier = 0;
        _weapon.intModifier = 2;
        _weapon.healthModifier = 0;
        _weapon.defenseModifier = 0;
        _weapon.atkModifier = 0;
        _weapon.mAtkModifier = 2;
        _weapon.hitModifier = 0;
    }
}
