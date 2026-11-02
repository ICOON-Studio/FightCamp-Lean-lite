---
name: reference_jev_router
description: S213 Jev model router trial - jev-router 1.6.0, key in ~/.config/jev-router/env (operator's), 4 tiers Haiku5.5/Sonnet5.5/Opus5.5/Fable5.1, terminal-only via Tools/jev_claude.ps1
metadata:
  type: reference
---
Operator S213 asked for Jev (TypeSafe decision model) to route prompts by model. Setup (operator pasted the key himself):
`npx.cmd @ediri/jev-router@1.6.0 setup --models claude --service none --no-claude-settings` -> key in ~/.config/jev-router/env,
~/.claude/settings.json NOT touched (desktop app not routed). Config ~/.config/jev-router/config.json rewritten from the packaged
anthropic-fable.json: fast=claude-haiku-5-5, balanced=claude-sonnet-5-5, frontier=claude-opus-5-5, max=claude-fable-5-1 (backup .bak_s213).
Start a routed session: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\jev_claude.ps1` (finds claude.exe under the MSIX path
%LOCALAPPDATA%\Packages\Claude_*\LocalCache\Roaming\Claude\claude-code). Live view 127.0.0.1:4100; savings `npx.cmd @ediri/jev-router@1.6.0 report`.
Traps: PowerShell blocks npx.ps1 (use npx.cmd); Claude may not handle API keys - the operator types them.
Related: [[project_session_S213_2026-10-12]].

**S213 LATER - MACHINE-WIDE (operator: "i do not understand jev just incorporate it i trust it works"):**
- Router installed at C:/Users/user/jev-router (NOT %APPDATA%: this app is MSIX and its AppData writes are virtualized - a
  scheduled task outside the app cannot see them; same trap for any tool a background task must run).
- Scheduled Task "FightCamp Jev Router" (S4U, hidden, logon+boot, restart every 1 min x999): cmd /c node ... serve --config
  ~/.config/jev-router/config.json --env-file ~/.config/jev-router/env --ui 4100, log ~/.local/state/jev-router/service.log (+ .err).
- ~/.claude/settings.json env: ANTHROPIC_BASE_URL=http://127.0.0.1:4000, CLAUDE_CODE_GATEWAY_HINT_HEADERS=1, ENABLE_TOOL_SEARCH=true
  (backup settings.json.bak_s213_jev). CLAUDE_CODE_AUTO_COMPACT_WINDOW=160000 deliberately NOT set (keeps the 330k handover rule).
- Tiers capped at Opus (operator cheaper mode): fast Haiku 5.5, balanced Sonnet 5.5, frontier+max Opus 5.5; no Fable.
- If Claude Code cannot connect: router down -> Start-ScheduledTask "FightCamp Jev Router"; full undo = remove the 3 env keys
  (or restore the .bak) + Unregister-ScheduledTask "FightCamp Jev Router".
- First live call: Haiku 5.5, $0.0003 vs $0.011 baseline.

**S214 FINDING (operator "why jev is not working"):** the router works (one terminal session 4b1a97, 20:16 UTC, Haiku 5.5, $0.0096 vs
$0.38 baseline) but the DESKTOP APP overrides the settings env: inside a desktop session `ANTHROPIC_BASE_URL=https://api.anthropic.com`,
so desktop sessions never reach 127.0.0.1:4000 and the model is whatever the app's menu says. Routed work = terminal via Tools\jev_claude.ps1.
- S214: typing `jev` in any terminal (C:\Users\user\.local\bin\jev.cmd -> Tools\jev_claude.ps1) starts a routed session; the ps1 now
  reuses the scheduled-task router on 4000. Operator confirmed "i can see it working now". Desktop app sessions stay unrouted.

**S216 OPUS DEFAULT (operator: "setup the jev router to opus 5.5 high for default model thinking and then delegate to lower if necessary"):**
- ~/.config/jev-router/config.json: defaultTier=frontier; all four jev.options (mechanical, routine, complex, deep) map to frontier, so every
  message goes to Opus 5.5 (backup config.json.bak_opus_default). Undo = restore that backup and restart the router.
- ~/.claude/settings.json: model=opus, effortLevel=high (backup settings.json.bak_opus_default).
- Router restarted (stop node PID running jev-router serve, then Start-ScheduledTask "FightCamp Jev Router"); log shows config loaded and
  requests answered by claude-opus-5-5 with status 200. Port 4000 returns 404 on "/" by design (alive).
- Lower tiers are for bounded subtasks chosen explicitly through the Agent tool model parameter (haiku/sonnet). Subagents skip Jev.
- Trade-off: Jev no longer saves money by downgrading routine messages; the cheaper-mode rule in CLAUDE.md (Sonnet default) is superseded.
