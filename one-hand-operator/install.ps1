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
}
finally {
    Set-Location $env:TEMP
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
