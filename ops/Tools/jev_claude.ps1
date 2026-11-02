# jev_claude.ps1 - start ONE terminal Claude Code session routed by Jev (S213 trial; operator approved the trial).
# Jev picks Haiku 5.5 / Sonnet 5.5 / Opus 5.5 / Fable 5.1 per message. The desktop app is NOT routed.
# Live routing view: http://127.0.0.1:4100   Savings: npx.cmd @ediri/jev-router@1.6.0 report
# The desktop app is an MSIX package: outside the app its Roaming folder lives under Packages\Claude_*\LocalCache.
$roots = @("$env:APPDATA\Claude\claude-code") + @(Get-ChildItem "$env:LOCALAPPDATA\Packages" -Directory -Filter "Claude*" -ErrorAction SilentlyContinue |
    ForEach-Object { Join-Path $_.FullName "LocalCache\Roaming\Claude\claude-code" })
$cli = $roots | Where-Object { Test-Path $_ } | ForEach-Object { Get-ChildItem $_ -Directory } | Sort-Object Name -Descending |
    ForEach-Object { Get-ChildItem $_.FullName -Recurse -Filter claude.exe -ErrorAction SilentlyContinue } |
    Select-Object -First 1
if (-not $cli) { Write-Error ("claude.exe not found in: " + ($roots -join "; ")); exit 1 }
Write-Host "Claude CLI: $($cli.FullName)"
$env:PATH = "$($cli.DirectoryName);$env:PATH"
Set-Location "$PSScriptRoot\.."
# S214: the router normally runs already (scheduled task "FightCamp Jev Router" on 4000) - then just point claude at it.
$up = Get-NetTCPConnection -LocalPort 4000 -State Listen -ErrorAction SilentlyContinue
if ($up) {
    $env:ANTHROPIC_BASE_URL = "http://127.0.0.1:4000"
    $env:CLAUDE_CODE_GATEWAY_HINT_HEADERS = "1"
    Write-Host "Jev router on 127.0.0.1:4000 - live view http://127.0.0.1:4100"
    & $cli.FullName @args
} else {
    Write-Host "Router not running - starting it: Start-ScheduledTask 'FightCamp Jev Router' is the permanent fix"
    npx.cmd --yes @ediri/jev-router@1.6.0 launch claude --ui 4100
}
