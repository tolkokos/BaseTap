# Base Pay SDK Integration Guide

## Overview

BaseTap integrates with Base Pay SDK to provide seamless payment experiences directly within your application.

## Prerequisites

```bash
npm install @coinbase/base-pay-sdk viem
```

## Quick Start

### 1. Initialize Base Pay Client

```typescript
import { createBasePayClient } from '@coinbase/base-pay-sdk';
import { createPublicClient, http } from 'viem';
import { base } from 'viem/chains';

const publicClient = createPublicClient({
  chain: base,
  transport: http()
});

const basePayClient = createBasePayClient({
  publicClient,
  contractAddress: '0xCDBbe936bf1930e9B9b841592B45F8B88849A3C0' // BaseTap Proxy on Base Mainnet
});
```

### 2. Create Payment Button

```typescript
import { BasePayButton } from '@coinbase/base-pay-sdk/react';

function PaymentComponent() {
  const handlePayment = async (amount: bigint) => {
    const referenceId = `0x${Date.now().toString(16).padStart(64, '0')}`;
    
    return {
      to: '0xCDBbe936bf1930e9B9b841592B45F8B88849A3C0',
      data: encodeFunctionData({
        abi: BaseTapABI,
        functionName: 'payETH',
        args: [referenceId]
      }),
      value: amount
    };
  };

  return (
    <BasePayButton
      amount="1000000000000000" // 0.001 ETH
      onPayment={handlePayment}
      onSuccess={(txHash) => console.log('Payment successful:', txHash)}
      onError={(error) => console.error('Payment failed:', error)}
    />
  );
}
```

### 3. Track Payment Status

```typescript
const referenceId = '0x...';
const payment = await baseTapContract.read.getPaymentByReference([referenceId]);

console.log('Payment details:', {
  payer: payment.payer,
  amount: payment.amount,
  timestamp: payment.timestamp,
  isETH: payment.isETH
});
```

## Advanced Features

### Multi-Token Payments

```typescript
// Pay with USDC
const usdcAmount = parseUnits('10', 6); // 10 USDC
const referenceId = generateReferenceId();

await baseTapContract.write.payToken([usdcAmount, referenceId]);
```

### Merchant-Specific Payments

```typescript
const merchantAddress = '0x...';
const referenceId = generateReferenceId();

await baseTapContract.write.payMerchantETH([merchantAddress, referenceId], {
  value: parseEther('0.01')
});
```

## Best Practices

1. **Always use unique reference IDs** for payment tracking
2. **Validate transaction confirmations** before showing success
3. **Handle errors gracefully** with user-friendly messages
4. **Monitor gas prices** for optimal transaction timing
5. **Index payment events** for analytics and reconciliation

## Testing on Base Sepolia

```typescript
const basePayClient = createBasePayClient({
  publicClient: createPublicClient({
    chain: baseSepolia,
    transport: http()
  }),
  contractAddress: '0x37a5f589dC699f2Fc18DFAA10050b2D56a071414' // BaseTap on Base Sepolia
});
```

## Resources

- [Base Pay SDK Documentation](https://docs.base.org/base-pay)
- [BaseTap Contract on BaseScan](https://basescan.org/address/0xCDBbe936bf1930e9B9b841592B45F8B88849A3C0)
- [OnchainKit Components](https://onchainkit.xyz)
