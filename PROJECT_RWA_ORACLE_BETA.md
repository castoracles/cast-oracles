# RWA Oracle + AI Agent — Public Beta (v0)

## What this is (in one sentence)
A production-minded **ingest → normalize → attest → publish** pipeline that delivers **real live-feed RWA data** as **signed, verifiable attestations**, plus an **AI agent** that consumes those attestations to produce pricing/underwriting outputs — accessible via **x402 pay-per-request** (no accounts or API keys required to start).

> Note: This beta is the **data oracle + agent outputs**. It is **not** a full tokenization/issuance platform or a secondary trading venue.

---

## Core principles
- **No fake data.** If a live source is unavailable, outputs are labeled **DEGRADED/STALE** — we do not fabricate.
- **Verifiable by default.** Every response includes timestamps, source receipts/fingerprints, and a signature.
- **Simple first.** Ship a single end-to-end vertical slice, then expand feeds, redundancy, and on-chain features.
- **Developer-first.** Clean schemas, predictable endpoints, copyable examples, easy local verification.

---

## What users get in the Beta (v0)
### 1) Signed oracle attestations
Each attestation is:
- **Timestamped** (observed + published)
- **Tamper-evident** (signed payload)
- **Traceable** (source receipts + raw digests/hashes)

Typical attestation fields:
- `feedId` and optional `assetId`
- `values[]` (normalized numbers + decimals/units)
- `observedAt` (when data was pulled)
- `publishedAt` (when attestation was produced)
- `expiresAt` or `ttlSeconds` (freshness window)
- `sources[]` (provider IDs + receipt metadata)
- `rawDigests[]` (hashes/fingerprints of raw inputs)
- `flags` (stale/degraded/outlier)
- `signature` (verifiable signature over the canonical payload)

### 2) Freshness + staleness checks
The system explicitly communicates:
- how fresh the data is (`now - observedAt`)
- when it expires (TTL)
- whether the response is **FRESH**, **STALE**, or **DEGRADED**

### 3) x402 access (pay-per-request)
- Paid requests unlock refreshes, higher rate limits, and premium endpoints
- No accounts/API keys required to start

### 4) Simple endpoints
- Pull the latest attestation
- Request a fresh update when needed
- Pull an AI agent output that cites the underlying attestation inputs

---

## Beta v0 deliverables (build scope)
### A) Oracle v0 (Live feed → Signed attestation)
**Goal:** One or more real live feeds packaged as verifiable attestations.

Endpoints (example shape):
- `GET  /oracle/<feedId>/latest`
- `POST /oracle/<feedId>/refresh` *(x402-gated)*

Behavior:
- Fetch from real sources (macro first)
- Normalize to stable schema (units/decimals)
- Produce signed attestation
- Cache latest attestation for fast reads

### B) AI Agent v0 (Attestation → Output)
**Goal:** A single agent endpoint that returns a pricing/risk output and references the exact attestation used.

Endpoints (example shape):
- `POST /agent/rwa/price` *(x402-gated)*
- `POST /agent/rwa/underwrite` *(optional, x402-gated)*

AI response includes:
- `priceEstimate` or `navEstimate` (or `rateEstimate`)
- `riskScore`
- `aprRecommendation`
- `explanation` referencing:
  - source attestation IDs/hashes
  - timestamps
  - key inputs used

### C) Public UI page (beta dashboard)
A single page that shows:
- Live feed freshness (“Observed N seconds ago”)
- Buttons:
  - **Get Latest**
  - **Refresh Now (x402)**
- Panels:
  - Latest attestation (copy JSON)
  - Agent output (copy JSON)
  - Proof Pack (below)

### D) Proof Pack (the “trust layer”)
Each run shows a proof bundle:
- LIVE badge + observed/published timestamps
- Source receipts (provider, pulled-at time, raw digest)
- Canonical attestation hash + signature (copy buttons)
- Verification actions:
  - Verify signature locally
  - Verify TTL/freshness
  - *(Later)* verify on-chain anchoring

---

## What this beta is NOT (v0)
To avoid mismatched expectations:
- Not a tokenization/issuance platform (yet)
- Not secondary trading/liquidity
- Not decentralized oracle consensus (multi-reporter) in v0
- Not custody/banking rails in v0 (unless explicitly integrated)

---

## Public messaging (avoid confusion)
### Name
**RWA Oracle Beta (Data Layer)**

### Positioning
First shipped component powering the broader:
**AI-Powered RWA Agent**

### One-line expectation setter
“This beta ships verifiable live data attestations + an agent output that cites them. Tokenization, on-chain anchoring, and multi-reporter validation come next.”

---

## Roadmap (post-v0)
- More feeds + more asset types
- Redundant sources + stronger confidence scoring
- On-chain anchoring (attestation hash commits)
- Multi-reporter validation / threshold signatures
- Monitoring/SLA indicators (health, cadence, staleness)
- Consumer SDKs (verify signatures + freshness in one call)

---

## Implementation notes (high-level)
- Always store an immutable event log:
  request → payment → source receipts → attestation hash → response hash
- If any live feed fails:
  set `flags.degraded = true`, keep last known attestation, and never fabricate “fresh”
- Provide a minimal verification snippet in docs (verify signature + TTL)

