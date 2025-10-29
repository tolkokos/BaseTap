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
///         Funds are immediately forwarded to the `treasury`.
contract BaseTap is
    Initializable,
    Ownable2StepUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    /// @dev Recipient of all payments.
    address public treasury;

    /// @dev Accepted ERC20 token for `payToken`. Zero address => token disabled (ETH-only).
    address public acceptedToken;

    // -------------------- Events --------------------
    event TreasuryChanged(address indexed treasury);
    event TokenChanged(address indexed token);
    event PaidETH(address indexed from, uint256 amount);
    event PaidToken(address indexed from, address indexed token, uint256 amount);

    // -------------------- Errors --------------------
    error ZeroAddress();
    error TokenNotSet();

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @notice Proxy initializer.
    /// @param initialOwner Owner to set (ProxyAdmin/EOA you control).
    /// @param initialTreasury Address that will receive funds.
    /// @param token ERC20 token to accept for `payToken` (zero to disable).
    function initialize(
        address initialOwner,
        address initialTreasury,
        address token
    ) public initializer {
        if (initialOwner == address(0) || initialTreasury == address(0)) revert ZeroAddress();

        // ✅ Correct initializer order for OZ Upgrades (Transparent)
        __Ownable_init(initialOwner);   // set owner first
        __Ownable2Step_init();          // then enable 2-step ownership
        __ReentrancyGuard_init();       // guards next
        __Pausable_init();              // pausable last

        treasury = initialTreasury;
        acceptedToken = token; // can be 0x0 (disabled)
        emit TreasuryChanged(initialTreasury);
        emit TokenChanged(token);
    }

    // -------------------- Owner controls --------------------

    /// @notice Update treasury recipient.
    function setTreasury(address newTreasury) external onlyOwner {
        if (newTreasury == address(0)) revert ZeroAddress();
        treasury = newTreasury;
        emit TreasuryChanged(newTreasury);
    }

    /// @notice Set accepted ERC20 token (0x0 to disable).
    function setAcceptedToken(address token) external onlyOwner {
        acceptedToken = token;
        emit TokenChanged(token);
    }

    /// @notice Pause/unpause payment entrypoints.
    function pause() external onlyOwner { _pause(); }
    function unpause() external onlyOwner { _unpause(); }

    // -------------------- Payments --------------------

    /// @notice Pay with ETH (forwards to treasury).
    function payETH() external payable whenNotPaused nonReentrant {
        (bool ok, ) = payable(treasury).call{value: msg.value}("");
        require(ok, "ETH forward failed");
        emit PaidETH(msg.sender, msg.value);
    }

    /// @notice Pay with ERC20 (requires prior approve(proxy, amount) from payer).
    function payToken(uint256 amount) external whenNotPaused nonReentrant {
        address token = acceptedToken;
        if (token == address(0)) revert TokenNotSet();
        require(IERC20(token).transferFrom(msg.sender, treasury, amount), "ERC20 transferFrom failed");
        emit PaidToken(msg.sender, token, amount);
    }

    /// @dev Fallback receive: sending ETH directly to proxy will forward to treasury.
    receive() external payable {
        (bool ok, ) = payable(treasury).call{value: msg.value}("");
        require(ok, "ETH forward failed");
        emit PaidETH(msg.sender, msg.value);
    }

    /// @dev Storage gap for future variables (recommended for upgradeable contracts).
    uint256[50] private __gap;
}
