# Base Account SDK Integration Guide

## Overview

Base Account SDK enables smart contract wallet integration with BaseTap, providing enhanced security and user experience through account abstraction.

## Why Base Account SDK?

- **Gasless Transactions**: Sponsor user gas fees for better UX
- **Batch Operations**: Execute multiple payments in one transaction
- **Social Recovery**: Secure account recovery without private keys
- **Session Keys**: Delegate limited permissions safely

## Prerequisites

```bash
npm install @coinbase/base-account-sdk viem @alchemy/aa-core
```

## Quick Start

### 1. Initialize Smart Account

```typescript
import { createSmartAccountClient } from '@coinbase/base-account-sdk';
import { base } from 'viem/chains';

const smartAccount = await createSmartAccountClient({
  chain: base,
  ownerAddress: '0x...', // EOA owner address
  bundlerUrl: 'https://base-mainnet.g.alchemy.com/v2/YOUR_KEY',
  paymasterUrl: 'https://base-mainnet.g.alchemy.com/v2/YOUR_KEY' // Optional for gasless
});
```

### 2. Execute BaseTap Payment

```typescript
const referenceId = `0x${Date.now().toString(16).padStart(64, '0')}`;

const userOp = await smartAccount.sendUserOperation({
  target: '0xCDBbe936bf1930e9B9b841592B45F8B88849A3C0', // BaseTap proxy
  data: encodeFunctionData({
    abi: BaseTapABI,
    functionName: 'payETH',
    args: [referenceId]
  }),
  value: parseEther('0.01')
});

const txHash = await smartAccount.waitForUserOperationTransaction(userOp);
console.log('Payment successful:', txHash);
```

### 3. Batch Multiple Payments

```typescript
const payments = [
  {
    merchant: '0xMerchant1...',
    amount: parseEther('0.01'),
    referenceId: generateReferenceId()
  },
  {
    merchant: '0xMerchant2...',
    amount: parseEther('0.02'),
    referenceId: generateReferenceId()
  }
];

const calls = payments.map(p => ({
  target: '0xCDBbe936bf1930e9B9b841592B45F8B88849A3C0',
  data: encodeFunctionData({
    abi: BaseTapABI,
    functionName: 'payMerchantETH',
    args: [p.merchant, p.referenceId]
  }),
  value: p.amount
}));

const batchOp = await smartAccount.sendUserOperation(calls);
```

### 4. Gasless Payments with Paymaster

```typescript
const paymasterConfig = {
  paymasterUrl: 'https://base-mainnet.g.alchemy.com/v2/YOUR_KEY',
  sponsorshipPolicy: {
    enabled: true,
    maxGasSponsorship: parseEther('0.001')
  }
};

const smartAccount = await createSmartAccountClient({
  chain: base,
  ownerAddress: userAddress,
  bundlerUrl: bundlerUrl,
  paymaster: paymasterConfig
});

// User pays 0 gas!
const userOp = await smartAccount.sendUserOperation({
  target: baseTapAddress,
  data: paymentCalldata,
  value: paymentAmount
});
```

## Advanced Features

### Session Keys for Recurring Payments

```typescript
import { SessionKeyPlugin } from '@coinbase/base-account-sdk/plugins';

const sessionKey = await smartAccount.installPlugin(SessionKeyPlugin, {
  permissions: {
    target: baseTapAddress,
    maxValue: parseEther('1'), // Max 1 ETH per tx
    validUntil: Math.floor(Date.now() / 1000) + 86400, // 24 hours
    allowedFunctions: ['payETH', 'payToken']
  }
});

// Now sessionKey can make payments without user approval
```

### Payment Analytics Integration

```typescript
const userPaymentCount = await baseTapContract.read.getUserPaymentCount([
  smartAccount.address
]);

const recentPayments = [];
for (let i = 0; i < userPaymentCount; i++) {
  const payment = await baseTapContract.read.getUserPayment([
    smartAccount.address,
    i
  ]);
  recentPayments.push(payment);
}

console.log('Smart account payment history:', recentPayments);
```

## Security Best Practices

1. **Limit session key permissions** to specific amounts and durations
2. **Implement spending limits** to protect user funds
3. **Use paymaster policies** to control gas sponsorship
4. **Monitor smart account activity** for suspicious patterns
5. **Enable social recovery** for account security

## Testing on Base Sepolia

```typescript
const testSmartAccount = await createSmartAccountClient({
  chain: baseSepolia,
  ownerAddress: testAddress,
  bundlerUrl: 'https://base-sepolia.g.alchemy.com/v2/YOUR_KEY'
});

// Test payment on sepolia
const testTx = await testSmartAccount.sendUserOperation({
  target: '0x37a5f589dC699f2Fc18DFAA10050b2D56a071414', // BaseTap Sepolia
  data: paymentData,
  value: testAmount
});
```

## Integration Checklist

- [ ] Smart account client initialized
- [ ] Bundler and paymaster configured
- [ ] Payment flow tested on testnet
- [ ] Batch payments implemented
- [ ] Session keys configured for UX
- [ ] Analytics tracking integrated
- [ ] Error handling implemented
- [ ] Gas monitoring setup

## Resources

- [Base Account SDK Docs](https://docs.base.org/base-account)
- [Account Abstraction Guide](https://eips.ethereum.org/EIPS/eip-4337)
- [Alchemy Account Kit](https://www.alchemy.com/account-kit)
- [BaseTap Analytics Dashboard](https://basescan.org/address/0xCDBbe936bf1930e9B9b841592B45F8B88849A3C0)
