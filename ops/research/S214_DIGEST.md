# S214 DIGEST (2026-10-12/13) - tooling stage: usage band everywhere, model router, agent meters; EQUIPSLOTS1A merged

## What now works (evidence)
- EQUIPSLOTS1A MERGED c7ab1ea1 (codex/equipslots1a diff minus HANDOFF/TASK): authored equipment slots per zone.
  `--only equip_slots,equipment_catalog,market_filter,club_fill,club_capacity,training_gain,gym --jobs 2` SUITE 39/0 (run on GREEN).
  Worktree E:/FightCamp/wt/EQUIPSLOTS1A retired.
- USAGE BAND in every session: mod ~/.claude/mods/usage-meter via settings env CLAUDE_CODE_PLUGIN_DIRS; also writes
  ~/.claude/mods/model-router-live/claude_usage.json (Claude 5h/week for the board).
- JEV: router works (terminal sessions; `jev` command = ~/.local/bin/jev.cmd -> Tools/jev_claude.ps1, reuses the 4000 router).
  The DESKTOP APP forces ANTHROPIC_BASE_URL=https://api.anthropic.com, so desktop sessions never reach it (operator "why jev is not working").
- MODEL ROUTER MOD (~/.claude/mods/model-router, Jev-lite): per prompt one Haiku call sorts mechanical/routine/complex/deep ->
  Haiku 5.5 / Sonnet 5.5 / Opus 5.5 via the `turn.step` model rewrite; `@haiku|@sonnet|@opus` forces; `/router on|off`.
  Proven headless (`--plugin-dir`, debug log: loaded, model.complete answered, events written). Loads in NEW sessions (env);
  this session's hot reload never picked up the folder created after enabling.
- LIVE VIEW 127.0.0.1:4101 (task "FightCamp Jev Live", Tools/jev_live.mjs): FightCamp copy of jev-router's UI (Apache-2.0,
  Tools/jev_live_ui with LICENSE+NOTICE) - one client per agent seat; Claude sessions from the mod's events; agent runs from
  live_runs.json (running = in flight); Codex tokens from ~/.codex/sessions (head/tail reads by date folder; cost $0 plan,
  baseline = Opus price; TECHSTAGE1 $9.02 baseline). Ops board nav tab "Model router".
- AGENT METERS + DECISIONS: Tools/agent_meters.py (Claude, Codex, GitHub $, OpenRouter), Tools/agent_router.py (role, busy,
  3-shell cap, watchdog, plan headroom); /api/meters + bars and next-task picks on 8787/agents.

## Game work
- GYMLOOK3A r3 landed 0daed17d: maple + corners fixed, FPS 27.5->44.7. Claude opened stills: brick smeared (stretched UVs), blue
  banner over the club name, square still on the ring emblem -> TASK_GYMLOOK3A_FIX3 (pixel-checker acceptance), Cursor RUNNING.
- TECHSTAGE1: Codex still working (uncommitted edits + Q226/face-drawn controls) - NOT merged; check_workflow flags HANDOFF/blocker files.
- TASK_FIGHTLOG1.md written (r46 slice 2) - launch on Codex after TECHSTAGE1 merges.
- PROFILE2E r7: Cursor process ended - collect.

## Decided (developer calls)
- No outside-proxy hack of the desktop app; route from inside via the mod API. Cost of switching models: one cache write per model.
- Agent cost: only Codex has readable token logs; Cursor/Qwen/Grok need operator keys -> Q-S212-3 on the board.
- Sale question (operator): not a product now (core is jev-router's, crowded field, new mod API); maybe free portfolio piece post-demo.

## Mistakes
- 4 shell agents for a while (PROFILE2E miscounted as landed). agent_router.py now enforces the cap from live_runs.
- A headless `claude -p` test ran in the repo: the Stop hook kept it working (tools denied, nothing changed). Run such tests outside the repo.
