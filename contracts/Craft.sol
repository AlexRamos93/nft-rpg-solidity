// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

contract Craft is ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _itemsCount;

    constructor() ERC721("ETHORIA Items", "ETRI") {}

    struct Item {
        address owner;
        uint256 codexId;
    }

    mapping(uint256 => Item) private items;

    event Crafted(address owner, uint256 itemId, uint256 codexId);

    function dungeonCraft(address _player, uint256 _id) external {
        _itemsCount.increment();
        uint256 _newItemId = _itemsCount.current();
        _safeMint(_player, _newItemId);
        items[_newItemId] = Item(_player, _id);
        emit Crafted(_player, _newItemId, _id);
    }

    function getItemById(uint256 _itemId) external view returns (Item memory) {
        return items[_itemId];
    }
}
