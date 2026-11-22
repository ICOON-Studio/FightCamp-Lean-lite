# claude_credit.ps1 - run ONE worker brief headless, billed to the Console API credit (S537; owner made the key; the $200
# Ultra monthly credit only pays for `claude -p` / Agent SDK runs with an API key - support.claude.com 17154008).
# The key lives OUTSIDE the repo (%USERPROFILE%\.fightcamp\console_api_key.txt, written by the owner) and is set for THIS
# process only - never globally (a global ANTHROPIC_API_KEY would move his normal sessions onto the credit).
# Usage (repo root):  powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\claude_credit.ps1 -Id WEIGHT3 `
#                       -Prompt 'Read and do ops/research/TASK_WEIGHT3.md ...' [-Model claude-fable-5-2] [-Budget 20]
# Log: ops/AgentComms/credit_runs/<Id>.json (the final JSON: result, total_cost_usd); one line per run in credit_runs.log.
param(
    [Parameter(Mandatory = $true)][string]$Id,
    [Parameter(Mandatory = $true)][string]$Prompt,
    [string]$Model = "claude-fable-5-2",
    [double]$Budget = 20
)
$keyFile = Join-Path $env:USERPROFILE ".fightcamp\console_api_key.txt"
if (-not (Test-Path $keyFile)) { Write-Error "no key file: $keyFile"; exit 2 }
$env:ANTHROPIC_API_KEY = (Get-Content -Raw $keyFile).Trim()
$env:CLAUDE_CODE_EXPERIMENTAL_CODE_MODE = "1"   # a worker: idle_guard lets it stop when its brief is done
# S537 FIX: with the normal config dir the claude.ai login WINS over the key (`claude auth status`: authMethod "claude.ai",
# Console usage 0 tokens) - the first seven runs billed his subscription. An own config dir has no login: authMethod "api_key".
$env:CLAUDE_CONFIG_DIR = Join-Path $env:USERPROFILE ".fightcamp\claude_credit_cfg"
New-Item -ItemType Directory -Force $env:CLAUDE_CONFIG_DIR | Out-Null
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$dir = Join-Path $root "ops\AgentComms\credit_runs"
New-Item -ItemType Directory -Force $dir | Out-Null
$out = Join-Path $dir "$Id.json"
$start = Get-Date -Format s
Push-Location $root
try {
    & claude -p $Prompt --model $Model --permission-mode auto --max-budget-usd $Budget --output-format json 2>&1 | Out-File -Encoding utf8 $out
} finally {
    Pop-Location
    Remove-Item Env:ANTHROPIC_API_KEY
    Remove-Item Env:CLAUDE_CONFIG_DIR
}
$cost = "?"
try { $cost = (Get-Content -Raw $out | ConvertFrom-Json).total_cost_usd } catch {}
Add-Content (Join-Path $dir "credit_runs.log") "$start $Id $Model budget=$Budget cost=$cost"
Write-Output "CREDIT_RUN_DONE $Id cost=$cost"
