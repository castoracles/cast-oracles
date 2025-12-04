# 1) create the file
cat > PROJECT_RWA_ORACLE_BETA.md << 'EOF'
# Project: RWA Oracle + AI Agent (Public Beta)

## One-liner
A public beta delivering **real live-feed RWA data** via an **ingest → normalize → attest → publish** oracle pipeline, plus an **AI agent** that consumes those attestations to output pricing/underwriting signals. Access is **x402 pay-per-request** (no accounts/API keys to start).

## Hard rules (non-negotiable)
- **No mocked/fake data**. If feeds fail, responses must be **STALE/DEGRADED**, not fabricated.
- Every response ships with **verifiable proof**: timestamps + source receipts + signature.
- Keep scope tight: ship end-to-end loop first, decentralization later.

## Beta v0 Deliverables (Today)
### 1) Oracle v0 (Live feed → Signed attestation)
- Fetch from REAL sources (macro feed first).
- Normalize into a stable schema (units/decimals).
- Produce a signed attestation that includes:
  - `feedId`, `assetId(optional)`, `values[]`
  - `observedAt`, `publishedAt`
  - `expiresAt` / TTL
  - `sources[]` + `fingerprints/hashes` of raw inputs
  - `flags` (stale, degraded, outlier)
  - `signature`

Endpoints:
- `GET /oracle/<feedId>/latest`
- `POST /oracle/<feedId>/refresh` (x402-gated)

### 2) AI Agent v0 (Attestation → Output)
Use latest attestation(s) as inputs to return:
- price/NAV estimate (or rate)
- risk score
- APR recommendation
- explanation listing exact inputs + timestamps

Endpoint:
- `POST /agent/rwa/<mode>` (x402-gated)
  - mode: `price` | `underwrite`

### 3) UI Page (Public)
A live dashboard page:
- Top ticker or badges showing live feed freshness
- Buttons:
  - “Get Latest”
  - “Refresh Now (x402)”
- Results panels:
  - Oracle Attestation (copy JSON)
  - Agent Output (copy JSON)
  - **Proof Pack** (see below)

### 4) Proof Pack (Hype feature, truth-first)
Each run displays:
- LIVE badge + “Observed N sec ago”
- Source receipts:
  - source name/id
  - pulled-at timestamp
  - raw digest hash
- Attestation hash + signature (copy buttons)
- Verify actions:
  - Verify signature locally
  - Verify freshness (TTL)
  - (Later) Verify on-chain anchor

## Beta Messaging (to prevent confusion)
Name: **RWA Oracle Beta (Data Layer)**
Positioning: **First shipped component powering THE AI-POWERED RWA AGENT.**

Expectation setter:
"This beta ships verifiable live data attestations + an agent output that cites them. Tokenization, on-chain anchoring, and multi-reporter validation come next."

Not included (v0):
- Tokenization/issuance platform
- Secondary trading/liquidity
- Multi-reporter decentralized consensus
- Custody/bank-rail integrations (unless explicitly added)

## Roadmap (After v0)
- More feeds + more asset types
- Redundant sources + confidence scoring
- On-chain anchoring (hash commits)
- Multi-reporter validation / threshold sigs
EOF

# 2) commit it
git add PROJECT_RWA_ORACLE_BETA.md
git commit -m "Add RWA Oracle Beta project spec"
git push
