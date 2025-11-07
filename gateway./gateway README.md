## Endpoints
- `GET /v0/sports/finalScore?league=NBA&gameId=LAL-BOS-2025-01-01`
  - First call → **402** with invoice (PaymentHub + invoiceId + amountWei)
  - Pay `PaymentHub.pay(invoiceId)` with value=amountWei on BNB Testnet
  - Retry with `?invoiceId=<same>&amountWei=<same>` → returns data + s402

See `../docs/API.md` for details.
