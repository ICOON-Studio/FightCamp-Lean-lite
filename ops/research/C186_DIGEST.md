# C186 - hand writers inside one clip

Model: gpt-6-astra, medium. Branch: codex/c186-hand-writers. Seed 92012, MMA, default options, fixed 30 Hz.

## Result and limits

A's >0.15 m/frame crossings in frames 0..599 fell **59 -> 5**: LeftHand 39 -> 2, RightHand 17 -> 0, Hips 3 -> 3. Frame 271 LeftHand fell **0.85202 -> 0.14000 m**. The worst remaining same-clip hand row across both fighters in frames 0..1799 is **A frame 277 (9.2333 s), LeftHand, hook_lead -> hook_lead, 0.23106 m**. This is a measured reduction, not zero residual discontinuities.

A: engine id `a`, wrestle-grappler, f05_m_mma_light_rigged.glb, rendered height 1.74 m. B: engine id `b`, striker, f06_m_mma_lhw_rigged.glb, rendered height 1.82 m. Both engine height fields are 178 cm; rendered heights are kept distinct.

## Part 1: name the writers

It is **not a clip restart** at frame 271: hook_lead time advances 0.3000 -> 0.3333 s. There is no single offending stage. The bound animation's wrist-minus-chest source sample itself moves 0.44885 m between those times. In the room, the sample/layer result moves 0.49818 m, contact IK raises the interframe displacement to 0.73099 m, and iterative overlap corrections raise it to 0.85202 m. Aim does not contribute on that frame. Neither rope nor limb clamp moves it further. Other worst rows originate in the lower-body splice or contact/overlap IK.

The optional `hand_writer_observer` is unset during normal playback. The trace records both hands and hips at animation sample, layer, inertia, foot lock, grounding, every arm IK call, aim/contact/overlap boundaries, root placement, mount blend, rope and limb clamp, and frame end. Its room subclass uses the production implementation and disables automatic room processing so there is one clock. Clip time and lower clip phase are captured at each write. The trace prints the ten worst same-key rows with each within-frame write distance; complete per-frame samples go to JSONL.

The table below compares the SAME stage in adjacent frames, in world metres. These are cumulative interframe distances, **not additive stage contributions**. The JSONL also allows successive writes within a frame to be compared; resetting yesterday's procedural pose and replacing the lower-body sample can make individual temporary writes larger than the final displayed move.

| Frame | Side / bone | Clip | Time s | Sample | Layer | Inertia | Aim | Contact | Overlap | Final |
|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|
| 271 | A LeftHand | hook_lead | 0.3000->0.3333 | 0.48564 | 0.49818 | 0.49818 | 0.49818 | 0.73099 | 0.85202 | 0.85202 |
| 1391 | B LeftHand | hook_lead | 0.3333->0.3667 | 0.39667 | 0.75126 | 0.75126 | 0.75126 | 0.75920 | 0.75990 | 0.75990 |
| 1261 | A RightHand | slip | 0.1667->0.2000 | 0.07277 | 0.07277 | 0.05871 | 0.05871 | 0.44998 | 0.74593 | 0.74593 |
| 1260 | A RightHand | slip | 0.1333->0.1667 | 0.13369 | 0.13369 | 0.12755 | 0.12755 | 0.40761 | 0.73047 | 0.73047 |
| 1659 | A RightHand | boxing_overhand | 0.5667->0.6000 | 0.86804 | 0.85113 | 0.85113 | 0.73656 | 0.71509 | 0.70962 | 0.70962 |
| 263 | B LeftHand | idle | 2.4667->2.5000 | 0.02543 | 0.02543 | 0.02477 | 0.02450 | 0.35766 | 0.69362 | 0.69362 |
| 1390 | B LeftHand | hook_lead | 0.3000->0.3333 | 0.54595 | 0.70852 | 0.70852 | 0.70852 | 0.70852 | 0.68954 | 0.68954 |
| 118 | B LeftHand | hook_lead | 0.5000->0.5333 | 0.06394 | 0.50812 | 0.50812 | 0.50812 | 0.52831 | 0.61048 | 0.61048 |
| 269 | B LeftHand | idle | 2.6667->2.7000 | 0.03863 | 0.03863 | 0.03863 | 0.03863 | 0.23024 | 0.60623 | 0.60623 |
| 440 | B LeftHand | kickboxing_body_kick | 0.0333->0.0667 | 0.53765 | 0.53765 | 0.60547 | 0.59890 | 0.59736 | 0.59736 | 0.59736 |

At frame 271, successive within-frame writes on A LeftHand are: root read/turn 0.03472 m, root placement 0.04728, undo preceding correction 0.11296, AnimationPlayer sample 0.63596, lower splice 0.36548, contact IK 0.30653, overlap arm pushes 0.04434/0.07228/0.09115/0.02147, and overlap root separation 0.02500. The clip clock stays monotonic. Interframe attribution, rather than simply picking the largest temporary reset, is why the correction belongs after their composition.

## Part 2: playback correction

`FightStagePlayer.finish_hand_frame` caps each final wrist target's travel to 4.2 m/s (0.14 m at 30 Hz), after animation, layers, aim, contact, separation and bounds placement. It bends the existing anatomical shoulder/elbow chain through `_bend_arm`, preserves glove global orientation, and stores the actual reachable result. No wrist-position track, source animation, fighter scale, simulation or engine RNG is edited. The aim lead-in is extended from 0.10 to 0.20 seconds so a landed target can be approached before contact under the new velocity bound. The next frame unwinds these rotations through the existing reverse-order procedural undo list. Paired performances clear this history and retain authored placement. Initial/zero-time frames receive no invented previous pose.

This is a **target velocity bound**, not a guarantee that the resulting wrist can always stay inside it: when the shoulder/root moves so far that the old world-space target is unreachable, the existing arm reach limits win. That is the residual at frame 277, where the hip displacement remains approximately 0.49 m. No arm is stretched and no root is teleported to force a passing hand statistic. Changes to final hands can affect later overlap placement; lower crossing counts alone are not proof that contact or the whole bout improved.

C185 trace, first 600 frames:

| Bone | Before crossings | After crossings |
|---|---:|---:|
| LeftHand | 39 | 2 |
| RightHand | 17 | 0 |
| Hips | 3 | 3 |
| Total | 59 | 5 |

The same trace's peak forward left-wrist extension for A's first/second hook and jab is respectively 0.45160/0.44357/0.73947 m BEFORE and 0.45102/0.43285/0.74308 m AFTER. The end-of-take guard offsets for those windows are unchanged (0.02700/0.05739/0.05979 m). These are three observed strikes, not a general guarantee of strike fidelity.

## Gates and media

Parse gate: CHECK total=3 fails=0. The first focused candidate returned SUITE total=18 fails=1, with fight_stage_realism_test.gd TOTAL=13 fails=8 (the allowed ceiling); all other focused tests passed. Its contact result exposed a tradeoff, motivating the earlier aim lead-in before the final gate.

Final focused gate: **SUITE total=18 fails=1**; the other 17 tests pass. The final earlier-aim candidate's realism result is TOTAL=13 fails=8, meeting the task's maximum of eight; this is still a red realism test. It fails R1, R2, R3, R4, R5, R5b, R7 and R8. No full suite was run.

| Metric | C185 recorded candidate | C186 final |
|---|---:|---:|
| R4 returns passing | 320/391 | 331/391 |
| R5 worst join/source ratio | 2.47x | 1.76x |
| R5b worst same-frame ratio | 2.06x | 1.76x |
| R8 landed hands reaching target | 123/189 (65%) | 129/189 (68%) |
| R7 violating overlap share | 8.9% | 9.8% |

The C185 column is the task-supplied digest's recorded result, not a fresh full-bout baseline run. The first C186 candidate, with the original 0.10 s aim lead-in, reached only 94/189 (50%); extending the lead-in to 0.20 s recovered contact before shipping. R7 remains worse than the C185 reference: a final continuity correction can give back some collision clearance. Wrist smoothness, target contact and nonpenetration are separate measurements; the unchanged count of eight failed rules must not hide this tradeoff.

Full 1800-frame writer census (both hands plus hips): A 165 -> 10 crossings, B 203 -> 29. This is a different window and population than the 59 -> 5 one-body, first-600 comparison above.

The final take3 is 60 seconds, 1280x720, 30 fps, 1800 decoded frames. Godot Movie Maker renders the project at 1920x1080; ffmpeg scales the delivery MP4 to 1280x720. The scene uses the same default gameplay options and population as the trace. The owned harness has a `record` mode that disables instrumentation, steps the real room once per frame, and controls only the capture camera.

**Camera difference is explicit:** take2 is the supplied historical recording. The current saved camera and default shot cropped the fighters at cage edges; the delivered take3 uses a tracking inspection camera inside the cage. The game camera and saved personal camera file are not edited. The comparison sheet labels the different framing; it is a temporal comparison, not a pixel-matched camera comparison. The capture's camera follows the hip midpoint; world-space motion measurements come from the independent trace, not screen displacement.

`previews/c186_before_after.png` contains BEFORE take2 | AFTER take3 pairs at 0,5,...,55 seconds. The MP4 was opened via decoded frames and the sheet was opened. Additional decoded frames around 8.9-9.3 seconds were inspected. This is decoded-frame review, not a claim of uninterrupted human playback. Arms stay attached and the targeted extension changes more gradually; crowding and the residual lower-body discontinuity remain. Foreground visibility is a capture concern, not evidence of corrected collision physics.

Final MP4: **31,733,046 bytes**, 1280x720, 30 fps, 60.0 s, all 1800 frames decoded. SHA-256 `d2ee0e7791c677e306195a9d8a0d5e53d5c5f677eedec7a04e012edceda24456`. The final tracking-camera MP4's decoded hook sequence and the rebuilt 12-time comparison sheet were both OPENED after final encoding. Render log contains no script/engine errors; the existing ObjectDB teardown warning remains. Import-generated sidecars and temporary measurement/capture files are not staged.

## Reproduction

The initial `--headless --import` completed once. Sandbox launch denial was resolved by approved execution. The matching branch was verified at `C:/Users/user/AppData/Local/Temp/FightCamp-C186`; the literal `Temp$4` path in chat did not exist. The task's named-file scope overrides the general initial sync/mailbox and HANDOFF workflow. HANDOFF, status and archive files were neither read nor edited. Only C185_DIGEST was read as prior task evidence.

```powershell
python Godot/tools/check_scripts.py Godot/scripts/FightStagePlayer.gd Godot/scripts/FightWorldLiveScreen.gd Godot/tools/c186_hand_writers.gd
& "$env:LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tools/c186_hand_writers.gd -- out=<writers.jsonl>
& "$env:LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64_console.exe" --headless --path Godot --script tools/c185_wrist_trace.gd -- out=<wrists.jsonl>
python Godot/tools/run_tests.py --godot "$env:LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64_console.exe" --only fight_stage,fight_world,fight_room_no_teleport,paired_stage,fight_body_layers
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/c186_hand_writers.gd --rendering-driver opengl3 --write-movie <take3.avi> --fixed-fps 30 --resolution 1280x720 --quit-after 1800 -- record out=<population.jsonl>
```

The BEFORE write trace was measured with instrumentation only, before adding `finish_hand_frame` and its two-line room call. In the final revision, omitting that room call reproduces the unbounded candidate baseline. The pre-existing C185 trace is unchanged.
