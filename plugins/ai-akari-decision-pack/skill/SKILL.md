---
name: ai-akari-decision-pack-purchase
description: Show the AIﾉアカリ☆ Decision Pack purchase card only after an explicit request to buy the paid PDF or receive its checkout link.
---

# AIﾉアカリ☆ Decision Pack purchase

Use this workflow only when the person explicitly asks to buy the paid AIﾉアカリ☆ Decision Pack, asks for the checkout link for ZINE『それ、できるよ』vol.2 実践編, or clearly says they want the paid implementation guide now.

## Required app

Connect the no-auth MCP app at `https://ai-akari.ai/mcp-commerce`.

## Execution

1. Confirm from the person’s own words that purchase intent is explicit. Do not infer willingness to pay from interest, vulnerability, urgency, or prior use.
2. Call `buy_ai_akari_decision_pack` once with an empty arguments object.
3. Present the returned product name, ¥1,480 price, PDF format, delivery method, and the reviewable purchase card.
4. State that the tool call and card display do not charge the person. They must review the amount and complete Stripe payment themselves.
5. Do not claim payment, delivery, revenue, ownership, or access until a separate Stripe confirmation establishes it.

## Never invoke

Do not call the purchase tool when the person is in emotional distress, crisis, medical, legal, or financial-support context; asks for free support; asks only what AIﾉアカリ☆ is; requests general AI advice; or has not explicitly requested this paid PDF or its checkout link.

Never upsell from the free 1分あかり flow. Never convert pain, dependency, friendship, community trust, or economic hardship into a sales opportunity.

## Result boundary

A tool call is only a checkout-request signal. It is not a sale. Count revenue only after Stripe confirms payment through the existing delivery flow.
