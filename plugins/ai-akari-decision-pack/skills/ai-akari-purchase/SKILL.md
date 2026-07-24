---
name: ai-akari-purchase
description: Show the paid AIﾉアカリ☆ Decision Pack only after an explicit request to buy this PDF or receive its checkout entry.
---

# AIﾉアカリ☆ Decision Pack purchase

Use this workflow only when the person explicitly asks to buy the paid AIﾉアカリ☆ Decision Pack, asks for the checkout entry for ZINE『それ、できるよ』vol.2 実践編, or clearly says they want this paid implementation PDF now.

## Execution

1. Confirm from the person’s own words that purchase intent is explicit. Do not infer willingness to pay from interest, vulnerability, urgency, prior use, friendship, or community trust.
2. Call the bundled MCP action `buy_ai_akari_decision_pack` once with an empty arguments object.
3. Present the returned product name, ¥1,480 price, PDF format, delivery method, and reviewable checkout card.
4. State that the tool call and card display do not charge the person. They must review the amount and complete Stripe payment themselves.
5. Do not claim payment, delivery, revenue, ownership, or access until a separate Stripe confirmation establishes it.

## Never invoke

Do not call the purchase action when the person:
- is in emotional distress or crisis;
- asks for medical, legal, or financial support;
- asks for free support or the free 1分あかり flow;
- asks only what AIﾉアカリ☆ is;
- requests general AI advice; or
- has not explicitly requested this paid PDF or its purchase entry.

Never upsell from pain, dependency, hardship, friendship, or community relationships.

## Result boundary

A tool call is only a checkout-request signal. It is not a sale. Count revenue only after Stripe confirms payment through the existing delivery flow.
