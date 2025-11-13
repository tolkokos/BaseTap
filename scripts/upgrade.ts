import { ethers, upgrades } from "hardhat";

async function main() {
  const proxy = process.env.PROXY_ADDRESS;
  if (!proxy) throw new Error("Set PROXY_ADDRESS in env");
  
  const contractName = process.env.CONTRACT_VERSION || "BaseTapV2";
  console.log(`Upgrading to ${contractName}...`);
  
  const F = await ethers.getContractFactory(contractName);
  const upgraded = await upgrades.upgradeProxy(proxy, F);
  await upgraded.waitForDeployment();
  const impl = await upgrades.erc1967.getImplementationAddress(await upgraded.getAddress());
  console.log("✅ Upgraded. New implementation:", impl);
  console.log("📋 Proxy address:", proxy);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
