# BaseTap

Instant onchain payment button for the Base ecosystem. Accepts ETH (and later ERC-20 like USDC), forwards funds to a treasury, and uses an upgradeable proxy (UUPS) to keep the logic evolvable. Built with Solidity + Hardhat and designed for GitHub Actions/Codespaces only.

[![Base](https://img.shields.io/badge/Built%20on-Base-0052FF)](https://base.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.24-blue)](https://soliditylang.org)

---

## Why BaseTap

- Onchain-first signal: upgradeable proxy, clear deployments and addresses.
- Built for Base: targets Base Mainnet and Base Sepolia.
- Simple integration: one contract, one button, one treasury.
- Prepared for growth: Base Pay / Base Account SDK integration planned.

---

## Features

**V2 Enhancements:**
- 📊 Complete payment history tracking with reference IDs
- 🏪 Multi-merchant registry and payment routing
- 📈 Real-time payment analytics and statistics
- 🔍 Advanced event indexing for off-chain applications
- 💾 Structured storage with mappings and structs

**Core Features:**
- ETH and ERC-20 (USDC) payments with instant forwarding
- TransparentUpgradeableProxy for safe contract evolution
- Pausable and non-reentrant execution guards
- Per-network deployment JSONs tracked on-chain
- Automated CI/CD via GitHub Actions

---

## Addresses & Deployments

Deployment files are stored per chain. Example structure:

deployments/
  base-mainnet.json
  base-sepolia.json

Each file should include:
- proxy: proxy address
- implementation: implementation address
- timestamp: ISO string
- contract: contract name
- network: chain name

> First onchain deployments will land with v0.1.0-rc.* pre-releases.

---

## Quick Start (GitHub Actions)

### 1. Setup GitHub Secrets

Configure required secrets in your repository (Settings → Secrets and variables → Actions):

**Required:**
- `PRIVATE_KEY` - deployer wallet private key (with 0x prefix)
- `OWNER_ADDRESS` - contract owner address
- `TREASURY_ADDRESS` - treasury address for payments
- `ETHERSCAN_API_KEY` - BaseScan API key for verification

**Optional (for custom commits):**
- `GIT_USER_NAME` - your name for git commits
- `GIT_USER_EMAIL` - your email for git commits

See [GitHub Setup Guide](./docs/GITHUB_SETUP.md) for detailed instructions.

### 2. Deploy or Upgrade

**Upgrade existing proxy:**
1. Go to **Actions** → **Upgrade BaseTap**
2. Select network: `baseSepolia` (testnet) or `base` (mainnet)
3. Select version: `BaseTapV2`
4. Click **Run workflow**

**Deploy new proxy:**
1. Go to **Actions** → **Deploy BaseTap (Transparent)**
2. Select network and verify option
3. Click **Run workflow**

### 3. Local Development (optional)

```bash
# Install dependencies
npm install

# Compile contracts
npm run build

# Test scripts
npm run test:scripts
npm run test:storage

# Lint
npm run lint
```

> All production deploys are executed via GitHub Actions `workflow_dispatch`.

---

## Roadmap

**✅ Completed:**
- v0.1.0: Initial TransparentProxy deployments (Base Mainnet + Sepolia)
- v0.2.0: Payment history, merchant registry, analytics (BaseTapV2)

**🚀 In Progress:**
- Base Pay SDK integration
- Base Account SDK for smart wallets
- OnchainKit UI components

**📋 Planned:**
- v0.3.0: ERC-721 payment receipt NFTs
- v0.4.0: Base DeFi integrations (Aerodrome, Uniswap)
- v0.5.0: Batch payment processing

---

## Security

- UUPS upgradeability with owner-gated upgrades
- Pausable and ReentrancyGuard
- Minimal external calls and checks-effects-interactions
- See SECURITY.md for reporting and scope

---

## Ecosystem Integration

BaseTap is built for the Base ecosystem and integrates with:
- **Base Pay SDK** - seamless payment experience
- **Base Account SDK** - smart contract wallet integration
- **Base Network** - low-cost, fast transactions
- **BaseScan** - contract verification and transparency

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for development guidelines.

## License

MIT © BaseTap contributors

---

**Built with ❤️ for the Base ecosystem**
