import { ethers } from "hardhat";

async function main() {
  const proxy = process.env.PROXY_ADDRESS;
  const token = process.env.TOKEN_ADDRESS;
  if (!proxy || !token) {
    throw new Error("Usage: PROXY_ADDRESS=0x... TOKEN_ADDRESS=0x... hardhat run --network <net> scripts/set-token.ts");
  }
  const c = await ethers.getContractAt("BaseTap", proxy);
  const tx = await c.setAcceptedToken(token);
  console.log("setAcceptedToken tx:", tx.hash);
  await tx.wait();
  console.log("Done");
}
main().catch((e) => { console.error(e); process.exit(1); });
