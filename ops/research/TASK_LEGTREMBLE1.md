# TASK LEGTREMBLE1 - AGY (Argon High) - the legs tremble in many clips: find where it comes from, fix it there

Status: OPEN (S419, Claude main). Discipline: boxing. Model: Argon High. Animation item (operator S401).
Source: the operator on the board's Boxer animations page, 11-10, with three stills of the boxer on the grid floor: "all these animaiton are broken the legs treble", then "the issue with the legs is in a lot of clips". The same complaint in S383 ("the knees are trembling again") was traced to the films running the fight's leg layers on clips that already plant their feet; the films were changed to the clip alone plus one KneeTrack.align. It is back, or it never left the clips.

## Contract
OWNS: tools/leg_tremble_census.gd, tools/leg_smooth_bake.gd, tests/leg_tremble_test.gd, docs/LEGTREMBLE1_RESULT.md, scripts/fight3d/KneeTrack.gd, assets/anim/baked/*.res (NOT mc_Box1_M3_Right_Hook.res and NOT mc_Box1_M3_Right_Hook_FT.res: PR 140 holds those two)
RED_TEST: tests/leg_tremble_test.gd -> LEG_TREMBLE failures=0
REGRESSION: beat_clips_test, move_tip_test, head_aim_test
VISUAL: Claude re-renders the board films after the merge and looks. Do not render.

## Prior research
- tools/owned_mocap_jitter.gd is the ruler, read its header in full: knee flex zigzags (reversals within 3 frames, a 5 to 15 Hz tremble, not a 2 to 3 Hz bounce), knee pole jumps, per-joint zigzags, foot slide. Modes: `mode=clip` (the keys by our own FK, nothing else), `mode=shown strip` (the board film's path: clip + KneeTrack.align), `mode=shown play noalign` (the fight's whole stack).
- Claude ran it on S419 over the 153 in-game clips it can load (`python ops/Tools/lean_anim_catalogue.py --ids`, minus the rk_ names, which it cannot load: res://rk_jab not found), 8 s each, `--fixed-fps 30`:
  film path: 45 of 153 clips show knee zigzags above 1; fight path: 59 of 153, 16 of them above 3.
  Worst, film / fight: pro_knockout_v7 8 / 8, strafe_right 6 / 7, entry_ring 6 / 6, pro_win_v5 5 / 6, pro_knockout_v1 5 / 5, pro_idle_fidget_v8 5 / 4, strafe_left 5 / 3, pro_idle_fidget_v1 3 / 4.
  Added by the fight stack alone (film 0 to 2, fight 3 to 5): pro_hit_by_cross_v4, pro_idle_hurt_v1, pro_right_hook_hard_ft, pro_hit_by_combo_v2, pro_left_hook_miss, pro_kidney_shot.
  These are Claude's quick reads of the JIT_JSON lines: re-run and trust your own table, not these.
- tools/clip_orbit.gd header (S383c, S383d): how the films are made and what was already switched off.
- Memory of this project: S407 "knee numbers were a broken ruler" (a table was believed before the probe was read), S408 the guard knee has no fault when measured as distance out of the hip-ankle-foot plane. So: prove the ruler before the table.
- ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Play a clip one frame at a time and watch one knee. A knee that moves forward, back, forward within three frames is trembling. Then take layers away until it stops: the fight's layers, then KneeTrack, then the retarget onto this body, until only the bought clip's own keys are left. Where it stops is where the fault is. A bought mocap clip that trembles in its own keys gets its leg tracks smoothed once, offline, and saved; a layer that adds tremble gets fixed or switched off for that case.

## Prefab check
Godot's Animation has no built-in track filter. A Butterworth or a Savitzky-Golay low-pass on quaternion tracks (log space, or component-wise then renormalised with the hemisphere kept continuous) is a few dozen lines: write it, no add-on.

## The job
1. THE RULER FIRST. tools/leg_tremble_census.gd (a thin wrapper round owned_mocap_jitter's reads, or that tool itself if it needs no change). Two controls that must read as expected or everything after is void: (a) a synthetic clip whose knee bends on a smooth 1 Hz sine must read 0 zigzags; (b) the same clip with a 10 Hz, 2 degree wobble added must read a rate near 20 reversals a second. Print both.
2. THE CENSUS, three arms, every in-game clip: `clip`, `film` (shown strip), `fight` (shown play noalign). Also get the rk_ clips in (they load through RkClips.load_into, see FightClips.gd line 95): the operator's stills may be of those. One row a clip: zigzags per second left and right knee in each arm, knee pole jumps, foot slide.
3. SAY WHERE IT LIVES, per clip: in the keys, added by KneeTrack.align, or added by the fight stack (then name the layer with the game's own switches: nojoin noguard noreach nosnap noglove noknee nofeet nofloor, one at a time).
4. FIX IT THERE.
   - In the keys: tools/leg_smooth_bake.gd low-passes ONLY the leg bones' rotation tracks (upper leg, lower leg, foot, toes) and the hips position of the listed clips and saves the .res. Cut-off as high as removes the tremble (start at 6 Hz).
   - In KneeTrack: fix it in KneeTrack.gd.
   - In another fight layer: do NOT edit that layer (Qwen holds FightStage, PunchReach, BeatFire, MoveStudio). Name it, with the numbers, in the result.

## Bars (tests/leg_tremble_test.gd, headless)
- The two ruler controls read as in step 1.
- Every in-game clip, `clip` and `film` arms: knee zigzags at most 0.5 a second on both knees.
- No clip's knee flex moves more than 3 degrees from the original at any frame (it is a smoothing, not a re-animation), and its largest bend is within 2 degrees of the original.
- Foot slide on plants not worse than the original by more than 5 mm on any clip.
- A punch's contact time and reach are untouched (arm tracks are not written): beat_clips_test and move_tip_test stay green without edits.
- The test is RED on main: paste that line.
The `fight` arm is reported, not barred, in this task.

## Rules
Godot through `python ops/Tools/godot_slot.py run --who agy -- <godot.exe> --headless --audio-driver Dummy --path . --fixed-fps 30 --script res://tests/leg_tremble_test.gd` (never the console build). No file over 500 lines. No he or she in the result text. Keep the originals reproducible: the bake tool reads the clip, writes the clip, and the result lists every .res it changed with before and after numbers.

## The one trap
Do not make a bar pass inside the measurement: no tolerance added to a read, no frames skipped because they fail, no clip dropped from the list. If a clip cannot reach a bar, leave it red and name it. Claude reads every comparison in the test at collect.

## Result lines (PR body)
RESULT: tests/leg_tremble_test.gd -> LEG_TREMBLE failures=0
RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
RESULT: tests/move_tip_test.gd -> MOVE_TIP PASS
RESULT: tests/head_aim_test.gd -> HEAD_AIM failures=0
