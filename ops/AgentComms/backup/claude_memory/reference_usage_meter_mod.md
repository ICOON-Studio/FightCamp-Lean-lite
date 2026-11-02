---
name: reference-usage-meter-mod
description: "The USAGE band (7D/5H/CTX) mod is REMOVED (S217 operator \"remove this its ugly ... covers half the screen\"); files kept in ~/.claude/mods/usage-meter"
metadata:
  node_type: memory
  type: reference
  originSessionId: c806f41f-3ae7-411c-afb0-2a34958e1367
  modified: 2026-10-13T08:05:28.001Z
---

S214 (2026-10-12) the operator asked for a usage band on every session; it loaded from `~/.claude/mods/usage-meter`
via `env.CLAUDE_CODE_PLUGIN_DIRS` in `~/.claude/settings.json`.

S217 (2026-10-13) operator: "remove this its ugly i told you to make it nice and it covers half the screen".
The env entry is deleted (backup settings.json.bak_s217_remove_band); the mod folder is left on disk, unloaded.
**How to apply:** never re-enable it or add another band/panel above the prompt unless he asks. If he asks again,
it must be one compact line and approved from a screenshot first.
