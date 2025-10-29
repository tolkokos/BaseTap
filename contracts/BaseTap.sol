// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {Ownable2StepUpgradeable} from "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title BaseTap (Implementation)
 * @notice Implementation logic for instant payments in ETH and ERC20 (USDC).
 *         To be used behind a TransparentUpgradeableProxy. Full logic can be replaced by admin.
 */
contract BaseTap is Initializable, Ownable2StepUpgradeable, PausableUpgradeable, ReentrancyGuardUpgradeable {
    address public treasury;      // recipient of payments
    address public acceptedToken; // ERC20 token (e.g., USDC). 0x0 -> disabled

    event TreasuryChanged(address indexed treasury);
    event TokenChanged(address indexed token);
    event PaidETH(address indexed from, uint256 amount);
    event PaidToken(address indexed from, address indexed token, uint256 amount);

    error ZeroAddress();
    error TokenNotSet();

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner, address initialTreasury, address token) public initializer {
        if (initialOwner == address(0) || initialTreasury == address(0)) revert ZeroAddress();
        __Ownable2Step_init();
        __Pausable_init();
        __ReentrancyGuard_init();
        _transferOwnership(initialOwner);
        treasury = initialTreasury;
        acceptedToken = token; // 0x0 allowed; set later via setAcceptedToken
        emit TreasuryChanged(initialTreasury);
        emit TokenChanged(token);
    }

    // owner controls
    function setTreasury(address newTreasury) external onlyOwner {
        if (newTreasury == address(0)) revert ZeroAddress();
        treasury = newTreasury;
        emit TreasuryChanged(newTreasury);
    }
    function setAcceptedToken(address token) external onlyOwner {
        acceptedToken = token; // can be 0x0 to disable ERC20
        emit TokenChanged(token);
    }
    function pause() external onlyOwner { _pause(); }
    function unpause() external onlyOwner { _unpause(); }

    // payments
    function payETH() external payable whenNotPaused nonReentrant {
        (bool ok, ) = payable(treasury).call{value: msg.value}("");
        require(ok, "ETH forward failed");
        emit PaidETH(msg.sender, msg.value);
    }
    function payToken(uint256 amount) external whenNotPaused nonReentrant {
        address token = acceptedToken;
        if (token == address(0)) revert TokenNotSet();
        require(IERC20(token).transferFrom(msg.sender, treasury, amount), "ERC20 transferFrom failed");
        emit PaidToken(msg.sender, token, amount);
    }

    receive() external payable {
        (bool ok, ) = payable(treasury).call{value: msg.value}("");
        require(ok, "ETH forward failed");
        emit PaidETH(msg.sender, msg.value);
    }
}
