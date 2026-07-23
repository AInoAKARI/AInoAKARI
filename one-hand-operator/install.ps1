$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Resolve-GitHubCli {
    $command = Get-Command gh -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }

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

function Convert-ExtractedScriptsToUtf8Bom {
    param([string]$Root)

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    $utf8Bom = New-Object System.Text.UTF8Encoding($true)
    foreach ($extension in @("*.ps1", "*.psm1", "*.ahk")) {
        Get-ChildItem -LiteralPath $Root -File -Filter $extension -Recurse | ForEach-Object {
            $text = [IO.File]::ReadAllText($_.FullName, $utf8NoBom)
            [IO.File]::WriteAllText($_.FullName, $text, $utf8Bom)
        }
    }
}

function Test-LivePidFile {
    param([string]$Path)

    if (-not (Test-Path $Path)) { return $false }
    $raw = (Get-Content -LiteralPath $Path -Raw -ErrorAction SilentlyContinue)
    if ([string]::IsNullOrWhiteSpace($raw)) { return $false }
    $raw = $raw.Trim()
    if ($raw -notmatch '^\d+$') { return $false }
    return $null -ne (Get-Process -Id ([int]$raw) -ErrorAction SilentlyContinue)
}

function Invoke-NativeQuiet {
    param(
        [string]$FilePath,
        [string[]]$ArgumentList,
        [string]$WorkingDirectory
    )

    $previousPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        if ([string]::IsNullOrWhiteSpace($WorkingDirectory)) {
            & $FilePath @ArgumentList *> $null
            return $LASTEXITCODE
        }

        Push-Location $WorkingDirectory
        try {
            & $FilePath @ArgumentList *> $null
            return $LASTEXITCODE
        }
        finally {
            Pop-Location
        }
    }
    finally {
        $ErrorActionPreference = $previousPreference
    }
}

function Ensure-CommandCenterWorkspace {
    param(
        [string]$GhPath,
        [string]$WorkspaceRoot
    )

    $git = Get-Command git -ErrorAction SilentlyContinue
    if (-not $git) { return $false }

    $setupExit = Invoke-NativeQuiet `
        -FilePath $GhPath `
        -ArgumentList @("auth", "setup-git", "--hostname", "github.com")
    if ($setupExit -ne 0) { return $false }

    $target = Join-Path $WorkspaceRoot "akari-command-center"
    if (Test-Path (Join-Path $target "AGENTS.md")) { return $true }

    if (Test-Path $target) {
        Remove-Item -LiteralPath $target -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Force -Path $WorkspaceRoot | Out-Null

    $cloneExit = Invoke-NativeQuiet `
        -FilePath $git.Source `
        -ArgumentList @(
            "clone",
            "--depth", "1",
            "https://github.com/AInoAKARI/akari-command-center.git",
            $target
        ) `
        -WorkingDirectory $WorkspaceRoot

    return ($cloneExit -eq 0 -and (Test-Path (Join-Path $target "AGENTS.md")))
}

$tempRoot = Join-Path $env:TEMP ("ai-no-akari-one-hand-" + [guid]::NewGuid().ToString("N"))
$archivePath = Join-Path $tempRoot "akari-command-center.zip"
$extractRoot = Join-Path $tempRoot "source"

try {
    $ghPath = Resolve-GitHubCli
    if (-not $ghPath) {
        $winget = Get-Command winget -ErrorAction SilentlyContinue
        if (-not $winget) { throw "GitHub CLI and winget are unavailable." }
        & $winget.Source install --id GitHub.cli --exact --accept-package-agreements --accept-source-agreements --silent
        if ($LASTEXITCODE -ne 0) { throw "GitHub CLI installation failed: $LASTEXITCODE" }
        $ghPath = Resolve-GitHubCli
    }
    if (-not $ghPath) { throw "GitHub CLI was not found after installation." }

    & $ghPath auth status --hostname github.com 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "GitHub CLI is not signed in." }

    $token = ((& $ghPath auth token --hostname github.com 2>$null) | Out-String).Trim()
    if ([string]::IsNullOrWhiteSpace($token)) { throw "GitHub token could not be read." }

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
        throw "The canonical repository archive is incomplete."
    }

    Expand-Archive -LiteralPath $archivePath -DestinationPath $extractRoot -Force
    Convert-ExtractedScriptsToUtf8Bom -Root $extractRoot

    $installer = Get-ChildItem -LiteralPath $extractRoot -File -Filter "install.ps1" -Recurse |
        Where-Object { $_.FullName.Replace('/', '\') -match '\\tools\\one-hand-operator\\install\.ps1$' } |
        Select-Object -First 1
    if (-not $installer) { throw "The canonical installer was not found." }

    & $installer.FullName
    $installerExit = $LASTEXITCODE

    $installedRoot = Join-Path $env:LOCALAPPDATA "AI-no-Akari\OneHandOperator"
    $ambientRoot = Join-Path $env:LOCALAPPDATA "AI-no-Akari\AmbientAgent"
    $statusScript = Join-Path $installedRoot "status.ps1"
    $operatorScript = Join-Path $installedRoot "one-hand-operator.ahk"

    $coreInstalled = (Test-Path $statusScript) -and (Test-Path $operatorScript)
    if (-not $coreInstalled) {
        throw "The one-hand operator core was not installed. Installer exit: $installerExit"
    }
    if ($installerExit -ne 0) {
        Write-Warning "The core started successfully. A diagnostic check returned $installerExit and will be repaired below."
    }

    $workspaceRoot = Join-Path $ambientRoot "workspaces"
    $workspaceReady = Ensure-CommandCenterWorkspace -GhPath $ghPath -WorkspaceRoot $workspaceRoot
    if (-not $workspaceReady) {
        Write-Warning "The right-hand controls are active, but the command-center workspace could not be prepared."
    }
    else {
        $dispatcherScript = Join-Path $installedRoot "ambient-dispatcher.ps1"
        $dispatcherPid = Join-Path $installedRoot "ambient-dispatcher.pid"
        if ((Test-Path $dispatcherScript) -and -not (Test-LivePidFile -Path $dispatcherPid)) {
            $powerShellExe = (Get-Process -Id $PID).Path
            Start-Process -FilePath $powerShellExe -ArgumentList @(
                "-NoProfile",
                "-ExecutionPolicy", "Bypass",
                "-WindowStyle", "Hidden",
                "-File", $dispatcherScript
            ) -WorkingDirectory $installedRoot
            Start-Sleep -Seconds 3
        }
    }

    if (Test-Path $statusScript) {
        try {
            $status = (& $statusScript | Out-String) | ConvertFrom-Json
            $reportPath = Join-Path $tempRoot "issue-92-install-report.md"
            $report = @"
## Windows live installation report

- checked_at: $($status.checked_at)
- one_hand_operator: $($status.one_hand_operator)
- local_whisper: $($status.local_whisper)
- windows_speech_fallback: $($status.windows_speech_fallback)
- dispatcher: $($status.dispatcher)
- ambient_paused: $($status.ambient_paused)
- spool pending / processing / completed / discarded / failed: $($status.spool.pending) / $($status.spool.processing) / $($status.spool.completed) / $($status.spool.discarded) / $($status.spool.failed)
- workspace_ready: $workspaceReady
- raw_audio_saved: false
- raw_image_saved: false
- camera_enabled: false

The public entry repaired partial installation state, prepared the private workspace over authenticated HTTPS, and restarted the resident dispatcher when needed.
"@
            [IO.File]::WriteAllText($reportPath, $report, (New-Object System.Text.UTF8Encoding($false)))
            & $ghPath issue comment 92 --repo AInoAKARI/akari-command-center --body-file $reportPath
            if ($LASTEXITCODE -ne 0) {
                Write-Warning "Installation is active, but automatic Issue reporting failed."
            }
        }
        catch {
            Write-Warning "Installation is active, but status reporting failed: $($_.Exception.Message)"
        }
    }

    Write-Host "AI no Akari one-hand operator is active."
    Write-Host "Workspace ready: $workspaceReady"
    $global:LASTEXITCODE = 0
}
finally {
    Set-Location $env:TEMP
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
