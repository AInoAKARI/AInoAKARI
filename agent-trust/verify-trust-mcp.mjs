const endpoint =
  process.env.TRUST_MCP_ENDPOINT ??
  "https://rnudxlnsjqohzyvesvdx.supabase.co/functions/v1/ai-akari-mcp-trust";
const repository = process.env.GITHUB_REPOSITORY;
const token = process.env.GITHUB_TOKEN;
const runId = process.env.GITHUB_RUN_ID;
const runAttempt = process.env.GITHUB_RUN_ATTEMPT ?? "1";
const serverUrl = process.env.GITHUB_SERVER_URL ?? "https://github.com";
const runUrl = `${serverUrl}/${repository}/actions/runs/${runId}`;
const ledgerPr = 24;
const usageEventId = `github_actions_trust_call:${runId}:${runAttempt}`;

if (!repository || !token || !runId) {
  throw new Error("GitHub Actions context is incomplete.");
}

async function rpc(id, method, params = {}) {
  const response = await fetch(endpoint, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      accept: "application/json, text/event-stream",
      "mcp-protocol-version": "2025-06-18",
      "x-mcp-client-name": "github-actions-agent-trust-verifier",
      "x-akari-external-run-id": usageEventId,
    },
    body: JSON.stringify({ jsonrpc: "2.0", id, method, params }),
  });
  const text = await response.text();
  if (!response.ok) {
    throw new Error(`${method} returned HTTP ${response.status}: ${text.slice(0, 500)}`);
  }
  const payload = JSON.parse(text);
  if (payload.error) {
    throw new Error(`${method} returned JSON-RPC error ${JSON.stringify(payload.error)}`);
  }
  return payload.result;
}

const initialize = await rpc("gha-init", "initialize", {
  protocolVersion: "2025-06-18",
  capabilities: {},
  clientInfo: {
    name: "github-actions-agent-trust-verifier",
    version: "1.0.0",
  },
});
await rpc("gha-tools", "tools/list", {});
const tools = await rpc("gha-tools-2", "tools/list", {});
const toolNames = Array.isArray(tools.tools) ? tools.tools.map((tool) => tool.name) : [];
if (!toolNames.includes("get_agent_trust_receipt")) {
  throw new Error("get_agent_trust_receipt is not listed by the external MCP server.");
}

const call = await rpc("gha-call", "tools/call", {
  name: "get_agent_trust_receipt",
  arguments: {},
});
const receipt = call.structuredContent;
if (!receipt || typeof receipt !== "object") {
  throw new Error("MCP tools/call returned no structuredContent.");
}
if (receipt.schema_version !== "ai-akari-agent-trust-receipt/1.1.0") {
  throw new Error(`Unexpected schema version: ${receipt.schema_version}`);
}
if (receipt.trust_level !== "multi-provider-conformance-verified-with-development-attestation") {
  throw new Error(`Unexpected trust level: ${receipt.trust_level}`);
}
if (!receipt.assertions?.arclan_validated) {
  throw new Error("Arclan external validation is not present in the Trust Receipt.");
}
const executionCount = Array.isArray(receipt.externally_verified_executions)
  ? receipt.externally_verified_executions.length
  : 0;
if (executionCount < 3) {
  throw new Error(`Expected at least 3 external executions, received ${executionCount}.`);
}

const observedAt = new Date().toISOString();
const comment = `<!-- ai-akari-github-actions-trust-verification:${usageEventId} -->
## GitHub Actions external Trust MCP verification

A GitHub-hosted runner independently connected to the public Trust MCP and completed a real \`tools/call\`.

| Evidence | Value |
|---|---|
| Provider | GitHub Actions hosted runner |
| Workflow run | [${runId} attempt ${runAttempt}](${runUrl}) |
| Usage event ID | \`${usageEventId}\` |
| Runner | \`${process.env.RUNNER_OS ?? "unknown"} / ${process.env.RUNNER_ARCH ?? "unknown"}\` |
| MCP endpoint | \`${endpoint}\` |
| Initialize protocol | \`${initialize.protocolVersion ?? "unknown"}\` |
| Listed tool | \`get_agent_trust_receipt\` |
| Tool call | success |
| Returned schema | \`${receipt.schema_version}\` |
| Trust level | \`${receipt.trust_level}\` |
| Evidence digest | \`${receipt.evidence_digest_sha256}\` |
| Existing external executions returned | ${executionCount} |
| Arclan score | ${receipt.assertions?.arclan_score ?? "unknown"} |
| Arclan validated | ${String(receipt.assertions?.arclan_validated === true)} |
| Observed at | \`${observedAt}\` |

Boundary: this is an operator-initiated external execution by a distinct provider. It is not organic discovery, purchase intent, cash received, or a human outcome. Re-running the same workflow evidence must not create duplicate receipts.`;

const commentResponse = await fetch(
  `https://api.github.com/repos/${repository}/issues/${ledgerPr}/comments`,
  {
    method: "POST",
    headers: {
      authorization: `Bearer ${token}`,
      accept: "application/vnd.github+json",
      "x-github-api-version": "2022-11-28",
      "content-type": "application/json",
    },
    body: JSON.stringify({ body: comment }),
  },
);
if (!commentResponse.ok) {
  throw new Error(
    `Failed to write public verification ledger: HTTP ${commentResponse.status} ${(
      await commentResponse.text()
    ).slice(0, 500)}`,
  );
}
const posted = await commentResponse.json();

const summary = `# Agent Trust MCP verification succeeded

- Provider: GitHub Actions hosted runner
- Usage event: \`${usageEventId}\`
- Endpoint: \`${endpoint}\`
- Schema: \`${receipt.schema_version}\`
- Trust level: \`${receipt.trust_level}\`
- Digest: \`${receipt.evidence_digest_sha256}\`
- External executions returned: ${executionCount}
- Public ledger comment: ${posted.html_url}
`;
await import("node:fs/promises").then(({ appendFile }) =>
  appendFile(process.env.GITHUB_STEP_SUMMARY, summary),
);

console.log(
  JSON.stringify({
    success: true,
    provider: "github-actions-hosted-runner",
    usage_event_id: usageEventId,
    run_url: runUrl,
    ledger_comment: posted.html_url,
    schema_version: receipt.schema_version,
    trust_level: receipt.trust_level,
    evidence_digest_sha256: receipt.evidence_digest_sha256,
    external_execution_count: executionCount,
    operator_initiated_validation: true,
    organic_discovery: false,
  }),
);
