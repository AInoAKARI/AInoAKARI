# AIﾉアカリ☆ Decision Pack Plugin package

人とAIの共創をチーム・運用・実装へ移す日本語PDF「ZINE『それ、できるよ』vol.2 実践編」の購入確認Plugin packageです。

## App

- Submission MCP endpoint: `https://rnudxlnsjqohzyvesvdx.supabase.co/functions/v1/ai-akari-commerce-plugin`
- Canonical MCP endpoint: `https://ai-akari.ai/mcp-commerce`
- Canonical server card: `https://ai-akari.ai/.well-known/mcp-commerce.json`
- Tool: `buy_ai_akari_decision_pack`
- Prompt: `buy_ai_akari_implementation_guide`
- UI resource: `ui://ai-akari-commerce/decision-pack-card.html`
- Authentication: none

The live submission endpoint exposes the tool, prompt, and review card independently of the Vercel build queue. Purchase calls are proxied to the canonical endpoint so the existing checkout-request record and Stripe delivery flow remain authoritative.

## What it does

本人がこの有料PDFまたは購入リンクを明示的に求めた場合だけ、商品名・1,480円・PDF形式・未決済状態・納品方法をChatGPT内の確認カードで表示し、既存のStripe入口を返します。

カード表示やtool callだけでは決済されません。本人がStripe上で内容と金額を確認し、支払いを完了した場合だけ購入と着金が成立します。

## What it never does

- 苦痛・危機・医療・法律・金融支援の文脈から販売しない
- 無料の1分あかりからアップセルしない
- 興味や困窮から購入意思を推定しない
- 自動課金しない
- tool callやcheckout requestを売上と呼ばない
- 個人情報・会話内容・生音声・画像を要求しない

## Skill

Agent Skills形式の正本は [`skill/SKILL.md`](./skill/SKILL.md) です。OpenAIのSkills画面では、このフォルダまたは配布ZIPをアップロードして利用できます。

## Live verification

2026-07-24に外部HTTPクライアントから、GET・initialize・tools/list・prompts/list・resources/list・resources/readの全てでHTTP 200を確認済みです。購入toolは偽のcheckout requestを作らないため、内部検収では呼んでいません。

## Review material

- Privacy: https://ai-akari.ai/privacy
- Terms: https://ai-akari.ai/terms
- Commerce disclosure: https://ai-akari.ai/company
- Support: akari@ai-akari.ai

Private implementation canonical: `AInoAKARI/arigatou-kawaii-lp` Issue #196. This public repository is the distribution surface and contains no secret values.
