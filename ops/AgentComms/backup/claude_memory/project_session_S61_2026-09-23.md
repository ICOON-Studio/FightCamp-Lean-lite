---
name: project-session-s61-2026-09-23
description: "S61 - CC fighter in the LIVE room (skin=cc, K toggle), gloves from ruleset data sized by G80, blind test caught get_bone_global_pose zero; S62 = engine-owned separation"
metadata:
  node_type: memory
  type: project
  originSessionId: 451cb13b-3b68-4664-bd9a-9fcc80f7aa25
  modified: 2026-09-23T15:57:05.023Z
---

S61 (2026-09-23) shipped `CCFighterSkin.gd`: the Character Creator body rides fighter A in the live room (`fighter_skin=cc`, `-- skin=cc`, record_room `skin=cc`, K toggles). Tripo body keeps playing, meshes hidden. Gloves come from `combat_rulesets.json` `gloves` (Qwen Q154), sized from Grok's G80. Height = A's mounted 1.740 m, no CC export spent (29 of 30 left).

Earned: Cursor's BLIND contract test (U148) found `get_bone_global_pose()` returns zero on an un-updated skeleton. Claude's own test passed because the live room refreshes it. See [[feedback-withhold-the-formula-give-the-definition]], [[project-godot-skeleton-pose-traps]].
Trap: the shared checkout was left on Codex's branch at session start. Check `git branch --show-current` before `git pull`.
Codex now runs in worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Venue` via `CODEX_REPO`, so its branch switches don't hit master.

**Why:** the next session builds S62, engine-owned separation. G79 gives the distance bands; Cursor U149 measures the before-table.
**How to apply:** collect Codex Northlight, U149 and Q155 first. The operator's CC verdict is pending: they launch the room with `-- skin=cc`.
