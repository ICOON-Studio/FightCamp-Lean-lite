# ANIM-SMOOTH1 review - 2026-10-10

Branch: `codex/anim-smooth1`, based on `ede143c4`. Acceptance remains OPEN: the
implemented review switches and recordings do not satisfy every numeric gate.

## Change

`cam_spring` and `alive_breath` default OFF, including in the demo. The camera
extends the existing fit path with exact critically damped aim/position steps
and a 0.25 s rotation half-life. The initial 6 rad/s take hit the framing guard;
12 rad/s plus Ludo's central-65-percent framing margin reduced acceleration
without dropping the hard guard. The pure spring test still checks 6 rad/s.

The existing independently seeded alive layer supplies 1.2 Hz / 2.5 cm hip sway,
2.4 Hz / 1.8 cm head bob and 1.5 degree pitch, and 0.8/1.7/2.6 cm breathing at
60/120/180 BPM. The screen feeds the same presented-time Cardio pulse as the HUD,
not its simulation lookahead. A 150 ms quintic fade releases strike/reaction
ownership. Continuous offsets are applied after clip/plant history is saved,
restored exactly next frame, and remain visible to final-pose gloves/modifiers.
Legacy missing spine aliases stay missing; the new position layer resolves
Chest/UpperChest aliases. No fight RNG, engine clock, AnimationTree conversion,
separation solver, inertialization replacement or new foot lock was added.

## Evidence

Seed 94400, boxing, `as_game`, 900 drawn frames at 30 fps. Logger reads
`frame_post_draw` skeleton global poses, including SkeletonModifier3D results.
Metrics use acceleration magnitude sigma, shortest-arc world quaternion
increments, and cumulative horizontal drift for qualifying plants.

| Metric | Baseline | After |
| --- | ---: | ---: |
| Camera acceleration sigma, m/s2 | 19.844293 | 14.785468 |
| Camera spikes above 3 x each take's median | 282 | 142 |
| No-strike speed min / median, cm/s | 0.000045 / 91.212570 | 0.505359 / 88.952422 |
| Reaction-free guard speed min, cm/s | 0.567319 | 2.346435 |
| Pelvis minimum, cm / frames below 55 cm | 44.456362 / 6 | 45.386182 / 5 |
| Join acceleration median / p95, deg/s2 | 10591.110922 / 34666.679544 | 11104.381940 / 38238.523677 |
| Foot drift median / max, cm per plant | N/A (0 plants) | N/A (0 plants) |
| Failed framing frames | 0 | 0 |

The requested full no-strike minimum includes a reaction at frame 249 on A:
0.505359 cm/s, below 0.8. Breathing is suppressed there because the reaction owns
the upper body. The separately reported guard minimum meets the range; it does
not replace the requested metric. World-space median speed includes locomotion.
Join median is up 4.85%, p95 up 10.30% (outside the 10% ceiling). The minimum
separation changes 2.09%; the small under-55 count changes from six to five.
No ankle sample run qualifies at <=4.5 cm above the canvas and <=0.12 m/s, so
there is no foot-drift witness and no claim that the foot gate passed.

Two silent H.264 MP4s, 1280x720, 30 s / 30 fps, `-an -crf 26` via
imageio-ffmpeg: `E:/FightCamp/tmp/anim_smooth1/before.mp4` and `after.mp4`.
Frames 1, 180, 360, 540, 720, 900 from each were opened with the file tool:
both men head to feet in all twelve; gloves stay visually attached.
Godot's project resizes its movie viewport to 1920x1080 despite `--resolution`;
the requested final MP4s and inspected frames are scaled to 1280x720.

The original baseline CSV's ancillary canvas-height fields were initially in
skeleton units. `baseline_world.csv` corrects only these two constant fields to
the room's logged world canvas plane, 1.270000000 m. No measured pose, camera,
clip or quaternion was changed. It matches final `off_final.csv` exactly:
SHA256 `f45a100c0379647e89d5b3f5fdaec5b3598b62b50d40c4e7c2e85980c2ac0a23`.
The original shipped video and final OFF video streams also match exactly:
MD5 `b8c0c897e6abdb9e226e6d011a1dd474`. AVI audio differs between runs and is
discarded by the required silent encode. The entire final OFF silent MP4 is
byte-identical to `before.mp4`, SHA256
`6c1d6185f903b8863c16fa0124a24a58692afe1a279c9948b2132206563fb35d`.
Original and diagnostic CSVs/AVIs are
retained in the same temporary artifact directory; final ON source is `after6`.
A camera-only control changes only camera_x/y/z; all body columns are identical.

## Gates and delivery limits

RED first on the unmodified master-derived scripts: `ANIM_SMOOTH1 fails=2`
(missing spring and continuous breathing), runner `SUITE total=1 fails=1`.
Final parse: `CHECK total=5 fails=0 autoload_refs=0 autoload_warnings=0`.
Focused: `SUITE total=1 fails=0`; alive: `SUITE total=1 fails=0`;
camera: `SUITE total=3 fails=0`; fight_stage: `SUITE total=10 fails=1`.
The failing `fight_stage_realism_test.gd` reports `TOTAL=13 fails=7`: R1 space
between exchanges, R2 stance takes, R3 planted-foot skate, R3b feet above canvas,
R5 joins like the performance, R5b joins against the same frames, R7 bodies never
pass through. These are its explicitly `GATED S4a` rules; its header says they
are expected to fail. No runtime/parse error or timeout caused that verdict.
The test runs with the new switches OFF. Fixing simulation rhythm, feet,
separation and inertialized joins exceeds this task's steps 0-2/owned scope;
the required zero-failure stage gate is not claimed.

General entry rules set aside per the user/task: GUI Godot executable instead
of _console, hidden desktop for movie jobs, two jobs for every test runner,
push only the assigned branch, and no windows/viewers/browser. Cache repair
read matching import metadata beyond the task's source windows, checked source
MD5/import settings, and copied only matching cached game assets into ignored
`.godot`. Tracked import files with zero content diff were restored by an exact
manifest. Automatic review rejected broad deletion of new metadata because it
could affect another agent; untracked generated UID/import files remain
unstaged. No unrelated source files were edited.
