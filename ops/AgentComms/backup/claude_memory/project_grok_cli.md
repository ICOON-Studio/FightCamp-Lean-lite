---
name: project_grok_cli
description: "Grok Build CLI 1.0.44 (xAI official) installed S124 on D:\\FightCamp\\tools\\grok\\bin; needs the operator's SuperGrok sign-in (plan paid until 2026-09-30); headless `grok -p`"
metadata:
  node_type: memory
  type: project
  originSessionId: 3789a020-1b4a-44ae-a0bb-6a86b94e9301
  modified: 2026-09-29T07:26:01.562Z
---

S124 (2026-09-29): operator asked "can you install grok cli?" and approved the stated download. Installed xAI's official
**Grok Build** 1.0.44 from `https://x.ai/cli/install.ps1` (script read in full first) with `GROK_BIN_DIR=D:\FightCamp\tools\grok\bin`
(grok.exe + agent.exe 156 MB each, grove hook exes). Bundled MinGit skipped (LOCALAPPDATA unset for the installer - it is
hard-wired to C:; git on PATH is used). The C: download copy was deleted; `~/.grok` holds config.toml, docs, completions.
User PATH now has the bin dir.

**Signed in S124 by the operator; headless verified:** `grok -p "..." --output-format plain` from a D: scratch dir answered
"GROK_OK Grok 4.7" in 6.5 s (default model Grok 4.7).

**Why:** Grok was browser-only (in-app browser); a CLI makes it a shell agent like Kimi/Cursor/Qwen.

**How to apply:**
- Sign-in is the OPERATOR's (`grok login`, browser OAuth at auth.x.ai, or `--device-auth`); it needs SuperGrok or X Premium+.
  The Grok plan is paid until 2026-09-30 - confirm renewal before relying on it. Never enter credentials; an xAI API key
  (`XAI_API_KEY`, console.x.ai) is the fallback, also the operator's to set.
- Headless: `grok -p "<prompt>" --output-format plain`, `--permission-mode bypassPermissions` or `--always-approve`,
  `--cwd <worktree>`. Docs on disk: `~/.grok/docs/user-guide/14-headless-mode.md`, `22-permissions-and-safety.md`.
- It reads `.claude/settings.json` for permission defaults - it may also pick up the repo's Claude hooks, as Cursor did
  ([[feedback_cursor_agent_claude_hook]]). Check that on the first launch.
- It is a SHELL agent: counts toward the two-at-once limit ([[feedback_two_agents_max_idle_priority]]); launch at IDLE
  priority, worktree on D: ([[feedback_worktrees_on_d]]). Launcher (like Tools/kimi_task.ps1) still to write after sign-in.
- Ops board (dd00d1b0): grok/kimi/cursor are detected by CLI INSTALL PATH (Tools/opsboard/server.py CLI_PATHS) and show
  'CLI · running' / 'CLI · idle'. The board is the scheduled task 'FightCamp Ops Board' running source server.py - kill its
  python and Start-ScheduledTask to load code changes; the first snapshot after a restart is the cached one (~30 s).
