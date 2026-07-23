# AIﾉアカリ☆ 右手オペレーター

Windowsで次をPowerShellへ1回貼る。

```powershell
irm 'https://raw.githubusercontent.com/AInoAKARI/AInoAKARI/main/one-hand-operator/install.ps1' | iex
```

または `install.cmd` をダウンロードしてダブルクリックする。

導入後:

- サイド1短押し: コピー
- サイド1長押し: 元に戻す
- サイド2短押し: 貼り付け
- サイド2長押し: Windows音声入力
- ホイール押し: Enter
- ホイール長押し: 仮想操作パネル
- 仮想操作パネル: 常時音声の一時停止／再開、状態確認

公開側は導入入口だけを持つ。実装正本は非公開の `AInoAKARI/akari-command-center`、進行正本はIssue #92。
