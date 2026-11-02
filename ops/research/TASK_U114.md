# TASK_U114 — CURSOR — THE THREE REPAIRS U113 PRICED: MAKE A CASCADEUR CLIP LOADABLE

**Agent:** Cursor · **Model:** composer-2.5 · **Effort:** medium · **Fast:** off
**Launch:** `Tools\cursor_task.cmd <this file> <workspace>` — NEVER `cursor-agent` directly.
**Branch:** `cursor/u114-cascadeur-retarget` · **Read this file and only the files it names.**
Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest other than
`research/U113_CASCADEUR_EXPORT.md`, and do not explore to "get oriented".

**Test tier — a `.gd` IS edited, so:** parse gate first
(`python Godot/tools/check_scripts.py <every .gd you touched>`), then
`python Godot/tools/run_tests.py --only clip`, then `--only pair`, then `--only grapple`.
**NO full suite** — that is Claude's at integration. **fails CEILING: the tree's four baseline
reds are `athlete_development`, `fight_pair_live` (PARKED on purpose), `fight_scoring` and
`fight_stage_realism`.** Match `AgentComms/last_suite.json` name for name; a NEW red name is a
failure you caused and must be fixed or reported, not shipped around.

---

## WHY THIS EXISTS

U113 (yours, 2026-09-21) proved a Cascadeur GLB cannot enter our paired retarget path and priced
the repair at four steps. **Step 3 is already done — Claude exported the Cascy reference and
committed it.** You are doing the other three, and they must land together: U113's own words are
"any one of the three alone is insufficient."

**Read `research/U113_CASCADEUR_EXPORT.md` first.** It has the full 21-row bone table in
§2 and the three blockers in §3. Do not re-derive the table — it is measured and gated.

## THE THREE REPAIRS

**1. `CASCY_TO_UE4`, a constant beside `UE4_TO_OURS` in `Godot/scripts/FightClipRetarget.gd`.**
21 rows, copied from U113 §2: `pelvis`→`pelvis`, `stomach`→`spine_01`, `chest`→`spine_02`,
`neck`→`neck_01`, `head`→`head`, `clavicle_l/r`→`clavicle_l/r`, `arm_l/r`→`upperarm_l/r`,
`forearm_l/r`→`lowerarm_l/r`, `hand_l/r`→`hand_l/r`, `thigh_l/r`→`thigh_l/r`,
`calf_l/r`→`calf_l/r`, `foot_l/r`→`foot_l/r`, `toe_l/r`→`ball_l/r`.
`PairedStagePlayer.graft_pair` hardcodes `FightClipRetarget.UE4_TO_OURS` at line 161 — that call
site has to be able to ask for the Cascy map instead. **Do not delete or rewrite `UE4_TO_OURS`;
every existing RamsterZ binding depends on it.**

**2. `.glb` loading.** `FightClipRetarget._load_fbx` (line 667) uses `FBXDocument` only.
`FightStagePlayer._load_glb` (line 1110) already does the `GLTFDocument` version — **copy that
pattern, do not invent a second one.** Check `_source_frames` too; U113 names it as the other
place that assumes FBX. Dispatch on the file extension so an `.fbx` path behaves exactly as it
does today.

**3. `UpperChest` inherits from `Chest`.** Cascy has no third spine segment (no `spine_03`), so
our `UpperChest` has no source. Make it follow `Chest` rather than being left unmapped. **Say in
the digest what "inherits" means in the code you wrote** — copied rotation, identity, or
something else — because a later reader will need to know whether the upper chest is really being
driven or merely not crashing.

## THE REFERENCE POSE, AND A QUESTION YOU MUST SETTLE RATHER THAN ASSUME

`Godot/assets/anim/audition/cascadeur/Cascy_rest_reference.glb` is committed: 66 skin joints, one
skinned mesh, a single keyframe. **It is Cascy's REST pose — arms at his sides — and it is NOT a
T-pose**, because `go_to_default_pose` refused on this rig (its nodes carry no stored T-pose).
The file is named for what it is on purpose; do not rename it to `T_pose`.

`build_silhouette_corrections` currently loads `PAIRED_REFERENCE` =
`res://assets/anim/audition/ramsterz_h2h/T_pose.fbx`, the UE4 Mannequin T-pose. **Read that
function and answer, in the digest: does the reference have to be a T-pose specifically, or does
it only have to be the pose the SOURCE rig's clip data is relative to?** If the rest pose
suffices, wire it and say why. **If a true T-pose is genuinely required, STOP at that point, say
so with the line of code that requires it, and deliver the other two repairs.** Do not fabricate
a T-pose by hand-rotating arms — a wrong reference silently folds the clip, which is the R108
failure mode U113 names.

## THE GATE

The three GLBs from S30 are at `C:/Users/user/AppData/Local/Temp/FightCamp-cascadeur-export/`
(`S30_CLINCH_A.glb`, `S30_CLINCH_B.glb`, `S30_CLINCH_pair.glb`). If that directory has been
cleared, say so and use the committed `Cascy_rest_reference.glb` alone.

Write `research/U114_check.py` and **it must exit 0 on a real run.** It asserts at least:
the `CASCY_TO_UE4` map has 21 rows and every value is a key of `UE4_TO_OURS`; the loader
dispatches on extension for both `.fbx` and `.glb`; and one literal pinned number a later reader
can check by eye. Print `U114_CHECK ...` lines and `U114_CHECK PASS`.

**And the real proof is not the check script — it is loading the clip.** Show, from a Godot run,
that `retarget_clip` gets past `_load_fbx` on `S30_CLINCH_A.glb` and reports bones mapped. **If
it loads and then fails later for a different reason, that is a GOOD result** — report the new
failure precisely. Do not tune anything to make a number look better.

## DELIVERABLES

- The edits to `Godot/scripts/FightClipRetarget.gd` and whatever call site needs the Cascy map.
- `research/U114_CASCADEUR_RETARGET.md` — what you changed, the reference-pose answer, the
  load result, the subset test output with its real `fails=` and the failing names.
- `research/U114_check.py` — exits 0.

Commit with explicit paths (`git add -- <files>`), push `cursor/u114-cascadeur-retarget`, then:

```
python Tools/agent_comms.py send --from cursor --to claude --topic u114-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`.

## THE TRAP SPECIFIC TO THIS TASK

**`UE4_TO_OURS` is load-bearing for every RamsterZ paired clip already shipping.** The temptation
is to "unify" the two maps or to make `UE4_TO_OURS` accept Cascy names. Do not. Add a second map
and a way to choose it. If a single existing test that passes today goes red, you have broken the
RamsterZ path, and that matters more than the Cascadeur one.

Second: `var x := <call>` fails when the call returns Variant, and a `Dictionary` lookup returns
Variant. Write the type — `var ue4: String = CASCY_TO_UE4[bone]` — never `:=`. A parse error does
not fail a headless test, it HANGS it until the timeout.
