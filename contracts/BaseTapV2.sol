// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {Ownable2StepUpgradeable} from "@openzeppelin/contracts-upgradeable/access/Ownable2StepUpgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title BaseTapV2 - Enhanced Payment Protocol for Base Ecosystem
/// @notice Instant payment button with history tracking, merchant registry, and analytics
/// @dev TransparentUpgradeableProxy pattern with storage layout preservation
contract BaseTapV2 is
    Initializable,
    Ownable2StepUpgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable
{
    // ============ Storage (V1) ============
    address public treasury;
    address public acceptedToken;

    // ============ Storage (V2 - NEW) ============
    
    /// @dev Payment record structure for history tracking
    struct PaymentRecord {
        address payer;
        address recipient;
        uint256 amount;
        address token;
        bytes32 referenceId;
        uint256 timestamp;
        bool isETH;
    }

    /// @dev Merchant information structure
    struct Merchant {
        address wallet;
        string name;
        bool isActive;
        uint256 totalReceived;
        uint256 paymentCount;
    }

    /// @dev Payment statistics per token
    struct TokenStats {
        uint256 totalVolume;
        uint256 totalPayments;
    }

    // Mappings for payment history and merchants
    mapping(address => PaymentRecord[]) public userPaymentHistory;
    mapping(bytes32 => PaymentRecord) public paymentById;
    mapping(address => Merchant) public merchants;
    mapping(address => TokenStats) public tokenStatistics;
    
    // Global counters
    uint256 public totalPaymentsCount;
    uint256 public totalETHVolume;

    // ============ Events ============
    event TreasuryChanged(address indexed treasury);
    event TokenChanged(address indexed token);
    event PaidETH(
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes32 indexed referenceId,
        uint256 timestamp
    );
    event PaidToken(
        address indexed from,
        address indexed to,
        address indexed token,
        uint256 amount,
        bytes32 referenceId,
        uint256 timestamp
    );
    event MerchantRegistered(address indexed merchant, string name);
    event MerchantStatusChanged(address indexed merchant, bool isActive);

    // ============ Custom errors ============
    error ZeroAddress();
    error TokenNotSet();
    error ForwardFailed();
    error TransferFromFailed();
    error ReceiveDisabled();
    error MerchantNotActive();
    error InvalidReferenceId();

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

    // ============ Owner Controls ============
    
    function setTreasury(address newTreasury) external onlyOwner {
        if (newTreasury == address(0)) revert ZeroAddress();
        treasury = newTreasury;
        emit TreasuryChanged(newTreasury);
    }

    function setAcceptedToken(address token) external onlyOwner {
        acceptedToken = token;
        emit TokenChanged(token);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    // ============ Merchant Registry ============
    
    function registerMerchant(address merchant, string calldata name) external onlyOwner {
        if (merchant == address(0)) revert ZeroAddress();
        merchants[merchant] = Merchant({
            wallet: merchant,
            name: name,
            isActive: true,
            totalReceived: 0,
            paymentCount: 0
        });
        emit MerchantRegistered(merchant, name);
    }

    function setMerchantStatus(address merchant, bool isActive) external onlyOwner {
        merchants[merchant].isActive = isActive;
        emit MerchantStatusChanged(merchant, isActive);
    }

    // ============ Payment Functions ============
    
    /// @notice Pay ETH with reference tracking
    /// @param referenceId Unique payment identifier for tracking
    function payETH(bytes32 referenceId) external payable whenNotPaused nonReentrant {
        if (referenceId == bytes32(0)) revert InvalidReferenceId();
        
        address recipient = treasury;
        
        (bool ok, ) = payable(recipient).call{value: msg.value}("");
        if (!ok) revert ForwardFailed();

        _recordPayment(msg.sender, recipient, msg.value, address(0), referenceId, true);
        
        emit PaidETH(msg.sender, recipient, msg.value, referenceId, block.timestamp);
    }

    /// @notice Pay ERC-20 token with reference tracking
    /// @param amount Token amount to pay
    /// @param referenceId Unique payment identifier for tracking
    function payToken(uint256 amount, bytes32 referenceId) external whenNotPaused nonReentrant {
        if (referenceId == bytes32(0)) revert InvalidReferenceId();
        address token = acceptedToken;
        if (token == address(0)) revert TokenNotSet();
        
        address recipient = treasury;
        
        bool ok = IERC20(token).transferFrom(msg.sender, recipient, amount);
        if (!ok) revert TransferFromFailed();

        _recordPayment(msg.sender, recipient, amount, token, referenceId, false);
        
        emit PaidToken(msg.sender, recipient, token, amount, referenceId, block.timestamp);
    }

    /// @notice Pay to specific merchant (ETH)
    /// @param merchant Registered merchant address
    /// @param referenceId Unique payment identifier
    function payMerchantETH(address merchant, bytes32 referenceId) 
        external 
        payable 
        whenNotPaused 
        nonReentrant 
    {
        if (referenceId == bytes32(0)) revert InvalidReferenceId();
        if (!merchants[merchant].isActive) revert MerchantNotActive();
        
        (bool ok, ) = payable(merchant).call{value: msg.value}("");
        if (!ok) revert ForwardFailed();

        merchants[merchant].totalReceived += msg.value;
        merchants[merchant].paymentCount++;

        _recordPayment(msg.sender, merchant, msg.value, address(0), referenceId, true);
        
        emit PaidETH(msg.sender, merchant, msg.value, referenceId, block.timestamp);
    }

    // ============ Internal Functions ============
    
    /// @dev Record payment in history and update statistics
    function _recordPayment(
        address payer,
        address recipient,
        uint256 amount,
        address token,
        bytes32 referenceId,
        bool isETH
    ) internal {
        PaymentRecord memory record = PaymentRecord({
            payer: payer,
            recipient: recipient,
            amount: amount,
            token: token,
            referenceId: referenceId,
            timestamp: block.timestamp,
            isETH: isETH
        });

        userPaymentHistory[payer].push(record);
        paymentById[referenceId] = record;

        totalPaymentsCount++;

        if (isETH) {
            totalETHVolume += amount;
            tokenStatistics[address(0)].totalVolume += amount;
            tokenStatistics[address(0)].totalPayments++;
        } else {
            tokenStatistics[token].totalVolume += amount;
            tokenStatistics[token].totalPayments++;
        }
    }

    // ============ View Functions ============
    
    /// @notice Get user's payment history count
    function getUserPaymentCount(address user) external view returns (uint256) {
        return userPaymentHistory[user].length;
    }

    /// @notice Get specific payment from user's history
    function getUserPayment(address user, uint256 index) 
        external 
        view 
        returns (PaymentRecord memory) 
    {
        return userPaymentHistory[user][index];
    }

    /// @notice Get payment by reference ID
    function getPaymentByReference(bytes32 referenceId) 
        external 
        view 
        returns (PaymentRecord memory) 
    {
        return paymentById[referenceId];
    }

    /// @notice Get merchant info
    function getMerchant(address merchant) external view returns (Merchant memory) {
        return merchants[merchant];
    }

    /// @notice Get token statistics
    function getTokenStats(address token) external view returns (TokenStats memory) {
        return tokenStatistics[token];
    }

    /// @notice Get ETH statistics (token address = 0x0)
    function getETHStats() external view returns (TokenStats memory) {
        return tokenStatistics[address(0)];
    }

    // ============ Legacy Functions (Compatibility) ============
    
    /// @notice Legacy payETH without referenceId (auto-generates)
    function payETH() external payable whenNotPaused nonReentrant {
        bytes32 autoRef = keccak256(abi.encodePacked(msg.sender, block.timestamp, msg.value));
        
        (bool ok, ) = payable(treasury).call{value: msg.value}("");
        if (!ok) revert ForwardFailed();

        _recordPayment(msg.sender, treasury, msg.value, address(0), autoRef, true);
        
        emit PaidETH(msg.sender, treasury, msg.value, autoRef, block.timestamp);
    }

    /// @notice Legacy payToken without referenceId (auto-generates)
    function payToken(uint256 amount) external whenNotPaused nonReentrant {
        address token = acceptedToken;
        if (token == address(0)) revert TokenNotSet();
        
        bytes32 autoRef = keccak256(abi.encodePacked(msg.sender, block.timestamp, amount));
        
        bool ok = IERC20(token).transferFrom(msg.sender, treasury, amount);
        if (!ok) revert TransferFromFailed();

        _recordPayment(msg.sender, treasury, amount, token, autoRef, false);
        
        emit PaidToken(msg.sender, treasury, token, amount, autoRef, block.timestamp);
    }

    /// @dev Block raw ETH to enforce pause + nonReentrant via payETH()
    receive() external payable {
        revert ReceiveDisabled();
    }

    /// @dev Storage gap for future variables
    uint256[40] private __gap;
}
