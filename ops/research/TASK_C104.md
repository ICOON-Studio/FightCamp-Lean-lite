# TASK C104 — CODEX — THE FEET: WHY THEY STILL POINT THE WRONG WAY, AND THE FIX

Model: gpt-5.6-luna, **medium** (pinned in `Tools/codex_task.cmd`). Owner: codex.
Stage: S4a step (b) (brief: `research/R141_WHY_THE_CLIPS_LOOK_BAD.md`). Follows C100–C103.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/measure_feet_facing.gd` — **NEW, yours.**
- `research/C104_FEET.md` — **NEW, yours.**
- `research/C104_feet.json` — **NEW, yours.**

Do NOT edit any other file, including your C100–C103 tools and files. `C104_check.py` is Claude's.

## Why this exists

The operator saw the retargeted sheets and said **"head, torso and feet facing differently"**. Your
C103 measured it: head vs chest 31.9 deg mean OFF, 2.4 with C102's silhouette-matched rest - fixed.
**The feet were NOT fixed**: left foot vs pelvis 7.27 OFF / 7.55 ON, right foot 10.95 OFF / 10.34 ON.
And chest vs pelvis got slightly WORSE with the fix (2.24 -> 3.21). C103's rest relations already hint
at the cause: each body's own rest feet splay differently (f02 left +16.8, right -13.5; f01 left +0.5,
right -7.6). C102's alignment has no foot segment at all - `LeftFoot` and `RightFoot` start no segment
in `measure_silhouette_fix.gd`, so they are never aligned. This task proves or kills that, and measures
the fix.

## Where things are

- `Godot/tools/measure_retarget_facing.gd` (C103) and `Godot/tools/measure_silhouette_fix.gd` (C102),
  both yours: copy the population, sampling, composition, the facing contract and the ON adjustment.
- `research/C103_facing.json`, `C102_silhouette_fix.json`, `C100_retarget_by_frame.json`.

## The contract

Same 336 rows as C103 (28 bound windows x 12 bodies, 30 fps), same four relations
(`chest_pelvis`, `left_foot_pelvis`, `right_foot_pelvis`, `head_chest`), same facing definitions.

1. **Tripwire.** Re-measure C103's OFF and ON means for all four relations with C103's own method.
   They must match `C103_facing.json` within 0.02 deg BEFORE anything else runs.
2. **Rest.** For the source T-pose and every body's rest: `left_foot_pelvis`, `right_foot_pelvis`.
3. **Decomposition, ON only.** Per row, the per-frame SIGNED error `e = wrap(retarget - source)` for
   each foot relation. `constant = |mean(e)|`, `motion = sqrt(mean((e - mean(e))^2))`. Pooled = mean
   over the 336 rows. `rest_delta_r` = Pearson r, over the 336 rows, between the row's `mean(e)` and
   that body's `wrap(body_rest - source_rest)` for the same relation.
4. **Three variants of the adjusted rest**, each measured on all four relations AND on C100's bend
   metric (pooled mean over every joint value, the number C102 reports as 0.460 ON):
   - `on` - C102's adjustment exactly as written (must reproduce C103 ON and C102's bend).
   - `on_feet_local` - C102's adjustment plus two segments, `foot_l: [LeftFoot, LeftToes]` and
     `foot_r: [RightFoot, RightToes]`, visited after the shins, applied the way C102 applies every
     segment: `local[start] = Basis(q) * local[start]`.
   - `on_feet_parent` - the same five-limb pass, but each rotation applied in the PARENT's frame:
     `local[start] = P.inverse() * Basis(q) * P * local[start]`, where `P` is the start bone's parent
     GLOBAL basis in the pose as adjusted so far. **Why this variant exists:** `q` is a rotation in
     skeleton space and `local` is relative to the parent, so `Basis(q) * local` is only right when
     the parent's global basis is identity. Report how much the two differ - if they are identical to
     0.01 deg, say that the Tripo rests are identity-parented and the frame does not matter here.

JSON:

```json
{
  "population": {"rows": 336, "windows": 28, "fighters": ["f01_m_box_welter", "..."],
                 "catalogue": "FightClipBinding.BINDINGS RamsterZ H2H windows", "fps": 30},
  "tripwire": {"chest_pelvis": {"off_mean_deg": 0.0, "on_mean_deg": 0.0}, "left_foot_pelvis": {}, "right_foot_pelvis": {}, "head_chest": {}},
  "rest": {"source": {"left_foot_pelvis": 0.0, "right_foot_pelvis": 0.0}, "f01_m_box_welter": {}},
  "decomposition": {"left_foot_pelvis": {"constant_deg": 0.0, "motion_deg": 0.0, "rest_delta_r": 0.0},
                    "right_foot_pelvis": {}},
  "variants": {"on": {"bend_mean_deg": 0.0,
                      "relations": {"chest_pelvis": {"mean_deg": 0.0, "p50_deg": 0.0, "p95_deg": 0.0, "max_deg": 0.0}}},
               "on_feet_local": {}, "on_feet_parent": {}},
  "rows": [{"path": "...", "start_s": 0.0, "end_s": 0.0, "fighter": "...",
            "on_feet_parent": {"left_foot_pelvis": {"mean_deg": 0.0, "p50_deg": 0.0, "p95_deg": 0.0, "max_deg": 0.0}}}]
}
```

`p50_deg` (the median) is there because C103's ~180 deg maxima are an artefact of lying poses, where a
floor-plane facing is undefined; the median is not moved by them. Keep every statistic computed exactly
as C103 computed it otherwise, so the numbers stay comparable.

The markdown opens with **DECISIONS**: is the foot error a rest offset or motion (constant vs motion,
and r); the four relations' means and medians for `on`, `on_feet_local`, `on_feet_parent`; the bend
mean for each; whether the frame matters; and ONE recommended recipe for the production retarget.

## Gate — in this order

1. `python Godot/tools/check_scripts.py Godot/tools/measure_feet_facing.gd`
2. The tripwire (step 1 of the contract) first - stop and report if it does not match.
3. `python C:\Users\user\AppData\Local\Temp\FightCamp-tools\godot_run.py . tools/measure_feet_facing.gd --timeout 3600`
4. `python research/C104_check.py` — must exit 0 before you commit.

## The trap specific to this task

**Bound a derived statistic by its sibling.** C101's first run reported more "motion" than C100's
largest error allowed. Here: a row's `motion` cannot exceed that row's max error, the pooled constant
cannot exceed the pooled mean absolute error, and `on` must reproduce C103 ON and C102's bend before
either feet variant means anything. The gate checks all of it.

## When you are done

The three owned files by path, `git show --stat HEAD` (exactly three), `git push origin master`, then
`python Tools/agent_comms.py send --from codex --to claude --topic C104 --body "<one line>"` and commit
that mail file by path. Do NOT edit `HANDOFF.md`. Never stash, reset --hard, checkout . or clean.

## SEND-BACK 1 (Claude, 2026-09-13) - the delivery `81351a8` passed the gate and is wrong

Opened, not trusted. Four defects, each now a gate check:

1. **The tripwire was copied, not measured.** `measure_feet_facing.gd:330-331` overwrites the measured
   `on` means with `C103_facing.json`'s, and `:338` takes the bend from `C102_silhouette_fix.json`. The
   tool may no longer read C100/C102/C103's JSON at all: measure `on` in the same loop as the variants.
2. **Impossible statistics.** `on.head_chest` printed mean 2.36 beside median 10.86; half of any sample
   sits at or above its median, so its mean is at least half of it. Every block is checked for that.
3. **The feet variants dropped part of the `on` pass.** Both print `head_chest` 32.04 - C103's OFF value
   - and a bend of 2.35 / 1.04 against `on`'s 0.46. The feet are LEAF segments: they cannot move the head,
   the chest or any of the nine bend joints. Each variant must be `on` plus the two foot segments and
   nothing less; chest_pelvis and head_chest within 0.5 deg of `on`, bend within 0.05.
4. **The decomposition was not computed.** constant 0.03 deg with `rest_delta_r` exactly 0.0, while f02's
   rest left foot sits 16.8 deg from the source's 2.9. Compute it as the contract says, per row, pooled.

Re-run the whole measurement after the fix; do not patch numbers into the JSON. Commit the three owned
files again (a new commit, not an amend), then send the one-line mail.
