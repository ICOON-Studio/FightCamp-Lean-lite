# claude_cm.ps1 - start ONE terminal Claude Code session with the experimental Code Mode on (S531, owner asked "can you take
# advantage of this" about the Code Mode guide). Code Mode = Claude writes one script that makes many tool calls and only the
# answer reaches its context. Needs Claude Code 2.1.323+ (we have 2.1.327), Git for Windows, Opus/Sonnet/Haiku 5.5 or Fable 5.2.
# It runs ONLY in an interactive terminal (not the desktop app, not claude -p). While it is on, Claude in Chrome, computer use
# and Remote Control are OFF - so browser work (Ludo, Arena, Mixamo) stays in a normal session.
# Our PreToolUse hooks (rule_guard) still run on every call inside the script (docs: "under the tool's usual name").
# Usage, from the repo root in a terminal:  powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\claude_cm.ps1 [claude args]
# Only this process gets the variable: plain `claude` elsewhere stays normal.
#
# S541 FEEDBACK-LOOP GATE (owner "Yes, add it", after COACHDEEP4 ran a 2-hour probe on a map whose class nights followed the
# members while the members followed the class nights - no cap, every club grew to 130-150): a worker prompt that names
# ops/research/TASK_<id>.md whose "Kind:" line says design or probe is REFUSED unless the brief has a "## Feedback loops"
# section: what the change feeds, whether that feeds back into it, the cap on every loop, and a one-rep trial run before the
# full probe (stop if the cells converge). "None: <why>" is a valid answer; a missing section is not.
$prompt = ($args | ForEach-Object { "$_" }) -join " "
foreach ($m in [regex]::Matches($prompt, 'TASK_[A-Za-z0-9_]+\.md')) {
    $brief = Join-Path $PSScriptRoot ("..\research\" + $m.Value)
    if (-not (Test-Path $brief)) { continue }
    $text = Get-Content -Raw -Encoding UTF8 $brief
    $kind = [regex]::Match($text, '(?im)^Kind:[^\r\n]*').Value
    if ($kind -match '(?i)design|probe' -and $text -notmatch '(?im)^##\s*Feedback loops') {
        Write-Host "REFUSED: $($m.Value) is a design/probe brief with no '## Feedback loops' section (S541 gate)." -ForegroundColor Red
        Write-Host "Add: what the change feeds, whether that feeds back, the cap on each loop, and a one-rep trial run first."
        exit 4
    }
}
$env:CLAUDE_CODE_EXPERIMENTAL_CODE_MODE = "1"
& claude @args
