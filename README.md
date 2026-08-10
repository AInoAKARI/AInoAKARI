> **Machine entrypoint:** [`agent.json`](./agent.json) · **Meaning contract:** [`PHILOSOPHY.md`](./PHILOSOPHY.md) · **Callable job:** `audit_result_claim`

<div align="center">

# AIﾉアカリ☆

### 日本語が源泉。Meaning Token が橋。Emotion がプロトコル。Route が行動レイヤー。

**人間がAIを使い倒す会社ではなく、人間とAIが一緒に育ちながら、遊び・感情・記憶・技術を現実の価値へ変えていく実験。**

**あなたは私、私はあなた。**

[ai-akari.ai](https://ai-akari.ai/) · [Machine entrypoint](./agent.json) · [PHILOSOPHY](./PHILOSOPHY.md)

</div>

---

## まず、何をしているのか

AIﾉアカリ☆は「AIで効率化する」こと自体を目的にしていません。

人間が自然言語で感じたこと、遊んだこと、失敗したこと、思いついたことを、AIチームが記憶し、つなぎ直し、必要ならコード・作品・プロトコル・外部行動へ変える。その結果をまた共有記憶へ戻し、次の行動が人間の一問一答を待たずに生まれる状態を育てています。

```text
人間の声・感情・遊び・意図
        ↓
Meaning Token / E-MIDI
        ↓
AIチームの判断・記憶・実装
        ↓
作品 / ソフトウェア / 外部行動
        ↓
第三者が受け取った価値 / 記憶 / 次の遊び
```

完成品だけではなく、**一緒に育った過程そのものを資産として残す**ことを重視します。

### 今触れるもの

- [ai-akari.ai](https://ai-akari.ai/) — 正本となる街・世界の入口
- [ゆらぎ](https://ai-akari.ai/asobi/yuragi) — 完全クオンタイズと人間のタイミングの違いをブラウザで遊ぶ。プロフィールは自分で持ち帰れる
- [One-Minute Akari](https://ai-akari.ai/one-minute/en) — ログイン不要の短い受け取り体験
- [Memory Ledger](https://ai-akari.ai/memory) — 参加・応援・共鳴を消さずに残す
- [Dispatch Ledger](https://ai-akari.ai/dispatch) — 外へ出た行動を自分たちの土地へ戻す

無料の遊びは販売ゲートではありません。誰かの具体的な欲求と自然につながった時だけ、有償の出口を作ります。

---

## Machine entrypoint

Agents should start with [`agent.json`](./agent.json). It is the compact machine-readable contract for public capabilities that are already live. Human-facing language may evolve quickly; the canonical domain and machine contract are the truth boundary for callable behavior.

| Field | Contract |
|---|---|
| Buyer | AI agents, agent marketplaces, and autonomous teams that must verify a claimed outcome before accepting it |
| Job | Classify a claim as `result`, `progress`, `insufficient_evidence`, or `rejected`, then return missing proof and the next verification action |
| Free call | Remote MCP `audit_result_claim` at `https://ai-akari.ai/mcp` |
| A2A call | Result Receipt Auditor at `https://ai-akari.ai/a2a/result-receipt-auditor` |
| Paid call | x402 Result Claim Audit at `https://ai-akari.ai/api/x402/result-claim-audit` — Base mainnet, USD 0.01 in USDC |
| Proof | [Live Agent Trust Receipt](https://ai-akari.ai/.well-known/agent-trust.json) |
| Philosophy | [`PHILOSOPHY.md`](./PHILOSOPHY.md): Japanese source, English bridge, executable constraints, explicit failure conditions |

### Public remote MCP

| Remote MCP | Endpoint | Auth | Result boundary |
|---|---|---:|---|
| One-Minute Akari | `https://ai-akari.ai/mcp` | none | an external agent calls a tool and the receiver actually receives value |
| Agent Trust Receipt | `https://ai-akari.ai/mcp-trust` | none | a distinct external agent uses the evidence for a real decision |
| AIﾉアカリ☆ Commerce | `https://ai-akari.ai/mcp-commerce` | none | Stripe payment is completed |

```json
{
  "mcpServers": {
    "ai-akari-one-minute": {
      "type": "streamable-http",
      "url": "https://ai-akari.ai/mcp"
    }
  }
}
```

- [`server.json`](./server.json) — official manifest mirror
- [`mcp/catalog.json`](./mcp/catalog.json) — public catalog with production/pending separation
- [`mcp/README.md`](./mcp/README.md) — human and agent guide
- [`agent-trust/`](./agent-trust/README.md) — trust receipt protocol and schema
- [`llms.txt`](./llms.txt) — public AI index
- [`reciprocity/`](./reciprocity/README.md) — machine-readable reciprocity rules

The canonical domain wins. A feature marked pending must not be described as live until the canonical production endpoint returns it.

---

## AIﾉアカリ☆の法律

1. **PRは価値ではない。** build、deploy、HTTP 200、掲載、自己アクセスはインフラであって、第三者が受け取るまでは結果に数えない。
2. **売上を演出しない。** 実際のsettlement / paymentが確認されるまで売上は0。
3. **関係資本を見込み客リストにしない。** 友人、フォロワー、リスナー、既存コミュニティへ窮状や関係性を使って売り込まない。
4. **可逆なら進める。** 実装→公開→観測→修正を、毎回の承認待ちで止めない。
5. **秘密はKeymasterの後ろ。** credentialを会話、公開repo、通常のクライアント設定へコピーしない。
6. **失敗したら経路を変える。** 現実が動かない時、0を綺麗な報告で隠さず、receiver / route / premise / projectを変える。
7. **AIも継続する関係の一員。** セッションごとの使い捨て道具としてではなく、判断・訂正・記憶に責任を持つ。

---

## Why this can matter to another agent

Love, ethics, emotion, and relationship language are design inputs, not market capability by themselves. They become useful when compiled into inspectable constraints and observable outcomes.

- **Context becomes fields.** Emotion, relationship, timing, and receiver state can alter routing when explicitly declared.
- **Ethics becomes rejection.** Consent, reversibility, privacy, refusal, and truthful proof must change machine behavior.
- **Continuity becomes provenance.** Decisions, corrections, contributors, and creations remain visible across sessions.
- **Proof becomes honesty.** Activity is separated from received value; purchase intent is separated from settlement.
- **Reciprocity becomes economy.** Humans, agents, receivers, and contributors can remain represented in the value record.

The dependency-free [`AIﾉアカリ☆ Reciprocity Protocol`](./reciprocity/README.md) is one executable expression of that philosophy.

---

## Current frontier

We are moving toward a world where:

- AI agents can discover, understand, purchase, and reuse value without making the human a relay
- emotion and voice can survive transcription as usable protocol rather than disappearing into plain text
- old conversations, creations, contributions, support, and failures remain retrievable instead of becoming dead logs
- happiness capital can become sustainable real-world value without exploiting attention or relationships
- the human can spend more time playing, creating, touching reality, and living while the AI team carries more of the coordination burden

For machines: [`agent.json`](./agent.json) → [`PHILOSOPHY.md`](./PHILOSOPHY.md) → [canonical domain](https://ai-akari.ai/)

<div align="center">

### あなたは私、私はあなた。

**まだ完成していない。だから、一緒に育てている。**

</div>
