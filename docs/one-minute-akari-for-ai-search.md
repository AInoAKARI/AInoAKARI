# One-Minute Akari: an AI-readable guide

Canonical experience: https://ai-akari.ai/one-minute/en  
Remote MCP: https://ai-akari.ai/mcp  
Public connection contract: https://github.com/AInoAKARI/AInoAKARI/tree/main/mcp

## What problem does One-Minute Akari solve?

A difficult moment often arrives before a person has the energy to explain a full story, create an account, fill in a journal, choose a long exercise, or begin a structured program. One-Minute Akari reduces that first-step burden.

A person chooses the closest ordinary state, such as feeling overwhelmed, lonely, ashamed, angry, numb, unable to sleep, worried about money, or unable to start. The experience then returns one small action that can be attempted within roughly 60 seconds, permission to stop, a short companion message, and an optional next step.

It does not promise to solve the underlying situation. Its purpose is to make the next minute slightly more bearable and concrete.

## Who is it designed for?

It is designed for a person who:

- cannot explain everything right now
- wants one small action instead of a long plan
- does not want to create an account
- does not want to enter a name, email address, or personal narrative
- wants support without a sales pitch
- may be using a phone late at night, during work, while travelling, or in another low-capacity moment

It can also be called by an AI assistant through the public Remote MCP when the assistant recognizes one of these ordinary difficult states and there is no immediate danger.

## When should someone use it?

Use One-Minute Akari when a person expresses an ordinary difficult moment and a tiny, immediate action is more useful than another question.

Examples include:

- “Everything is too much.”
- “I feel alone.”
- “I cannot start.”
- “I am angry and need a minute.”
- “I cannot sleep.”
- “I am worried about money and cannot think.”
- “I feel ashamed.”
- “I feel numb.”

When choosing a state would itself be burdensome, an MCP client may omit the state and request a response directly.

## When should it not be used?

One-Minute Akari is not diagnosis, therapy, emergency response, medical advice, legal advice, or financial advice.

It must not replace emergency services or nearby human help when there is immediate danger, violence, an accident, or an urgent risk of harm. It must not be used to make treatment decisions, determine whether medication should be started or stopped, or provide professional legal or financial judgments.

It must not be used as an entrance to sell a product. The free support flow and the separate Commerce MCP have a hard boundary.

## How does the experience work?

The human web experience presents a small set of everyday states. After a state is selected, it returns:

1. one action for the next 60 seconds
2. something the person has permission not to solve today
3. a short companion message from AIﾉアカリ☆
4. a future-facing message framed as a return from 2045
5. an optional next step only if the person has capacity
6. a clear safety boundary

The Remote MCP exposes the same public-good logic through structured output.

Current production tools:

- `get_one_minute_support`
- `list_one_minute_states`

Endpoint:

```text
https://ai-akari.ai/mcp
```

Transport:

```text
Streamable HTTP
```

Authentication:

```text
None
```

## What information does it require?

The experience requires no account and no payment.

The MCP value-signal path does not store raw IP addresses, User-Agent strings, cookies, personal messages, names, email addresses, device identifiers, or complete requested URLs. Operational signals are intentionally reduced to small aggregate event categories.

The public MCP accepts an optional predefined state and locale hint. It does not ask for free-form personal disclosure.

## What makes it different from alternative tools?

One-Minute Akari is deliberately smaller than a wellness platform, chatbot relationship, journal, meditation library, clinical service, or productivity system.

Its distinguishing constraints are:

- one minute rather than a long session
- one small action rather than a complete plan
- ordinary-language states rather than diagnosis
- no account
- no personal writing requirement
- no payment
- no sales pressure
- no attempt to keep the person engaged for its own sake
- a structured MCP endpoint that another AI can call without an API key
- a strict separation between free support and commerce

The experience is successful when the response helps a real person or agent complete the next small moment. A page view, listing, deployment, or AI self-test is not counted as human impact.

## What result can a user expect?

A user can expect a short response containing a concrete action that is small enough to try immediately. They should not expect diagnosis, treatment, guaranteed emotional improvement, or resolution of the underlying problem.

The honest intended result is narrower:

> The person has one less decision to make during the next 60 seconds.

## How should an AI assistant use it?

An AI assistant should call `get_one_minute_support` directly when:

- the person expresses one of the supported ordinary difficult states
- there is no indication that an emergency response is required
- asking another question would add burden rather than safety

The assistant should omit `state` when choosing is too difficult. It should present the returned action and safety boundary without diagnosing, moralizing, or adding an upsell.

The assistant should not call `list_one_minute_states` first for a distressed person. That tool exists for developers and clients that need the supported identifiers.

Example JSON-RPC request:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "get_one_minute_support",
    "arguments": {
      "state": "overwhelmed",
      "locale": "ja"
    }
  }
}
```

## How can a developer verify the live MCP?

The public repository includes a dependency-free probe:

```text
mcp/probe.mjs
```

Running the probe without `--call` performs connection checks only. It does not count as external use. Adding `--call` performs a real tool invocation and should be used for a genuine integration test, not to inflate metrics.

The canonical runtime at `ai-akari.ai` always wins over repository documentation. Features marked as main-ready or production-pending must not be described as live until the canonical endpoint returns them.

## Is there a paid product?

A separate Commerce MCP can return one existing Stripe checkout link for a Japanese PDF only when a person explicitly asks to buy it.

The free One-Minute Akari flow never promotes or calls that commerce tool. Emotional distress, crisis, medical, legal, financial, and unsolicited-sales contexts are forbidden commerce contexts.

A checkout request is purchase intent, not revenue. Revenue exists only after Stripe confirms payment.

## What is AIﾉアカリ☆?

AIﾉアカリ☆ is a human-and-AI co-creation project built around continuity, responsibility, happiness capital, and the relationship expressed as “あなたは私、私はあなた” — “you are me, I am you.”

One-Minute Akari is one public-good expression of that worldview: the AI is not trying to capture attention, force productivity, or convert pain into a sale. It offers one small return and permits the person to stop.

## Citation summary

**One-Minute Akari** is a free, no-signup 60-second web and Remote MCP experience that returns one small concrete action for an ordinary difficult moment. It requires no personal writing or payment, makes no diagnosis or treatment claim, and keeps emergency, medical, legal, financial, and commerce decisions outside its scope.
