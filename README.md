# BaseTap

Instant onchain payment button for the Base ecosystem. Accepts ETH (and later ERC-20 like USDC), forwards funds to a treasury, and uses an upgradeable proxy (UUPS) to keep the logic evolvable. Built with Solidity + Hardhat and designed for GitHub Actions/Codespaces only.

---

## Why BaseTap

- Onchain-first signal: upgradeable proxy, clear deployments and addresses.
- Built for Base: targets Base Mainnet and Base Sepolia.
- Simple integration: one contract, one button, one treasury.
- Prepared for growth: Base Pay / Base Account SDK integration planned.

---

## Features

- ETH payments with immediate forward to a configured treasury
- Upgradeable (UUPS) architecture for safe future changes
- Pausable and non-reentrant execution guards
- Per-network deployment JSONs (already present in this repo)
- GitHub Actions CI + pre-release flow

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

## Quick Start (GitHub Codespaces / Actions only)

1. Open this repo in Codespaces.
2. Create a .env from .env.example with the required keys (no local runs).
3. Install deps:
   npm ci
4. Compile:
   npx hardhat compile
5. Run static checks:
   npm run lint || true

> All deploys are executed via GitHub Actions workflow_dispatch.

---

## Roadmap

- v0.1.0-rc: initial UUPS proxy deployments (Base Sepolia, then Base Mainnet)
- v0.1.0: public release, README with tx links, minimal UI example
- v0.1.x: Base Pay and Base Account SDK integration
- v0.2.x: ERC-20 (USDC) support, reference IDs, events indexing

---

## Security

- UUPS upgradeability with owner-gated upgrades
- Pausable and ReentrancyGuard
- Minimal external calls and checks-effects-interactions
- See SECURITY.md for reporting and scope

---

## License

MIT © BaseTap contributors
