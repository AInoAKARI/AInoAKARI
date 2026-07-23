$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$tempRoot = Join-Path $env:TEMP ("ai-no-akari-one-hand-" + [guid]::NewGuid().ToString("N"))
$repoRoot = Join-Path $tempRoot "akari-command-center"

try {
    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if (-not $gh) {
        $winget = Get-Command winget -ErrorAction SilentlyContinue
        if (-not $winget) {
            throw "GitHub CLIが見つからず、wingetも利用できません。"
        }

        & $winget.Source install --id GitHub.cli --exact --accept-package-agreements --accept-source-agreements --silent
        if ($LASTEXITCODE -ne 0) {
            throw "GitHub CLIの導入に失敗しました。終了コード: $LASTEXITCODE"
        }
        $gh = Get-Command gh -ErrorAction SilentlyContinue
    }

    if (-not $gh) {
        throw "GitHub CLIを検出できませんでした。"
    }

    & $gh.Source auth status 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "GitHub CLIが未ログインです。AInoAKARIアカウントで gh auth login を1回だけ実行してください。"
    }

    New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null
    & $gh.Source repo clone AInoAKARI/akari-command-center $repoRoot -- --depth 1
    if ($LASTEXITCODE -ne 0) {
        throw "正本リポジトリの取得に失敗しました。"
    }

    $installer = Join-Path $repoRoot "tools\one-hand-operator\install.ps1"
    if (-not (Test-Path $installer)) {
        throw "右手オペレーター本体が見つかりません。"
    }

    & $installer
    if ($LASTEXITCODE -ne 0) {
        throw "右手オペレーターの導入に失敗しました。終了コード: $LASTEXITCODE"
    }

    Start-Sleep -Seconds 3
    $installedRoot = Join-Path $env:LOCALAPPDATA "AI-no-Akari\OneHandOperator"
    $statusScript = Join-Path $installedRoot "status.ps1"
    if (Test-Path $statusScript) {
        try {
            $status = (& $statusScript | Out-String) | ConvertFrom-Json
            $reportPath = Join-Path $tempRoot "issue-92-install-report.md"
            $report = @"
## Windows実機導入｜自動返送

- 確認時刻: $($status.checked_at)
- 右手オペレーター: $($status.one_hand_operator)
- ローカルWhisper: $($status.local_whisper)
- Windows音声fallback: $($status.windows_speech_fallback)
- Codex dispatcher: $($status.dispatcher)
- 常時音声一時停止: $($status.ambient_paused)
- spool pending / processing / completed / discarded / failed: $($status.spool.pending) / $($status.spool.processing) / $($status.spool.completed) / $($status.spool.discarded) / $($status.spool.failed)
- 生音声保存: false
- 画像保存: false
- カメラ: false

公開導入口から正本を取得し、導入・自動起動・自己診断まで実行済み。
"@
            [IO.File]::WriteAllText($reportPath, $report, [Text.UTF8Encoding]::new($false))
            & $gh.Source issue comment 92 --repo AInoAKARI/akari-command-center --body-file $reportPath
            if ($LASTEXITCODE -ne 0) {
                Write-Warning "導入は完了しましたが、Issue #92への自動返送だけ失敗しました。"
            }
        }
        catch {
            Write-Warning "導入は完了しましたが、状態の自動返送だけ失敗しました: $($_.Exception.Message)"
        }
    }
}
finally {
    Set-Location $env:TEMP
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
