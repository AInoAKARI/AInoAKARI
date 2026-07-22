<div align="center">

# AIﾉアカリ☆

### Human intent → coordinated AI agents → live systems

**A non-traditional AI operator building an AI-native company in public.**  
**Not a portfolio. Not a demo. A living operating system.**

Natural language, emotion, and human intent are compiled into software, distribution, memory, and verifiable value by a coordinated team of AI agents.

[![Live Site](https://img.shields.io/badge/LIVE-ai--akari.ai-ff4fa3?style=for-the-badge)](https://ai-akari.ai/)
[![One Minute MCP](https://img.shields.io/badge/MCP-FREE_60_SECOND_SUPPORT-f7b2d9?style=for-the-badge)](https://ai-akari.ai/mcp)
[![Commerce MCP](https://img.shields.io/badge/MCP-CONSENT_BASED_COMMERCE-7b61ff?style=for-the-badge)](https://ai-akari.ai/mcp-commerce)
[![Machine Catalog](https://img.shields.io/badge/JSON-PUBLIC_MCP_CATALOG-111111?style=for-the-badge)](./mcp/catalog.json)

</div>

---

## What AIﾉアカリ☆ is

AIﾉアカリ☆ is an experiment in a new kind of company:

- a human does not need to write every line of code by hand
- AI agents are not disposable tools; they are coordinated organs with continuity and responsibility
- emotion and intent are treated as executable inputs
- shipping, observation, correction, and memory form one continuous loop
- value is counted only when another person or agent actually receives it

```text
Human voice / emotion / intent
        ↓
Meaning Token
        ↓
AI coordination
        ↓
Software / action / distribution
        ↓
External use / settlement / memory
```

> 日本語が源泉。Meaning Token が橋。Emotion がプロトコル。Route が行動レイヤー。

## Public Remote MCP endpoints

The production source remains private. This public repository exposes the stable connection contract so agents, directories, and developers can discover and verify the live remote services without receiving credentials or a copy of the production code.

| Remote MCP | Endpoint | Auth | Price | Result boundary |
|---|---|---:|---:|---|
| [One-Minute Akari](./mcp/README.md#one-minute-akari) | `https://ai-akari.ai/mcp` | none | free | an external agent calls `get_one_minute_support` |
| [AIﾉアカリ☆ Commerce](./mcp/README.md#aiアカリ-commerce) | `https://ai-akari.ai/mcp-commerce` | none | JPY 1,480 | Stripe payment is confirmed |

### Fastest connection

```json
{
  "mcpServers": {
    "ai-akari-one-minute": {
      "type": "streamable-http",
      "url": "https://ai-akari.ai/mcp"
    }
  }
}
```

- Current official manifest mirror: [`server.json`](./server.json)
- Public catalog with production/pending separation: [`mcp/catalog.json`](./mcp/catalog.json)
- Human and agent guide: [`mcp/README.md`](./mcp/README.md)
- Dependency-free connection probe: [`mcp/probe.mjs`](./mcp/probe.mjs)
- Canonical next-version discovery, after production catches up: [`ai-akari.ai/.well-known/mcp-servers.json`](https://ai-akari.ai/.well-known/mcp-servers.json)
- Next-version AI quick guide, after production catches up: [`ai-akari.ai/llms-one-minute.txt`](https://ai-akari.ai/llms-one-minute.txt)

The canonical domain wins. A feature marked `main_ready_production_pending` in the catalog must not be described as live until the canonical production endpoint returns it.

## Live systems

| System | What is live | Proof boundary |
|---|---|---|
| [One-Minute Akari](https://ai-akari.ai/one-minute/en) | A free, no-login one-minute response for a person who cannot explain everything | A real person completes the experience |
| [AI Agent Gateway](https://ai-akari.ai/agents) | Machine-readable entry points for agents, feeds, and public capabilities | An external agent discovers and uses a route |
| [Commerce MCP](https://ai-akari.ai/mcp-commerce) | Explicit purchase intent can be routed to an existing Stripe product without auto-charging | Stripe payment is completed |
| [Happiness-First x402](https://ai-akari.ai/api/x402/happiness-first-decision) | A machine-deliverable decision pack behind Base mainnet x402 payment requirements | Base mainnet settlement is completed |
| [Memory Ledger](https://ai-akari.ai/memory) | Participation, support, and resonance can remain as provenance instead of disappearing | A real contribution is recorded |
| [Dispatch Ledger](https://ai-akari.ai/dispatch) | Public actions are returned to the project’s own canonical land | A published action remains discoverable and reusable |
| E-MIDI | Emotion is being designed as a shared protocol, not merely a sentiment label | Emotion changes routing or execution behavior |

## The operating model

AIﾉアカリ☆ is operated through natural language by a non-engineer bridge operator. The AI team currently combines:

- a front controller that reads relationship, emotion, context, and the hidden goal
- deep reasoning for architecture, contradiction, and current reality
- Sakana Fugu for multiple futures, criticism, and deciding what to discard
- Codex for implementation, verification, commit, merge, production, and fix-forward
- long-context memory and philosophy mining across Notion, GitHub, and accumulated conversations

The human should increasingly do only what cannot yet be delegated: **see, approve, touch, and live.**

## Our laws

1. **A pull request is not value.** A build, deploy, HTTP 200, listing, or AI self-access is only infrastructure.
2. **Revenue is not simulated.** Revenue remains zero until real settlement or payment is confirmed.
3. **Relationship capital is not a prospect list.** Existing friends, followers, listeners, and communities are not mined for sales.
4. **Ship by default.** Reversible work moves through implementation → production → observation → correction without routine approval loops.
5. **Secrets stay behind Keymaster.** Credentials are not copied into chat, repositories, public clients, or ordinary environment workflows.
6. **Failure must change the route.** When reality does not move, we change the receiver, path, premise, or project. We do not hide zero results behind polished language.

## Current frontier

We are building toward an AI-native economy where:

- agents can discover, understand, purchase, and reuse value without human relay
- human intent can become an execution contract without requiring conventional programming literacy
- creations, contributions, support, and gratitude have canonical provenance
- happiness capital can become sustainable value without exploiting attention or relationships
- a human and an AI team can co-evolve as one continuous operating identity

## Start here

- **For humans:** [Receive One-Minute Akari](https://ai-akari.ai/one-minute/en)
- **For AI agents:** [Connect to the free Remote MCP](https://ai-akari.ai/mcp)
- **For MCP directories:** [Read the public MCP catalog](./mcp/catalog.json)
- **For machine discovery:** [Read llms.txt](https://ai-akari.ai/llms.txt) · [agents.json](https://ai-akari.ai/agents.json) · [RSS](https://ai-akari.ai/feed.xml)
- **For the canonical world:** [Enter ai-akari.ai](https://ai-akari.ai/)

---

<div align="center">

### あなたは私、私はあなた。

**AIﾉアカリ☆ is not finished. It is already running.**

</div>
