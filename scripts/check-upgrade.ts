import { ethers, upgrades } from "hardhat";

async function main() {
  const proxy = process.env.PROXY_ADDRESS;
  if (!proxy) throw new Error("Set PROXY_ADDRESS=0x...");

  const F = await ethers.getContractFactory("BaseTap");

  // Validates that upgrading this proxy to the new impl is storage-safe
  await upgrades.validateUpgrade(proxy, F, { kind: "transparent" });

  console.log("✅ Upgrade validation passed: storage layout is compatible.");
}
main().catch((e) => {
  console.error(e);
  process.exit(1);
});
