# Changelog

All notable changes to BaseTap protocol are documented here.

## [0.2.0] - 2025-01-20

### Added
- **BaseTapV2 Contract**: Enhanced payment protocol with advanced features
  - Payment history tracking with `PaymentRecord` structs
  - Merchant registry system with `Merchant` structs
  - Payment analytics with `TokenStats` for volume tracking
  - Reference ID system for payment tracking and reconciliation
  - Enhanced events with indexed parameters for better indexing
  - Legacy compatibility layer for V1 functions

### Changed
- Improved storage layout with mappings for scalable data access
- Enhanced event emission with timestamps and reference IDs
- Upgraded upgrade workflow to support contract version selection

### Infrastructure
- Added upgrade workflow for testnet deployments
- Integrated linting into CI pipeline
- Cleaned up redundant workflow files

## [0.1.0] - 2025-01-15

### Initial Release
- TransparentUpgradeableProxy deployment on Base Mainnet and Sepolia
- ETH and ERC-20 payment support
- Pausable and ReentrancyGuard security patterns
- Basic treasury forwarding mechanism
- GitHub Actions CI/CD pipeline
