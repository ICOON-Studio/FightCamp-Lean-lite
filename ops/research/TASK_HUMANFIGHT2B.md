# TASK HUMANFIGHT2B - CURSOR (Grok 4.7 High) - the stepping route without pops, with one-frame contact, and no fudges

Status: OPEN (S433, Claude main). Discipline: boxing. Model: grok-4.7-high
Source: the animation item (operator S401: "keep the animation work progressing on every session"). Same GOALS as
`ops/research/TASK_HUMANFIGHT2.md` (read it whole): no pops at clip starts, the range picks the punch, one-frame contact,
posture limits, the ruler first. PR 200 (round 1) was REJECTED in S433 because its bars passed by fudges (review:
`ops/tmp_s433/collect_review.json`, the HUMANFIGHT2 entries). This round adds HARD BANS, each with its own ruler check.
Do not touch the feet layers (FootLock, FloorStand, ShownRoot, FootPlant, RingFeet, RkJoinFeet).

## Contract
OWNS: tests/human_motion_test.gd, tests/human_motion_lib.gd, tools/human_fight_report.py, tools/human_fight_film.gd, tools/human_fight_tap.gd, docs/HUMANFIGHT2_RESULT.md, scripts/fight3d/PopCap.gd, scripts/fight3d/ContactBeat.gd, scripts/fight3d/PostureLimit.gd, scripts/fight3d/ReachBand.gd, scripts/fight3d/FightStage.gd, scripts/fight3d/BeatFire.gd, scripts/fight3d/BeatClips.gd, scripts/fight3d/PunchReach.gd, scripts/fight3d/BoxerBuild.gd
RED_TEST: tests/human_motion_test.gd -> HUMAN_MOTION_TEST failures=0
REGRESSION: human_feet_test, boxer_footwork_test, ring_feet_test, beat_clips_test, fight_feel_test, body_keep_test, range_breath_test, short_punch_test, knockdown_ring_test, fight_flow_test, file_limits_test, head_aim_test, guard_knee_test, ko_continues_test, block_meet_test, rokoko_clips_test, knockdown_still_test, sound_sync_test, sound_bank_test, fighter_look_test
VISUAL: yes
(Why the last five: rokoko_clips_test and knockdown_still_test load FightStage and play clips through the modifier stack;
sound_sync_test and sound_bank_test read BeatFire.gd's SOURCE for exact strings (`PunchRange.cut_off`, `FightSfx.blocked()`,
`FightSfx.missed(`, `FightSfx.step()`, `FightSfx.knockdown(`, `FightSfx.big_shot_ahead(at)`): keep those lines as they are;
fighter_look_test loads BoxerBuild.gd and FightStage.gd.)

## The job
Scope, in this order: (1) pops and (2) contact are REQUIRED (the two the operator sees). (3) reach by range and (4) posture
come after, only if each lands cleanly within the bans. A part not done keeps its bar PRINTED, not counted (step 2).
1. The ruler, split in two files under 500 lines each: `tests/human_motion_lib.gd` (tally, bone reads, bars, helpers) and
   `tests/human_motion_test.gd` (the runs). You may start from PR 200's Part A (`git show refs/pr/200:tests/human_motion_test.gd`,
   499 lines) but fix it as below. Same definitions in `tools/human_fight_report.py` for the film csv.
   a. POPS (old brief Part A.1). Before any angle: if `q.dot(prev) < 0`, use `-q` (quaternion sign), then `get_angle()`.
      Hips read RELATIVE TO THE BOXER NODE, and a frame where the harness or the fight moves a node more than 0.2 m
      (`_place`, `_set_gap`, a round start) is skipped and counted apart: the ruler never scores its own teleports.
      `shown.csv` today logs bone ORIGINS only (`human_fight_film.gd` BONES, read on `skeleton_updated`): add each arm and
      trunk bone's shown global rotation (quaternion x,y,z,w) and the bones B2 needs (LeftUpperArm, RightUpperArm,
      LeftLowerArm, RightLowerArm) as NEW columns at the END of the row (`human_fight_report.py` reads by column name).
   b. CONTACT and REACTION LAG come from the GAME's route, never from the test calling `stage.hit`: the test does NOT call
      `stage.hit` or `stage.land` itself. Play a real bout headless in a child Godot under `--fixed-fps 30` (pattern:
      `tests/rokoko_clips_test.gd` line 98) running `tools/human_fight_film.gd` (TestJump men_fight, seed 7, at least 40 s),
      so BeatFire's own timer (`BeatFire.gd` line 202, `create_timer(at)` -> `stage.hit`) starts the reaction. Add the
      columns you need to `human_fight_film.gd` (contact frame, target point, glove face from the HAND BONE, reaction clip).
      The reaction start = the first frame the struck boxer's AnimationPlayer shows the hit clip.
      The film reaches the beat switch as `view._beat` (FightView.gd line 48). Give BeatFire a PUBLIC log it fills inside
      `go` (line 162 on): one entry per punch with the view time, who, the clip it armed, `punch_id` (-1 = refused, line 164)
      and, for a landed one, the reaction clip it bound at line 202. The film writes that log to a second csv.
      HIT-STOP frames are not contact frames: `HitImpact.hit` sets `stage._hold_left` (HitImpact.HOLD_S 0.03 / 0.05 / 0.06 s)
      and both clips stand still while it runs (the film's `hold` column). Count them apart and print them; the 1-2 frame
      contact bar counts only frames with `hold` 0. HitImpact.gd is NOT owned: the hit-stop stays as it is.
   c. STARTS: count punches started and refused in the bout (from BeatFire's log). Bars: at least 20 punches started in the
      window (lengthen the window past 40 s if today's main starts fewer), and with the fixes ON at least 90 % of the OFF
      arm's started count on the same seed and window; refused printed for both arms.
   d. Hit reactions (`pro_hit_by_*`, `mc_hit_*`, `react_*`) are never scored as punches by the reach bar.
   e. The bans below, each a check (B1-B5). B2, B3 and B4 need to see the pose just BEFORE and just AFTER the new modules
      in the same frame: `tools/human_fight_tap.gd` is a test-only SkeletonModifier3D that `human_fight_film.gd` adds twice
      per skeleton, one right before the first new module and one right after the last (the new modules sit next to each
      other in the stack). Each tap stores the global poses it reads with `Engine.get_process_frames()`; a frame where
      either tap did not run (RkPure switches modifiers off during a captured take) is skipped and counted apart.
      The film prints each skeleton's final modifier order once the bout starts; paste it in the result page.
   f. The feet-together and knee bars read on the REAL bout (it steps and circles); if the knee bar reads red on almost
      every frame (PR 200 read 2269 of ~2400), check it against one numbered sheet before trusting it, and say so.
2. Run the ruler on today's main; write every number under BEFORE in `docs/HUMANFIGHT2_RESULT.md` and quote the FAIL lines.
   A bar that reads green where the critics saw the fault means the ruler is wrong: fix the ruler, never the bar. Commit the
   ruler ALONE first. Bars counted as failures: pops, contact, starts, B1-B5. Reach and posture bars are printed with
   `REPORT` (not `FAIL`) until their part ships; then they become checks in the same commit. Never the other way round.
3. PopCap.gd: a 4-6 frame blend at every clip start (through the JoinSmoother `js.join(half_life, duration)` in
   `FightStage._start`, lines 264-271) and a per-frame turn cap: the shown bone may move from the previous frame's shown pose
   by at most the cap, by rotating from the previous pose TOWARD this frame's pose (slerp by cap / angle), never set to the
   previous pose. Today, with the JoinSmoother on (the game), `_start` calls `js.join()` with its defaults
   (`JoinSmoother.HALF_LIFE_S` 0.06, `DURATION_S` 0.3, JoinSmoother.gd lines 11-12) or `js.join(GUARD_HALF_LIFE_S,
   GUARD_JOIN_S)` back to the guard; `BLEND_S` 0.15 (line 46) only fades clips with `-- nojoin`. JoinSmoother.gd is not
   owned: call it, do not edit it. Do every bone change in `_process_modification` (no `skeleton_updated` handler, no `_busy`
   flag). Skip the hip cap on a teleport (the boxer node moved more than 0.2 m this frame) and while a fall / knockdown clip
   plays (`BeatClips.DOWN`, `BeatClips.OUT`). Place the new modules in BoxerBuild BEFORE every feet layer (FootPlant,
   FootLock, FloorStand, RkJoinFeet, the footwork rig): the feet layers keep the last word. If the hip pops left come from a
   feet layer, show it with the numbers and leave it; never cap after the feet layers. PR 200's `PopCap.join` / `fade` may
   be kept; nothing else of it.
4. ContactBeat.gd: the glove touches for ONE frame (two at most, hit-stop frames apart) then goes home: change the hold
   through a PUBLIC call on PunchReach (`hold_s` on `arm()` or a `release()`), never by writing `pr._contact` or any
   `_field` of another script. Today's hold is `PunchReach.HOLD_S` 0.05 plus the `OUT_S` 0.16 ease (PunchReach.gd lines
   13-15). Keep the constants `IN_S`, `HOLD_S`, `OUT_S` and the static two-argument `PunchReach.weight(t, contact)`
   working exactly as today: `fight_feel_test` lines 33-35 call them by name. Keep PunchReach's `_clip`, `_contact` and
   `_process_modification()` as they are: `HitImpact.hit` (lines 29-36, not owned) reads them on every landed punch. A
   blocked punch: aim the HAND BONE at the blocking glove (as `FightStage.arm_block` does), never move a glove node.
5. Reach by range (only if clean): ONE place, in the beat choice BEFORE BeatFire arms it: pass `ctx.gap` =
   `stage._gap_shown()` into `BeatClips.punch(move, ctx, has)` at `BeatFire.gd` line 116, so clip, contact and hand
   (lines 116-119) all come from the clip that will play. The move the simulation chose stays (a cross stays a cross):
   range picks among that move's takes (a stepping take when long, an inside take when short) or the boxer steps first
   and the beat waits; a beat is never dropped. Bands come from each clip's measured reach, not a hand-typed table:
   `BeatClips.contact_row(clip)` gives `reach_m` for the 59 Punch PRO rows of `assets/data/clip_contact.json` (no row has
   `short_m` today, though `FightStage.land` line 136 reads it), and a captured take's row (`RkClips.row`) has no reach at
   all: measure those at the clip's contact frame the way `FightStage._jab_gap` does (`IdleMatch.pose_point`). With no
   `gap` in ctx, `BeatClips.punch` picks exactly as today (beat_clips_test and rokoko_clips_test call it without one).
   Never inside `FightStage.play` (line 366): `HitImpact.hit` (line 45) plays reactions through it.
6. PostureLimit.gd (only if clean): rotation-only clamps on the shown pose (trunk lean, the thigh turned about the
   hip-to-ankle axis so the knee sits over the foot, the arm chain for gloves in the guard). No translation of any bone.
   S434: guard_knee_test is RED ON MAIN since HUMANFIGHT1 made the stepping route the default (79665239, FootLock /
   FloorStand): both rear knees bow OUT in the settled guard (boxer 0 -0.0685, boxer 1 -0.0670 against the source take's
   +0.0291, bar 0.03). It passed on 099d6393 (before). This thigh turn must bring both rear knees back inside the bar; its
   RESULT line quotes the four GUARD_KNEE numbers before and after. Never move SOURCE or MEAN_BAR.
7. Each fix ships ON with a control arm (`-- nopopcap`, `-- nocontactbeat`, `-- noreachband`, `-- noposture`); the ruler
   runs one OFF arm (all four switches off, same seed and window; the starts bar in 1c compares against it) and prints
   it. AFTER numbers beside BEFORE. FightStage gets only calls (it is 478 lines).

## Hard bans (each is a ruler check that must read 0)
Each ban reads 0 on today's main (step 2 proves it and prints the number); a ban that reads red on main is a ruler bug.
- B1: no glove node or mesh moved apart from its hand bone. `Gloves._follow` puts each glove node's origin ON the hand bone
  (`Gloves.gd` line 121; the glove node is a child of the Skeleton3D), so every frame, both gloves, both boxers: (a) glove node `global_position` to the shown Hand bone
  origin under 1 cm; (b) each MeshInstance3D under the glove node keeps the transform relative to its glove node that it had
  on the first frame, within 1 cm. A fix that moves a glove node or a mesh fails (a) or (b).
- B2: no bone length change by the new modules: each limb segment (UpperLeg-LowerLeg, LowerLeg-Foot, UpperArm-LowerArm,
  LowerArm-Hand, both sides) read at the AFTER tap differs from the same segment at the BEFORE tap by under 1 % of its rest
  length, every frame. Also print the shown length against rest on every frame (REPORT): modules on main (ElbowClear,
  PunchReach's arm solve, FighterLife) already write bone origins, so that one is not the ban.
- B3: the feet are never moved by the new modules: (a) the source of PopCap, ContactBeat, PostureLimit and ReachBand names
  no Foot or Toes bone (the ruler scans the four files); (b) the LeftFoot, RightFoot, LeftToes and RightToes global origins
  at the AFTER tap are within 1 cm of the BEFORE tap, every frame. A knee clamp that swings the toes fails (b).
- B4: no snap-back: for every bone a new module writes, a frame where the AFTER rotation equals the previous frame's AFTER
  rotation (under 0.05 degrees, sign-corrected) while the BEFORE rotation moved more than 1 degree from it is a failure.
- B5: the fix never swaps or refuses what BeatFire chose: (a) for every punch in BeatFire's log with `punch_id >= 0`, the
  hitter's AnimationPlayer shows the logged clip on the next drawn frame (unless a newer `play_id` started); (b) every
  landed punch's struck boxer shows the logged reaction clip, or the log says the hit was cut off (`PunchRange.cut_off`);
  (c) the text of `func play(` in FightStage.gd and the whole of HitImpact.gd name none of the new modules (the ruler scans
  them).

## What the last round got wrong
- `PostureLimit.clamp_mesh` and `ContactBeat.put_on` moved glove MESHES; `glove_front` reads the mesh, so the bars passed with gloves off the wrists.
- `PostureLimit._knee` moved the LowerLeg origin and wrote the feet back: the legs stretched and the feet moved.
- `PopCap._cap_hips` wrote the feet's global poses back every frame and capped the world hip, so the hips crawled after each teleport.
- `PopCap._cap_rots` snapped a bone to its last frame on a quaternion sign artifact, fitted to the ruler's own bug (its comment says so).
- `ReachBand` inside `FightStage.play` swapped hit REACTIONS into punches and refused landed beats, while BeatFire armed the original clip.
- The test called `stage.hit` itself on the contact frame, so lag 0 measured the harness, not the game.
- A refused punch was not counted and no minimum was set: throwing nothing passed.
- `human_feet_test` and `boxer_footwork_test` went red (both green on main); AFTER, the film and the sheets were missing.

## Prior research
ops/research/TASK_HUMANFIGHT2.md, ops/research/HUMANFIGHT1_DIGEST.md ("Round 3", "Where it stands"),
ops/research/FIGHT_DISPLAY_DECISION_S419.md, ops/tmp_s433/collect_review.json (HUMANFIGHT2 review and verify),
ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
An animator fixes the joins with a blend and a turn limit on the joints, never by sliding a glove or stretching a leg;
makes contact a beat (touch, snap home, the other's head moves on that frame); and checks the result on the film, not only in numbers.

## Prefab check
No prefab: rules on our own stage. The clips stay (Punch PRO + Mixamo, owned). Do not source new clips.

## Rules
Worktree `E:/FightCamp/wt/LEAN_HUMANFIGHT2B`, branch `cursor/humanfight2b` from origin/main, seeded first with
`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\LEAN_HUMANFIGHT2B`.
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>`
on the PC (never `_console.exe`). Parse first with `--check-only --script res://<file>`.
Line counts today: FightStage.gd 478, BeatClips.gd 279, BeatFire.gd 228, PunchReach.gd 267, BoxerBuild.gd 207,
human_fight_film.gd 141, human_fight_report.py 192; PopCap/ContactBeat/PostureLimit/ReachBand, human_fight_tap.gd, both
test files and the result page are new. No file over 500 lines at any commit. The test's child Godot (step 1b) runs inside
the test's own godot_slot job: start the test through godot_slot, never the child. The test prints
`HUMAN_MOTION_TEST failures=%d` as its last line and quits 1 on any failure. block_meet_test is red on main (1 failure): its bar is no new failure;
if file_limits_test reads red on main too, name the line, and the bar is no new line.
GDScript traps: type a Variant call (`var n: int = ...`, not `:=`); `%%` in a format string; a name reused in one function
is a parse error; `get_bone_global_pose()` headless needs the skeleton updated (read in `skeleton_updated` or after
`force_update_all_bone_transforms()`). Never "he" or "she" in code or text (no_pronoun_test).
Do not edit `tests/human_feet_test.gd`, `tests/block_meet_test.gd` or any REGRESSION test.

## Result lines (PR body)
RESULT: tests/human_motion_test.gd -> HUMAN_MOTION_TEST failures=0 (and the FAIL lines it read on main)
RESULT: tests/<each REGRESSION test>.gd -> <its own pass line> (one line each; block_meet: its failure count vs main)
Paste: BEFORE / AFTER table, the OFF-arm numbers, which of parts 3-6 shipped and which stayed REPORT. Film: 60 s on the
hidden desktop, `python tools/hidden_desktop.py run --timeout=580 <godot.exe> --path . --windowed --resolution 1280x720
--fixed-fps 30 --write-movie <out>/men.avi --audio-driver Dummy --script res://tools/human_fight_film.gd -- <out> secs=60
seed=7`, as mp4, its report in the result page, and four sheets (`tools/film_sheets.py`): a straight right from the guard,
a landed hook and its reaction, a body shot, a close exchange; name the frames a human should look at.
