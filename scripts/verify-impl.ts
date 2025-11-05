import { run, upgrades } from "hardhat";

async function main() {
  const proxy = process.env.PROXY_ADDRESS;
  if (!proxy)
    throw new Error(
      "Usage: PROXY_ADDRESS=0x... hardhat run scripts/verify-impl.ts --network <net>"
    );
  const impl = await upgrades.erc1967.getImplementationAddress(proxy);
  console.log("Implementation to verify:", impl);
  await run("verify:verify", { address: impl, constructorArguments: [] });
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
