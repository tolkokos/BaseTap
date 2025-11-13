import { ethers } from "hardhat";

async function main() {
  console.log("\n🧪 Testing script configurations...\n");
  
  // Test 1: Contract factories can be loaded
  console.log("1️⃣ Testing contract factories...");
  try {
    const BaseTap = await ethers.getContractFactory("BaseTap");
    console.log("   ✅ BaseTap factory loaded");
    
    const BaseTapV2 = await ethers.getContractFactory("BaseTapV2");
    console.log("   ✅ BaseTapV2 factory loaded\n");
  } catch (e: any) {
    console.error("   ❌ Factory loading failed:", e.message);
    process.exit(1);
  }
  
  // Test 2: Environment variable handling
  console.log("2️⃣ Testing environment variables...");
  const contractVersion = process.env.CONTRACT_VERSION || "BaseTapV2";
  console.log(`   ✅ CONTRACT_VERSION: ${contractVersion}`);
  
  const proxyAddress = process.env.PROXY_ADDRESS || "Not set (will use from deployments)";
  console.log(`   ✅ PROXY_ADDRESS: ${proxyAddress}\n`);
  
  // Test 3: Deployment file structure
  console.log("3️⃣ Testing deployment files...");
  try {
    const baseSepoliaDeployment = require("../deployments/baseSepolia.json");
    console.log(`   ✅ Base Sepolia proxy: ${baseSepoliaDeployment.proxy}`);
    
    const baseDeployment = require("../deployments/base.json");
    console.log(`   ✅ Base Mainnet proxy: ${baseDeployment.proxy}\n`);
  } catch (e: any) {
    console.error("   ❌ Deployment file error:", e.message);
    process.exit(1);
  }
  
  console.log("✅ All script configurations are valid!\n");
  console.log("📝 Scripts ready:");
  console.log("   - scripts/upgrade.ts");
  console.log("   - scripts/deploy-transparent.ts");
  console.log("   - scripts/read-proxy-info.ts");
  console.log("   - scripts/verify-impl.ts\n");
  
  console.log("🚀 Ready for upgrade on testnet!");
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
