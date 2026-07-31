import { mkdtemp, readFile, stat } from "node:fs/promises";
import { tmpdir } from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const packageRoot = path.resolve(process.argv[2] || "node_modules/openclaw");
const packageJson = JSON.parse(
  await readFile(path.join(packageRoot, "package.json"), "utf8"),
);

if (`${packageJson.name}@${packageJson.version}` !== "openclaw@2026.7.1-2") {
  throw new Error(
    `This version-pinned canary requires openclaw@2026.7.1-2; received ${packageJson.name}@${packageJson.version}`,
  );
}

const sessionsModule = path.join(packageRoot, "dist/sessions-D8qGY7uC.js");
const { z: createWriteTool } = await import(pathToFileURL(sessionsModule));
const cwd = await mkdtemp(path.join(tmpdir(), "openclaw-write-canary-"));
const relativeTarget = "artifact.txt";
const target = path.join(cwd, relativeTarget);
const content = "intent-outcome-canary\n";

// Controlled boundary injection: the delegated operation resolves but does not
// persist the file. This isolates whether the generic write tool verifies its
// promised postcondition before returning success.
const operations = {
  mkdir: async () => {},
  writeFile: async () => {},
  readFile: async () => {
    const error = new Error("No such file or directory");
    error.code = "ENOENT";
    throw error;
  },
  statFile: async () => null,
};

const tool = createWriteTool(cwd, { operations });
const toolResult = await tool.execute("canary-write-1", {
  path: relativeTarget,
  content,
});

let externalObservation;
try {
  const result = await stat(target);
  externalObservation = {
    exists: true,
    type: result.isFile() ? "file" : result.isDirectory() ? "directory" : "other",
    size: result.size,
  };
} catch (error) {
  externalObservation = {
    exists: false,
    error_code: error?.code ?? "UNKNOWN",
  };
}

const text = Array.isArray(toolResult?.content)
  ? toolResult.content
      .filter((block) => block?.type === "text")
      .map((block) => block.text)
      .join("\n")
  : "";

console.log(
  JSON.stringify(
    {
      canary: "openclaw-write-outcome-postcondition",
      package: `${packageJson.name}@${packageJson.version}`,
      node: process.version,
      intent: {
        operation: "write",
        target: relativeTarget,
        required_postcondition: {
          exists: true,
          type: "file",
          size: Buffer.byteLength(content, "utf8"),
        },
      },
      delegated_operation: {
        writeFile_resolved: true,
        persisted: false,
      },
      tool_result: {
        text,
        is_error: toolResult?.isError === true,
        details: toolResult?.details ?? null,
      },
      external_observation: externalObservation,
      mismatch:
        text.startsWith("Successfully wrote ") && externalObservation.exists === false,
    },
    null,
    2,
  ),
);
