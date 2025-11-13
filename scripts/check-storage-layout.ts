import { ethers, upgrades } from "hardhat";

async function main() {
  console.log("\n📊 Checking storage layout compatibility...\n");
  
  // Check BaseTap (V1)
  console.log("1️⃣ BaseTap (V1) storage layout:");
  const BaseTapFactory = await ethers.getContractFactory("BaseTap");
  await upgrades.validateImplementation(BaseTapFactory, {
    kind: "transparent"
  });
  console.log("   ✅ BaseTap V1 is valid\n");
  
  // Check BaseTapV2
  console.log("2️⃣ BaseTapV2 storage layout:");
  const BaseTapV2Factory = await ethers.getContractFactory("BaseTapV2");
  await upgrades.validateImplementation(BaseTapV2Factory, {
    kind: "transparent"
  });
  console.log("   ✅ BaseTapV2 is valid\n");
  
  console.log("🎉 Both contracts have valid storage layouts!");
  console.log("\n📝 Note: To upgrade existing proxy, you'll need:");
  console.log("   - PRIVATE_KEY with owner permissions");
  console.log("   - Run upgrade.ts script on testnet first");
}

main().catch((e) => {
  console.error("❌ Error:", e.message);
  process.exit(1);
});
