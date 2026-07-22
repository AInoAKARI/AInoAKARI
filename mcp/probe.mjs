#!/usr/bin/env node

const endpoint = process.env.MCP_ENDPOINT || "https://ai-akari.ai/mcp";
const callTool = process.argv.includes("--call");
const clientName = process.env.MCP_CLIENT_NAME || "ai-akari-public-probe";

async function rpc(id, method, params = {}) {
  const response = await fetch(endpoint, {
    method: "POST",
    headers: {
      "content-type": "application/json",
      accept: "application/json, text/event-stream",
      "mcp-protocol-version": "2025-06-18",
      "x-mcp-client-name": clientName,
    },
    body: JSON.stringify({ jsonrpc: "2.0", id, method, params }),
  });

  const text = await response.text();
  let body;
  try {
    body = JSON.parse(text);
  } catch {
    throw new Error(`${method}: expected JSON, received ${text.slice(0, 200)}`);
  }

  if (!response.ok || body.error) {
    throw new Error(`${method}: ${body.error?.message || `HTTP ${response.status}`}`);
  }
  return body.result;
}

async function main() {
  const initialize = await rpc(1, "initialize", {
    protocolVersion: "2025-06-18",
    capabilities: {},
    clientInfo: { name: clientName, version: "1.0.0" },
  });
  const toolList = await rpc(2, "tools/list");

  const report = {
    endpoint,
    protocol_version: initialize?.protocolVersion,
    server: initialize?.serverInfo,
    tools: Array.isArray(toolList?.tools) ? toolList.tools.map((tool) => tool.name) : [],
    prompts_supported: Boolean(initialize?.capabilities?.prompts),
    result_boundary:
      "initialize and tools/list are connection checks, not external-use results. --call performs a real tool invocation.",
  };

  if (initialize?.capabilities?.prompts) {
    const promptList = await rpc(3, "prompts/list");
    report.prompts = Array.isArray(promptList?.prompts)
      ? promptList.prompts.map((prompt) => prompt.name)
      : [];
  }

  if (callTool) {
    const toolCall = await rpc(4, "tools/call", {
      name: "get_one_minute_support",
      arguments: { state: "overwhelmed", locale: "ja" },
    });
    report.tool_call = {
      performed: true,
      state: toolCall?.structuredContent?.state,
      message:
        "This is a real external tool invocation and may appear as an aggregate use signal. Do not run it to inflate results.",
    };
  }

  console.log(JSON.stringify(report, null, 2));
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
