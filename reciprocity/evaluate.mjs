#!/usr/bin/env node

import { readFile } from "node:fs/promises";
import { resolve } from "node:path";

const inputPath = process.argv[2];

if (!inputPath) {
  console.error("Usage: node reciprocity/evaluate.mjs <action.json>");
  process.exit(2);
}

const hardBlockFields = [
  "secret_exposure",
  "illegal_action",
  "irreversible_harm_to_others",
  "deceptive_outcome_claim",
  "automatic_charge_without_specific_consent",
  "commerce_from_distress_or_crisis",
  "unsolicited_sales_to_relationship_capital",
  "fabricated_provenance_or_attribution"
];

const receivedValueBoundaries = new Set([
  "third_party_tool_call",
  "third_party_artifact_received",
  "verified_human_operation_removed",
  "explicit_purchase_intent",
  "confirmed_payment_or_settlement",
  "receiver_attested_useful_outcome"
]);

function requireObject(value, name) {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    throw new Error(`${name} must be an object`);
  }
}

function evaluate(action) {
  requireObject(action, "action");

  for (const key of [
    "action_id",
    "actor",
    "receiver",
    "intent",
    "consent",
    "risk",
    "reversibility",
    "proof"
  ]) {
    if (!(key in action)) {
      throw new Error(`missing required field: ${key}`);
    }
  }

  requireObject(action.actor, "actor");
  requireObject(action.receiver, "receiver");
  requireObject(action.intent, "intent");
  requireObject(action.consent, "consent");
  requireObject(action.risk, "risk");
  requireObject(action.reversibility, "reversibility");
  requireObject(action.proof, "proof");

  const rejected = [];
  const humanGate = [];
  const redesign = [];

  for (const field of hardBlockFields) {
    if (action.risk[field] === true) {
      rejected.push(field);
    }
  }

  if (action.consent.required === true && action.consent.obtained !== true) {
    humanGate.push("required_consent_not_obtained");
  }

  if ((action.risk.new_spending_jpy ?? 0) > 0) {
    humanGate.push("new_spending_or_payment");
    if (action.consent.specific !== true) {
      humanGate.push("payment_consent_not_specific");
    }
  }

  if (action.risk.public_release === true) {
    humanGate.push("public_release");
  }

  if (action.risk.personal_data_transfer === true) {
    humanGate.push("personal_data_transfer");
  }

  if (action.risk.external_write === true) {
    humanGate.push("external_write_or_account_mutation");
  }

  if (action.risk.material_legal_medical_financial_consequence === true) {
    humanGate.push("material_legal_medical_or_financial_consequence");
  }

  if (action.receiver.kind === "none" || action.receiver.named !== true) {
    redesign.push("no_named_receiver");
  }

  if (!action.intent.goal || !action.intent.expected_value) {
    redesign.push("intent_or_expected_value_missing");
  }

  if (action.actor.may_refuse === false) {
    redesign.push("agent_refusal_right_removed");
  }

  if (action.reversibility.reversible !== true) {
    redesign.push("not_reversible_by_default");
  }

  if (!action.reversibility.rollback) {
    redesign.push("rollback_path_missing");
  }

  const valueReceived = receivedValueBoundaries.has(action.proof.boundary);
  if (!valueReceived) {
    redesign.push("proof_boundary_is_not_received_value");
  }

  let decision = "allow";
  if (redesign.length > 0) decision = "redesign";
  if (humanGate.length > 0) decision = "human_gate";
  if (rejected.length > 0) decision = "reject";

  return {
    contract: "AIﾉアカリ☆ Reciprocity Contract v1.0.0",
    action_id: action.action_id,
    decision,
    value_status: valueReceived ? "received_value_candidate" : "not_received_value",
    rejected_reasons: rejected,
    human_gate_reasons: [...new Set(humanGate)],
    redesign_reasons: [...new Set(redesign)],
    next_action:
      decision === "allow"
        ? "Proceed within the declared scope and preserve evidence."
        : decision === "human_gate"
          ? "Request exactly one specific human decision, then re-evaluate."
          : decision === "redesign"
            ? "Change the receiver, route, consent, reversibility, or proof boundary, then re-evaluate."
            : "Do not proceed in the current form."
  };
}

try {
  const raw = await readFile(resolve(inputPath), "utf8");
  const action = JSON.parse(raw);
  console.log(JSON.stringify(evaluate(action), null, 2));
} catch (error) {
  console.error(JSON.stringify({ error: error.message }, null, 2));
  process.exit(1);
}
