// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

interface IEquipCodex {
    struct Equip {
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

    struct Recipe {
        uint256 itemId;
        uint256 materialOneId;
        uint256 materialOneQtd;
        uint256 materialTwoId;
        uint256 materialTwoQtd;
        uint256 materialThreeId;
        uint256 materialThreeQtd;
        uint256 nonMaterialItemId;
        uint256 fee;
    }

    function getItemById(uint256 _id) external pure returns (Equip memory);

    function getItemRecipe(uint256 _itemId)
        external
        pure
        returns (Recipe memory _recipe);
}
