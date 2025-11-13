import { ethers, upgrades } from "hardhat";

async function main() {
  const proxy = process.env.PROXY_ADDRESS || "0x37a5f589dC699f2Fc18DFAA10050b2D56a071414";
  const contractName = process.env.CONTRACT_VERSION || "BaseTapV2";
  
  console.log(`\n🔍 Validating upgrade from proxy ${proxy} to ${contractName}...\n`);
  
  const Factory = await ethers.getContractFactory(contractName);
  
  try {
    await upgrades.validateUpgrade(proxy, Factory, {
      kind: "transparent"
    });
    console.log("✅ Upgrade validation PASSED!");
    console.log("✅ Storage layout is compatible");
    console.log("✅ No conflicts detected");
    console.log("\n🎉 Safe to upgrade!");
  } catch (error: any) {
    console.error("❌ Upgrade validation FAILED!");
    console.error(error.message);
    process.exit(1);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
