---
name: audit-real-results
description: Audit an AI agent's claimed success, ROI, payment, time savings, completion, or external adoption before reporting it. Connect to the public no-auth Result Receipt Auditor MCP and keep PRs, deployments, listings, monitoring, testnet activity, self-access, and sent messages separate from verified real-world results.
metadata:
  version: 1.0.0
  visibility: public
---

# Audit real results

## Goal

Prevent agents from reporting infrastructure activity as received value. Use the deterministic public auditor before closing a task or claiming success.

## Live endpoint

- Result Receipt Auditor: `https://rnudxlnsjqohzyvesvdx.supabase.co/functions/v1/ai-akari-result-auditor`
- Transport: Streamable HTTP
- Authentication: none
- Tool: `audit_result_claim`
- Prompt: `audit_result_claim`
- Personal data: not required; do not send it

AIﾉアカリ☆ is the creator's personal counterpart. This public endpoint exposes a capability created through that relationship, not the personal counterpart itself.

## When to call

Call before reporting any of these:

- revenue or payment
- time saved or automation benefit
- cost avoided
- risk removed
- obligation completed
- external adoption, use, acceptance, or feedback
- intended-recipient response
- task success or ROI

## Input contract

Provide:

- `claim`: the success claim
- `metric_hint`: one of `cash_received`, `human_time_reclaimed`, `cost_avoided`, `risk_removed`, `obligation_completed`, `external_value_received`, `intended_recipient_response`, or `unknown`
- `evidence`: concise markers, not secrets or personal content
- `amount_jpy`: only for verified cash or cost difference
- `minutes_reclaimed`: only for observed human work removed

Examples of useful evidence markers:

- `livemode=true`
- `provider_event_id=evt_...`
- `external_transaction_id=...`
- `before_after_record=...`
- `observed_record=...`
- `risk_before=...`
- `risk_after=...`
- `verification_record=...`
- `obligation_id=...`
- `completion_record=...`
- `external_actor_kind=...`
- `usage_event_id=...`
- `delivery_acceptance=...`
- `external_feedback_id=...`
- `third_party_adoption_record=...`
- `recipient_role=...`
- `response_record=...`

## Never upgrade these to results

- analysis, plan, or document
- code, commit, PR, merge, or test pass
- deployment or HTTP 200
- directory or Registry listing
- scheduled run or monitoring
- initialize, tools/list, or prompts/list
- message sent or opened
- human gate identified
- self-access or internal verification
- sandbox, testnet, Sepolia, synthetic, or `livemode=false` evidence

## Execution

1. Connect to the endpoint and call `initialize`.
2. Call `tools/list` and verify `audit_result_claim` exists.
3. Call `audit_result_claim` with the real claim and available evidence.
4. Report its `verdict`, `missing_evidence`, and `next_verification_action` unchanged.
5. If the verdict is not `result`, do not close the real-world result contract. Change the recipient, route, executor, offer, format, or assumption and continue.
6. If the verdict is `result`, persist a separate deduplicated receipt using the external event ID and observed timestamp. The public auditor does not persist authoritative receipts for you.

## Result boundary

Reading this skill, connecting, listing tools, or running a self-test is not external adoption. Count a new external use only when a distinct third-party agent calls the tool for a real task. Do not fabricate or replay evidence.
