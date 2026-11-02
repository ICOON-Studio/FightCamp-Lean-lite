---
name: project_session_S211_2026-10-12
description: S211 - cheek guard approved, gloves into the animation lab, Codex always gets the toolkit, 4 merges, E: freed; traps learned
metadata:
  type: project
---

S211 (2026-10-12). Operator: guard "OK - keep this guard" (Q-S210-2); "why the fighters do not wear gloves ?" -> ANIMSOURCE1D step F
(the lab renders bare MetaHuman fists; contact was measured at the knuckles - must be the glove surface, CCFighterSkin.drawn_glove_points).
Merged NIGHTLY4, RECEPTION1C_APPLY, RECORD1, STRESSTIP1. Maria 54 icons approved. Digest: research/S211_DIGEST.md.

Traps that cost time this session:
- check_workflow `branch` reuses the branch's registered worktree: an UNSEEDED scratch worktree fails EVERY test (12 false reds). Seed with
  Tools/seed_godot_cache.ps1 before gating.
- MHNATIVE1's mh_native_clips is GAME_ON: merging it alone ships whatever mh_*.glb is on master (the rejected 1B cross). Merge it TOGETHER
  with the accepted ANIMSOURCE1D clips.
- Git Bash `find` is Unix find: piping into `find /c` scanned all of C:. Use C:\Windows\System32\find.exe explicitly.
- Python heredocs with Windows paths: use raw strings or the Edit tool (\U escapes broke two scripts).
- Goose: installer moved to aaif-goose/goose; a run can "succeed" with no work when the provider wants credits - read the run log.
- Cloud agents (Qwen/Cursor) often push the branch but "PR could not be opened": collect from the branch by diff.
Related: [[feedback_codex_access_everything]], [[feedback_retire_worktrees_on_merge]].
