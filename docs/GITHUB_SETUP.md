# GitHub Repository Setup Guide

Полная инструкция по настройке GitHub Secrets и Variables для работы с BaseTap.

---

## 🔑 Required GitHub Secrets

Перейди в: **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

### 1. PRIVATE_KEY
**Описание:** Приватный ключ кошелька с owner правами на контракт  
**Формат:** `0xabc123...` (с 0x префиксом)  
**Где взять:** Из MetaMask/Coinbase Wallet → Account details → Export Private Key

⚠️ **ВАЖНО:** Этот кошелек должен быть owner контракта BaseTap

---

### 2. OWNER_ADDRESS
**Описание:** Адрес owner кошелька  
**Формат:** `0xYourAddress...`  
**Где взять:** Скопируй адрес из MetaMask/Coinbase Wallet

---

### 3. TREASURY_ADDRESS
**Описание:** Адрес treasury для получения платежей  
**Формат:** `0xTreasuryAddress...`  
**Можно:** Использовать тот же адрес что и OWNER_ADDRESS

---

### 4. ETHERSCAN_API_KEY
**Описание:** API ключ для верификации контрактов на BaseScan  
**Где взять:** https://basescan.org/myapikey

**Шаги:**
1. Создай аккаунт на BaseScan.org
2. Перейди в API Keys
3. Создай новый ключ
4. Скопируй и добавь в Secrets

ℹ️ **Примечание:** Один ключ работает для Base Mainnet и Base Sepolia

---

### 5. GIT_USER_NAME (опционально)
**Описание:** Твоё имя для git коммитов  
**Формат:** `Your Name` (текст)  
**Пример:** `John Doe`

Если не указать - будет использоваться твой GitHub username.

---

### 6. GIT_USER_EMAIL (опционально)
**Описание:** Твой email для git коммитов  
**Формат:** `your.email@example.com`  
**Пример:** `john@example.com`

Если не указать - будет использоваться `username@users.noreply.github.com`.

---

## 📊 Optional GitHub Variables

Перейди в: **Settings** → **Secrets and variables** → **Actions** → **Variables** tab

### 1. BASE_RPC_URL
**Описание:** RPC endpoint для Base Mainnet  
**Default:** `https://mainnet.base.org` (публичный)  
**Рекомендация:** Используй Alchemy или Infura для лучшей стабильности

**Пример (Alchemy):**
```
https://base-mainnet.g.alchemy.com/v2/YOUR_API_KEY
```

---

### 2. BASE_SEPOLIA_RPC_URL
**Описание:** RPC endpoint для Base Sepolia (testnet)  
**Default:** `https://base-sepolia-rpc.publicnode.com` (публичный)

**Пример (Alchemy):**
```
https://base-sepolia.g.alchemy.com/v2/YOUR_API_KEY
```

---

### 3. SEPOLIA_RPC_URL
**Описание:** RPC endpoint для Ethereum Sepolia  
**Default:** `https://ethereum-sepolia-rpc.publicnode.com` (публичный)

---

## 🎯 Topics для репозитория

Добавь эти topics в Settings → General → Topics:

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

**Зачем?** Для индексации проекта Base Network и другими инструментами для аирдропа.

---

## 📝 Repository Description

Settings → General → Description:

```
Instant onchain payment protocol for Base ecosystem | Base Pay + Account SDK + OnchainKit | Upgradeable UUPS proxy
```

---

## ✅ Проверка настройки

После добавления всех secrets, запусти тест:

1. Перейди в **Actions**
2. Выбери **CI** workflow
3. Нажми **Run workflow**
4. Если успешно ✅ - всё настроено правильно

---

## 🚀 Первый upgrade на testnet

**Когда все secrets настроены:**

1. **Actions** → **Upgrade BaseTap**
2. **Run workflow**
3. Выбери:
   - Network: `baseSepolia`
   - Version: `BaseTapV2`
4. **Run workflow**

Ожидаемый результат:
- ✅ Upgrade выполнен
- ✅ Новый implementation задеплоен
- ✅ Deployment file обновлён
- ✅ Коммит от твоего имени
- ✅ Verification на BaseScan (может быть отложена)

---

## 🔐 Безопасность

- ❌ **НЕ КОМИТИТЬ** .env файл с secrets
- ❌ **НЕ ДЕЛИТЬСЯ** PRIVATE_KEY ни с кем
- ✅ Используй отдельный кошелек для деплоев
- ✅ Регулярно проверяй баланс owner кошелька
- ✅ Используй hardware wallet для mainnet операций (опционально)

---

## 📞 Поддержка

Если возникают проблемы:
1. Проверь что все secrets добавлены
2. Проверь формат (с 0x префиксом для адресов и ключей)
3. Проверь баланс кошелька (нужен ETH для gas на Base)
4. Проверь что ты owner контракта

---

**Готово к работе!** 🎉
