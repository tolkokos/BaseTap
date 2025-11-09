# Contributing

Thanks for your interest in improving BaseTap.

## Principles
- Onchain-first: deployments and upgrades must be reproducible.
- Minimalism: small, auditable changes.
- Deterministic CI: use Node LTS and `npm ci`.

## Development
- Use GitHub Codespaces or Actions only.
- Keep Solidity code without inline comments.
- Prefer small PRs with clear titles.

## Scripts
- `npm ci` to install
- `npx hardhat compile` to build
- `npm run lint || true` optional lint

## Commits
Use conventional commits, e.g.:
- `feat: add ERC20 pay path`
- `fix: guard reentrancy on ETH flow`
- `chore: pin OZ contracts version`
- `docs: update README with addresses`

## Releases
- Pre-releases `v0.x.y-rc.N` for test deployments
- Public releases `v0.x.y` with BaseScan links and deployment JSONs
