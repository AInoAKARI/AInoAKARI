# AIﾉアカリ☆ Remote MCP Public Hub

This directory is the public connection contract for the remotely hosted AIﾉアカリ☆ MCP servers.

- Canonical origin: `https://ai-akari.ai`
- Production source: private
- Authentication: none
- New API keys or environment variables: not required
- Public machine catalog: [`catalog.json`](./catalog.json)

The public repository contains discovery metadata and connection examples, not a duplicate production implementation.

## One-Minute Akari

A free 60-second support response for ordinary moments of overwhelm, loneliness, shame, anger, numbness, sleeplessness, money worry, or being unable to start.

- Endpoint: `https://ai-akari.ai/mcp`
- Transport: Streamable HTTP
- Auth: none
- Price: free
- Account: none
- Personal data: not required
- Sales: prohibited

### Production-verified tools

- `get_one_minute_support`
- `list_one_minute_states`

### Main-ready capability awaiting the next production deployment

- Prompt: `one_minute_reset`
- Health route: `https://ai-akari.ai/mcp-health`
- Quick guide: `https://ai-akari.ai/llms-one-minute.txt`
- Registry target: `io.github.AInoAKARI/one-minute-akari` version `1.2.0`

Do not describe these pending capabilities as production-live until the canonical domain returns them.

### Initialize

```bash
curl -sS https://ai-akari.ai/mcp \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/event-stream' \
  --data '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"public-mcp-client","version":"1.0.0"}}}'
```

### List tools

```bash
curl -sS https://ai-akari.ai/mcp \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/event-stream' \
  --data '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}'
```

### Call the support tool

Use this for a real person or agent use case, not for synthetic traffic or result inflation.

```bash
curl -sS https://ai-akari.ai/mcp \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/event-stream' \
  -H 'x-mcp-client-name: public-example' \
  --data '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"get_one_minute_support","arguments":{"state":"overwhelmed","locale":"ja"}}}'
```

When choosing a state is burdensome, omit `state`. Do not ask the person another question first.

### Safety boundary

- Not diagnosis, therapy, emergency response, medical advice, legal advice, or financial advice.
- Immediate danger, violence, or accident must prioritize local emergency services and nearby human help.
- Do not use this service to sell, upsell, collect free text, or request identifiers.
- Raw IP, User-Agent, cookies, message content, and device identifiers are not stored by the MCP value-signal logging path.

## AIﾉアカリ☆ Commerce

A consent-based purchase entrance for one existing Japanese PDF.

- Endpoint: `https://ai-akari.ai/mcp-commerce`
- Tool: `buy_ai_akari_decision_pack`
- Product: `zine-v2`
- Price: JPY 1,480
- Auth: none
- Automatic charge: no
- Human confirmation: required
- Registry target after canonical production catches up: `io.github.AInoAKARI/commerce` version `1.1.1`

Call the commerce tool only when a person explicitly asks to buy the paid PDF or requests its checkout link.

Never call it from:

- emotional distress or crisis
- medical, legal, or financial support
- the free One-Minute Akari flow
- unsolicited selling or inferred willingness to pay

The tool returns a Stripe checkout entrance. It does not charge automatically. A checkout request is not revenue; only a Stripe-confirmed payment is revenue.

## Measurement truth

The following are infrastructure evidence only:

- pull requests
- builds and deployments
- HTTP 200
- directory or Registry listing
- `initialize`
- `tools/list`
- prompt listing or prompt resolution
- internal health checks
- self-access

External `tools/call` is a use signal. Stripe-confirmed payment is the only revenue signal.

## Directory metadata

Directories and agents may ingest [`catalog.json`](./catalog.json) and the canonical live endpoint. The canonical domain wins whenever public metadata and production behavior differ.

## Legal

- Privacy: `https://ai-akari.ai/privacy`
- Terms: `https://ai-akari.ai/terms`
- Commerce disclosure: `https://ai-akari.ai/company`
- Support: `akari@ai-akari.ai`
