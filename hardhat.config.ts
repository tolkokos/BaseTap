import * as dotenv from "dotenv";
dotenv.config();
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";

const pk = (process.env.PRIVATE_KEY || "").replace(/^0x/, "");

function pickUSDC(network?: string): string | undefined {
  if (!network) return process.env.USDC_ADDRESS;
  if (network === "base") return process.env.USDC_ADDRESS_BASE || process.env.USDC_ADDRESS;
  if (network === "baseSepolia") return process.env.USDC_ADDRESS_BASE_SEPOLIA || process.env.USDC_ADDRESS;
  if (network === "sepolia") return process.env.USDC_ADDRESS_SEPOLIA || process.env.USDC_ADDRESS;
  return process.env.USDC_ADDRESS;
}
process.env.USDC_ADDRESS = pickUSDC(process.env.HARDHAT_NETWORK);

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.24",
    settings: { optimizer: { enabled: true, runs: 200 } },
  },
  networks: {
    sepolia: { url: process.env.SEPOLIA_RPC_URL || "", chainId: 11155111, accounts: pk ? ["0x" + pk] : [] },
    base: { url: process.env.BASE_RPC_URL || "", chainId: 8453, accounts: pk ? ["0x" + pk] : [] },
    baseSepolia: { url: process.env.BASE_SEPOLIA_RPC_URL || "", chainId: 84532, accounts: pk ? ["0x" + pk] : [] },
  },
  etherscan: {
    apiKey: {
      sepolia: process.env.ETHERSCAN_API_KEY || "",
      base: process.env.BASESCAN_API_KEY || "",
      baseSepolia: process.env.BASESCAN_SEPOLIA_API_KEY || process.env.BASESCAN_API_KEY || "",
    },
    customChains: [
      { network: "base", chainId: 8453, urls: { apiURL: "https://api.basescan.org/api", browserURL: "https://basescan.org" } },
      { network: "baseSepolia", chainId: 84532, urls: { apiURL: "https://api-sepolia.basescan.org/api", browserURL: "https://sepolia.basescan.org" } }
    ]
  }
};
export default config;
