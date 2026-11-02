# TASK C103 — CODEX — HEAD, TORSO AND FEET FACING DIFFERENT WAYS

Model: gpt-5.6-luna, **medium** (pinned in `Tools/codex_task.cmd`). Owner: codex.
Stage: S4a (brief: `research/R141_WHY_THE_CLIPS_LOOK_BAD.md`). Follows C100, C101, C102.

**Test tier: A NEW TOOL AND A STUDY. No shipped script is edited.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/measure_retarget_facing.gd` — **NEW, yours.**
- `research/C103_FACING.md` — **NEW, yours.**
- `research/C103_facing.json` — **NEW, yours.**

Do NOT edit any other file, including your C100–C102 tools and files.

## Why this exists

The operator looked at the retargeted sheets and said, verbatim: **"head, torso and feet facing
differently"** and **"arms not natural"**. C100–C102 measured only the BEND between two segments
(elbow, knee, hip, shoulder abduction, neck lean). A bend angle is blind to TWIST about the vertical:
a torso turned 40 degrees away from its feet has perfect knee and hip bend numbers. C102's silhouette
fix took the bend error from 8.3 to 0.46 degrees and says nothing about facing. This task measures
exactly what the operator saw.

## Where things are

- `Godot/tools/measure_retarget_frames.gd` (C100) and `Godot/tools/measure_silhouette_fix.gd` (C102),
  both yours: read both whole and reuse the population, sampling, composition and the ON adjustment.
- Bone names: `Hips Spine Chest UpperChest Neck Head LeftUpperArm RightUpperArm LeftUpperLeg
  RightUpperLeg LeftFoot LeftToes RightFoot RightToes` (the 22-bone map in `measure_r108_retarget.gd`).

## The contract

Facing is a direction on the FLOOR PLANE (the up component removed), per frame, per body:

- **pelvis**: perpendicular to `LeftUpperLeg -> RightUpperLeg`, on the floor plane.
- **chest**: perpendicular to `LeftUpperArm -> RightUpperArm`, on the floor plane.
- **left foot / right foot**: `LeftFoot -> LeftToes` and `RightFoot -> RightToes`, on the floor plane.
- **head**: the `Head` bone's global basis applied to the chest's REST facing - calibrated so that in
  each body's own rest pose the head faces exactly where its chest faces. (The head has no left-right
  joint pair, so it cannot be read from positions.)

Pick each perpendicular's sign ONCE per body from its rest pose so that pelvis and chest face where the
rest toes point. Then per frame the RELATIONS, each a signed yaw wrapped to (-180, 180]:
`chest - pelvis`, `left_foot - pelvis`, `right_foot - pelvis`, `head - chest`.

Error per frame = |wrap(retarget relation - source relation)|. Measure it OFF (C100's pipeline) and ON
(C102's silhouette-matched rest) on the same 336 rows (28 bound windows x 12 bodies, 30 fps).

JSON:

```json
{
  "tripwire": {"clip": "H2H_HitReaction01.FBX", "fighter": "f01_m_box_welter", "samples": 9,
               "fixed_mean_deg": 7.21, "fixed_max_deg": 19.64},
  "rest_relations": {"source": {"chest_pelvis": 0.0, "left_foot_pelvis": 0.0, "right_foot_pelvis": 0.0, "head_chest": 0.0},
                     "f01_m_box_welter": {"chest_pelvis": 0.0, "left_foot_pelvis": 0.0, "right_foot_pelvis": 0.0, "head_chest": 0.0}},
  "rows": [{"path": "...", "start_s": 0.0, "end_s": 0.0, "fighter": "...", "frames": 0,
            "off": {"chest_pelvis": {"mean_deg": 0.0, "p95_deg": 0.0, "max_deg": 0.0}, "...": {}},
            "on":  {"chest_pelvis": {"mean_deg": 0.0, "p95_deg": 0.0, "max_deg": 0.0}, "...": {}}}],
  "relations": {"chest_pelvis": {"off_mean_deg": 0.0, "off_p95_deg": 0.0, "off_max_deg": 0.0,
                                 "on_mean_deg": 0.0, "on_p95_deg": 0.0, "on_max_deg": 0.0}}
}
```

The markdown opens with **DECISIONS**: per relation, OFF and ON mean / p95 / max; the worst relation;
the ten worst rows OFF with clip and body; whether C102's silhouette fix also fixes facing (yes / no /
partly, with numbers); and one plain line on what still needs fixing for the operator's "head, torso
and feet facing differently".

## Gate — in this order

1. `python Godot/tools/check_scripts.py Godot/tools/measure_retarget_facing.gd`
2. The R108 tripwire (7.21 / 19.64 ±0.05) first.
3. `python C:\Users\user\AppData\Local\Temp\FightCamp-tools\godot_run.py . tools/measure_retarget_facing.gd --timeout 1800`
4. `python research/C103_check.py` — must exit 0 before you commit.

## The trap specific to this task

**A facing measured in a body's own bone axes is not a facing.** The UE4 Mannequin and our rig name
their bone axes differently - that is what the rest corrections exist for. Read pelvis, chest and feet
from JOINT POSITIONS only, and calibrate the head at rest, or you will measure the axis convention
instead of the pose. The gate checks that in each rest pose the chest faces the pelvis's way and the
feet point roughly forward.

## When you are done

The three owned files by path, `git show --stat HEAD` (exactly three), `git push origin master`, then
`python Tools/agent_comms.py send --from codex --to claude --topic C103 --body "<one line>"` and commit
that mail file by path. Do NOT edit `HANDOFF.md`. Never stash, reset --hard, checkout . or clean.
