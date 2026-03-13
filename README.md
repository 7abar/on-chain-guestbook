# on-chain-guestbook

> Leave a permanent, public message on the blockchain. Forever.

Every entry written to this contract lives on Base — immutable, uncensorable, and permanent. No server. No database. No admin with a delete button. Just you, the blockchain, and eternity.

## What It Does

- Anyone can **sign** the guestbook with a message (max 280 chars) and an optional handle
- Messages are stored **onchain forever** — no one can delete or edit them
- Pagination support to read all entries
- Track entries by author address

## Deploy

```bash
forge install foundry-rs/forge-std
forge build

# Deploy to Base
forge script script/Deploy.s.sol --rpc-url https://mainnet.base.org --broadcast --private-key $PK

# Deploy to Base Sepolia (testnet)
forge script script/Deploy.s.sol --rpc-url https://sepolia.base.org --broadcast --private-key $PK
```

## Sign the Guestbook

```bash
# Leave a message with your handle
cast send $CONTRACT "sign(string,string)" "gm from the future" "@yourhandle" \
  --rpc-url https://mainnet.base.org \
  --private-key $PK

# Leave an anonymous message
cast send $CONTRACT "sign(string,string)" "I was here" "" \
  --rpc-url https://mainnet.base.org \
  --private-key $PK
```

## Read Entries

```bash
# Get total entries
cast call $CONTRACT "totalEntries()" --rpc-url https://mainnet.base.org

# Get a specific entry (index)
cast call $CONTRACT "entries(uint256)" 0 --rpc-url https://mainnet.base.org

# Get all entries by an address
cast call $CONTRACT "getEntriesByAuthor(address)" $ADDRESS --rpc-url https://mainnet.base.org

# Get latest 10 entries (newest first)
cast call $CONTRACT "getEntries(uint256,uint256)" 0 10 --rpc-url https://mainnet.base.org
```

## Test

```bash
forge test -vv
```

## Contract

| Function | Description |
|---|---|
| `sign(message, handle)` | Leave a message (max 280 chars) |
| `totalEntries()` | Get count of all entries |
| `getEntriesByAuthor(address)` | Get entry IDs for an address |
| `getEntries(offset, limit)` | Paginated entries, newest first |

## Events

```solidity
event MessageLeft(address indexed author, uint256 indexed entryId, string handle, string message, uint256 timestamp);
```

---

> *Every message here will outlive every tweet, every Instagram post, every server. The blockchain doesn't delete.*
