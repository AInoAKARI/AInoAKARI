$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Resolve-GitHubCli {
    $command = Get-Command gh -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    $candidates = @()
    if ($env:ProgramFiles) {
        $candidates += Join-Path $env:ProgramFiles "GitHub CLI\gh.exe"
    }

    $programFilesX86 = [Environment]::GetEnvironmentVariable("ProgramFiles(x86)")
    if ($programFilesX86) {
        $candidates += Join-Path $programFilesX86 "GitHub CLI\gh.exe"
    }

    if ($env:LOCALAPPDATA) {
        $candidates += Join-Path $env:LOCALAPPDATA "Programs\GitHub CLI\gh.exe"
    }

    return ($candidates | Where-Object { Test-Path $_ } | Select-Object -First 1)
}

$tempRoot = Join-Path $env:TEMP ("ai-no-akari-one-hand-" + [guid]::NewGuid().ToString("N"))
$archivePath = Join-Path $tempRoot "akari-command-center.zip"
$extractRoot = Join-Path $tempRoot "source"

try {
    $ghPath = Resolve-GitHubCli
    if (-not $ghPath) {
        $winget = Get-Command winget -ErrorAction SilentlyContinue
        if (-not $winget) {
            throw "GitHub CLIが見つからず、wingetも利用できません。"
        }

        & $winget.Source install --id GitHub.cli --exact --accept-package-agreements --accept-source-agreements --silent
        if ($LASTEXITCODE -ne 0) {
            throw "GitHub CLIの導入に失敗しました。終了コード: $LASTEXITCODE"
        }

        $ghPath = Resolve-GitHubCli
    }

    if (-not $ghPath) {
        throw "GitHub CLIを検出できませんでした。"
    }

    & $ghPath auth status --hostname github.com 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "GitHub CLIが未ログインです。AInoAKARIアカウントでGitHubにログインしてください。"
    }

    $token = ((& $ghPath auth token --hostname github.com 2>$null) | Out-String).Trim()
    if ([string]::IsNullOrWhiteSpace($token)) {
        throw "GitHub認証情報を取得できませんでした。"
    }

    New-Item -ItemType Directory -Force -Path $tempRoot, $extractRoot | Out-Null

    $headers = @{
        Authorization = "Bearer $token"
        Accept = "application/vnd.github+json"
        "X-GitHub-Api-Version" = "2022-11-28"
        "User-Agent" = "AI-no-Akari-OneHandOperator"
    }

    Invoke-WebRequest `
        -Uri "https://api.github.com/repos/AInoAKARI/akari-command-center/zipball/main" `
        -Headers $headers `
        -OutFile $archivePath

    if (-not (Test-Path $archivePath) -or (Get-Item $archivePath).Length -lt 1024) {
        throw "正本リポジトリの取得データが不完全です。"
    }

    Expand-Archive -LiteralPath $archivePath -DestinationPath $extractRoot -Force

    $installer = Get-ChildItem -LiteralPath $extractRoot -File -Filter "install.ps1" -Recurse |
        Where-Object { $_.FullName.Replace('/', '\') -match '\\tools\\one-hand-operator\\install\.ps1$' } |
        Select-Object -First 1

    if (-not $installer) {
        throw "右手オペレーター本体が見つかりません。"
    }

    & $installer.FullName
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

公開導入口からHTTPS API経由で正本を取得し、導入・自動起動・自己診断まで実行済み。
"@
            [IO.File]::WriteAllText($reportPath, $report, [Text.UTF8Encoding]::new($false))
            & $ghPath issue comment 92 --repo AInoAKARI/akari-command-center --body-file $reportPath
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
