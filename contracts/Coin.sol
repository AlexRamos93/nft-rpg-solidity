// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Coin is ERC20, Ownable {
    constructor() ERC20("Ethorians", "ETHOR") {
        _mint(msg.sender, 1000000000000);
        // _transfer(address(this), msg.sender, 15000);
    }
}
