// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

contract HelmetCodex {
    struct Helmet {
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

    function getHelmetById(uint256 _id)
        public
        pure
        returns (Helmet memory _helmet)
    {
        if (_id == 1) {
            return dragonHelmet();
        }
        if (_id == 2) {
            return crownHelmet();
        }
        if (_id == 3) {
            return royalGuardHelmet();
        }
        if (_id == 4) {
            return hornedHelmet();
        }
        if (_id == 5) {
            return boneMask();
        }
        if (_id == 6) {
            return hatOfTheMage();
        }
        if (_id == 7) {
            return crusaderHelmet();
        }
        if (_id == 8) {
            return warriorHelmet();
        }
        if (_id == 9) {
            return steelHelmet();
        }
        if (_id == 10) {
            return ironHelmet();
        }
        if (_id == 11) {
            return leatherCap();
        }
    }

    function dragonHelmet() public pure returns (Helmet memory _helmet) {
        _helmet.id = 1;
        _helmet.name = "Dragon Helmet";
        _helmet.description = "";
        _helmet.defense = 11;
        _helmet.strModifier = 0;
        _helmet.vitModifier = 3;
        _helmet.dexModifier = 3;
        _helmet.intModifier = 0;
        _helmet.healthModifier = 0;
        _helmet.defenseModifier = 2;
        _helmet.atkModifier = 0;
        _helmet.mAtkModifier = 0;
        _helmet.hitModifier = 2;
    }

    function crownHelmet() public pure returns (Helmet memory _helmet) {
        _helmet.id = 2;
        _helmet.name = "Crown Helmet";
        _helmet.description = "";
        _helmet.defense = 10;
        _helmet.strModifier = 2;
        _helmet.vitModifier = 0;
        _helmet.dexModifier = 0;
        _helmet.intModifier = 0;
        _helmet.healthModifier = 2;
        _helmet.defenseModifier = 0;
        _helmet.atkModifier = 2;
        _helmet.mAtkModifier = 0;
        _helmet.hitModifier = 0;
    }

    function royalGuardHelmet() public pure returns (Helmet memory _helmet) {
        _helmet.id = 3;
        _helmet.name = "Royal guard Helmet";
        _helmet.description = "";
        _helmet.defense = 9;
        _helmet.strModifier = 2;
        _helmet.vitModifier = 0;
        _helmet.dexModifier = 0;
        _helmet.intModifier = 0;
        _helmet.healthModifier = 0;
        _helmet.defenseModifier = 1;
        _helmet.atkModifier = 1;
        _helmet.mAtkModifier = 0;
        _helmet.hitModifier = 0;
    }

    function hornedHelmet() public pure returns (Helmet memory _helmet) {
        _helmet.id = 4;
        _helmet.name = "Horned Helmet";
        _helmet.description = "";
        _helmet.defense = 9;
        _helmet.strModifier = 2;
        _helmet.vitModifier = 0;
        _helmet.dexModifier = 0;
        _helmet.intModifier = 0;
        _helmet.healthModifier = 0;
        _helmet.defenseModifier = 0;
        _helmet.atkModifier = 2;
        _helmet.mAtkModifier = 0;
        _helmet.hitModifier = 0;
    }

    function boneMask() public pure returns (Helmet memory _helmet) {
        _helmet.id = 5;
        _helmet.name = "Bone mask";
        _helmet.description = "";
        _helmet.defense = 9;
        _helmet.strModifier = 0;
        _helmet.vitModifier = 1;
        _helmet.dexModifier = 0;
        _helmet.intModifier = 1;
        _helmet.healthModifier = 0;
        _helmet.defenseModifier = 0;
        _helmet.atkModifier = 0;
        _helmet.mAtkModifier = 2;
        _helmet.hitModifier = 0;
    }

    function hatOfTheMage() public pure returns (Helmet memory _helmet) {
        _helmet.id = 6;
        _helmet.name = "Hat of the mage";
        _helmet.description = "";
        _helmet.defense = 8;
        _helmet.strModifier = 0;
        _helmet.vitModifier = 0;
        _helmet.dexModifier = 0;
        _helmet.intModifier = 1;
        _helmet.healthModifier = 0;
        _helmet.defenseModifier = 0;
        _helmet.atkModifier = 0;
        _helmet.mAtkModifier = 2;
        _helmet.hitModifier = 0;
    }

    function crusaderHelmet() public pure returns (Helmet memory _helmet) {
        _helmet.id = 7;
        _helmet.name = "Crusader Helmet";
        _helmet.description = "";
        _helmet.defense = 8;
        _helmet.strModifier = 0;
        _helmet.vitModifier = 2;
        _helmet.dexModifier = 0;
        _helmet.intModifier = 0;
        _helmet.healthModifier = 0;
        _helmet.defenseModifier = 1;
        _helmet.atkModifier = 0;
        _helmet.mAtkModifier = 0;
        _helmet.hitModifier = 0;
    }

    function warriorHelmet() public pure returns (Helmet memory _helmet) {
        _helmet.id = 8;
        _helmet.name = "Warrior Helmet";
        _helmet.description = "";
        _helmet.defense = 7;
        _helmet.strModifier = 1;
        _helmet.vitModifier = 0;
        _helmet.dexModifier = 0;
        _helmet.intModifier = 0;
        _helmet.healthModifier = 0;
        _helmet.defenseModifier = 0;
        _helmet.atkModifier = 0;
        _helmet.mAtkModifier = 0;
        _helmet.hitModifier = 0;
    }

    function steelHelmet() public pure returns (Helmet memory _helmet) {
        _helmet.id = 9;
        _helmet.name = "Steel Helmet";
        _helmet.description = "";
        _helmet.defense = 6;
        _helmet.strModifier = 0;
        _helmet.vitModifier = 0;
        _helmet.dexModifier = 0;
        _helmet.intModifier = 0;
        _helmet.healthModifier = 0;
        _helmet.defenseModifier = 0;
        _helmet.atkModifier = 0;
        _helmet.mAtkModifier = 0;
        _helmet.hitModifier = 0;
    }

    function ironHelmet() public pure returns (Helmet memory _helmet) {
        _helmet.id = 10;
        _helmet.name = "Iron Helmet";
        _helmet.description = "";
        _helmet.defense = 5;
        _helmet.strModifier = 0;
        _helmet.vitModifier = 0;
        _helmet.dexModifier = 0;
        _helmet.intModifier = 0;
        _helmet.healthModifier = 0;
        _helmet.defenseModifier = 0;
        _helmet.atkModifier = 0;
        _helmet.mAtkModifier = 0;
        _helmet.hitModifier = 0;
    }

    function leatherCap() public pure returns (Helmet memory _helmet) {
        _helmet.id = 11;
        _helmet.name = "Leather cap";
        _helmet.description = "";
        _helmet.defense = 3;
        _helmet.strModifier = 0;
        _helmet.vitModifier = 0;
        _helmet.dexModifier = 0;
        _helmet.intModifier = 0;
        _helmet.healthModifier = 0;
        _helmet.defenseModifier = 0;
        _helmet.atkModifier = 0;
        _helmet.mAtkModifier = 0;
        _helmet.hitModifier = 0;
    }
}
