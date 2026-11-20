# claude_cm.ps1 - start ONE terminal Claude Code session with the experimental Code Mode on (S531, owner asked "can you take
# advantage of this" about the Code Mode guide). Code Mode = Claude writes one script that makes many tool calls and only the
# answer reaches its context. Needs Claude Code 2.1.323+ (we have 2.1.327), Git for Windows, Opus/Sonnet/Haiku 5.5 or Fable 5.2.
# It runs ONLY in an interactive terminal (not the desktop app, not claude -p). While it is on, Claude in Chrome, computer use
# and Remote Control are OFF - so browser work (Ludo, Arena, Mixamo) stays in a normal session.
# Our PreToolUse hooks (rule_guard) still run on every call inside the script (docs: "under the tool's usual name").
# Usage, from the repo root in a terminal:  powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\claude_cm.ps1 [claude args]
# Only this process gets the variable: plain `claude` elsewhere stays normal.
$env:CLAUDE_CODE_EXPERIMENTAL_CODE_MODE = "1"
& claude @args
