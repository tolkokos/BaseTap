import { upgrades } from "hardhat";

async function main() {
  const proxy = process.env.PROXY_ADDRESS;
  if (!proxy) throw new Error("Set PROXY_ADDRESS=0x...");
  const impl = await upgrades.erc1967.getImplementationAddress(proxy);
  const admin = await upgrades.erc1967.getAdminAddress(proxy);
  console.log("Proxy:", proxy);
  console.log("Implementation:", impl);
  console.log("ProxyAdmin:", admin);
}
main().catch((e) => { console.error(e); process.exit(1); });
