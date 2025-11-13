# BaseTap Project Structure

Complete overview of all files and directories in the BaseTap project.

---

## 📁 Root Directory

### Configuration Files

- **`hardhat.config.ts`** - Hardhat configuration for Solidity compilation, network settings (Base, Base Sepolia, Sepolia), and Etherscan verification
- **`tsconfig.json`** - TypeScript configuration for scripts and type checking
- **`package.json`** - Node.js dependencies and npm scripts for building, deploying, and managing the project
- **`.gitignore`** - Git ignore rules for node_modules, build artifacts, environment files
- **`.env.example`** - Example environment variables template (PRIVATE_KEY, RPC URLs, API keys)

### Documentation Files

- **`README.md`** - Main project documentation with features, quick start guide, and ecosystem integrations
- **`CHANGELOG.md`** - Version history and release notes (v0.1.0, v0.2.0)
- **`CONTRIBUTING.md`** - Contribution guidelines for developers
- **`SECURITY.md`** - Security policy and vulnerability reporting
- **`LICENSE`** - MIT License
- **`FILE_STRUCTURE.md`** - This file - complete project structure documentation

---

## 📂 `/contracts` - Smart Contracts

### Main Contracts

- **`BaseTap.sol`** - Original payment contract (V1)
  - ETH and ERC-20 payment acceptance
  - TransparentUpgradeableProxy pattern
  - Pausable and ReentrancyGuard protections
  - Treasury forwarding

- **`BaseTapV2.sol`** - Enhanced payment protocol (V2)
  - **Structs:** PaymentRecord, Merchant, TokenStats
  - **Mappings:** Payment history, merchant registry, analytics
  - **Features:** Reference IDs, merchant support, payment tracking
  - **Storage:** Backward compatible with V1
  - **Events:** Enhanced indexed events for better off-chain indexing

---

## 📂 `/scripts` - Deployment & Management Scripts

### Core Scripts

- **`deploy-transparent.ts`** - Deploy new TransparentUpgradeableProxy
  - Supports both BaseTap and BaseTapV2
  - Configurable via CONTRACT_VERSION env variable
  - Initializes with owner, treasury, and accepted token

- **`upgrade.ts`** - Upgrade existing proxy to new implementation
  - Uses OpenZeppelin upgrades plugin
  - ForceImport for existing proxies
  - Transparent proxy kind specification
  - Detailed logging for each step

- **`verify-impl.ts`** - Verify implementation contract on BaseScan
  - Reads implementation address from proxy
  - Submits to Etherscan/BaseScan API
  - Works for all networks (Base, Base Sepolia, Sepolia)

- **`read-proxy-info.ts`** - Read proxy information
  - Displays proxy address
  - Shows current implementation address
  - Shows ProxyAdmin address

---

## 📂 `/deployments` - Deployment Records

Stores deployment addresses and metadata for each network.

- **`base.json`** - Base Mainnet deployment
  - Proxy: `0xCDBbe936bf1930e9B9b841592B45F8B88849A3C0`
  - Contains: proxy, implementation, proxyAdmin addresses, timestamp

- **`baseSepolia.json`** - Base Sepolia testnet deployment
  - Proxy: `0x37a5f589dC699f2Fc18DFAA10050b2D56a071414`
  - Contains: proxy, implementation, proxyAdmin addresses, timestamp, deployer

---

## 📂 `/.github` - GitHub Configuration

### `/workflows` - GitHub Actions CI/CD

- **`ci.yml`** - Continuous Integration
  - Runs on push to main branch
  - Installs dependencies, compiles contracts
  - Runs linting (Prettier, Solhint)
  - Uploads build artifacts

- **`deploy.yml`** - Deploy workflow
  - Manual trigger (workflow_dispatch)
  - Supports all networks (Base, Base Sepolia, Sepolia)
  - Deploys TransparentUpgradeableProxy
  - Commits deployment addresses
  - Optional verification on BaseScan

- **`upgrade.yml`** - Upgrade workflow
  - Manual trigger with network and version selection
  - Supports Base Mainnet and testnets
  - Reads proxy from deployments/*.json
  - Upgrades to BaseTapV2 or BaseTap
  - Updates deployment files
  - Commits from configured user (GIT_USER_NAME/EMAIL)
  - Verifies new implementation

### Other GitHub Files

- **`CODE_OF_CONDUCT.md`** - Community code of conduct (Contributor Covenant v2.0)

---

## 📂 `/docs` - Additional Documentation

- **`BASE_PAY_INTEGRATION.md`** - Base Pay SDK integration guide
  - Setup instructions
  - Payment button implementation
  - Multi-token payments
  - Merchant-specific payments
  - Testing on Base Sepolia

- **`BASE_ACCOUNT_SDK_INTEGRATION.md`** - Base Account SDK guide
  - Smart contract wallet integration
  - Gasless transactions with paymaster
  - Batch operations
  - Session keys for recurring payments
  - Security best practices

- **`GITHUB_SETUP.md`** - GitHub repository setup guide
  - Required secrets (PRIVATE_KEY, OWNER_ADDRESS, etc.)
  - Optional variables (RPC URLs)
  - Repository topics for discoverability
  - Setup verification steps
  - Security recommendations

---

## 📂 `/typechain-types` (Generated)

TypeScript type definitions auto-generated from compiled contracts.
- Not committed to git (in .gitignore)
- Generated via `npm run build`

---

## 📂 `/artifacts` (Generated)

Hardhat compilation artifacts (ABIs, bytecode).
- Not committed to git (in .gitignore)
- Generated via `npm run build`

---

## 📂 `/cache` (Generated)

Hardhat internal cache for faster compilation.
- Not committed to git (in .gitignore)

---

## 📂 `/node_modules` (Generated)

Node.js dependencies installed via npm/yarn.
- Not committed to git (in .gitignore)

---

## 🔧 Configuration Files Explained

### `hardhat.config.ts`
- **Networks:** Base (8453), Base Sepolia (84532), Sepolia (11155111)
- **Compiler:** Solidity 0.8.24 with optimizer
- **Plugins:** hardhat-ethers, hardhat-verify, hardhat-upgrades
- **Etherscan:** API v2 configuration for BaseScan verification

### `package.json` Scripts
- `build` - Compile contracts with Hardhat
- `deploy:proxy:base` - Deploy to Base Mainnet
- `deploy:proxy:base-sepolia` - Deploy to Base Sepolia
- `upgrade` - Upgrade existing proxy
- `verify:impl` - Verify implementation on explorer
- `read:proxy` - Read proxy information
- `lint` - Run Prettier and Solhint
- `fmt` - Format code with Prettier

---

## 🎯 Key Concepts

### Upgradeable Architecture
- **TransparentUpgradeableProxy:** Separates storage (proxy) from logic (implementation)
- **Storage Layout:** V2 preserves V1 layout for safe upgrades
- **ProxyAdmin:** Controls upgrade permissions

### Base Ecosystem Integration
- **OnchainKit:** UI components for Base dApps
- **Base Pay SDK:** Seamless payment integration
- **Base Account SDK:** Smart contract wallet support
- **Viem & Wagmi:** Modern web3 libraries

### Deployment Strategy
- **Testnet First:** Always test on Base Sepolia before mainnet
- **GitHub Actions:** Automated CI/CD pipeline
- **Verification:** All contracts verified on BaseScan for transparency

---

## 📝 Important Notes

1. **Never commit** `.env` files - use GitHub Secrets instead
2. **Always test** upgrades on testnet before mainnet
3. **Verify contracts** on BaseScan for transparency
4. **Use topics** in GitHub repo for Base ecosystem discoverability
5. **Document changes** in CHANGELOG.md for every release

---

**Last Updated:** 2025-11-13
**Version:** 0.2.0
