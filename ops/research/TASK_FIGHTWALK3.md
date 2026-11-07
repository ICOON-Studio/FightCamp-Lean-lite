# TASK FIGHTWALK3 - CURSOR (Composer 2.5, Fast OFF) - the corner minute a TV director would cut: 4 -> 8

Status: OPEN (S397, Claude, anim-chain session). Discipline: boxing (between rounds). START FROM FIGHTWALK2's branch:
`git checkout origin/cursor/fightwalk2 -- scripts/fight3d/CornerCrew.gd scripts/fight3d/CornerMinute.gd scripts/fight3d/CrewWalk.gd tools/walk_cycle.gd tests/fight_walk_test.gd`
(FIGHTWALK2 = PR #70: crew on the captured walk, no folded arms; its corner staging was fixed by Claude after a blind critic).
Your shell works now (S397: Cursor's hook wrapper broke every command; the dispatcher gives your worktree an empty hook file).
RUN THE TESTS YOURSELF before you finish.

## Contract
OWNS: scripts/fight3d/CornerCrew.gd, scripts/fight3d/CornerMinute.gd, scripts/fight3d/CrewWalk.gd, scripts/fight3d/CornerIK.gd,
  scripts/fight3d/CornerCues.gd, tools/walk_cycle.gd, tests/fight_walk_test.gd, tests/corner_work_test.gd
RED_TEST: tests/corner_work_test.gd -> CORNER_WORK failures=0
REGRESSION: fight_walk_test, fight_polish_test, corner_warm_test, foot_plant_test, corner_lens_test, ring_feet_test, crowd_room_test
VISUAL: yes
FILM: --resolution 1920x1080 --script res://tools/corner_film.gd -- E:/FightCamp/tmp/fightwalk3 film short

## Why (a fresh blind critic, S397, on tools/corner_film.gd `short`: main 4.5/10, FIGHTWALK2 4/10)
- The walk to the corner is under a second and cut before anyone arrives; she starts it with both arms stuck out.
- The coach either stands with folded arms or crouches eye to eye and barely moves; a 4.5 s close-up of him staring with
  no hands while the caption says "Go downstairs. Dig to the body". He snaps from standing to kneeling in one frame.
- The second stands idle outside the ropes in every shot (in one version his body crossed the coach's head).
- The walk out at "Seconds out" is a dash and round 2 opens in clinch range.
The critic's 8/10: (1) bell, then 3-4 s of walking at a tired pace on one camera, ending with her turning and sitting, unbroken;
(2) the coach kneels facing her within ~1 s, hands on her gloves or face, head and hands moving with each line; (3) the second
does real jobs in sequence: gumshield out, water, wipe the face, cold compress or grease, then steps out through the ropes at
"Seconds out"; (4) faces lit, heads in frame, no one passes through anyone; (5) at "Seconds out" she stands, the stool and team
leave the ring, she walks to centre at a measured pace, round 2 opens from a real gap of about two steps.

## First: make tests/fight_walk_test.gd measure truly (it is red on FIGHTWALK2's branch, commit after 'harness')
Claude's run (S397, 17:2x, branch cursor/fightwalk2): crew live 2.05 m in 4.60-4.87 s (limit 4.40-4.61); bar a planted slide
p90 0.64 max 13.2 m/s (n=105); b p90 0.40 max 20.6; c turn slide 9.9; e boxer p95 3.73 max 5.68, crew p95 0.87 max 2.5;
two SCRIPT ERRORs in _bar_f (CornerMinute ctx lacks keys: 'worked', a Nil .visible). The boxer's walk is main's plain stride,
yet two blind critics saw planted steps on film - so part of this is the harness (single-frame 13 m/s foot jumps: the loop
seam of ow_walk? the plant pick by toe height? does AnimationPlayer.advance() apply speed_scale in MANUAL mode?). Find which,
fix the measurement or the walk, and say which in the PR body. Do not loosen a bar to pass.

## Do
1. Write tests/corner_work_test.gd FIRST, headless (build FightStage + CornerCrew + CornerMinute as tests/fight_walk_test.gd
   `_bar_f` does; step the minute on a fixed clock with its own _process switched off). Bars, from node and bone positions:
   - a. her walk to the stool: from the bell to her hips on the seat >= 3.0 s, no camera cut inside the walk (CornerMinute's
     shot list), ground speed within FIGHTWALK2's bars (no skate, no dash);
   - b. the coach is crouched (Head bone under 1.25 m) within 0.9 m of her face within 1.5 s of her sitting, and his left or
     right hand (CornerIK) is within 0.15 m of her glove, knee or face for at least 30% of the minute's talk; at least 3
     different actions (clip or hand target) over the minute; no single-frame jump of his hips over 0.15 m (no snap);
   - c. the second does at least 4 jobs in order (gumshield, water, towel to her face, ice or grease), each with his hand
     within 0.15 m of its target bone at its cue, and is outside the ropes (or walking out with the stool) by "Seconds out";
   - d. nobody passes through anybody: every frame, the head of each of boxer / coach / second stays >= 0.12 m from the
     others' torso capsules (Hips -> UpperChest) and heads;
   - e. "Seconds out" to the bell: she walks corner -> centre in >= 2.5 s, and at the bell the two boxers' hips are >= 1.2 m
     apart.
   Run it on main first and write main's numbers in the PR body (most bars must FAIL on main).
2. Make it green with clips already in the project (ow_walk, af_*; tools/corner_probe.gd lists them) and CornerIK reaches - no
   new motion, nothing generated. Keep each change in the cue list readable (CUES / SHOTS in CornerMinute); if CornerMinute
   passes 500 lines, move the cue bodies into scripts/fight3d/CornerCues.gd.
3. Keep every REGRESSION test green. Do not touch CornerShots.gd (CORNERCAM1, Goose), RingCamera.gd, FightView.gd, FootPlant.gd,
   RingFeet.gd, HitSnap.gd, BeatFire.gd, nor the fight model (scripts/rules/*, scripts/state/*, scripts/world/*).

## Rules
- Real captures only (no Meshy, no MPFB, no generated motion). Bodies unchanged: men bare-chested, women in singlets, boots.
- Files under 500 lines. Commit with clear messages. No edits to ops/, tools/run_tests.sh or any gate file.
- Headless only (`--headless --audio-driver Dummy`); nothing opens on screen. The dispatcher films before/after.

## Result lines (PR body)
RESULT: CORNER_WORK main  a=.. b=.. c=.. d=.. e=..
RESULT: CORNER_WORK after a=.. b=.. c=.. d=.. e=..
RESULT: regression <pass/fail per test>

## Prior research
ops/research/FIGHTWALK3_DESIGN_AGY.md (a designer seat's cue-by-cue 8/10 plan from the critic - use what fits the bars); TASK_FIGHTWALK2.md (the walk bars); FIGHT_TESTS_S396.md; CornerMinute.gd / CornerIK.gd S307-S396 notes (shot list, water, ice).

## What would a human do?
A real corner: the stool goes in as she walks back, she sits, the coach drops to one knee in front of her, both hands on her
gloves, talking fast; the second pulls the gumshield, gives water, wipes her face, puts ice on her neck, greases her brows;
at "Seconds out" the stool and the team go out through the ropes and she walks to the centre.

## Prefab check
No new asset: ow_walk (CMU) and the af_* corner clips are in the project; the bottle and ice props exist (CornerCrew props).
