# OpenClaw write postcondition canary for issue #67136

## Claim

On the latest published package tested, the generic write-tool boundary can report a successful write after its delegated `writeFile` operation resolves, without independently verifying that the promised file exists.

This is a controlled boundary canary. It does **not** claim that every concrete OpenClaw backend silently drops writes. It demonstrates that a delegated operation can resolve without persistence and the generic tool can still return a syntactic success response.

## Tested artifact

```yaml
package: openclaw@2026.7.1-2
npm_tarball_sha1: 4583b987ea7277230ce1c7b2b8535d3e219f57ac
npm_integrity: sha512-ycF3yPcbjN6bUPeaUx6Mh6vze1hQWoD3CT/wWcmD7a8xaHHHRUaAlaq+lFxMHf1ssEgODVAwjlzYqp2twkYZ7g==
node_tested: v24.15.0
runs: 3
mismatches: 3
```

The published bundle used by the canary is `dist/sessions-D8qGY7uC.js`. Current main was inspected at [`e051a7bb4a6b`](https://github.com/openclaw/openclaw/commit/e051a7bb4a6ba69b87391e990b00813114b1d482). [`src/agents/sessions/tools/write.ts`](https://github.com/openclaw/openclaw/blob/e051a7bb4a6ba69b87391e990b00813114b1d482/src/agents/sessions/tools/write.ts) returns success immediately after delegated `ops.writeFile` resolves, while [`src/agents/agent-tools.read.ts`](https://github.com/openclaw/openclaw/blob/e051a7bb4a6ba69b87391e990b00813114b1d482/src/agents/agent-tools.read.ts) supplies delegated sandbox and host write operations without a post-write read/stat verification step.

## Reproduce

```bash
workdir="$(mktemp -d)"
npm install --prefix "$workdir" openclaw@2026.7.1-2
npx --yes -p node@24.15.0 node ./openclaw-write-canary.mjs "$workdir/node_modules/openclaw"
```

Expected contract:

```yaml
intent:
  operation: write
  target: artifact.txt
  postcondition:
    exists: true
actual:
  tool_response: Successfully wrote 22 bytes to artifact.txt
  external_stat: ENOENT
verdict:
  contract_match: false
```

## Observed output

All three runs returned the same semantic result:

```json
{
  "package": "openclaw@2026.7.1-2",
  "node": "v24.15.0",
  "tool_result": {
    "text": "Successfully wrote 22 bytes to artifact.txt",
    "is_error": false
  },
  "external_observation": {
    "exists": false,
    "error_code": "ENOENT"
  },
  "mismatch": true
}
```

## Minimal fix boundary

Do not convert a resolved delegated write into a success receipt until the declared postcondition is independently observed. At minimum, the generic boundary should read/stat the target through the same operation layer and return an error when persistence is absent or contradictory.

An external auditor can also represent this as `intent_contract` plus `observed_outcome`, but the primary fix belongs at the OpenClaw write boundary so callers cannot receive a false success claim in the first place.
