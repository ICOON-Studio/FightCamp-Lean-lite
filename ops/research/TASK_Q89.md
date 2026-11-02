# TASK Q89 — QWEN — THE REACTIONS' ROOT SWAY: IS THE SKATE THE HIPS WE THREW AWAY?

Model: qwen3-coder, **medium**, `--yolo`. Owner: qwen. Worktree `C:/Users/user/AppData/Local/Temp/FightCamp-Q81`
(already imported). Before anything: `git -C C:/Users/user/AppData/Local/Temp/FightCamp-Q81 fetch origin` then
`git -C C:/Users/user/AppData/Local/Temp/FightCamp-Q81 switch -c qwen/q89-reaction-sway origin/master`.
Push the BRANCH; never checkout, merge or rebase anything else. Stage: S4a (d) part 3, item (3), forecast.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run the tool, gate script.

## Owned files

- `Godot/tools/measure_reaction_sway.gd` — **NEW, yours.**
- `research/Q89_REACTION_SWAY.md` — **NEW, yours.**
- `research/Q89_reaction_sway.json` — **NEW, yours.**

Do NOT edit any other file. `research/Q89_check.py` is Claude's - never edit it.

## Why this exists

The realism test `tests/fight_stage_realism_test.gd` rule R3 measures a planted foot sliding over the canvas in
the live room: **mean 0.333 m/s against a 0.10 m/s bound**, and by take **react_head 0.74 m/s, react_body
0.88 m/s, slip 0.58 m/s, hook_lead 0.85 m/s, idle 0.04 m/s** (measured at `d02757d`). A foot bearing weight has
zero ground velocity.

The suspect: the bought RamsterZ clips move the pelvis HORIZONTALLY (a hit man sways or steps back), and our
retarget carries only the pelvis HEIGHT. `Godot/scripts/FightClipRetarget.gd:358-381` says so ("the Hips get ONE
position track that moves on the height axis only"). If the performer's feet stay planted while his hips
travel, pinning the hips horizontally drags each planted foot along the canvas at the hips' speed. If instead the
performer's OWN feet slide, the skate is in the performance and no carry fixes it. This task tells the two apart,
on the source clips themselves, before anyone changes the retarget.

## The method - SOURCE CLIPS ONLY, no fighter body

Read `FightClipRetarget.gd` lines 460-525 (`_source_frames`) and 614-721 (`_load_fbx`, `_anim_of`, `_index`,
`_local_at`, `_globals`, `_to_ours`). They are `static` and callable from your tool as
`Retarget._load_fbx(path)` etc., with `const Retarget := preload("res://scripts/FightClipRetarget.gd")`.
For each sample `t`: `var g: Dictionary = Retarget._to_ours(Retarget._globals(index, Retarget._local_at(index, clip, t)), Retarget.UE4_TO_OURS)`
gives each of OUR bone names -> its global `Transform3D` in the source scene. Free each loaded scene
(`scene.free()`) when its takes are done.

**Which takes - read them, never copy them:** `const Binding := preload("res://scripts/FightClipBinding.gd")`,
then for EVERY role in `Binding.BINDINGS` whose `"path"` ends in `.FBX` (case-sensitive) AND which carries
`"retarget": true`: if the role has `"variants"`, each variant is one take (its own `path`, `start_s`,
`end_s`); otherwise the role's own `path`, `start_s`, `end_s` is one take. Take names: `role` for the first,
`role#1`, `role#2` ... for the rest - the same names `FightStagePlayer` gives them.

**Sampling:** 30 samples per second over `[start_s, end_s]`, both ends included:
`n = max(2, ceil((end_s - start_s) * 30) + 1)`, sample `s` at `start_s + (end_s - start_s) * s / (n - 1)`.
This is exactly `_source_frames`' rule.

Per sample record: `t` (seconds from the take's start), and the global ORIGIN of `Hips`, `LeftToes`, `RightToes`
as `[x, y, z]`. Y is up.

**Per take, compute (the gate recomputes every one of these from your raw rows):**

- `floor_y` = the lower of the two toes' `y` at sample 0.
- A **planted step** between samples `k-1` and `k`: take the LOWER toe at `k` (left if `left.y <= right.y`); the
  step counts only if the same toe is also the lower one at `k-1`, and both its heights above `floor_y` lie in
  `[-0.0263, 0.05]` m (the realism test's R3 rule, `tests/fight_stage_realism_test.gd:432-445`).
- `source_skate_mps` = mean over planted steps of that toe's horizontal speed `|dxz| * 30`. 0 when no step.
- `pinned_skate_mps` = the same mean, but each toe's horizontal position first has the Hips' horizontal travel
  removed: `toe.xz - (hips.xz(k) - hips.xz(0))`. This is what our body does with the hips pinned (proportions
  ignored) - the PREDICTION of what the room measures.
- `hips_speed_planted_mps` = mean over the same planted steps of the Hips' horizontal speed.
- `hips_travel_end_m` = `|hips.xz(last) - hips.xz(0)|`; `hips_travel_max_m` = max over samples of `|hips.xz(k) - hips.xz(0)|`.
- `planted_steps` = the count.

## JSON

```json
{
  "population": {"kind": "source clips only, no fighter body", "fps": 30,
                 "binding": "res://scripts/FightClipBinding.gd", "name_map": "FightClipRetarget.UE4_TO_OURS"},
  "room_r3_at_d02757d": {"react_head": 0.74, "react_body": 0.88, "slip": 0.58, "hook_lead": 0.85, "idle": 0.04},
  "takes": [{"take": "react_head", "role": "react_head", "path": "", "start_s": 0.0, "end_s": 0.0,
             "floor_y": 0.0, "planted_steps": 0, "source_skate_mps": 0.0, "pinned_skate_mps": 0.0,
             "hips_speed_planted_mps": 0.0, "hips_travel_end_m": 0.0, "hips_travel_max_m": 0.0,
             "samples": [[0.0, [0,0,0], [0,0,0], [0,0,0]]]}]
}
```

`samples` rows are `[t, hips, left_toes, right_toes]`.

## The markdown

Open with `## DECISIONS`: one table row per take (take, source skate, pinned skate, hips speed while planted,
hips travel end / max). Then, per ROLE that `room_r3_at_d02757d` names, the take-count-weighted mean pinned skate
beside the room's number, and a one-word verdict per role:

- **SWAY** - source skate under 0.10 m/s and pinned skate at least 0.10 m/s: the feet are planted in the
  performance and pinning the hips makes them slide. Carrying the horizontal hip travel would fix it.
- **PERFORMANCE** - source skate at least 0.10 m/s: the performer's own feet slide or step.
- **CLEAN** - both under 0.10 m/s.

One closing line: does the pinned skate explain the room's react_head and react_body numbers (within a factor of
two), yes or no, with the numbers.

## Gate - in this order, from the worktree root

1. `python Godot/tools/check_scripts.py Godot/tools/measure_reaction_sway.gd`
2. `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py . tools/measure_reaction_sway.gd --timeout 900`
   (the tool writes the JSON to `res://research/Q89_reaction_sway.json` and prints `Q89 done takes=<n>`).
   **A GDScript runtime error HANGS a headless run until its timeout: read the log after the first minute; a
   `SCRIPT ERROR` line means kill it and fix.** `var x := <call>` fails on a Variant return - write the type.
3. `python research/Q89_check.py` must print `Q89_CHECK PASS` and exit 0. Copy it from master first if your
   branch does not have it: `git -C <worktree> checkout origin/master -- research/Q89_check.py` (read it; do
   not commit a change to it).
4. Write the markdown.

## Commit

`git status -s` first. `git add -- Godot/tools/measure_reaction_sway.gd research/Q89_REACTION_SWAY.md research/Q89_reaction_sway.json`
then `git commit -m "Q89: ..." -- <the same three paths>`, `git show --stat HEAD` (exactly three files),
`git push -u origin qwen/q89-reaction-sway`, then
`python Tools/agent_comms.py send --from qwen --to claude --topic "Q89 ready" --body "qwen/q89-reaction-sway <hash>"`.
Do NOT edit `HANDOFF.md`.

## The trap

Two traps, both from earlier measurements on this same pipeline. (1) `_globals` composes from the FBX scene ROOT,
so the Hips origin INCLUDES any root travel - that is what you want; do not subtract the root. (2) A take whose
toes never come within 5 cm of `floor_y` (a knockdown lying down, a jumping clip) has zero planted steps: report
`planted_steps: 0` and skates of 0 - never skip the take and never invent a floor.

## SENT BACK 2026-09-13 (first delivery `d153559`)

The tool subtracted the FBX `root` node's horizontal origin from every bone
(`measure_reaction_sway.gd:116-123`) - **trap (1) above says do not**. The vendor stores a reaction's sway and
a stagger's travel IN THE ROOT, so the subtraction zeroed exactly the quantity this task measures: `react_body`
(H2H_StaggerSmall01, 0-1 s) read hips travel 0.000 m, and every reaction's root sway was reported as the
performer's own foot slide (PERFORMANCE). Claude's independent probe through the same production composition
(`_globals` over `_local_at`, nothing subtracted) reads that window at **Hips XZ max 0.722 m, LeftToes XZ max
0.698 m**, and the whole of H2H_HitReaction01 at Hips 0.154 m against LeftToes 0.002 m - planted feet, swaying
hips. Your `pinned_skate` numbers are unaffected (pinning cancels the root) and matched the room; the SOURCE
columns and the verdicts are wrong.

**Fix:** delete the root subtraction (lines 116-123) and nothing else, re-run, re-write the verdicts from the new
numbers. `Q89_check.py` on master now fails any tool that indexes `["root"]` and any `react_body`
`hips_travel_max_m` more than 10% from 0.722 m. Copy it from `origin/master` again before running it. Amend
nothing: make a NEW commit on the same branch with the same three paths, push, mail "Q89 ready (resent)".
