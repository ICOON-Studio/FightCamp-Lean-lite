---
name: project-session-S214
description: S214 tooling stage - usage band + model-router mod in all new sessions, live view 4101 with agents, agent meters/router; EQUIPSLOTS1A merged
metadata:
  type: project
---
S214 (2026-10-12/13). EQUIPSLOTS1A merged c7ab1ea1 (39/0). Operator asked for the usage band everywhere, then Jev for all
sessions: the desktop app forces ANTHROPIC_BASE_URL, so routing moved INSIDE via the model-router mod (`turn.step` model
rewrite) + live view 127.0.0.1:4101 (Tools/jev_live.mjs, task "FightCamp Jev Live", forked jev UI with one client per agent).
Agent meters (Tools/agent_meters.py) + decisions (Tools/agent_router.py) on 8787/agents. Digest S214_DIGEST.md.
Traps: hot reload does not pick up a mod folder created after enabling (new sessions load it via CLAUDE_CODE_PLUGIN_DIRS,
';'-separated); `$` must be passed only to top-level functions (validate refuses closures); type is `EngineInterface`;
a headless `claude -p` test inside the repo gets driven on by the Stop hook - run it elsewhere; Windows keeps an open Codex
log's mtime at creation - pick logs by date folder. Cursor/Qwen/Grok billing waits on Q-S212-3 (operator keys).
Related: [[reference-usage-meter-mod]] [[reference_jev_router]].
