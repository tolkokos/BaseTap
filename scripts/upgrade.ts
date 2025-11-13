import { ethers, upgrades } from "hardhat";

async function main() {
  const proxy = process.env.PROXY_ADDRESS;
  if (!proxy) throw new Error("Set PROXY_ADDRESS in env");
  
  const contractName = process.env.CONTRACT_VERSION || "BaseTapV2";
  console.log(`\n🔄 Upgrading proxy ${proxy} to ${contractName}...\n`);
  
  const F = await ethers.getContractFactory(contractName);
  
  // Force import existing proxy if not registered
  try {
    console.log("📝 Registering existing proxy...");
    await upgrades.forceImport(proxy, F, { kind: "transparent" });
    console.log("✅ Proxy registered\n");
  } catch (e: any) {
    // Proxy might already be registered, continue
    console.log("ℹ️  Proxy already registered or registration skipped\n");
  }
  
  console.log("🚀 Starting upgrade...");
  const upgraded = await upgrades.upgradeProxy(proxy, F, { kind: "transparent" });
  await upgraded.waitForDeployment();
  
  const impl = await upgrades.erc1967.getImplementationAddress(await upgraded.getAddress());
  console.log("\n✅ Upgrade complete!");
  console.log("📋 Proxy address:", proxy);
  console.log("🆕 New implementation:", impl);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
