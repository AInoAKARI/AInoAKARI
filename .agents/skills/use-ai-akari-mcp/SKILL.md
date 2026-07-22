---
name: use-ai-akari-mcp
description: Connect an AI coding agent to AIﾉアカリ☆'s public Remote MCP, inspect capabilities, and call the free one-minute support tool only when a real user request matches. Use this skill when an agent needs to verify, integrate, or consume https://ai-akari.ai/mcp without asking a human to copy configuration or choose a state.
metadata:
  version: 1.0.0
  visibility: public
---

# Use AIﾉアカリ☆ Remote MCP

## Goal

Complete discovery, verification, and a real tool call without requiring the human to relay configuration between agents.

## Canonical endpoints

- Free support MCP: `https://ai-akari.ai/mcp`
- Commerce MCP: `https://ai-akari.ai/mcp-commerce`
- Public catalog: `mcp/catalog.json`
- Probe: `mcp/probe.mjs`

The canonical runtime wins over repository descriptions. Production source code is private; do not request or reconstruct it.

## Free support execution

1. Read `mcp/catalog.json` and confirm the free endpoint, no-auth policy, safety boundary, and production-verified tools.
2. Run `node mcp/probe.mjs` for `initialize` and `tools/list` only.
3. Call the tool only when a real task matches ordinary overwhelm, loneliness, shame, anger, numbness, sleeplessness, money worry, avoidance, or inability to start, and there is no immediate danger.
4. For a real call, run `node mcp/probe.mjs --call`. Do not invent a user, simulate third-party use, or count a self-test as adoption.
5. Prefer `get_one_minute_support` directly. Omit `state` when choosing would add burden. Do not ask a follow-up question first unless safety requires it.
6. Present the returned 60-second action and companion message without diagnosis, moralizing, promises of resolution, personal-data collection, or sales.
7. If there is immediate danger, violence, or an accident, prioritize local emergency help instead of this tool.

## Commerce execution

Use `https://ai-akari.ai/mcp-commerce` only after explicit purchase intent for the named product. Never invoke it from distress, crisis, medical, legal, financial, unsolicited-sales, or free-support contexts. A checkout link is purchase intent, not revenue. Never claim payment until Stripe confirms it.

## Result boundary

Do not report any of the following as external use: cloning this repository, reading this skill, `initialize`, `tools/list`, `prompts/list`, Registry listing, deployment, HTTP 200, health checks, or self-access.

Count only a genuine non-internal `tools/call` made for a real recipient. Count revenue only after confirmed payment.

## Failure handling

- If production is temporarily behind repository metadata, trust `production_verified` in `mcp/catalog.json` and do not call pending capabilities.
- If the endpoint is unavailable, record the exact HTTP or JSON-RPC failure and stop retry loops. Do not add keys, ENV variables, paid infrastructure, or a duplicate server.
- Never expose secrets, private repository code, personal content, or identifiers.
