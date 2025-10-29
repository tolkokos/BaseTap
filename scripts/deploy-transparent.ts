import { ethers, upgrades } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`Deployer: ${deployer.address}`);

  const owner = process.env.OWNER_ADDRESS || deployer.address;
  const treasury = process.env.TREASURY_ADDRESS || deployer.address;
  const token = process.env.USDC_ADDRESS || ethers.ZeroAddress;

  const F = await ethers.getContractFactory("BaseTap");
  const proxy = await upgrades.deployProxy(F, [owner, treasury, token], {
    kind: "transparent",
    initializer: "initialize",
  });
  await proxy.waitForDeployment();

  const proxyAddr = await proxy.getAddress();
  console.log("BaseTap Proxy:", proxyAddr);

  try {
    // иногда RPC даёт лаг — делаем небольшую паузу
    await new Promise((r) => setTimeout(r, 2000));

    const implAddr = await upgrades.erc1967.getImplementationAddress(proxyAddr);
    const adminAddr = await upgrades.erc1967.getAdminAddress(proxyAddr);
    console.log("Implementation:", implAddr);
    console.log("ProxyAdmin:", adminAddr);
  } catch (e: any) {
    console.warn(
      "WARN: Could not read ERC1967 slots right now. " +
        "Proxy is deployed at the address above.\n" +
        "This can happen if RPC is lagging or if you’re checking the wrong address.\n" +
        "You can re-run a read later with scripts/verify-impl.ts."
    );
    throw e; // если хочешь НЕ падать — закомментируй эту строку
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
