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
    initializer: "initialize"
  });
  await proxy.waitForDeployment();

  const proxyAddr = await proxy.getAddress();
  const implAddr = await upgrades.erc1967.getImplementationAddress(proxyAddr);
  const adminAddr = await upgrades.erc1967.getAdminAddress(proxyAddr);

  console.log("BaseTap Proxy:", proxyAddr);
  console.log("Implementation:", implAddr);
  console.log("ProxyAdmin:", adminAddr);
}

main().catch((e) => { console.error(e); process.exit(1); });
