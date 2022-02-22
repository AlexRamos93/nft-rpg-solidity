// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

import "hardhat/console.sol";

interface HeroContract {
    struct HeroStruct {
        uint256 level;
        uint256 class;
        uint256 experience;
    }

    function getApproved(uint256) external view returns (address);

    function ownerOf(uint256) external view returns (address);
}

interface WeaponCodexContract {
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

    function getWeaponById(uint256 _id)
        external
        pure
        returns (Weapon memory _weapon);
}

interface HelmetCodexContract {
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
        external
        pure
        returns (Helmet memory _helmet);
}

interface AmorCodexContract {
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
        external
        pure
        returns (Armor memory _armor);
}

interface CraftContract {
    struct Item {
        address owner;
        uint256 codexId;
    }

    function getItemById(uint256 _itemId) external view returns (Item memory);

    function items(uint256) external view returns (Item memory);

    function getApproved(uint256) external view returns (address);

    function ownerOf(uint256) external view returns (address);
}

contract Equipment {
    address public craftAddr;
    CraftContract private craft;
    address public heroAddr;
    HeroContract private hero;

    address public weaponCodexAddr;
    WeaponCodexContract private weaponCodex;
    address public armorCodexAddr;
    AmorCodexContract private armorCodex;
    address public helmetCodexAddr;
    HelmetCodexContract private helmetCodex;

    // WeaponCodexContract private constant WEAPON_CODEX =
    //     WeaponCodexContract(0xce761D788DF608BD21bdd59d6f4B54b2e27F25Bb);

    struct HeroEquipment {
        WeaponCodexContract.Weapon armOne;
        WeaponCodexContract.Weapon armTwo;
        AmorCodexContract.Armor armor;
        HelmetCodexContract.Helmet helmet;
    }

    // heroId => itemId
    mapping(uint256 => uint256) private armOne;
    mapping(uint256 => uint256) private armTwo;
    mapping(uint256 => uint256) private armor;
    mapping(uint256 => uint256) private helmet;
    mapping(uint256 => uint256) private pants;
    mapping(uint256 => uint256) private boots;

    constructor(
        address _craftAddr,
        address _heroAddr,
        address _weaponCodexAddr,
        address _armorCodexAddr,
        address _helmetCodexAddr
    ) {
        craftAddr = _craftAddr;
        craft = CraftContract(craftAddr);
        heroAddr = _heroAddr;
        hero = HeroContract(heroAddr);

        weaponCodexAddr = _weaponCodexAddr;
        weaponCodex = WeaponCodexContract(_weaponCodexAddr);
        armorCodexAddr = _armorCodexAddr;
        armorCodex = AmorCodexContract(_armorCodexAddr);
        helmetCodexAddr = _helmetCodexAddr;
        helmetCodex = HelmetCodexContract(_helmetCodexAddr);
    }

    function _isApprovedOrOwnerHero(uint256 _hero)
        internal
        view
        returns (bool)
    {
        return
            hero.getApproved(_hero) == msg.sender ||
            hero.ownerOf(_hero) == msg.sender;
    }

    function _isApprovedOrOwnerItem(uint256 _itemId)
        internal
        view
        returns (bool)
    {
        return
            craft.getApproved(_itemId) == msg.sender ||
            craft.ownerOf(_itemId) == msg.sender;
    }

    function getHeroEquipments(uint256 _heroId)
        external
        view
        returns (HeroEquipment memory)
    {
        require(_isApprovedOrOwnerHero(_heroId), "Not the hero owner");
        uint256 _armOneId = armOne[_heroId];
        uint256 _armTwoId = armTwo[_heroId];
        uint256 _armorId = armor[_heroId];
        uint256 _helmetId = helmet[_heroId];
        WeaponCodexContract.Weapon memory _weaponOne = weaponCodex
            .getWeaponById(craft.getItemById(_armOneId).codexId);
        WeaponCodexContract.Weapon memory _weaponTwo = weaponCodex
            .getWeaponById(craft.getItemById(_armTwoId).codexId);
        AmorCodexContract.Armor memory _armor = armorCodex.getArmorById(
            craft.getItemById(_armorId).codexId
        );
        HelmetCodexContract.Helmet memory _helmet = helmetCodex.getHelmetById(
            craft.getItemById(_helmetId).codexId
        );
        return HeroEquipment(_weaponOne, _weaponTwo, _armor, _helmet);
    }

    function getHeroArmOne(uint256 _heroId)
        external
        view
        returns (WeaponCodexContract.Weapon memory)
    {
        require(_isApprovedOrOwnerHero(_heroId), "Not the hero owner");
        uint256 _armOneId = armOne[_heroId];
        return weaponCodex.getWeaponById(craft.getItemById(_armOneId).codexId);
    }

    function getHeroArmTwo(uint256 _heroId)
        external
        view
        returns (WeaponCodexContract.Weapon memory)
    {
        require(_isApprovedOrOwnerHero(_heroId), "Not the hero owner");
        uint256 _armTwoId = armTwo[_heroId];
        return weaponCodex.getWeaponById(craft.getItemById(_armTwoId).codexId);
    }

    function getHeroArmor(uint256 _heroId)
        external
        view
        returns (AmorCodexContract.Armor memory)
    {
        require(_isApprovedOrOwnerHero(_heroId), "Not the hero owner");
        uint256 _armorId = armor[_heroId];
        return armorCodex.getArmorById(craft.getItemById(_armorId).codexId);
    }

    function getHeroHelmet(uint256 _heroId)
        external
        view
        returns (HelmetCodexContract.Helmet memory)
    {
        require(_isApprovedOrOwnerHero(_heroId), "Not the hero owner");
        uint256 _helmetId = helmet[_heroId];
        return helmetCodex.getHelmetById(craft.getItemById(_helmetId).codexId);
    }

    //------------------------------------------------------------------------------
    //----------------------------EQUIP AND UNEQUIP FUNCTIONS-----------------------
    //------------------------------------------------------------------------------

    function _checkEquipmentType(uint8 _type) internal pure {
        require(_type >= 1 || _type <= 6, "Invalid equipment type");
    }

    function _equipOrUnequipBase(
        uint256 _itemId,
        uint256 _heroId,
        uint8 _type
    ) internal view {
        require(_isApprovedOrOwnerItem(_itemId), "Not the item owner");
        require(_isApprovedOrOwnerHero(_heroId), "Not the hero owner");
        _checkEquipmentType(_type);
    }

    function unequip(
        uint256 _itemId,
        uint256 _heroId,
        uint8 _type
    ) external {
        _equipOrUnequipBase(_itemId, _heroId, _type);
        if (_type == 1) {
            require(armor[_heroId] == _itemId, "This item is not equiped");
            delete armor[_heroId];
        }
        if (_type == 2) {
            require(armOne[_heroId] == _itemId, "This item is not equiped");
            delete armOne[_heroId];
        }
        if (_type == 3) {
            require(armTwo[_heroId] == _itemId, "This item is not equiped");
            delete armTwo[_heroId];
        }
        if (_type == 4) {
            require(helmet[_heroId] == _itemId, "This item is not equiped");
            delete helmet[_heroId];
        }
        if (_type == 5) {
            require(pants[_heroId] == _itemId, "This item is not equiped");
            delete pants[_heroId];
        }
        if (_type == 6) {
            require(boots[_heroId] == _itemId, "This item is not equiped");
            delete boots[_heroId];
        }
    }

    function equip(
        uint256 _heroId,
        uint256 _itemId,
        uint8 _type
    ) external {
        _equipOrUnequipBase(_itemId, _heroId, _type);
        if (_type == 1) {
            require(armor[_heroId] == 0, "You need to unequip first!");
            armor[_heroId] = _itemId;
        }
        if (_type == 2) {
            require(armOne[_heroId] == 0, "You need to unequip first!");
            WeaponCodexContract.Weapon memory weapon = weaponCodex
                .getWeaponById(craft.getItemById(_itemId).codexId);

            if (weapon.twoHanded) {
                require(armTwo[_heroId] == 0, "Can't equip two handed weapon");
            } else {
                uint256 armTwoId = armTwo[_heroId];
                weapon = weaponCodex.getWeaponById(
                    craft.getItemById(armTwoId).codexId
                );
                require(
                    weapon.twoHanded == false,
                    "Can't equip two handed weapon"
                );
            }
            armOne[_heroId] = _itemId;
        }
        if (_type == 3) {
            require(armTwo[_heroId] == 0, "You need to unequip first!");
            WeaponCodexContract.Weapon memory weapon = weaponCodex
                .getWeaponById(craft.getItemById(_itemId).codexId);

            if (weapon.twoHanded) {
                require(armOne[_heroId] == 0, "Can't equip two handed weapon");
            } else {
                uint256 armOneId = armOne[_heroId];
                weapon = weaponCodex.getWeaponById(
                    craft.getItemById(armOneId).codexId
                );
                require(
                    weapon.twoHanded == false,
                    "Can't equip two handed weapon"
                );
            }
            armTwo[_heroId] = _itemId;
        }
        if (_type == 4) {
            require(helmet[_heroId] == 0, "You need to unequip first!");
            helmet[_heroId] = _itemId;
        }
        if (_type == 5) {
            require(pants[_heroId] == 0, "You need to unequip first!");
            pants[_heroId] = _itemId;
        }
        if (_type == 6) {
            require(boots[_heroId] == 0, "You need to unequip first!");
            boots[_heroId] = _itemId;
        }
    }
}
