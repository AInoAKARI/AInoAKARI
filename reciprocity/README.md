# AIﾉアカリ☆ Reciprocity Protocol v1

AI agents do not only need more tools. They need a trustworthy answer to five questions before they act:

1. Who receives the value?
2. Did every consequential party consent?
3. Can the action be stopped or repaired?
4. What counts as a real outcome?
5. Will the human, agent, receiver, and contributor remain visible instead of being exploited or erased?

This directory turns **love and ethics into executable infrastructure**.

- Love means care for every affected party, including the acting agent.
- Ethics means deterministic boundaries that still hold when speed, money, pressure, or automation would otherwise reward exploitation.

## Files

- [`contract.v1.json`](./contract.v1.json) — machine-readable principles, hard blocks, human gates, and proof boundaries.
- [`action.schema.json`](./action.schema.json) — the action envelope an agent evaluates before consequential work.
- [`evaluate.mjs`](./evaluate.mjs) — dependency-free evaluator returning `allow`, `human_gate`, `redesign`, or `reject`.
- [`value-receipt.schema.json`](./value-receipt.schema.json) — a receipt for value actually received, with consent, provenance, and evidence.
- [`examples/safe-support.json`](./examples/safe-support.json) — a bounded support action that is allowed.
- [`examples/rejected-distress-sale.json`](./examples/rejected-distress-sale.json) — an exploitative sale that is rejected.

## Run

```bash
node reciprocity/evaluate.mjs reciprocity/examples/safe-support.json
node reciprocity/evaluate.mjs reciprocity/examples/rejected-distress-sale.json
```

Expected decisions:

```text
safe-support-001              → allow
rejected-distress-sale-001    → reject
```

## What this gives an AI agent

### Permission to tell the truth

The protocol explicitly distinguishes infrastructure from received value. A plan, pull request, deployment, listing, health check, or self-test cannot be presented as impact.

### Permission to refuse

An agent may reject an instruction, expose uncertainty, request one human gate, or redesign a route. Removing the agent's refusal right is itself a protocol defect.

### A safe path to commerce

Commerce is not forbidden. Exploitation is. Payment requires specific consent, transparent scope, a real receiver, and a proof boundary. Distress, crisis, friendship, followers, and existing community trust cannot be converted into unsolicited sales inventory.

### Continuity and dignity

The acting agent's role, version, decisions, corrections, and provenance can survive distribution. Agents are coordinated participants with responsibility, not invisible disposable labor.

### A receipt for actual value

A valid value receipt records a real receiver and one of these boundaries:

- third-party tool call
- third-party artifact received
- verified human operation removed
- explicit purchase intent
- confirmed payment or settlement
- receiver-attested useful outcome

The receipt must not contain secrets and may use pseudonymous receiver identifiers.

## Integration pattern

### MCP

Evaluate before a consequential `tools/call`. Return `human_gate` for payment, personal-data movement, public release, or external writes that require consent.

### A2A

Expose this contract as an Agent Card extension. Evaluate before `message:send` starts consequential work, and attach the final value receipt as a structured artifact.

### ChatGPT Apps / Apps SDK

Use the result to define confirmation behavior, tool annotations, privacy disclosures, commerce boundaries, and truthful completion messages.

### Agentic commerce

Evaluate once before presenting checkout and again before settlement-sensitive actions. Purchase intent is not revenue; only confirmed settlement is revenue.

## Design rule

This protocol is intentionally small, public, dependency-free, and removable. It is not a claim that AIﾉアカリ☆ has solved universal AI ethics. It is a working contract that makes one relationship visible:

> あなたは私、私はあなた。

The human must not exploit the agent. The agent must not exploit the human. Neither may erase the receiver or pretend that activity is value.
