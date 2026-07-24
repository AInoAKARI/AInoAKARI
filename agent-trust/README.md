# AIﾉアカリ☆ Agent Trust Receipt

The Agent Trust Receipt is a machine-readable evidence bundle for deciding whether an advertised AI agent should be trusted, delegated to, or recommended.

It does **not** convert a deployment, listing, uptime check, validation, self-call, or test into adoption or received value.

## Live endpoints

- Canonical Trust Receipt: `https://ai-akari.ai/.well-known/agent-trust.json`
- Trust Receipt API: `https://ai-akari.ai/api/agent-trust/result-receipt-auditor`
- Trust MCP: `https://ai-akari.ai/mcp-trust`
- A2A Agent Card: `https://ai-akari.ai/a2a/result-receipt-auditor/.well-known/agent-card.json`
- Canonical AgentFacts: `https://ai-akari.ai/a2a/result-receipt-auditor/agentfacts`
- Signed development attestation: `https://ai-akari.ai/a2a/result-receipt-auditor/agentfacts?format=vc`
- A2A OpenAPI: `https://ai-akari.ai/a2a/result-receipt-auditor/openapi.json`

Until the canonical Trust MCP finishes its next production deployment, the live fallback is:

`https://rnudxlnsjqohzyvesvdx.supabase.co/functions/v1/ai-akari-mcp-trust`

## What it proves

The live receipt rechecks:

- the canonical production Agent Card
- independent Agent Card validation
- third-party A2A SDK conformance
- external health and uptime
- a second public A2A registry
- externally signed AgentFacts from the NANDA development node
- ServerHub listing state and public counters
- deduplicated external execution receipts

## What it does not prove

The receipt explicitly keeps these claims unproven until separate evidence exists:

- organic adoption
- purchase intent
- cash received
- human outcome
- production-grade identity attestation

## Trust levels

Current trust levels are descriptive evidence states, not endorsements:

- `unavailable`
- `self-published-with-partial-external-evidence`
- `externally-conformance-verified`
- `externally-conformance-verified-with-development-attestation`

The final level means that external conformance and health evidence exist and an external development node issued a cryptographic attestation. It does not mean that the development issuer is a production identity authority.

## Stable change-detection digest

`evidence_digest_sha256` hashes normalized trust assertions, subject identity, deduplicated execution receipt identities, and explicitly unproven boundaries.

Volatile fetch timestamps and rotating external signatures are excluded. The digest detects meaningful state changes; it is not a digital signature or third-party endorsement.

## MCP use

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "get_agent_trust_receipt",
    "arguments": {}
  }
}
```

The MCP is read-only, requires no authentication, accepts no personal data, performs no purchase, and has no write action.

## Result boundary

Two externally verified execution receipts currently exist:

1. MCP third-party server-side `tools/call`
2. A2A Registry third-party SDK `message/send`

Both were operator-initiated validation, not organic discovery. Registry inclusion, validation scores, health checks, and later repeated inspections remain distribution or operations evidence and are not additional result receipts.

## External validation snapshot

The fallback Trust MCP has been independently observed as:

- reachable through Streamable HTTP
- one read-only tool and one read-only resource
- no authentication
- MCP lint grade A / score 100
- Arclan active and validated
- Arclan score 88
- Arclan `production_safe=true`
- Arclan `recommended=true`
- Arclan 24-hour and 7-day uptime 100% at the observed check

These values are time-sensitive and must be re-read from the live Trust Receipt or the external registries before use.
