# TASK Q87 — QWEN — THE HIP CARRY, PROTOTYPED AND JUDGED BY THE FLOOR

Model: qwen3-coder, **medium**, `--yolo`. Owner: qwen. Branch `qwen/q87-hip-carry` in your worktree.
Stage: S4a step (c). Follows U83 (Cursor) and your Q83.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/measure_hip_carry.gd` — **NEW, yours.**
- `research/Q87_HIP_CARRY.md` — **NEW, yours.**
- `research/Q87_hip_carry.json` — **NEW, yours.**

Do NOT edit any other file. `Q87_check.py` is Claude's.

## Why this exists

The retarget writes rotation tracks only (`Godot/scripts/FightClipRetarget.gd`, `_build`), so a knocked-down
fighter lies down at standing height, in mid-air. S4a step (c) will add a `Hips` POSITION track carrying the
clip's pelvis height. U83 (`research/U83_PELVIS_BY_TREE.md`) settled what to carry: the source's pelvis
position track is LOCAL and holds the HEIGHT; the ROOT holds horizontal travel (not carried - the room owns
where a fighter stands). The source T-pose pelvis sits at **0.9675 m**. What nobody knows is how to SCALE that
height onto twelve bodies of different sizes - and a wrong scale puts feet through the floor or in the air.

## The method

Start from `Godot/tools/measure_s4a_retarget.gd` (Claude's, read it whole): same 28 bound windows x 12
bodies, same 30 fps sampling, same production corrections (`FightClipRetarget.build_silhouette_corrections`)
and `RestFixer.pose_frame` locals, same `_compose` of the target skeleton. Add the source pelvis HEIGHT per
frame, composed through the clip's tree the U83 way (`Godot/tools/measure_pelvis_by_tree.gd`, read it whole).

Then pose the target four ways, identical except for the `Hips` origin (skeleton space, height axis only):

- `none` - rest origin, as today;
- `unscaled` - rest origin + (source_pelvis_h(t) - 0.9675);
- `hip_ratio` - rest origin + (source_pelvis_h(t) - 0.9675) x (target rest Hips height / 0.9675);
- `leg_ratio` - rest origin + (source_pelvis_h(t) - 0.9675) x (target rest leg length / source T-pose leg
  length), leg length = UpperLeg->LowerLeg->Foot segment lengths summed, left side.

Heights are measured in each skeleton's own space; the target "floor" is that body's REST lowest toe height.
Per row and variant, per frame, the LOWEST foot point (`LeftToes`, `RightToes`, `LeftFoot`, `RightFoot`) above
the floor, and the Hips height. Report:

- `floor_min_m` - the lowest the lowest foot ever gets (negative = through the floor);
- `float_mean_m` - mean of the lowest foot over frames, for STANDING windows (every window except the two
  knockdowns and `H2H_StaggerLarge04_LowHit`);
- `end_hips_m` - the Hips height at the window's last frame, for the two knockdowns.

JSON:

```json
{
  "population": {"rows": 336, "windows": 28, "fighters": 12, "fps": 30, "corrections": "build_silhouette_corrections"},
  "source_tpose_pelvis_m": 0.9675,
  "source_leg_m": 0.0,
  "variants": {"none": {"floor_min_m": 0.0, "float_mean_m": 0.0, "float_p95_m": 0.0, "knockdown_end_hips_m": [0.0, 0.0]},
               "unscaled": {}, "hip_ratio": {}, "leg_ratio": {}},
  "rows": [{"path": "...", "start_s": 0.0, "end_s": 0.0, "fighter": "...", "standing": true,
            "none": {"floor_min_m": 0.0, "float_mean_m": 0.0, "end_hips_m": 0.0}, "unscaled": {}, "hip_ratio": {}, "leg_ratio": {}}],
  "bodies": {"f01_m_box_welter": {"rest_hips_m": 0.0, "rest_leg_m": 0.0}}
}
```

(`knockdown_end_hips_m` = the mean over the 12 bodies of `end_hips_m`, one value per knockdown clip, in the order
KnockDown01, KnockDown02; `float_mean_m` and `float_p95_m` pool every frame of every standing row; `source_leg_m` is
the source T-pose's left UpperLeg->LowerLeg->Foot length; `rest_hips_m` is each body's rest Hips height in its
skeleton space, the same space `end_hips_m` is read in.)

The markdown opens with **DECISIONS**: the four variants' floor_min, float mean/p95 and knockdown end heights
side by side; which variant keeps feet on the floor AND lays a knocked-down body on it; and one line on what
still floats or sinks and on which bodies.

## Gate — in this order

1. `python Godot/tools/check_scripts.py Godot/tools/measure_hip_carry.gd`
2. From your worktree root, output to a log FILE (never piped):
   `C:\Users\user\AppData\Local\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/measure_hip_carry.gd`
3. `python research/Q87_check.py` — must exit 0 before you commit.

## The trap specific to this task

**Physics is the judge, and it has two sides.** A variant that never lets a knocked-down body reach the floor
is wrong, and so is one that pushes a standing fighter's feet through it. The gate derives both from your own
rows and from U83's source heights - never from the variant you prefer. And the height axis is Y in a Godot
skeleton but the source track is Z-up: U83's JSON shows the raw track is `[0, 0, h]` - check your axis
against it before anything else.

## When you are done

Commit the three owned files by path on `qwen/q87-hip-carry`, `git show --stat HEAD` (exactly three), push THE
BRANCH; never checkout, merge or rebase master. Then
`python Tools/agent_comms.py send --from qwen --to claude --topic Q87 --body "<one line>"`, commit that mail file
by path on the branch and push again. Do NOT edit `HANDOFF.md`.

## SEND-BACK 1 (Claude, 2026-09-13) - THE SPEC WAS WRONG, NOT THE TOOL

`7137642` did what this task said, and what it said was ambiguous: "each body's rest Hips height in its
skeleton space". These skeletons' origin is NOT at the floor - f01's rest Hips reads 0.105, f06's 0.064 (f06
and f08 are half-scale skeletons: rest leg 0.477 against f01's 0.873). So `hip_ratio` scaled the carry by
~0.1 and left knockdowns ~0.85 m up in the air, while its "-0.7 m below the floor" for `unscaled` and
`leg_ratio` is really ~0.12-0.17 m ABOVE it - a body lying on the canvas. The markdown's verdict followed the
spec's error. Claude's mistake; fix it this way:

1. **Heights above each body's own floor.** `rest_hips_m` = rest Hips y minus that body's rest lowest foot
   point y; `end_hips_m` = the Hips y at the window's last frame minus the same rest floor. The source's are
   already above y = 0 (U83). The carry formulas are unchanged, with `hip_ratio` now using the height above
   the floor.
2. **`chosen`**: the variant that keeps feet out of the floor (`floor_min_m` >= -0.05) AND lays both knockdowns
   on it (their pooled `knockdown_end_hips_m` both within 0.05-0.35 m), or `"none_of_them"`. The gate checks
   the choice against your own pooled numbers.
3. The gate now also holds `rest_hips_m` to anatomy: hips above the floor are 0.95-1.40 x the leg length
   (the source's are 0.9675 / 0.828 = 1.17).

Re-run the tool after the change; never edit the JSON by hand. New commit, push, mail.
