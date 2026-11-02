---
name: feedback_cursor_agent_claude_hook
description: cursor-agent reads ~/.claude/settings.json and breaks on any PreToolUse hook - launch it through Tools/cursor_task.cmd
metadata:
  type: feedback
---

**cursor-agent implements Claude Code hook compatibility**: it reads `%USERPROFILE%\.claude\settings.json`
and runs the `PreToolUse` hooks it finds. On Windows it builds that call as **PowerShell** —
`$OutputEncoding = ...; Get-Content '<payload>.json' -Raw | & { $input | rtk hook claude }` — and then
evaluates the string with **bash**, which dies on `&` and `$OutputEncoding`.

Every shell command inside cursor-agent is then rejected before it runs, `echo test` included:
`Rejected: Hook blocked with message: --: eval: line 1: syntax error near unexpected token '&'`.

**It is not RTK's fault** — the broken wrapper is Cursor's own, so *any* Claude Code hook does it.
It cost Cursor the whole of U109's first pass: it wrote both tools correctly and could not run one
line, so no gate, no commit, no push.

**Does not work, do not retry:** `CLAUDE_CONFIG_DIR` pointed at an empty directory (ignored), and an
empty `.cursor/hooks.json` in either the project or the user directory (Cursor's own hook file does
not override the Claude import).

**How to apply:** launch through `Tools\cursor_task.cmd <prompt-file> <workspace-dir> [out-file]`,
which gives cursor-agent a HOME containing an empty `.claude/settings.json` plus a **junction** to
the real `.cursor`, so its auth, config and history stay its own and only the Claude settings are
hidden. The prompt arrives on stdin, so a long task file needs no quoting. The user's own
`rtk hook claude` is left untouched and still works in Claude Code. Related:
[[project_cursor_preferred_build_agent]], [[feedback_cursor_one_task_per_launch]].
