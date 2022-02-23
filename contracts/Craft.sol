// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "hardhat/console.sol";

interface ICOIN {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

interface IMaterial {
    function getBalanceOf(address _player, uint256 _id)
        external
        view
        returns (uint256);

    function spend(
        address _player,
        uint256[] memory _ids,
        uint256[] memory _amounts
    ) external;

    function isApprovedForAll(address account, address operator)
        external
        view
        returns (bool);
}

interface IArmorCodex {
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

    function getItemRecipe(uint256 _itemId)
        external
        pure
        returns (Recipe memory _recipe);
}

contract Craft is ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _itemsCount;

    IArmorCodex private armorCodex;
    IMaterial private material;
    ICOIN private coin;

    constructor(
        address _armorCodexAddr,
        address _materialAddr,
        address _coinAddr
    ) ERC721("ETHORIA Items", "ETRI") {
        armorCodex = IArmorCodex(_armorCodexAddr);
        material = IMaterial(_materialAddr);
        coin = ICOIN(_coinAddr);
    }

    struct Item {
        address owner;
        uint256 codexId;
    }

    mapping(uint256 => Item) public items;

    event Crafted(address owner, uint256 itemId, uint256 codexId);

    function _craftMint(address _player, uint256 _id) internal {
        _itemsCount.increment();
        uint256 _newItemId = _itemsCount.current();
        _safeMint(_player, _newItemId);
        items[_newItemId] = Item(_player, _id);
        emit Crafted(_player, _newItemId, _id);
    }

    function getItemById(uint256 _itemId) external view returns (Item memory) {
        return items[_itemId];
    }

    function craft(
        address _player,
        uint256 _itemId,
        uint256[] memory _materialIds
    ) external {
        IArmorCodex.Recipe memory recipe = armorCodex.getItemRecipe(_itemId);
        uint256[] memory _amounts = new uint256[](_materialIds.length);
        for (uint256 i = 0; i < _materialIds.length; i++) {
            uint256 balance = material.getBalanceOf(_player, _materialIds[i]);
            if (_materialIds[i] == recipe.materialOneId) {
                require(
                    balance >= recipe.materialOneQtd,
                    "Not enough material"
                );
                _amounts[i] = recipe.materialOneQtd;
            }
            if (_materialIds[i] == recipe.materialTwoId) {
                require(
                    balance >= recipe.materialTwoQtd,
                    "Not enough material"
                );
                _amounts[i] = recipe.materialTwoQtd;
            }
            if (_materialIds[i] == recipe.materialThreeId) {
                require(
                    balance >= recipe.materialThreeQtd,
                    "Not enough material"
                );
                _amounts[i] = recipe.materialThreeQtd;
            }
        }
        bool isTransfered = coin.transferFrom(
            _player,
            address(this),
            recipe.fee
        );
        require(isTransfered, "Not enough coins to pay fee");
        require(
            material.isApprovedForAll(_player, address(this)),
            "Craft doesnt have approval"
        );
        material.spend(_player, _materialIds, _amounts);
        _craftMint(_player, _itemId);
    }
}
