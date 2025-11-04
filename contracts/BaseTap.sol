// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {Ownable2StepUpgradeable} from "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title BaseTap (Implementation)
/// @notice Instant payment button for ETH and ERC20 (e.g., USDC).
///         To be used behind a TransparentUpgradeableProxy.
contract BaseTap is
    Initializable,
    Ownable2StepUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    address public treasury;
    address public acceptedToken;

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

    function initialize(
        address initialOwner,
        address initialTreasury,
        address token
    ) public initializer {
        if (initialOwner == address(0) || initialTreasury == address(0)) revert ZeroAddress();

        __Ownable_init(initialOwner);
        __Ownable2Step_init();
        __ReentrancyGuard_init();
        __Pausable_init();

        treasury = initialTreasury;
        acceptedToken = token;
        emit TreasuryChanged(initialTreasury);
        emit TokenChanged(token);
    }

    // -------- owner controls --------
    function setTreasury(address newTreasury) external onlyOwner {
        if (newTreasury == address(0)) revert ZeroAddress();
        treasury = newTreasury;
        emit TreasuryChanged(newTreasury);
    }

    function setAcceptedToken(address token) external onlyOwner {
        acceptedToken = token; // 0x0 disables ERC20 flow
        emit TokenChanged(token);
    }

    function pause() external onlyOwner { _pause(); }
    function unpause() external onlyOwner { _unpause(); }

    // -------- payments --------
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

    /// @dev Block raw ETH to enforce pause + nonReentrant via payETH().
    receive() external payable {
        revert("Use payETH()");
    }

    /// @dev Storage gap for future variables.
    uint256[50] private __gap;
}
