# TASK C201 - CODEX - ONE RIG, PASS 2: bring f02-f12 onto the canonical rig convention
Model: `gpt-6-astra`, MEDIUM (`CODEX_MODEL=gpt-6-astra`), web OFF. Owner: codex. Assigned S75, 2026-09-25. 3D lane.

## Why
C200 (merged S75, 55920f3b) locked FightCamp-f01-v1 (`research/C200_RIG_SPEC.md`) and measured the other eleven
fighters: names and parents match, but every one "differs on 22 bones" in rest, and f06/f08 are 1-unit exports. So
each body still carries its own per-bone retarget corrections - the readiness audit's G6 FAIL ("rig lock").

## What would a human do?
A studio keeps ONE skeleton DEFINITION - bone names, hierarchy, joint orientation (axis convention), units - and lets
each character have its OWN bone lengths. Animation is authored against the definition; per-character proportion is
handled by the retarget's translation/hip scaling, never by forcing every body to the reference man's limb lengths.
So the lock is on ORIENTATION + NAMES + UNITS, not on the exact local translations. Answer this in your digest first
(Blender/Unreal practice: one skeleton asset, proportion via retarget), then build.

## Do
1. Amend the spec: split admission into STRICT (names, parents, identity local rest bases within 0.5 degrees, metres,
   +Z forward, body-centred origin) and PER-BODY (bone lengths, stature 1.55-2.05 m). f01 stays the reference and its
   SHA256 lock is unchanged. Update `Godot/tools/import_fighter_clip.gd` admission and
   `Godot/tests/rig_convention_contract_test.gd` to match; keep every existing mutant, add one: a body with a correct
   length but a 30-degree rotated forearm rest basis must be REFUSED.
2. In Blender 5.2.1 (on the PC), re-orient f02-f12's rest so every local rest basis is identity, keeping skin weights,
   bone lengths and the mesh unchanged in world space (apply the inverse to the bind so the skin does not move). f06 and
   f08: rescale to their real stature (take it from the athlete data they are bound to, or 1.75 m if none) - never the
   1.00 m export height.
3. Re-export each as `<name>_rigged.glb` next to the original with a `_v1` suffix; do NOT overwrite the live files. Run
   admission on all twelve and print the table (name, stature, max basis error, ADMIT/REFUSE).
4. Prove it moves pictures, not only tables: retarget ONE RamsterZ clip (`H2H_HitReaction01.FBX`, the `react_head`
   window C200 hashed) onto f03 old vs f03_v1 and render both side by side at 854x480 through `Tools/godot_hidden.ps1`
   (never `--position`); md5 the MP4 and state what differs. The corrections table for f03_v1 should be near-identity.
5. Do NOT switch the live game to the _v1 files in this task. Swapping is S76, after the operator sees step 4.

## Owned files
`research/C200_RIG_SPEC.md`, `Godot/tools/import_fighter_clip.gd` (211 lines, read whole),
`Godot/tests/rig_convention_contract_test.gd` (122 lines, read whole), new `Godot/assets/models/fighters/*_v1.glb`,
new `Tools/blender/c201_*.py`, new `Godot/tools/c201_*.gd`, `research/C201_DIGEST.md`, the MP4 under
`research/_captures/watch_loop/`. `Godot/scripts/FightClipRetarget.gd` is READ-ONLY (~950 lines; `grep -n` then
`sed -n` windows); RamsterZ pose hash `83f6a766...f9ea` must stay unchanged.

## Gate (tier: script edited)
Parse gate on every touched .gd first. Then `python Godot/tools/run_tests.py --only rig_convention,clip_retarget,cascy,fight_clip,fight_world_live`.
Worktree: `git fetch origin && git checkout -B codex/c201-rebind-eleven origin/master` in a fresh worktree, then
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --import` ONCE before any test (S74 lesson: a worktree
without the import fails on class and asset caches, which is not a test result). No BUDDI/SMPL/SMPL-X/MANO anything.
Commit explicit paths, push the branch, then
`python Tools/agent_comms.py send --from codex --to claude --topic C201 --body "<admission table summary, mp4 md5, tests>"`.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
Re-orienting a rest bone without compensating its children and the inverse bind moves the skin: the table will say
ADMIT and the body will be folded. Step 4's render is the check the table cannot give - look at it before you send.
