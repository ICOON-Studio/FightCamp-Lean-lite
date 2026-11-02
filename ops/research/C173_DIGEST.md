# C173 - stance switches authored in Cascadeur

Task-specific no-fetch/rebase, restricted reads, no-HANDOFF and per-clip
publication supersede the general entry workflow. Model: gpt-6-astra;
task requests medium effort (runtime effort is not exposed here).
No engine stance decisions or catalogue changes. No generation credits.

## 1. Cascy_Switch_O2S

Source: frame 0 of
`assets/anim/audition/motifect/unpacked/Motifect_martial_arts_v1_0/GLB/muay_thai_guard_stance.glb`.
The source hip-derived heading gives L-R foot lead +0.274161 m. Joint
directions are resized to Cascy's measured limb lengths. The endpoint is
constructed by exchanging every left/right controller and reflecting X;
it is not separately posed. Cascadeur solves and exports all 34 frames.
Solved source-controller lead: +28.3207 -> -28.3218 cm.
0.30 s start hold + 0.50 s motion + 0.30 s end hold, 30 fps.

Retargeted to f01 using the existing silhouette correction and hip carry.
First/last .25 s each sampled 16 times; hands sampled at 120 Hz throughout.

| Gate | Measured | Threshold |
|---|---:|---:|
| Start L-R lead along body heading | +0.280737 m | > +0.15 m |
| End L-R lead along body heading | -0.286225 m | < -0.15 m |
| Worst mirrored legs/trunk angle | 3.423140 degrees | <= 5 degrees |
| Horizontal root travel | 0 m | < .15 m |
| Minimum wrist above sternum | .134210 m | > 0 m |

Facing uses the hips/shoulders line, not a fixed world axis. Mirror angles
compare reflected anatomical motion relative to each target bone's rest
frame, accommodating different left/right bone-axis conventions.
Full per-bone numbers and thresholds: `Tools/cascadeur/c173_switch/O2S/probe.log`.
Two actual duplicated Animation resources with mutated key tracks go red:
unmirrored trunk landing 10 failures; never-switching pose 11 failures,
including its end lead +.280737 m against the required negative sign.
Neither mutant changes the accepted asset or gate thresholds.

Parse: 1/0. Probe: 0 failures. `--only clip`: **SUITE total=10 fails=0**.
Initial sandboxed probe emitted host log/certificate errors; final validation
and render ran in the normal host environment without those errors.
No full suite. Front and side at 0/.30/.40/.55/.70/.80/1.10 s reviewed:
**a small in-place switch hop, with the feet exchanging lead and guard retained,
reads as a switch step**. This is visual assessment, not a coach's endorsement.

![O2S front and side](../../Tools/cascadeur/c173_switch/Cascy_Switch_O2S_sheet.png)

Reproduction from repo root (Cascadeur server running):
```
python Tools/cascadeur/build_switch_step.py O2S
python Tools/cascadeur/author_switch_step.py O2S
python Godot/tools/check_scripts.py Godot/tools/switch_step_probe.gd
godot --path Godot --script tools/switch_step_probe.gd --resolution 540x600 -- Cascy_Switch_O2S --mutants --render
python Godot/tools/run_tests.py --only clip
```
Use the installed Godot executable and `FIGHTCAMP_STAGE_GATE=off` for this
explicit multi-clip assignment. Source replay includes RIG.json and CLIP.json;
no native scene-save success is claimed. GLB export and Godot render are verified.

O2S publication: **755b1f78**, pushed origin/master; C173 message a2aa517459bd.

## 2. Cascy_Switch_S2O

Every controller at every frame is the exact reflection/L-R exchange of the
accepted O2S CLIP.json. No new source sampling or independent posing.
Cascadeur read-back: -28.3218 -> +28.3207 cm lead. Same 1.10 s duration.

| Gate | Measured | Threshold |
|---|---:|---:|
| Start L-R lead | -.286225 m | < -.15 m |
| End L-R lead | +.280737 m | > +.15 m |
| Worst mirrored legs/trunk angle | 3.417416 degrees | <= 5 degrees |
| Root travel | 0 m | < .15 m |
| Minimum wrist above sternum | .134210 m | > 0 m |

The probe prints sign-normalized lead values for S2O; the table above gives
physical L-R values. Mutated unmirrored end: 10 failures; never switches:
11 failures. Parse 1/0, probe 0 failures. Logs in c173_switch/S2O.
Front/side review: **the mirrored hop changes the lead from right to left,
keeps the guard up, and reads as the reverse switch step**.

![S2O front and side](../../Tools/cascadeur/c173_switch/Cascy_Switch_S2O_sheet.png)
`--only clip`: **SUITE total=10 fails=0**. No full suite.

S2O publication: **9d8b62d4**, pushed origin/master; C173 message 9023de8b00d5.

## 3. Cascy_StepThrough_O2S

Same sourced guard and reflected endpoint. The rear right foot advances first;
the left foot follows after 40% of the motion, completing a 55 cm source advance.
Holds .30/.30 s; motion .50 s. A shallow 8 cm weight dip keeps both leg chains
reachable while the feet use different timing. No new pose is invented for
the landing: controller targets remain the translated mirror of the start.

The first export switched lead but FAILED the mirror gate: left thigh/shin
twist ~79.75 degrees. Recomputing reachable knees alone did not fix it.
Cascadeur's calf direction controller remained stationary in world space;
the travelling hip passed its pole. Explicit moving calf direction controllers,
with calf MainPoint left solver-owned, fix the exported twist. This was a
source-authoring repair; no gate or engine correction was changed.
Rejected first result retained in StepThrough_O2S/attempt1_probe.txt.

| Gate | Measured | Threshold |
|---|---:|---:|
| Start L-R lead | +.280770 m | > +.15 m |
| End L-R lead | -.286273 m | < -.15 m |
| Worst mirrored legs/trunk angle | 3.421767 degrees | <= 5 degrees |
| Forward root travel on target | .575822 m | >= .40 m |
| Total horizontal root travel on target | .575842 m | <= .70 m |
| Minimum wrist above sternum | .132707 m | > 0 m |

**Root-motion boundary:** the existing retarget helper retains only returning
sway and discards non-returning horizontal motion. For this travelling audition,
the probe/render mounts the untouched skeletal retarget on the exported source
hip trajectory using the existing hip-carry scale (.01046992 target metres per
source centimetre). The source export carries 54.999668 cm of travel. This
verifies the exported motion on the target rig; it does not claim the fight
engine already consumes the new tactic or this trajectory. No engine edits.
The first rejected log mislabeled source centimetres as metres; the corrected
probe label states source_travel_cm explicitly.

Both actual track-mutated controls go red. Parse 1/0; probe 0 failures.
Front/side review: **the rear right foot steps through, the left foot follows,
and the fighter finishes in southpaw guard; it reads as an advancing switch**.

![Step-through front and side](../../Tools/cascadeur/c173_switch/Cascy_StepThrough_O2S_sheet.png)
`--only clip`: **SUITE total=10 fails=0**. All three switch exports pass.

Step-through publication: **15788277**, pushed origin/master; C173 message
b294591f8b64. Each switch has its own commit, push and immediate message.

## C172 leftover

Kneeling closed guard now passes all five unchanged contacts, worst ankle
drift **28.077703% < 30%**, without widening its source ankle gap. Front/side/
high/low sheets reviewed; both knees now sit beneath the raised hips.
Before/after side-by-side evidence and full numbers are appended to C172_DIGEST.md.
All seven hard controls remain unchanged. No HANDOFF, catalogue, FightRealtime
or FightStance edits; no fetch/rebase or full suite.
