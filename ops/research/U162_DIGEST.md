# U162 — retarget speed census (Cursor, S66)

Branch `cursor/u162-retarget-speed`. Census tool: `Godot/tools/u162_retarget_speed_census.gd`.
Measurement module: `Godot/scripts/U162RetargetSpeed.gd`.

## Definition (one speed for both arms)

**Chest-relative effector origin, 60 Hz, tempo 1.0 from t=0** — same as Q167 /
`clip_phases.json` (`peak_speed_mps`). World-space wrist/foot speed on the vendor
rig runs much higher on spinning strikes (e.g. `karate_empiuchi` source world
18.26 m/s vs chest 4.32 m/s); comparing world to chest looks like a 4× defect
when nothing in retarget is wrong.

Proof: on vendor source, |world_peak / chest_peak − 1| median **0.29**, max **3.23**
across 111 retargeted strikes.

## Part 1 — census (124 bound strikes, 111 retargeted, 13 skipped graft/non-retarget)

Population: **f01 1.74 m**, **f02 1.88 m**. Production retarget path (silhouette
corrections, hip carry/sway as `FightStagePlayer` whole-strike).

| Stat | retarget f01 / vendor source (chest) |
|------|--------------------------------------|
| median | **0.883** |
| p90 | **1.047** |
| max | **1.072** (`muay_thai_thip_khang`, LeftFoot) |

**No clip exceeds 1.5×.** f02 tracks f01 (same max 1.072, slightly lower on heavy
body).

`karate_empiuchi` (U160 elbow): vendor chest **4.32 m/s**, retarget f01 **3.71 m/s**
(ratio **0.86**). `clip_phases.json` **3.69 m/s** (ratio to vendor **0.85**) —
that file is **Q167 f01 retarget**, not vendor source. U160’s **4.64×** is
**live-room on-screen speed ÷ clip_phases**, not retarget ÷ source.

Full table: `research/u162_speed_census.json`.

## Part 2 — cause

**Not** bake_fps (glTF), slice windows, mirroring, or a 4× retarget time-scale.
Retarget preserves chest-relative effector speed within **~7%** high side; median
retarget is **slower** than vendor because silhouette/hip carry reshapes the torso
slightly.

The outlier narrative was a **definition bug**: (1) treating `clip_phases.json` as
“source”, (2) measuring **world** speed on screen against **chest-relative**
phases, often with locomotion/IK still in the path (U160/C189).

**Retarget/slice code:** no change warranted on these numbers.

**U160 tempo cap (~0.332):** should **not** ship as a retarget fix — it would
slow elbows **below** their own vendor timing (~0.86× already). If elbows still
look fast in take-four, fix **live playback** (layers, placement, world vs
chest instrument), not global tempo on the clip.

## Gate

- Parse: `U162RetargetSpeed.gd`, census, `fight_retarget_speed_test.gd`
- `fight_retarget_speed_test.gd`: ratio ≤ **1.15**, mutants on shortened clip
- `run_tests.py --only fight_clip_retarget` → total=1 fails=0
- `run_tests.py --only fight_cascy_retarget` → total=1 fails=0
- `run_tests.py --only fight_strike` → total=2 fails=0
