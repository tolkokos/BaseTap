import * as dotenv from "dotenv";
dotenv.config();

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@openzeppelin/hardhat-upgrades";

// ----------------------------
// Private key setup
// ----------------------------
const pk = (process.env.PRIVATE_KEY || "").replace(/^0x/, "");

// Safe RPC defaults (public fallbacks)
const SEP_URL  = process.env.SEPOLIA_RPC_URL      || "https://ethereum-sepolia-rpc.publicnode.com";
const BASE_URL = process.env.BASE_RPC_URL         || "https://mainnet.base.org";
const BSEP_URL = process.env.BASE_SEPOLIA_RPC_URL || "https://base-sepolia-rpc.publicnode.com";

// Ensure private key is set for live networks
if (!pk && process.env.HARDHAT_NETWORK && process.env.HARDHAT_NETWORK !== "hardhat") {
  throw new Error("PRIVATE_KEY is required for live network deployments");
}

// USDC selector
function pickUSDC(network?: string): string | undefined {
  if (!network) return process.env.USDC_ADDRESS;
  if (network === "base") return process.env.USDC_ADDRESS_BASE || process.env.USDC_ADDRESS;
  if (network === "baseSepolia") return process.env.USDC_ADDRESS_BASE_SEPOLIA || process.env.USDC_ADDRESS;
  if (network === "sepolia") return process.env.USDC_ADDRESS_SEPOLIA || process.env.USDC_ADDRESS;
  return process.env.USDC_ADDRESS;
}
process.env.USDC_ADDRESS = pickUSDC(process.env.HARDHAT_NETWORK);

// ----------------------------
// Hardhat config
// ----------------------------
const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.24",
    settings: { optimizer: { enabled: true, runs: 200 } },
  },

  networks: {
    sepolia: {
      url: SEP_URL,
      chainId: 11155111,
      accounts: pk ? ["0x" + pk] : [],
    },
    base: {
      url: BASE_URL,
      chainId: 8453,
      accounts: pk ? ["0x" + pk] : [],
    },
    baseSepolia: {
      url: BSEP_URL,
      chainId: 84532,
      accounts: pk ? ["0x" + pk] : [],
    },
  },

  etherscan: {
    // ✅ Etherscan API v2 single key
    apiKey: process.env.ETHERSCAN_API_KEY || "",
    customChains: [
      {
        network: "base",
        chainId: 8453,
        urls: {
          apiURL: "https://api.basescan.org/api",
          browserURL: "https://basescan.org",
        },
      },
      {
        network: "baseSepolia",
        chainId: 84532,
        urls: {
          apiURL: "https://api-sepolia.basescan.org/api",
          browserURL: "https://sepolia.basescan.org",
        },
      },
    ],
  },
};

export default config;
