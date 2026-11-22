# claude_credit.ps1 - run ONE worker brief on the Console's $200 "API credit (Ultra)" (S537).
# That credit covers Agent SDK / API, NOT Claude Code: `claude -p` was refused ("Credit balance is too low") and, with the
# claude.ai login present, billed his subscription instead. So this now hands the run to ops/Tools/sdk_run.py (Agent SDK).
# Usage (repo root):  powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\claude_credit.ps1 -Id WEIGHT3 `
#                       -Prompt 'Read and do ops/research/TASK_WEIGHT3.md ...' [-Model claude-fable-5-2] [-Budget 20]
param(
    [Parameter(Mandatory = $true)][string]$Id,
    [Parameter(Mandatory = $true)][string]$Prompt,
    [string]$Model = "claude-fable-5-2",
    [double]$Budget = 20
)
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Push-Location $root
try {
    & python ops/Tools/sdk_run.py --id $Id --budget $Budget --model $Model $Prompt
} finally {
    Pop-Location
}
