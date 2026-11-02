# TASK C101 — CODEX — IS THE ERROR A CONSTANT OFFSET OR A MOTION ERROR?

Model: gpt-5.6-luna, **medium** (pinned in `Tools/codex_task.cmd`). Owner: codex.
Stage: S4a (brief: `research/R141_WHY_THE_CLIPS_LOOK_BAD.md`). Follows your own C100.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate on the new tool,
run it, then the gate script. No test suite.

## Owned files

- `Godot/tools/measure_retarget_offsets.gd` — **NEW, yours.**
- `research/C101_OFFSET_OR_MOTION.md` — **NEW, yours.**
- `research/C101_offset_or_motion.json` — **NEW, yours.**

Do NOT edit `Godot/tools/measure_retarget_frames.gd` or its C100 files — C101 is a second
instrument beside it, not a change to it. No other file either.

## Why this exists

C100 measured the retarget on every frame of 28 windows × 12 bodies: **elbows are off by ~14°
on average and hips by up to 36.8°**, while knees and shoulders stay near 4°. That magnitude
could mean two very different things, with very different fixes:

- **A CONSTANT OFFSET** — the joint is off by roughly the same signed amount on every frame,
  because the two rigs' rest poses differ at that joint (our fighter's rest elbow is slightly
  bent where the source's is straight, say). That is cause 1 in R141: a cheap correction to the
  rest, and most of the error disappears.
- **A MOTION ERROR** — the signed error swings across the clip, because the rotation-only
  retarget moves the limb differently on a body with different proportions. That is cause 2:
  it needs IK, and no rest correction fixes it.

C100 recorded only the UNSIGNED error, so it cannot tell them apart. This task can.

## Where things are

- `Godot/tools/measure_retarget_frames.gd` — yours from C100, 201 lines: read it whole and reuse
  its population, sampling, tripwire and global-pose composition.
- `Godot/tools/measure_r108_retarget.gd` — `SEGMENTS` and `JOINTS` at lines 59–80.
- `res://assets/anim/audition/ramsterz_h2h/T_pose.fbx` — its hierarchy IS the source rest pose (R108).

## The contract

1. **Rest offset.** For each of the 12 fighters and each of R108's `JOINTS`: the joint angle in
   the SOURCE rest (T_pose.fbx) minus the same joint angle in that FIGHTER'S rest, in degrees.
2. **Signed error per frame.** Same population and sampling as C100 (every bound RamsterZ window
   × 12 bodies, 30 fps): `source angle − retargeted angle`, signed, per joint. Per
   (window, fighter, joint) report `signed_mean_deg` and `signed_std_deg` over the frames.
3. **The split.** Per (fighter, joint), pooled over that fighter's windows (frame-weighted):
   `constant_part_deg` = |mean signed error|, `motion_part_deg` = standard deviation of the
   signed error, and `offset_share` = constant² ÷ (constant² + motion²).

JSON, exactly this shape:

```json
{
  "tripwire": {"clip": "H2H_HitReaction01.FBX", "fighter": "f01_m_box_welter", "samples": 9,
               "fixed_mean_deg": 7.21, "fixed_max_deg": 19.64},
  "rest_offsets": [{"fighter": "f01_m_box_welter", "joint": "elbow_l", "rest_offset_deg": 0.0}],
  "rows": [{"path": "...", "start_s": 0.0, "end_s": 0.0, "fighter": "...", "joint": "elbow_l",
            "frames": 0, "signed_mean_deg": 0.0, "signed_std_deg": 0.0}],
  "split": [{"fighter": "...", "joint": "elbow_l", "frames": 0, "constant_part_deg": 0.0,
             "motion_part_deg": 0.0, "offset_share": 0.0}]
}
```

The markdown opens with **DECISIONS**: per joint pooled across all fighters, the constant part,
the motion part and the offset share; whether each fighter's `rest_offset_deg` predicts its
`constant_part_deg` (say how closely, with the numbers); and one plain line per joint:
"a rest correction would remove most of this" or "this needs IK". Name the population first.

## Gate — in this order

1. `python Godot/tools/check_scripts.py Godot/tools/measure_retarget_offsets.gd`
2. The tripwire first, exactly as in C100: f01 + `H2H_HitReaction01.FBX` at R108's nine samples
   must give 7.21° / 19.64° within ±0.05°, or stop and publish no rows.
3. Run: `python C:\Users\user\AppData\Local\Temp\FightCamp-tools\godot_run.py . tools/measure_retarget_offsets.gd --timeout 3000`
4. `python research/C101_check.py` — **must exit 0 before you commit.** It derives the
   population from the repo and checks your signed statistics against C100's unsigned ones.

## The trap specific to this task

**|mean| is not mean|x|.** A joint that swings ±20° around zero has a signed mean near 0 and an
unsigned mean near 13° — that is a MOTION error even though its "average error" looks small.
Report the constant part and the motion part side by side for every joint and never let one
number stand for both. And C100's headless trap still holds: compose global poses from
`get_bone_pose()` down the parent chain; `get_bone_global_pose()` returns the REST pose.

## When you are done

`git add --` the three owned files, commit with those paths on the commit line,
`git show --stat HEAD` (exactly three files), `git push origin master`, then
`python Tools/agent_comms.py send --from codex --to claude --topic C101 --body "<one line>"` and
commit that mail file by path. Do NOT edit `HANDOFF.md`. Never `git stash`, `reset --hard`,
`checkout .` or `clean`.

## REDO (Claude, 2026-09-13) - the first delivery measured a different angle from C100

`77648f4` passed the first gate and concluded "motion error, needs IK" for seven of nine joints. That
conclusion is void. `measure_retarget_offsets.gd` took each joint angle with
`Vector3.signed_angle_to(other, axis)`; C100 took the UNSIGNED angle between the two segments. A
signed angle about an axis flips sign whenever the two segments are nearly collinear - a nearly
straight knee flips on a millimetre of sideways difference - so the "signed error" jumps by twice the
angle between frames. Result: knees with an 18 deg "motion part" where C100's largest knee error is
8-11 deg, and single rows at 87 deg. **No spread of errors can exceed the largest error.**

**The contract always said** `source angle - retargeted angle` of the SAME angle C100 measured. Use
C100's unsigned inter-segment angle on both bodies and subtract. The rest offsets use the same angle.
The gate now bounds every row's and every joint's RMS by C100's largest error, and fails the first
delivery on 7 joints and on thousands of rows.
