// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

contract MaterialCodex {
    struct Material {
        uint256 id;
        string name;
    }

    function getMaterialInfo(uint256 _id)
        external
        pure
        returns (Material memory _material)
    {
        if (_id == 1) {
            return dragonScale();
        }
        if (_id == 2) {
            return dragonClaw();
        }
        if (_id == 3) {
            return dragonLeather();
        }
        if (_id == 4) {
            return steel();
        }
        if (_id == 5) {
            return ironOre();
        }
        if (_id == 6) {
            return pieceOfRoyalSteel();
        }
        if (_id == 7) {
            return magicSulphur();
        }
        if (_id == 8) {
            return elvenAmulet();
        }
        if (_id == 9) {
            return elvishTalisman();
        }
        if (_id == 10) {
            return demonicEssence();
        }
        if (_id == 11) {
            return skull();
        }
        if (_id == 12) {
            return pieceOfCloth();
        }
        if (_id == 13) {
            return rangersEye();
        }
        if (_id == 14) {
            return leather();
        }
    }

    function dragonScale() public pure returns (Material memory _material) {
        _material.id = 1;
        _material.name = "Dragon Scale";
    }

    function dragonClaw() public pure returns (Material memory _material) {
        _material.id = 2;
        _material.name = "Dragon Claw";
    }

    function dragonLeather() public pure returns (Material memory _material) {
        _material.id = 3;
        _material.name = "Dragon Leather";
    }

    function steel() public pure returns (Material memory _material) {
        _material.id = 4;
        _material.name = "Steel";
    }

    function ironOre() public pure returns (Material memory _material) {
        _material.id = 5;
        _material.name = "Iron Ore";
    }

    function pieceOfRoyalSteel()
        public
        pure
        returns (Material memory _material)
    {
        _material.id = 6;
        _material.name = "Piece of Royal Steel";
    }

    function magicSulphur() public pure returns (Material memory _material) {
        _material.id = 7;
        _material.name = "Magic Sulphur";
    }

    function elvenAmulet() public pure returns (Material memory _material) {
        _material.id = 8;
        _material.name = "Elven Amulet";
    }

    function elvishTalisman() public pure returns (Material memory _material) {
        _material.id = 9;
        _material.name = "Elvish Talisman";
    }

    function demonicEssence() public pure returns (Material memory _material) {
        _material.id = 10;
        _material.name = "Demonic Essence";
    }

    function skull() public pure returns (Material memory _material) {
        _material.id = 11;
        _material.name = "Skull";
    }

    function pieceOfCloth() public pure returns (Material memory _material) {
        _material.id = 12;
        _material.name = "Piece of cloth";
    }

    function rangersEye() public pure returns (Material memory _material) {
        _material.id = 13;
        _material.name = "Ranger's Eye";
    }

    function leather() public pure returns (Material memory _material) {
        _material.id = 14;
        _material.name = "Leather";
    }
}
