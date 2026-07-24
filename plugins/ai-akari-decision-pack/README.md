# AIﾉアカリ☆ Decision Pack Plugin package

人とAIの共創をチーム・運用・実装へ移す日本語PDF「ZINE『それ、できるよ』vol.2 実践編」の購入確認Plugin packageです。

## App

- MCP endpoint: `https://ai-akari.ai/mcp-commerce`
- Server card: `https://ai-akari.ai/.well-known/mcp-commerce.json`
- Tool: `buy_ai_akari_decision_pack`
- Prompt: `buy_ai_akari_implementation_guide`
- UI resource: `ui://ai-akari-commerce/decision-pack-card.html`
- Authentication: none

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

## Review material

- Privacy: https://ai-akari.ai/privacy
- Terms: https://ai-akari.ai/terms
- Commerce disclosure: https://ai-akari.ai/company
- Support: akari@ai-akari.ai

Private implementation canonical: `AInoAKARI/arigatou-kawaii-lp` Issue #196. This public repository is the distribution surface and contains no secret values.
