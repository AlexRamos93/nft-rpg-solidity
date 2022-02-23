// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Material is ERC1155Burnable, Ownable {
    constructor() ERC1155("") {}

    event Spended(address indexed owner, uint256[] ids, uint256[] amounts);
    event Transfered(
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] amounts
    );

    function mint(
        address _player,
        uint256 _id,
        uint256 _amount
    ) external onlyOwner {
        _mint(_player, _id, _amount, "");
    }

    function spend(
        address _player,
        uint256[] memory _ids,
        uint256[] memory _amounts
    ) external {
        burnBatch(_player, _ids, _amounts);
        emit Spended(_player, _ids, _amounts);
    }

    function getBalanceOf(uint256 _id) external view returns (uint256) {
        return balanceOf(msg.sender, _id);
    }

    function transfer(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts
    ) external {
        safeBatchTransferFrom(msg.sender, _to, _ids, _amounts, "");
        emit Transfered(msg.sender, _to, _ids, _amounts);
    }
}
