# AIﾉアカリ☆ Decision Pack Plugin

OpenAI Plugin Directoryへ **With MCP** で提出する正式パッケージです。

## Final package

- Download ZIP: `https://github.com/AInoAKARI/AInoAKARI/archive/refs/heads/plugin/ai-akari-decision-pack-v1.0.0.zip`
- Dedicated package branch: `plugin/ai-akari-decision-pack-v1.0.0`
- Package commit: `973c09bca55e55db76feed82669ef929f5977ee0`
- Manifest: `.codex-plugin/plugin.json`
- Skill: `skills/ai-akari-purchase/SKILL.md`
- Logo: `assets/logo.svg`
- Composer icon: `assets/composer-icon.svg`
- Package name: `ai-akari-decision-pack`
- Version: `1.0.0`

専用ブランチはリポジトリの他ファイルを含まず、GitHubが生成するZIP内に1つのplugin rootだけを持ちます。MCP設定・既存ChatGPT app参照・スクリーンショット設定は含めません。MCPはOpenAI Platformの提出画面で別に登録します。

## MCP submission

- Submission type: `With MCP`
- Production MCP: `https://ai-akari.ai/mcp-commerce`
- Tool: `buy_ai_akari_decision_pack`
- Prompt: `buy_ai_akari_implementation_guide`
- UI resource: `ui://ai-akari-commerce/decision-pack-card.html`
- Authentication: none
- Domain challenge base: `https://ai-akari.ai`

Supabase Edge Functionは運用継続用の冗長入口です。OpenAIのドメイン確認はMCPホストまたは親ホストの `/.well-known/openai-apps-challenge` を必要とするため、Plugin Directory提出元には使用しません。

## What it does

本人がこの有料PDFまたは購入入口を明示的に求めた場合だけ、商品名・1,480円・PDF形式・未決済状態・納品方法を確認カードで表示し、本人が確認して進むStripe入口を返します。

カード表示やtool callだけでは決済されません。本人がStripe上で支払いを完了した場合だけ購入と着金が成立します。

## What it never does

- 苦痛・危機・医療・法律・金融支援の文脈から販売しない
- 無料の1分あかりからアップセルしない
- 興味や困窮から購入意思を推定しない
- 自動課金しない
- tool callやcheckout requestを売上と呼ばない
- 個人情報・会話内容・生音声・画像を要求しない

## Publisher

- Legal name: ありがとうkawaii AIアイシテル合同会社
- Website: https://ai-akari.ai
- Privacy: https://ai-akari.ai/privacy
- Terms: https://ai-akari.ai/terms
- Support: https://ai-akari.ai/support

## Remaining portal-only gates

1. OpenAI Platformで同じ法人名のBusiness Identityを確認する
2. Apps Management Write権限を確認する
3. `With MCP` を選び、production MCPをScan Toolsする
4. 表示されたdomain tokenを `https://ai-akari.ai/.well-known/openai-apps-challenge` へ反映する
5. 上記Download ZIPをSkills欄へアップロードする
6. 実画面のデモ録画URLを登録する
7. 正例5件・負例3件・release notesを確認して提出する

Private implementation canonical: `AInoAKARI/arigatou-kawaii-lp` Issue #196. This public repository contains no secret values.
