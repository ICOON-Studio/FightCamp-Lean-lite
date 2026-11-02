---
name: feedback_operator_commands_must_run_in_powershell
description: every command handed to the operator must work in THEIR PowerShell; my shell is MSIX-sandboxed so my paths lie - codex via LOCALAPPDATA\OpenAI\Codex\bin
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0aecafce-54cc-4dc8-94e4-3d1b7a25653f
  modified: 2026-09-24T23:37:57.753Z
---

Operator, 2026-09-25, after `codex mcp add ...` failed with "codex is not recognized": "i have been using for a month
non stop you have never given me the right command to put on the powershell every command you give returns error".
The same day a bare `C:\Program Files\...` folder path failed, and so did `& "$env:APPDATA\npm\codex.cmd"`.

**Why:** the Claude app is an MSIX package, so MY %APPDATA% is virtualized: `npm\codex.cmd` exists for my shell and
NOT for the operator's. A command that runs in my PowerShell tool is therefore not proof it runs in theirs. The
operator types into Windows PowerShell 5.1 (sometimes as Administrator).

**How to apply:** hand over only commands built from paths that live OUTSIDE AppData\Roaming, tag the block
`powershell`, quote every path with spaces and prefix with `&`. VERIFIED WORKING for the operator:
codex = `& (Get-ChildItem "$env:LOCALAPPDATA\OpenAI\Codex\bin" -Recurse -Filter codex.exe | Select-Object -First 1).FullName`.
Blender 5.2 = `& "C:\Program Files\Blender Foundation\Blender 5.2\blender.exe"` (or just launch it myself).
Never a bare `codex`, `qwen`, `cursor-agent`, or anything under my APPDATA. Better: launch things myself when the
permission layer allows, and hand over only what needs the operator's hands (sign-ins, approvals).
