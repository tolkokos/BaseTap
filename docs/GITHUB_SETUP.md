# GitHub Repository Setup Guide

Complete guide for configuring GitHub Secrets and Variables for BaseTap deployment and operations.

---

## 🔑 Required GitHub Secrets

Navigate to: **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

### 1. PRIVATE_KEY
**Description:** Private key of the wallet with owner permissions on the contract  
**Format:** `0xabc123...` (with 0x prefix)  
**How to get:** From MetaMask/Coinbase Wallet → Account details → Export Private Key

⚠️ **IMPORTANT:** This wallet must be the owner of the BaseTap contract

---

### 2. OWNER_ADDRESS
**Description:** Owner wallet address  
**Format:** `0xYourAddress...`  
**How to get:** Copy address from MetaMask/Coinbase Wallet

---

### 3. TREASURY_ADDRESS
**Description:** Treasury address for receiving payments  
**Format:** `0xTreasuryAddress...`  
**Note:** Can use the same address as OWNER_ADDRESS

---

### 4. ETHERSCAN_API_KEY
**Description:** API key for contract verification on BaseScan  
**How to get:** https://basescan.org/myapikey

**Steps:**
1. Create an account on BaseScan.org
2. Navigate to API Keys
3. Create a new key
4. Copy and add to Secrets

ℹ️ **Note:** One key works for both Base Mainnet and Base Sepolia

---

### 5. GIT_USER_NAME (optional)
**Description:** Your name for git commits  
**Format:** `Your Name` (text)  
**Example:** `John Doe`

If not specified - your GitHub username will be used.

---

### 6. GIT_USER_EMAIL (optional)
**Description:** Your email for git commits  
**Format:** `your.email@example.com`  
**Example:** `john@example.com`

If not specified - `username@users.noreply.github.com` will be used.

---

## 📊 Optional GitHub Variables

Navigate to: **Settings** → **Secrets and variables** → **Actions** → **Variables** tab

### 1. BASE_RPC_URL
**Description:** RPC endpoint for Base Mainnet  
**Default:** `https://mainnet.base.org` (public)  
**Recommendation:** Use Alchemy or Infura for better stability

**Example (Alchemy):**
```
https://base-mainnet.g.alchemy.com/v2/YOUR_API_KEY
```

---

### 2. BASE_SEPOLIA_RPC_URL
**Description:** RPC endpoint for Base Sepolia (testnet)  
**Default:** `https://base-sepolia-rpc.publicnode.com` (public)

**Example (Alchemy):**
```
https://base-sepolia.g.alchemy.com/v2/YOUR_API_KEY
```

---

### 3. SEPOLIA_RPC_URL
**Description:** RPC endpoint for Ethereum Sepolia  
**Default:** `https://ethereum-sepolia-rpc.publicnode.com` (public)

---

## 🎯 Repository Topics

Add these topics in Settings → General → Topics:

```
base
base-network
ethereum
l2
coinbase
onchainkit
base-pay
smart-contracts
defi
payments
upgradeable
solidity
web3
```

**Why?** For project indexing by Base Network and other tools for potential airdrops.

---

## 📝 Repository Description

Settings → General → Description:

```
Instant onchain payment protocol for Base ecosystem | Base Pay + Account SDK + OnchainKit | Upgradeable UUPS proxy
```

---

## ✅ Setup Verification

After adding all secrets, run a test:

1. Navigate to **Actions**
2. Select **CI** workflow
3. Click **Run workflow**
4. If successful ✅ - everything is configured correctly

---

## 🚀 First Testnet Upgrade

**When all secrets are configured:**

1. **Actions** → **Upgrade BaseTap**
2. **Run workflow**
3. Select:
   - Network: `baseSepolia`
   - Version: `BaseTapV2`
4. **Run workflow**

Expected result:
- ✅ Upgrade executed
- ✅ New implementation deployed
- ✅ Deployment file updated
- ✅ Commit from your name
- ✅ Verification on BaseScan (may be delayed)

---

## 🔐 Security

- ❌ **DO NOT COMMIT** .env file with secrets
- ❌ **DO NOT SHARE** PRIVATE_KEY with anyone
- ✅ Use a separate wallet for deployments
- ✅ Regularly check owner wallet balance
- ✅ Use hardware wallet for mainnet operations (optional)

---

## 📞 Support

If you encounter issues:
1. Verify all secrets are added
2. Check format (with 0x prefix for addresses and keys)
3. Check wallet balance (need ETH for gas on Base)
4. Verify you are the contract owner

---

**Ready to deploy!** 🎉
