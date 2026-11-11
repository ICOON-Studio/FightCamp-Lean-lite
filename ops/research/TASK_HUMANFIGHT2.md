# TASK HUMANFIGHT2 - CURSOR (Grok 4.7 High) - the stepping route moves like two boxers: no pops, a reach per punch, one-frame contact, posture limits

Status: OPEN (S432). Discipline: boxing (the demo). Model: Grok 4.7 High (Cursor).
Source: the operator chose the route in S432 (Q-S294-183, after two films and six blind critics): "Older stepping route".
The game now plays it by default (commit 79665239: captured takes are opt-in, `-- rokoko`). Six critics over three rounds
agree on what holds it at 4/10; read `ops/research/HUMANFIGHT1_DIGEST.md` sections "Round 3" and "Where it stands" whole.
This task is the four CODE items they agree on, in their order. None of them is a leg layer: do not touch the feet
(FootLock, FloorStand, ShownRoot, FootPlant, RingFeet) - they are fixed and measured (0 airborne, slide 0.7 m a minute).

## Contract
OWNS: scripts/fight3d/PopCap.gd, scripts/fight3d/ReachBand.gd, scripts/fight3d/ContactBeat.gd, scripts/fight3d/PostureLimit.gd, scripts/fight3d/FightStage.gd, scripts/fight3d/BeatClips.gd, scripts/fight3d/PunchRange.gd, scripts/fight3d/BoxerBuild.gd, tools/human_fight_report.py, tests/human_motion_test.gd, docs/HUMANFIGHT2_RESULT.md
RED_TEST: tests/human_motion_test.gd -> HUMAN_MOTION_TEST failures=0
REGRESSION: human_feet_test, ring_feet_test, beat_clips_test, fight_feel_test, boxer_footwork_test, body_keep_test, range_breath_test, short_punch_test, knockdown_ring_test, fight_flow_test, file_limits_test
VISUAL: yes

## Where to work
Worktree `E:/FightCamp/wt/LEAN_HUMANFIGHT2` on branch `cursor/humanfight2` from origin/main, seeded with
`powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\LEAN_HUMANFIGHT2`
BEFORE any Godot run. Never work in E:/FightCamp/Lean itself. Every Godot job through
`python ops/Tools/godot_slot.py run --who cursor -- <command>`. No file over 500 lines at any commit: FightStage.gd is 478
lines, so put the logic in the four new modules and add only calls to FightStage.

## The instruments you already have (from HUMANFIGHT1, on main)
- `tools/human_fight_film.gd`: a real bout, both boxers as SHOWN, every frame to `shown.csv` (headless gives the csv without
  a film). `tools/human_fight_report.py <shown.csv>` prints the rulers per boxer and per clip (pops, slip, knees).
- `tools/film_sheets.py`: numbered frame sheets from a film (read them yourself: you cannot see images, so measure instead
  and say which frames a human should look at).
- `tests/human_feet_test.gd`: how to play the stage calls the fight makes (FightStage.play / guard / step / circle, two
  DIFFERENT bodies) and read the DRAWN skeleton every frame (skeleton_updated). Copy that harness for the new test.

## Part A: the ruler (commit it alone, before any change; it must read RED on today's main)
Add to `tools/human_fight_report.py` (and the same definitions in `tests/human_motion_test.gd`, headless, the game's
stage calls, two different bodies, at least 40 s of a bout at 30 fps):
1. POPS: a frame where the hips move more than 3 cm up/down or 8 cm along, or any bone of the arms/trunk turns more than
   25 degrees, in one frame. Count per clip and at clip starts (the frame a new clip begins) separately. Today: 65 / 36
   hip pops a minute on the default route (S432 film). Bar: hip pops at clip starts 0; all hip pops under 10 a minute.
2. REACH: for every punch, the pelvis gap when it STARTS and whether that punch can land from there (its glove reach from
   the clip's own contact frame, `BeatClips.contact` / `FightStage.glove_front`). Bar: 0 punches started out of their band
   (a band per punch family: straight, hook, uppercut, body), and 0 landed punches that needed a carry (PunchRange.close_in)
   of more than 0.15 m.
3. CONTACT: for every landed punch, the frames the glove stays within 6 cm of the target point (`FightStage.target_point`).
   Today the critics saw 4 to 12. Bar: 1 to 2 frames, then the hand travels home. And the frame the struck boxer's reaction
   clip starts minus the contact frame. Bar: 0 to 1 frame.
4. POSTURE: per frame, trunk lean from vertical (fwd and side), each knee over its foot (knee x/z outside the foot's
   segment by more than 8 cm = knock-kneed or splayed), both gloves' height between belt and eyebrows when not punching or
   hit, feet distance (feet together = under 0.25 m). Bar: trunk lean under 35 degrees outside a weave or a body shot and
   under 50 inside them; 0 frames knock-kneed; gloves inside the band 95 % of guard frames; feet together 0 frames
   outside a step's mid-swing.
Run it on today's main; write every number under BEFORE in docs/HUMANFIGHT2_RESULT.md. Each bar must read RED where the
critics saw the fault; if one reads green, the ruler is wrong: fix the ruler, not the bar.

## Part B: the fix (a second pass; the bars are frozen)
1. `PopCap.gd`: a per-frame cap on the SHOWN pose (bones read after the clips, before the draw - the same place
   ShownRoot works) plus a 4 to 6 frame blend at every clip start in `FightStage._start` (today BLEND_S). A clip that starts
   with the back already turned (the straight right) blends from the guard, it does not jump.
2. `ReachBand.gd`: "the range picks the punch". Before a punch starts (`FightStage.play` and the beat picker in
   BeatClips), check the pelvis gap against that punch's band. Out of band: pick the punch of the same intent that fits
   (a jab instead of a cross when long, a hook or uppercut when short), or take the step first. Never carry a boxer more
   than 0.15 m to make it land.
3. `ContactBeat.gd`: the glove touches for ONE frame (two at most) and comes home; the struck boxer's reaction starts on
   that frame (`FightStage.land` / `hit`). A blocked punch stops on the glove for one frame too.
4. `PostureLimit.gd`: the limits in Part A applied to every clip on the shown pose (clamp, never a new pose): trunk lean,
   knees over feet, gloves between belt and eyebrows in the guard, feet apart.
Each switch has a control arm (`-- nopopcap`, `-- noreachband`, `-- nocontactbeat`, `-- noposture`) and ships ON
(GameSwitches rule: new features default on). AFTER numbers beside BEFORE.

## Done
- `RESULT: tests/human_motion_test.gd -> HUMAN_MOTION_TEST failures=0`, red on main (quote the FAIL lines).
- Every REGRESSION test green, by name, each with its own pass line (not an engine line).
- A 60 s film on the hidden desktop: `python tools/hidden_desktop.py run --timeout=580 <godot.exe> --path . --windowed
  --resolution 1280x720 --fixed-fps 30 --write-movie <out>/men.avi --audio-driver Dummy --script res://tools/human_fight_film.gd
  -- <out> secs=60 seed=7`, converted to mp4, its report pasted into the result page, and four numbered sheets
  (film_sheets.py) of the frames a human should look at: a straight right from the guard, a landed hook and its reaction,
  a body shot, an exchange at close range.
- No critic round: Claude judges the film; critics only on the operator's word (usage budget).

## Prior research
ops/research/HUMANFIGHT1_DIGEST.md (rounds 0-3, both routes measured, the six critics' lists); ops/research/FIGHT_DISPLAY_DECISION_S419.md;
SQ41 (John: how big fight games build their animation - read it if it has landed in ops/research before you start).

## What would a human do?
A boxing animator cleans the joins first (blends, no pops), then makes each punch thrown from its own distance, then makes
contact a beat (touch, snap back, the other's head moves on that frame), then checks posture on every clip against a coach.

## Prefab check
No prefab: these are rules on our own stage. The clips themselves stay (Punch PRO + Mixamo, owned). Do not source new clips.

## The trap
HUMANFIGHT1 measured the feet and fixed them while the score stayed at 3-4: a ruler that only reads one thing rewards
fixing that thing. Measure all four before changing any, and do not let a fix to one move another's bar the wrong way
(read the whole report after every change).
