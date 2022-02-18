// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

contract AmorCodex {
    struct Armor {
        uint256 id;
        string name;
        string description;
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
    }

    function getArmorById(uint256 _id)
        public
        pure
        returns (Armor memory _armor)
    {
        if (_id == 1) {
            return dragonScaleMail();
        }
        if (_id == 2) {
            return fullPlateMail();
        }
        if (_id == 3) {
            return royalGuardArmor();
        }
        if (_id == 4) {
            return crusaderArmor();
        }
        if (_id == 5) {
            return elvenArmor();
        }
        if (_id == 6) {
            return skullAmor();
        }
        if (_id == 7) {
            return warriorAmor();
        }
        if (_id == 8) {
            return steelArmor();
        }
        if (_id == 9) {
            return mageCape();
        }
        if (_id == 10) {
            return rangersCloak();
        }
        if (_id == 11) {
            return chainAmor();
        }
        if (_id == 12) {
            return leatherAmor();
        }
    }

    function dragonScaleMail() public pure returns (Armor memory _armor) {
        _armor.id = 1;
        _armor.name = "Dragon scale mail";
        _armor.description = "";
        _armor.defense = 16;
        _armor.strModifier = 5;
        _armor.vitModifier = 5;
        _armor.dexModifier = 5;
        _armor.intModifier = 5;
        _armor.healthModifier = 3;
        _armor.defenseModifier = 3;
        _armor.atkModifier = 0;
        _armor.mAtkModifier = 0;
        _armor.hitModifier = 0;
    }

    function fullPlateMail() public pure returns (Armor memory _armor) {
        _armor.id = 2;
        _armor.name = "Full plate mail";
        _armor.description = "";
        _armor.defense = 15;
        _armor.strModifier = 3;
        _armor.vitModifier = 1;
        _armor.dexModifier = 0;
        _armor.intModifier = 0;
        _armor.healthModifier = 3;
        _armor.defenseModifier = 3;
        _armor.atkModifier = 0;
        _armor.mAtkModifier = 0;
        _armor.hitModifier = 0;
    }

    function royalGuardArmor() public pure returns (Armor memory _armor) {
        _armor.id = 3;
        _armor.name = "Royal guard armor";
        _armor.description = "";
        _armor.defense = 14;
        _armor.strModifier = 2;
        _armor.vitModifier = 2;
        _armor.dexModifier = 1;
        _armor.intModifier = 0;
        _armor.healthModifier = 2;
        _armor.defenseModifier = 0;
        _armor.atkModifier = 2;
        _armor.mAtkModifier = 0;
        _armor.hitModifier = 1;
    }

    function crusaderArmor() public pure returns (Armor memory _armor) {
        _armor.id = 4;
        _armor.name = "Crusader armor";
        _armor.description = "";
        _armor.defense = 13;
        _armor.strModifier = 0;
        _armor.vitModifier = 2;
        _armor.dexModifier = 0;
        _armor.intModifier = 0;
        _armor.healthModifier = 0;
        _armor.defenseModifier = 2;
        _armor.atkModifier = 0;
        _armor.mAtkModifier = 0;
        _armor.hitModifier = 0;
    }

    function elvenArmor() public pure returns (Armor memory _armor) {
        _armor.id = 5;
        _armor.name = "Elven armor";
        _armor.description = "";
        _armor.defense = 13;
        _armor.strModifier = 0;
        _armor.vitModifier = 0;
        _armor.dexModifier = 4;
        _armor.intModifier = 0;
        _armor.healthModifier = 0;
        _armor.defenseModifier = 0;
        _armor.atkModifier = 0;
        _armor.mAtkModifier = 0;
        _armor.hitModifier = 5;
    }

    function skullAmor() public pure returns (Armor memory _armor) {
        _armor.id = 6;
        _armor.name = "Skull armor";
        _armor.description = "";
        _armor.defense = 12;
        _armor.strModifier = 0;
        _armor.vitModifier = 0;
        _armor.dexModifier = 0;
        _armor.intModifier = 3;
        _armor.healthModifier = 1;
        _armor.defenseModifier = 0;
        _armor.atkModifier = 0;
        _armor.mAtkModifier = 3;
        _armor.hitModifier = 0;
    }

    function warriorAmor() public pure returns (Armor memory _armor) {
        _armor.id = 7;
        _armor.name = "Warrior amor";
        _armor.description = "";
        _armor.defense = 12;
        _armor.strModifier = 1;
        _armor.vitModifier = 0;
        _armor.dexModifier = 0;
        _armor.intModifier = 0;
        _armor.healthModifier = 0;
        _armor.defenseModifier = 0;
        _armor.atkModifier = 1;
        _armor.mAtkModifier = 0;
        _armor.hitModifier = 0;
    }

    function steelArmor() public pure returns (Armor memory _armor) {
        _armor.id = 8;
        _armor.name = "Steel amor";
        _armor.description = "";
        _armor.defense = 10;
        _armor.strModifier = 0;
        _armor.vitModifier = 0;
        _armor.dexModifier = 0;
        _armor.intModifier = 0;
        _armor.healthModifier = 0;
        _armor.defenseModifier = 0;
        _armor.atkModifier = 0;
        _armor.mAtkModifier = 0;
        _armor.hitModifier = 0;
    }

    function mageCape() public pure returns (Armor memory _armor) {
        _armor.id = 9;
        _armor.name = "Mage cape";
        _armor.description = "";
        _armor.defense = 9;
        _armor.strModifier = 0;
        _armor.vitModifier = 0;
        _armor.dexModifier = 0;
        _armor.intModifier = 2;
        _armor.healthModifier = 0;
        _armor.defenseModifier = 0;
        _armor.atkModifier = 0;
        _armor.mAtkModifier = 2;
        _armor.hitModifier = 0;
    }

    function rangersCloak() public pure returns (Armor memory _armor) {
        _armor.id = 10;
        _armor.name = "Ranger's cloak";
        _armor.description = "";
        _armor.defense = 9;
        _armor.strModifier = 0;
        _armor.vitModifier = 0;
        _armor.dexModifier = 2;
        _armor.intModifier = 0;
        _armor.healthModifier = 0;
        _armor.defenseModifier = 0;
        _armor.atkModifier = 0;
        _armor.mAtkModifier = 0;
        _armor.hitModifier = 2;
    }

    function chainAmor() public pure returns (Armor memory _armor) {
        _armor.id = 11;
        _armor.name = "Chain amor";
        _armor.description = "";
        _armor.defense = 6;
        _armor.strModifier = 0;
        _armor.vitModifier = 0;
        _armor.dexModifier = 0;
        _armor.intModifier = 0;
        _armor.healthModifier = 0;
        _armor.defenseModifier = 0;
        _armor.atkModifier = 0;
        _armor.mAtkModifier = 0;
        _armor.hitModifier = 0;
    }

    function leatherAmor() public pure returns (Armor memory _armor) {
        _armor.id = 12;
        _armor.name = "Leather amor";
        _armor.description = "";
        _armor.defense = 4;
        _armor.strModifier = 0;
        _armor.vitModifier = 0;
        _armor.dexModifier = 0;
        _armor.intModifier = 0;
        _armor.healthModifier = 0;
        _armor.defenseModifier = 0;
        _armor.atkModifier = 0;
        _armor.mAtkModifier = 0;
        _armor.hitModifier = 0;
    }
}